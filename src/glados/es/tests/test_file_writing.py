from django.test import TestCase
from glados.es import file_writer
import json
import time
import gzip


class FileWriterTester(TestCase):
    def test_generates_source(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Name', 'property_name': 'pref_name'}]

        source_must_be = ['molecule_chembl_id', 'pref_name']
        source_got = file_writer.get_search_source(test_columns_to_download)
        self.assertEqual(source_must_be, source_got, 'The search source is not generated correctly')

    def test_fails_when_output_format_is_not_available(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Name', 'property_name': 'pref_name'}]
        test_index_name = 'chembl_molecule'

        test_query = json.loads(open('src/glados/es/tests/data/test_query0.json', 'r').read())

        with self.assertRaises(file_writer.FileWriterError,
                               msg='It should raise an error when the given format is not supported'):
            file_writer.write_separated_values_file(desired_format='XLSX',
                                                    index_name=test_index_name,
                                                    query=test_query,
                                                    columns_to_download=test_columns_to_download,
                                                    base_file_name='test' + str(int(round(time.time() * 1000))))

    def test_fails_when_index_name_is_not_provided(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Name', 'property_name': 'pref_name'}]
        test_index_name = None

        test_query = json.loads(open('src/glados/es/tests/data/test_query0.json', 'r').read())

        with self.assertRaises(file_writer.FileWriterError,
                               msg='It should raise an error when the index name is not given'):
            file_writer.write_separated_values_file(desired_format=file_writer.OutputFormats.CSV,
                                                    index_name=test_index_name,
                                                    query=test_query,
                                                    columns_to_download=test_columns_to_download,
                                                    base_file_name='test' + str(int(round(time.time() * 1000))))

    def test_downloads_and_writes_csv_file_no_parsing_required(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Name', 'property_name': 'pref_name'}]
        test_index_name = 'chembl_molecule'

        test_query = json.loads(open('src/glados/es/tests/data/test_query0.json', 'r').read())

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path = file_writer.write_separated_values_file(desired_format=file_writer.OutputFormats.CSV,
                                                                index_name=test_index_name, query=test_query,
                                                                columns_to_download=test_columns_to_download,
                                                                base_file_name=filename)

        with gzip.open(out_file_path, 'rt', encoding='utf-16-le') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"ChEMBL ID";"Name"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"CHEMBL59";"DOPAMINE"\n', 'Line is malformed!')

    def test_downloads_and_writes_csv_file_parsing_required(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'property_name': 'molecule_synonyms'}]
        test_index_name = 'chembl_molecule'

        test_query = json.loads(open('src/glados/es/tests/data/test_query0.json', 'r').read())

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path = file_writer.write_separated_values_file(desired_format=file_writer.OutputFormats.CSV,
                                                                index_name=test_index_name, query=test_query,
                                                                columns_to_download=test_columns_to_download,
                                                                base_file_name=filename)

        with gzip.open(out_file_path, 'rt', encoding='utf-16-le') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"ChEMBL ID";"Synonyms"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"CHEMBL59";"Carbilev|DOPAMINE|Dopamine|Intropin|Parcopa|Sinemet"\n',
                             'Line is malformed!')


