from django.test import TestCase
from glados.es import file_writer


class FileWriterTester(TestCase):

    def test_generates_source(self):

        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Name', 'property_name': 'pref_name'}]

        source_must_be = ['molecule_chembl_id', 'pref_name']
        source_got = file_writer.get_search_source(test_columns_to_download)
        self.assertEqual(source_must_be, source_got, 'The search source is not generated correctly')

    def test_downloads_and_writes_csv_file_no_parsing_required(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Name', 'property_name': 'pref_name'}]
        print('test_downloads_and_writes_csv_file')
