from elasticsearch_dsl.connections import connections
from django.conf import settings
import logging
import json
import traceback
from glados.es.ws2es.es_util import es_util
from glados.settings import RunEnvs


logger = logging.getLogger('glados.es_connection')

MONITORING_CONNECTION = 'monitoring'
DATA_CONNECTION = 'data'

KEYWORD_TYPE = {'type': 'keyword', 'ignore_above': 500}
BOOLEAN_TYPE = {'type': 'boolean'}
INTEGER_TYPE = {'type': 'integer'}
LONG_TYPE = {'type': 'long'}

REQUIRED_INDEXES = [
    {
        'idx_name': 'chembl_glados_es_cache_usage',
        'shards': 7,
        'replicas': 1,
        'mappings': {
            '_doc': {
                'properties': {
                    'es_index': KEYWORD_TYPE,
                    'es_query': KEYWORD_TYPE,
                    'es_aggs': KEYWORD_TYPE,
                    'es_request_digest': KEYWORD_TYPE,
                    'host': KEYWORD_TYPE,
                    'run_env_type': KEYWORD_TYPE,
                    'is_cached': BOOLEAN_TYPE,
                    'request_date': {
                        'type':   'date',
                        'format': 'yyyy-MM-dd HH:mm:ss||epoch_millis'
                    }
                }
            }
        }
    },
    {
        'idx_name': 'chembl_glados_es_download_record',
        'shards': 7,
        'replicas': 1,
        'mappings': {
            '_doc': {
                'properties': {
                    'download_id': KEYWORD_TYPE,
                    'time_taken': INTEGER_TYPE,
                    'is_new': BOOLEAN_TYPE,
                    'file_size': LONG_TYPE,
                    'es_index': KEYWORD_TYPE,
                    'es_query': KEYWORD_TYPE,
                    'run_env_type': KEYWORD_TYPE,
                    'desired_format': KEYWORD_TYPE,
                    'total_items': INTEGER_TYPE,
                    'host': KEYWORD_TYPE,
                    'request_date': {
                        'type':   'date',
                        'format': 'yyyy-MM-dd HH:mm:ss||epoch_millis'
                    }
                }
            }
        }
    },
    {
        'idx_name': 'chembl_glados_es_search_record',
        'shards': 7,
        'replicas': 1,
        'mappings': {
            '_doc': {
                'properties': {
                    'search_type': KEYWORD_TYPE,
                    'run_env_type': KEYWORD_TYPE,
                    'host': KEYWORD_TYPE,
                    'request_date': {
                        'type':   'date',
                        'format': 'yyyy-MM-dd HH:mm:ss||epoch_millis'
                    }
                }
            }
        }
    },
    {
        'idx_name': 'chembl_glados_es_tinyurl_usage_record',
        'shards': 7,
        'replicas': 1,
        'mappings': {
            '_doc': {
                'properties': {
                    'event': KEYWORD_TYPE,
                    'run_env_type': KEYWORD_TYPE,
                    'host': KEYWORD_TYPE,
                    'request_date': {
                        'type':   'date',
                        'format': 'yyyy-MM-dd HH:mm:ss||epoch_millis'
                    }
                }
            }
        }
    },
    {
        'idx_name': 'chembl_glados_es_view_record',
        'shards': 7,
        'replicas': 1,
        'mappings': {
            '_doc': {
                'properties': {
                    'view_name': KEYWORD_TYPE,
                    'view_type': KEYWORD_TYPE,
                    'entity_name': KEYWORD_TYPE,
                    'run_env_type': KEYWORD_TYPE,
                    'host': KEYWORD_TYPE,
                    'request_date': {
                        'type':   'date',
                        'format': 'yyyy-MM-dd HH:mm:ss||epoch_millis'
                    },
                    'time_taken': INTEGER_TYPE,
                    'is_new': BOOLEAN_TYPE,
                }
            }
        }
    },
    {
        'idx_name': 'chembl_glados_tiny_url',
        'shards': 7,
        'replicas': 1,
        'mappings': {
            '_doc': {
                'properties': {
                }
            }
        }
    }
]


def setup_glados_es_connection(connection_type=DATA_CONNECTION):
    try:
        connections.get_connection(alias=connection_type)
        logger.info('ES Connection {0} has already been created! Skipping for now . . .'.format(connection_type))
        return
    except KeyError as e:
        logger.info('ES Connection {0} does not exist, will try to create it!'.format(connection_type))
    es_host = None
    es_username = None
    es_password = None

    if connection_type == DATA_CONNECTION:
        es_host = getattr(settings, 'ELASTICSEARCH_DATA_HOST', None)
        es_username = getattr(settings, 'ELASTICSEARCH_DATA_USERNAME', None)
        es_password = getattr(settings, 'ELASTICSEARCH_DATA_PASSWORD', None)
    elif connection_type == MONITORING_CONNECTION:
        es_host = getattr(settings, 'ELASTICSEARCH_MONITORING_HOST', None)
        es_username = getattr(settings, 'ELASTICSEARCH_MONITORING_USERNAME', None)
        es_password = getattr(settings, 'ELASTICSEARCH_MONITORING_PASSWORD', None)

    logger.info('SETTING UP ES CONNECTION - TYPE: {0}'.format(connection_type))
    if es_host is None:
        logger.warning('The elastic search connection has not been defined for "{0}"!'.format(connection_type))
    else:
        try:
            keyword_args = {
                "hosts": [es_host],
                "timeout": 30,
                "retry_on_timeout": True,
                'alias': connection_type
            }

            if es_password is not None:
                keyword_args["http_auth"] = (es_username, es_password)

            connections.create_connection(**keyword_args)

            if not connections.get_connection(alias=connection_type).ping():
                raise Exception('PING to elasticsearch endpoint failed!')
            logger.info('PING to {0} was successful for {1} connection!'.format(es_host, connection_type))

            if connection_type == MONITORING_CONNECTION:
                create_indexes()
            elif connection_type == DATA_CONNECTION:
                logger.info('Initialising es-utils connection')

                if settings.RUN_ENV == RunEnvs.TRAVIS:
                    es_util.setup_connection_from_full_url(settings.ELASTICSEARCH_EXTERNAL_URL)
                else:
                    es_util.setup_connection_from_full_url(settings.ELASTICSEARCH_HOST)

        except Exception as e:
            traceback.print_exc()
            logger.error('{0} ES connection could not be created - Reason:'.format(connection_type) + str(e))


def create_idx(idx_name, shards=5, replicas=1, mappings=None):
    es_conn = connections.get_connection(alias=MONITORING_CONNECTION)
    if es_conn.indices.exists(index=idx_name):
        logger.info('Elastic search index {0} already exists.'.format(idx_name))
        return
    create_body = {
        'settings': {
            'number_of_shards': shards,
            'number_of_replicas': replicas,
        }
    }

    if mappings:
        create_body['mappings'] = mappings

    if logger:
        logger.info("Attempting to create index: {0}".format(idx_name))
        logger.debug('Index creation body:\n{0}'.format(json.dumps(create_body, indent=4, sort_keys=True)))
    creation_error = "Unknown reason!"
    # noinspection PyBroadException
    try:
        es_conn.indices.create(index=idx_name, body=create_body, ignore=400)
    except Exception as e:
        creation_error = traceback.format_exc()
    if not es_conn.indices.exists(index=idx_name):
        logger.error('Index {0} was not created!\nDue too:\n{1}'.format(idx_name, creation_error))
    else:
        logger.info('Elastic search index {0} has been created with {1} shards and {2} replica(s).'
                    .format(idx_name, shards, replicas)
                    )


def create_indexes():
    global REQUIRED_INDEXES
    for index_desc in REQUIRED_INDEXES:
        try:
            create_idx(**index_desc)
        except Exception as e:
            logger.error(
                'Failed to process index description.\nIndex Description:\n{0}\n\n'
                .format(json.dumps(index_desc, indent=4, sort_keys=True))
            )
