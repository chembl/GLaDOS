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

        schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('nonexistent')
        self.assertFalse(schema_obj_got['metadata_generated'])

    def test_metadata_is_not_produced_for_some_compound_types(self):

        # # not generated for compounds type unclassified
        schema_obj_got = schema_tags_generator.get_schema_obj_for_compound('CHEMBL1256399')
        self.assertFalse(schema_obj_got['metadata_generated'])