import unittest
from glados.es_properties_configuration import configuration_getter


class ConfigurationGetterTester(unittest.TestCase):

    def test_gets_config_for_one_property_with_no_override(self):

        print('test_gets_config_for_one_property')
        index_name = 'chembl_activity'
        prop_id = '_metadata.assay_data.assay_subcellular_fraction'
        config_got = configuration_getter.get_config_for(index_name, prop_id)
        print('config_got: ', config_got)

        self.assertEqual(config_got['index_name'], index_name)
        self.assertEqual(config_got['prop_id'], prop_id)