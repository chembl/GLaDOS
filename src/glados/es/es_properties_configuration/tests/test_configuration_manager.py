from django.test import TestCase, override_settings
from glados.es.es_properties_configuration import configuration_manager
import glados.es.ws2es.es_util as es_util
from django.conf import settings
from glados.settings import RunEnvs
import os
import yaml


class ConfigurationGetterTester(TestCase):
    CONFIG_TEST_FILE = os.path.join(settings.GLADOS_ROOT, 'es/es_properties_configuration/tests/data/test_override.yml')
    GROUPS_TEST_FILE = os.path.join(settings.GLADOS_ROOT, 'es/es_properties_configuration/tests/data/test_groups.yml')
    SORTING_TEST_FILE = os.path.join(settings.GLADOS_ROOT,
                                     'es/es_properties_configuration/tests/data/test_default_sorting.yml')

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
            config_got = configuration_manager.get_config_for_prop(index_name, prop_id)
            self.fail('This should have thrown an exception for a non existing index!')
        except configuration_manager.ESPropsConfigurationManagerError:
            pass

    def test_fails_when_property_does_not_exist(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'activity'
        prop_id = 'does_not_exist'

        try:
            config_got = configuration_manager.get_config_for_prop(index_name, prop_id)
            self.fail('This should have thrown an exception for a non existing property!')
        except configuration_manager.ESPropsConfigurationManagerError:
            pass

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_one_property_with_no_override(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'activity'
        prop_id = '_metadata.assay_data.assay_subcellular_fraction'
        config_got = configuration_manager.get_config_for_prop(index_name, prop_id)

        self.assertEqual(config_got['index_name'], index_name)
        self.assertEqual(config_got['prop_id'], prop_id)
        self.assertTrue(config_got['aggregatable'])
        self.assertEqual(config_got['type'], 'string')
        self.assertEqual(config_got['label'], 'Assay Data Subcellular Fraction')
        self.assertEqual(config_got['label_mini'], 'As. Data Subc. Frct.')

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_one_property_with_override(self):

        override_config_must_be = yaml.load(open(settings.PROPERTIES_CONFIG_OVERRIDE_FILE, 'r'), Loader=yaml.FullLoader)

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'activity'
        prop_id = '_metadata.activity_generated.short_data_validity_comment'
        config_got = configuration_manager.get_config_for_prop(index_name, prop_id)

        property_config_must_be = override_config_must_be[index_name][prop_id]
        self.assertEqual(config_got['label'], property_config_must_be['label'],
                         'The label was not overridden properly!')
        self.assertEqual(config_got['label_mini'], property_config_must_be['label_mini'],
                         'The label mini was not overridden properly!')

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_a_virtual_property(self):

        override_config_must_be = yaml.load(open(settings.PROPERTIES_CONFIG_OVERRIDE_FILE, 'r'), Loader=yaml.FullLoader)

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        prop_id = 'trade_names'
        config_got = configuration_manager.get_config_for_prop(index_name, prop_id)

        property_config_must_be = override_config_must_be[index_name][prop_id]
        self.assertEqual(config_got['prop_id'], prop_id,
                         'The prop_id was not set up properly!')
        self.assertEqual(config_got['based_on'], property_config_must_be['based_on'],
                         'The based_on was not set up properly!')
        self.assertEqual(config_got['label'], property_config_must_be['label'],
                         'The label was not set up properly!')
        self.assertFalse(config_got['aggregatable'], 'This property should not be aggregatable')

        self.assertEqual(config_got['is_virtual'], True,
                         'This is a virtual property!')
        self.assertEqual(config_got['is_contextual'], False,
                         'This is not a contextual property!')

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_fails_for_a_virtual_property_based_on_non_existing_prop(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        prop_id = 'trade_names_wrong'

        try:
            config_got = configuration_manager.get_config_for_prop(index_name, prop_id)
            self.fail('This should have thrown an exception for a non existing property!')
        except configuration_manager.ESPropsConfigurationManagerError:
            pass

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_makes_sure_config_for_a_contextual_property_is_correct(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        prop_id = '_context.similarity_wrong'

        try:
            config_got = configuration_manager.get_config_for_prop(index_name, prop_id)
            self.fail('This should have thrown an exception for a bad configuration!')
        except configuration_manager.ESPropsConfigurationManagerError:
            pass

    @override_settings(PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_gets_config_for_a_contextual_property(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        prop_id = '_context.similarity'
        config_got = configuration_manager.get_config_for_prop(index_name, prop_id)

        self.assertEqual(config_got['prop_id'], prop_id,
                         'The prop_id was not set up properly!')

        self.assertFalse(config_got['aggregatable'])
        self.assertTrue(config_got['sortable'])
        self.assertEqual(config_got['type'], 'double')
        self.assertEqual(config_got['label'], 'Similarity')
        self.assertEqual(config_got['label_mini'], 'Similarity')

        self.assertEqual(config_got['is_virtual'], True, 'This is a virtual property!')
        self.assertEqual(config_got['is_contextual'], True, 'This is a contextual property!')

    # ------------------------------------------------------------------------------------------------------------------
    # Getting a custom list of properties
    # ------------------------------------------------------------------------------------------------------------------
    def test_fails_config_for_a_list_of_properties_when_index_does_not_exist(self):

        index_name = 'does_not_exist'
        props = ['_metadata.assay_data.assay_subcellular_fraction']

        try:
            configuration_manager.get_config_for_props_list(index_name, props)
            self.fail('This should have thrown an exception for a non existing index!')
        except configuration_manager.ESPropsConfigurationManagerError:
            pass

    def test_fails_config_for_a_list_of_properties_when_property_does_not_exist(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'activity'
        props = ['does_not_exist']

        try:
            configuration_manager.get_config_for_props_list(index_name, props)
            self.fail('This should have thrown an exception for a non existing property!')
        except configuration_manager.ESPropsConfigurationManagerError:
            pass

    def test_gets_config_for_a_list_of_properties(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'activity'
        props = ['_metadata.activity_generated.short_data_validity_comment', '_metadata.assay_data.assay_cell_type']

        configs_got = configuration_manager.get_config_for_props_list(index_name, props)
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
        self.assertEqual(config['label'], 'Assay Cell Type')
        self.assertEqual(config['label_mini'], 'Assay Data Cell Type')

    # ------------------------------------------------------------------------------------------------------------------
    # Getting a group of properties
    # ------------------------------------------------------------------------------------------------------------------
    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_fails_when_index_does_not_exist(self):

        index_name = 'does_not_exist'
        group_name = 'download'

        try:
            configs_got = configuration_manager.get_config_for_group(index_name, group_name)['properties']
            self.fail('This should have thrown an exception for a non existing index!')
        except configuration_manager.ESPropsConfigurationManagerError:
            pass

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_fails_when_group_does_not_exist(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'activity'
        group_name = 'does_not_exist'

        try:
            configs_got = configuration_manager.get_config_for_group(index_name, group_name)['properties']
            self.fail('This should have thrown an exception for a non existing group!')
        except configuration_manager.ESPropsConfigurationManagerError:
            pass

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_with_only_default_properties(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'activity'
        group_name = 'download'

        configs_got = configuration_manager.get_config_for_group(index_name, group_name)['properties']
        groups_must_be = yaml.load(open(settings.PROPERTIES_GROUPS_FILE, 'r'), Loader=yaml.FullLoader)
        group_must_be = groups_must_be[index_name][group_name]

        for sub_group, props_list_must_be in group_must_be.items():
            props_list_got = [c['prop_id'] for c in configs_got[sub_group]]
            self.assertTrue(props_list_got == props_list_must_be)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE)
    def test_gets_config_for_a_group_with_default_and_additional_properties(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'activity'
        group_name = 'table'

        configs_got = configuration_manager.get_config_for_group(index_name, group_name)['properties']
        groups_must_be = yaml.load(open(settings.PROPERTIES_GROUPS_FILE, 'r'), Loader=yaml.FullLoader)
        group_must_be = groups_must_be[index_name][group_name]

        for sub_group, props_list_must_be in group_must_be.items():
            props_list_got = [c['prop_id'] for c in configs_got[sub_group]]
            self.assertTrue(props_list_got == props_list_must_be)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, GROUPS_DEFAULT_SORTING_FILE=SORTING_TEST_FILE)
    def test_gets_config_for_a_group_with_default_sorting(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        group_name = 'sorted_table'

        configs_got = configuration_manager.get_config_for_group(index_name, group_name)
        properties_got = configs_got['properties']

        groups_must_be = yaml.load(open(settings.PROPERTIES_GROUPS_FILE, 'r'), Loader=yaml.FullLoader)
        group_must_be = groups_must_be[index_name][group_name]
        sortings_must_be = yaml.load(open(settings.GROUPS_DEFAULT_SORTING_FILE, 'r'), Loader=yaml.FullLoader)
        sorting_must_be = sortings_must_be[index_name][group_name]

        sorting_got = configs_got['default_sorting']

        for sub_group, props_list_must_be in group_must_be.items():
            props_list_got = [c['prop_id'] for c in properties_got[sub_group]]
            self.assertTrue(props_list_got == props_list_must_be)

        self.assertEqual(sorting_must_be, sorting_got, msg='The default sorting was not set up correctly')

    def test_gets_id_property_for_index(self):

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        id_property_must_be = 'molecule_chembl_id'

        for index_name, id_property_must_be in [(settings.CHEMBL_ES_INDEX_PREFIX+'molecule', 'molecule_chembl_id')]:
            id_property_got = configuration_manager.get_id_property_for_index(index_name)

            self.assertEqual(id_property_must_be, id_property_got, msg='The id property for {} was not returned '
                                                                       'correctly!'.format(index_name))

    def test_fails_to_get_id_property_when_index_does_not_exist(self):

        index_name = 'does_not_exist'

        with self.assertRaises(configuration_manager.ESPropsConfigurationManagerError,
                               msg='This should rise an error when the index does not exist'):
            configuration_manager.get_id_property_for_index(index_name)

    def test_fails_to_get_id_property_when_it_is_a_compound_id(self):
        """Handling of compound ids is not implemented yet! mostly in using contexts!"""

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'mechanism_by_parent_target'
        # for now, the id property will be the first property
        id_property_must_be = 'parent_molecule.molecule_chembl_id'

        with self.assertWarns(configuration_manager.ESPropsConfigurationManagerWarning,
                              msg='This should have warned when the index has a compound id'):
            id_property_got = configuration_manager.get_id_property_for_index(index_name)
            self.assertEqual(id_property_must_be, id_property_got, msg='The id property was not returned properly')
