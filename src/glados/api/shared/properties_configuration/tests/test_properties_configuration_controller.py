import os
import json
from django.test import RequestFactory, TestCase, override_settings
from django.conf import settings
from django.urls import reverse
from glados.settings import RunEnvs
from glados.api.shared.properties_configuration import properties_configuration_controller
from glados.es.es_properties_configuration import configuration_manager
import glados.es.ws2es.es_util as es_util


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
    def test_returns_server_error_when_index_does_not_exist(self):

        index_name = 'does_not_exist'
        prop_id = 'molecule_chembl_id'

        request_url = reverse('get_config_for_property', args=(index_name, prop_id))
        request = self.request_factory.get(request_url)
        response_got = properties_configuration_controller.get_config_for_property(request, index_name, prop_id)

        self.assertEqual(response_got.status_code, 500, 'This should return a 500 error when the index does not exist')

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE,
                       PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE,
                       GROUPS_DEFAULT_SORTING_FILE=SORTING_TEST_FILE)
    def test_returns_server_error_when_property_does_not_exist(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        prop_id = 'does_not_exist'

        request_url = reverse('get_config_for_property', args=(index_name, prop_id))
        request = self.request_factory.get(request_url)
        response_got = properties_configuration_controller.get_config_for_property(request, index_name, prop_id)

        self.assertEqual(response_got.status_code, 500,
                         'This should return a 500 error when the property does not exist')

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE,
                       PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE,
                       GROUPS_DEFAULT_SORTING_FILE=SORTING_TEST_FILE)
    def test_gets_config_for_one_property(self):
        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        prop_id = 'molecule_chembl_id'

        request_url = reverse('get_config_for_property', args=(index_name, prop_id))
        request = self.request_factory.get(request_url)
        response_got = properties_configuration_controller.get_config_for_property(request, index_name, prop_id)
        data_got = json.loads(response_got.content.decode('utf-8'))
        data_must_be = configuration_manager.get_config_for_prop(index_name, prop_id)

        self.assertEqual(data_got, data_must_be,
                         msg='The property configuration is not correct')

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE,
                       PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE,
                       GROUPS_DEFAULT_SORTING_FILE=SORTING_TEST_FILE)
    def test_gets_config_for_a_group_fails_when_index_does_not_exist(self):

        index_name = 'does_not_exist'
        group_name = 'download'

        request_url = reverse('get_config_for_group', args=(index_name, group_name))
        request = self.request_factory.get(request_url)
        response_got = properties_configuration_controller.get_config_for_group(request, index_name, group_name)

        self.assertEqual(response_got.status_code, 500,
                         'This should return a 500 error when the group does not exist')

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE,
                       PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE,
                       GROUPS_DEFAULT_SORTING_FILE=SORTING_TEST_FILE)
    def test_gets_config_for_a_group(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        group_name = 'sorted_table'

        request_url = reverse('get_config_for_property', args=(index_name, group_name))
        request = self.request_factory.get(request_url)
        response_got = properties_configuration_controller.get_config_for_group(request, index_name, group_name)
        data_got = json.loads(response_got.content.decode('utf-8'))
        data_must_be = configuration_manager.get_config_for_group(index_name, group_name)
        self.assertEqual(data_got, data_must_be,
                         msg='The group configuration is not correct')
