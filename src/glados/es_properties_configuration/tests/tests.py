from django.test import TestCase, override_settings
from glados.es_properties_configuration import configuration_getter
import glados.ws2es.es_util as es_util
from django.conf import settings
from glados.settings import RunEnvs
import os
import yaml
import re


class ConfigurationGetterTester(TestCase):

    CONFIG_TEST_FILE = os.path.join( settings.GLADOS_ROOT, 'es_properties_configuration/tests/data/test_override.yml')

    def setUp(self):

        if settings.RUN_ENV == RunEnvs.TRAVIS:
            es_util.setup_connection_from_full_url(settings.ELASTICSEARCH_EXTERNAL_URL)
        else:
            es_util.setup_connection_from_full_url(settings.ELASTICSEARCH_HOST)

    # ------------------------------------------------------------------------------------------------------------------
    # Getting one property
    # ------------------------------------------------------------------------------------------------------------------
    def test_fails_when_index_does_not_exist(self):

        index_name = 'does_not_exist'
        prop_id = '_metadata.assay_data.assay_subcellular_fraction'

        try:
            config_got = configuration_getter.get_config_for(index_name, prop_id)
            self.assertTrue(False, 'This should have thrown an exception for a non existing index!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    def test_fails_when_property_does_not_exist(self):

        index_name = 'chembl_activity'
        prop_id = 'does_not_exist'

        try:
            config_got = configuration_getter.get_config_for(index_name, prop_id)
            self.assertTrue(False, 'This should have thrown an exception for a non existing property!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_one_property_with_no_override(self):

        index_name = 'chembl_activity'
        prop_id = '_metadata.assay_data.assay_subcellular_fraction'
        config_got = configuration_getter.get_config_for(index_name, prop_id)

        self.assertEqual(config_got['index_name'], index_name)
        self.assertEqual(config_got['prop_id'], prop_id)
        self.assertTrue(config_got['aggregatable'])
        self.assertEqual(config_got['type'], 'string')
        self.assertEqual(config_got['label'], 'Assay Data Subcellular Fraction')
        self.assertEqual(config_got['label_mini'], 'As. Data Subc. Frct.')

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_one_property_with_override(self):

        override_config_must_be = yaml.load(open(settings.PROPERTIES_CONFIG_OVERRIDE_FILE, 'r'), Loader=yaml.FullLoader)

        index_name = 'chembl_activity'
        prop_id = '_metadata.activity_generated.short_data_validity_comment'
        config_got = configuration_getter.get_config_for(index_name, prop_id)

        property_config_must_be = override_config_must_be[index_name][prop_id]
        self.assertEqual(config_got['label'], property_config_must_be['label'],
                         'The label was not overridden properly!')
        self.assertEqual(config_got['label_mini'], property_config_must_be['label_mini'],
                         'The label mini was not overridden properly!')

    # ------------------------------------------------------------------------------------------------------------------
    # Getting a custom list of properties
    # ------------------------------------------------------------------------------------------------------------------
    def test_fails_config_for_a_list_of_properties_when_index_does_not_exist(self):

        index_name = 'does_not_exist'
        props = ['_metadata.assay_data.assay_subcellular_fraction']

        try:
            configuration_getter.get_config_for_props_list(index_name, props)
            self.assertTrue(False, 'This should have thrown an exception for a non existing index!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    def test_fails_config_for_a_list_of_properties_when_property_does_not_exist(self):

        index_name = 'chembl_activity'
        props = ['does_not_exist']

        try:
            configuration_getter.get_config_for_props_list(index_name, props)
            self.assertTrue(False, 'This should have thrown an exception for a non existing property!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    def test_gets_config_for_a_list_of_properties(self):

        index_name = 'chembl_activity'
        props = ['_metadata.activity_generated.short_data_validity_comment', '_metadata.assay_data.assay_cell_type']

        configs_got = configuration_getter.get_config_for_props_list(index_name, props)
        config = configs_got[0]
        self.assertEqual(config['index_name'], index_name)
        self.assertEqual(config['prop_id'], props[0])
        self.assertTrue(config['aggregatable'])
        self.assertEqual(config['type'], 'string')
        self.assertEqual(config['label'], 'Short Data Validity Comment')
        self.assertEqual(config['label_mini'], 'Shrt. Data Vald. Comn.')

        config = configs_got[1]
        self.assertEqual(config['index_name'], index_name)
        self.assertEqual(config['prop_id'], props[1])
        self.assertTrue(config['aggregatable'])
        self.assertEqual(config['type'], 'string')
        self.assertEqual(config['label'], 'Assay Data Cell Type')
        self.assertEqual(config['label_mini'], 'Assay Data Cell Type')

    # ------------------------------------------------------------------------------------------------------------------
    # Getting a group of properties
    # ------------------------------------------------------------------------------------------------------------------
    def test_fails_to_get_group_when_index_does_not_exist(self):

        pass
        # index_name = 'does_not_exist'
        # group_id = '_metadata.assay_data.assay_subcellular_fraction'
        #
        # try:
        #     config_got = configuration_getter.get_config_for(index_name, prop_id)
        #     self.assertTrue(False, 'This should have thrown an exception for a non existing index!')
        # except configuration_getter.ESPropsConfigurationGetterError:
        #     pass

