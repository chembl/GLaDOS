import unittest
import os
from glados import schema_tags_generator
from django.conf import settings
import ftplib


class MetadataGenerationTester(unittest.TestCase):

    def setUp(self):
        os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'
        print('METADATA GENERATION TEST')
        print('Running Test: {0}'.format(self._testMethodName))

    def test_metadata_is_produced_for_main_page(self):

        schema_obj_got = schema_tags_generator.get_main_page_schema(None)

        self.assertEqual(schema_obj_got.get('schema:identifier'), settings.CURRENT_CHEMBL_FULL_DOI)
        self.assertEqual(schema_obj_got.get('schema:version'), settings.CURRENT_CHEMBL_RELEASE_NAME)

        # Travis has some troubles connecting to FTPs :(
        # ftp = ftplib.FTP("ftp.ebi.ac.uk")
        # ftp.login("anonymous", "ftplib-example-1")
        # file_list = ftp.nlst('/pub/databases/chembl/ChEMBLdb/latest/')
        # file_names = [f.replace('/pub/databases/chembl/ChEMBLdb/latest/', '') for f in file_list]

        for distribution in schema_obj_got.get('schema:distribution'):

            # file_url = distribution['contentURL']
            # file_name_got = file_url.replace('ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/', '')
            # self.assertIn(file_name_got, file_names, '{} is not in the ftp'.format(file_url))
            upload_date_got = distribution['uploadDate']
            self.assertEqual(upload_date_got, settings.CURRENT_DOWNLOADS_DATE)

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

