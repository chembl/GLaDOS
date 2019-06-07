import unittest
from glados.es_properties_configuration import configuration_getter
import glados.ws2es.es_util as es_util


class ConfigurationGetterTester(unittest.TestCase):

    def setUp(self):
        es_util.setup_connection('wp-p1m-50.ebi.ac.uk', 9200)

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
        prop_id = 'does not exist'

        try:
            config_got = configuration_getter.get_config_for(index_name, prop_id)
            self.assertTrue(False, 'This should have thrown an exception for a non existing property!')
        except configuration_getter.ESPropsConfigurationGetterError:
            pass

    def test_gets_config_for_one_property_with_no_override(self):

        print('test_gets_config_for_one_property')
        index_name = 'chembl_activity'
        prop_id = '_metadata.assay_data.assay_subcellular_fraction'
        config_got = configuration_getter.get_config_for(index_name, prop_id)
        print('config_got: ', config_got)

        self.assertEqual(config_got['index_name'], index_name)
        self.assertEqual(config_got['prop_id'], prop_id)