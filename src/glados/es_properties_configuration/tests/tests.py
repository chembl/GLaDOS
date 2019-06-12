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
    GROUPS_TEST_FILE = os.path.join( settings.GLADOS_ROOT, 'es_properties_configuration/tests/data/test_groups.yml')

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
            config_got = configuration_getter.get_config_for_prop(index_name, prop_id)
            self.fail('This should have thrown an exception for a non existing index!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    def test_fails_when_property_does_not_exist(self):

        index_name = 'chembl_activity'
        prop_id = 'does_not_exist'

        try:
            config_got = configuration_getter.get_config_for_prop(index_name, prop_id)
            self.fail('This should have thrown an exception for a non existing property!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_one_property_with_no_override(self):

        index_name = 'chembl_activity'
        prop_id = '_metadata.assay_data.assay_subcellular_fraction'
        config_got = configuration_getter.get_config_for_prop(index_name, prop_id)

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
        config_got = configuration_getter.get_config_for_prop(index_name, prop_id)

        property_config_must_be = override_config_must_be[index_name][prop_id]
        self.assertEqual(config_got['label'], property_config_must_be['label'],
                         'The label was not overridden properly!')
        self.assertEqual(config_got['label_mini'], property_config_must_be['label_mini'],
                         'The label mini was not overridden properly!')

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_a_virtual_property(self):

        override_config_must_be = yaml.load(open(settings.PROPERTIES_CONFIG_OVERRIDE_FILE, 'r'), Loader=yaml.FullLoader)

        index_name = 'chembl_molecule'
        prop_id = 'trade_names'
        config_got = configuration_getter.get_config_for_prop(index_name, prop_id)

        property_config_must_be = override_config_must_be[index_name][prop_id]
        print('property_config_must_be: ', property_config_must_be)
        self.assertEqual(config_got['prop_id'], prop_id,
                         'The prop_id was not set up properly!')
        self.assertEqual(config_got['based_on'], property_config_must_be['based_on'],
                         'The based_on was not set up properly!')
        self.assertEqual(config_got['label'], property_config_must_be['label'],
                         'The label was not set up properly!')
        # print('aggregatable: ', config_got['aggregatable'])
        self.assertFalse(config_got['aggregatable'], 'This property should not be aggregatable')

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_fails_for_a_virtual_property_based_on_non_existing_prop(self):

        index_name = 'chembl_molecule'
        prop_id = 'trade_names_wrong'

        try:
            config_got = configuration_getter.get_config_for_prop(index_name, prop_id)
            self.fail('This should have thrown an exception for a non existing property!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_makes_sure_config_for_a_contextual_property_is_correct(self):

        index_name = 'chembl_molecule'
        prop_id = '_context.similarity_wrong'

        try:
            config_got = configuration_getter.get_config_for_prop(index_name, prop_id)
            self.fail('This should have thrown an exception for a bad configuration!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_a_contextual_property(self):

        index_name = 'chembl_molecule'
        prop_id = '_context.similarity'
        config_got = configuration_getter.get_config_for_prop(index_name, prop_id)

        self.assertEqual(config_got['prop_id'], prop_id,
                         'The prop_id was not set up properly!')

        self.assertTrue(config_got['aggregatable'])
        self.assertEqual(config_got['type'], 'double')
        self.assertEqual(config_got['label'], 'Similarity')
        self.assertEqual(config_got['label_mini'], 'Similarity')

    # ------------------------------------------------------------------------------------------------------------------
    # Getting a custom list of properties
    # ------------------------------------------------------------------------------------------------------------------
    def test_fails_config_for_a_list_of_properties_when_index_does_not_exist(self):

        index_name = 'does_not_exist'
        props = ['_metadata.assay_data.assay_subcellular_fraction']

        try:
            configuration_getter.get_config_for_props_list(index_name, props)
            self.fail('This should have thrown an exception for a non existing index!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    def test_fails_config_for_a_list_of_properties_when_property_does_not_exist(self):

        index_name = 'chembl_activity'
        props = ['does_not_exist']

        try:
            configuration_getter.get_config_for_props_list(index_name, props)
            self.fail('This should have thrown an exception for a non existing property!')
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
    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_fails_when_index_does_not_exist(self):

        index_name = 'does_not_exist'
        group_name = 'download'

        try:
            configs_got = configuration_getter.get_config_for_group(index_name, group_name)
            self.fail('This should have thrown an exception for a non existing index!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_fails_when_group_does_not_exist(self):

        index_name = 'chembl_activity'
        group_name = 'does_not_exist'

        try:
            configs_got = configuration_getter.get_config_for_group(index_name, group_name)
            self.fail('This should have thrown an exception for a non existing group!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_with_only_default_properties(self):

        index_name = 'chembl_activity'
        group_name = 'download'

        configs_got = configuration_getter.get_config_for_group(index_name, group_name)
        groups_must_be = yaml.load(open(settings.PROPERTIES_GROUPS_FILE, 'r'), Loader=yaml.FullLoader)
        group_must_be = groups_must_be[index_name][group_name]

        for sub_group, props_list_must_be in group_must_be.items():
            props_list_got = [c['prop_id'] for c in configs_got[sub_group]]
            self.assertTrue(props_list_got == props_list_must_be)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_with_default_and_additional_properties(self):

        index_name = 'chembl_activity'
        group_name = 'table'

        configs_got = configuration_getter.get_config_for_group(index_name, group_name)
        groups_must_be = yaml.load(open(settings.PROPERTIES_GROUPS_FILE, 'r'), Loader=yaml.FullLoader)
        group_must_be = groups_must_be[index_name][group_name]

        for sub_group, props_list_must_be in group_must_be.items():
            props_list_got = [c['prop_id'] for c in configs_got[sub_group]]
            self.assertTrue(props_list_got == props_list_must_be)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_with_default_sorting(self):

        index_name = 'chembl_molecule'
        group_name = 'sorted_table'

        configs_got = configuration_getter.get_config_for_group(index_name, group_name)
        groups_must_be = yaml.load(open(settings.PROPERTIES_GROUPS_FILE, 'r'), Loader=yaml.FullLoader)
        group_must_be = groups_must_be[index_name][group_name]

        for sub_group, props_list_must_be in group_must_be.items():
            if sub_group != '__default_sorting__':
                props_list_got = [c['prop_id'] for c in configs_got[sub_group]]
                self.assertTrue(props_list_got == props_list_must_be)

