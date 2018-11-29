import unittest
import os
from django.conf import settings
from glados import es_connection
from glados import schema_tags_generator


class MetadataGenerationTester(unittest.TestCase):

    def setUp(self):
        os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'
        settings.ELASTICSEARCH_HOST = 'https://www.ebi.ac.uk/chembl/glados-es/'
        es_connection.setup_glados_es_connection()
        print('Running Test: {0}'.format(self._testMethodName))

    def test_metadata_is_not_produced_for_nonexistent_compounds(self):

        schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('nonexistent', None)
        self.assertFalse(schema_obj_got['metadata_generated'])

    def test_metadata_is_not_produced_for_some_compound_types(self):

        # not generated for compounds type unclassified
        schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('CHEMBL1256399', None)
        self.assertFalse(schema_obj_got['metadata_generated'])

        # not generated for compounds type cell, this should produce the schema for cells as defined in bioschemas
        schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('CHEMBL2108615', None)
        self.assertFalse(schema_obj_got['metadata_generated'])

        # not generated for compounds type antibody, this should produce the schema for protein as defined in bioschemas
        schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('CHEMBL2108378', None)
        self.assertFalse(schema_obj_got['metadata_generated'])

        # not generated for compounds type enzyme, this should produce the schema for enzyme as defined in bioschemas
        schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('CHEMBL2108476', None)
        self.assertFalse(schema_obj_got['metadata_generated'])

        # not generated for compounds type protein, this should produce the schema for protein as defined in bioschemas
        schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('CHEMBL308896', None)
        self.assertFalse(schema_obj_got['metadata_generated'])

