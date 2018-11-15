import unittest
from glados import schema_tags_generator

class MetadataGenerationTester(unittest.TestCase):


    def setUp(self):
        print('Running Test: {0}'.format(self._testMethodName))

    def test_metadata_is_not_produced_for_some_compound_types(self):

        pass
        # # not generated for compounds type unclassified
        # schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('CHEMBL2108378')
        # print('schema_obj_got: ')
        # print(schema_obj_got)
        # pass