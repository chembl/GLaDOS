from django.test import RequestFactory, TestCase, override_settings
from django.conf import settings
import os
import glados.es.ws2es.es_util as es_util
from glados.settings import RunEnvs


class PropertiesConfigurationControllerTester(TestCase):

    CONFIG_TEST_FILE = os.path.join(settings.GLADOS_ROOT,
                                    'api/shared/properties_configuration/tests/data/test_override.yml')
    GROUPS_TEST_FILE = os.path.join(settings.GLADOS_ROOT,
                                    'api/shared/properties_configuration/tests/data/test_groups.yml')
    SORTING_TEST_FILE = os.path.join(settings.GLADOS_ROOT,
                                     'api/shared/properties_configuration/tests/data/test_default_sorting.yml')

    def setUp(self):
        self.request_factory = RequestFactory()
        if settings.RUN_ENV == RunEnvs.TRAVIS:
            es_util.setup_connection_from_full_url(settings.ELASTICSEARCH_EXTERNAL_URL)
        else:
            es_util.setup_connection_from_full_url(settings.ELASTICSEARCH_HOST)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE,
                       PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE,
                       GROUPS_DEFAULT_SORTING_FILE=SORTING_TEST_FILE)
    def test_gets_config_for_one_property(self):
        print('test_gets_config_for_one_property')
