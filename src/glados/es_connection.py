from elasticsearch_dsl.connections import connections
from django.conf import settings
import logging


logger = logging.getLogger('glados.es_connection')


def setup_glados_es_connection():
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

            if settings.ELASTICSEARCH_PASSWORD is not None:
                keyword_args["http_auth"] = (settings.ELASTICSEARCH_USERNAME, settings.ELASTICSEARCH_PASSWORD)

            connections.create_connection(**keyword_args)
            if not connections.get_connection().ping():
                raise Exception('Connection to elasticsearch endpoint failed!')
            logger.info('PING to {0} was successful!')
        except Exception as e:
            logger.warning('The elastic search connection has not been created!')
            logger.warning('please use ELASTICSEARCH_HOST, ELASTICSEARCH_USERNAME and ELASTICSEARCH_PASSWORD'
                           ' in the Django settings to define it.')
            logger.warning('elastic search functionalities will be disabled!')
            logger.error(e)
