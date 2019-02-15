from elasticsearch_dsl.connections import connections
from django.conf import settings
import logging
import json
import traceback


logger = logging.getLogger('glados.es_connection')

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
            'es_cached_request': {
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
            'es_download_record': {
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
            'es_view_record': {
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
        'idx_name': 'chembl_glados_es_view_record',
        'shards': 7,
        'replicas': 1,
        'mappings': {
            'es_view_record': {
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
        'replicas': 1
    }
]


def setup_glados_es_connection():
    print('SET UP ES CONNECTION')
    if getattr(settings, 'ELASTICSEARCH_HOST', None) is None:
        logger.warning('The elastic search connection has not been defined!')
        logger.warning('Please use ELASTICSEARCH_HOST in the Django settings to define it.')
        logger.warning('Elastic search functionalities will be disabled!')
    else:
        try:
            keyword_args = {
                "hosts": [settings.ELASTICSEARCH_HOST],
                "timeout": 30,
                "retry_on_timeout": True
            }

            print('ELASTICSEARCH_HOST: ', settings.ELASTICSEARCH_HOST)
            print('ELASTICSEARCH_USERNAME')
            # for c in settings.ELASTICSEARCH_USERNAME:
            #     print(c)
            #
            # print('ELASTICSEARCH_PASSWORD')
            # for c in settings.ELASTICSEARCH_PASSWORD:
            #     print(c)

            if settings.ELASTICSEARCH_PASSWORD is not None:
                keyword_args["http_auth"] = (settings.ELASTICSEARCH_USERNAME, settings.ELASTICSEARCH_PASSWORD)

            connections.create_connection(**keyword_args)
            if not connections.get_connection().ping():
                raise Exception('Connection to elasticsearch endpoint failed!')
            logger.info('PING to {0} was successful!'.format(settings.ELASTICSEARCH_HOST))
            create_indexes()
        except Exception as e:
            print('CONNECTION NOT CREATED!')
            traceback.print_exc()
            logger.warning('The elastic search connection has not been created!')
            logger.warning('please use ELASTICSEARCH_HOST, ELASTICSEARCH_USERNAME and ELASTICSEARCH_PASSWORD'
                           ' in the Django settings to define it.')
            logger.warning('elastic search functionalities will be disabled!')
            logger.error(e)


def create_idx(idx_name, shards=5, replicas=1, mappings=None):
    es_conn = connections.get_connection()
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
