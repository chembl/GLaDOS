from django.test import TestCase
from glados.es import file_writer
import json
import time
import gzip
from django.conf import settings
import os


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
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())

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
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())

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
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_writer.write_separated_values_file(
            desired_format=file_writer.OutputFormats.CSV,
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

        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_writer.write_separated_values_file(
            desired_format=file_writer.OutputFormats.CSV,
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

    def test_fails_with_context_but_no_id_property(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'property_name': 'molecule_synonyms'}]
        test_index_name = 'chembl_molecule'
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        test_contextual_columns = [{'label': 'Similarity', 'property_name': 'similarity'}]

        test_context = {
            'ChEMBL59': {
                'molecule_chembl_id': 'ChEMBL59',
                'similarity': 100.0
            }
        }

        filename = 'test' + str(int(round(time.time() * 1000)))
        with self.assertRaises(file_writer.FileWriterError,
                               msg='It should raise an error when the conexts is given but no id property'):
            out_file_path, total_items = file_writer.write_separated_values_file(
                desired_format=file_writer.OutputFormats.CSV,
                index_name=test_index_name, query=test_query,
                columns_to_download=test_columns_to_download,
                base_file_name=filename, context=test_context,
                contextual_columns=test_contextual_columns)

    def test_fails_with_context_but_no_contextual_columns(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'property_name': 'molecule_synonyms'}]
        test_index_name = 'chembl_molecule'
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        id_property = 'molecule_chembl_id'

        test_context = {
            'ChEMBL59': {
                'molecule_chembl_id': 'ChEMBL59',
                'similarity': 100.0
            }
        }

        filename = 'test' + str(int(round(time.time() * 1000)))
        with self.assertRaises(file_writer.FileWriterError,
                               msg='It should raise an error when the conexts is given but no contextual columns '
                                   'description'):
            out_file_path, total_items = file_writer.write_separated_values_file(
                desired_format=file_writer.OutputFormats.CSV,
                index_name=test_index_name, query=test_query,
                columns_to_download=test_columns_to_download,
                base_file_name=filename, context=test_context,
                id_property=id_property)

    def test_writes_csv_files_with_context(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'property_name': 'molecule_synonyms'}]
        test_index_name = 'chembl_molecule'
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        id_property = 'molecule_chembl_id'
        test_contextual_columns = [{'label': 'Similarity', 'property_name': 'similarity'}]

        test_context = {
            'CHEMBL59': {
                'molecule_chembl_id': 'CHEMBL59',
                'similarity': 100.0
            }
        }

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_writer.write_separated_values_file(
            desired_format=file_writer.OutputFormats.CSV,
            index_name=test_index_name, query=test_query,
            columns_to_download=test_columns_to_download,
            base_file_name=filename, context=test_context,
            id_property=id_property,
            contextual_columns=test_contextual_columns)

        with gzip.open(out_file_path, 'rt', encoding='utf-16-le') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"Similarity";"ChEMBL ID";"Synonyms"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"100.0";"CHEMBL59";"Carbilev|DOPAMINE|Dopamine|Intropin|Parcopa|Sinemet"\n',
                             'Line is malformed!')

    def test_reports_file_writing_progress(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'property_name': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'property_name': 'molecule_synonyms'}]
        test_index_name = 'chembl_molecule'

        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query1.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        id_property = 'molecule_chembl_id'
        test_contextual_columns = [{'label': 'Similarity', 'property_name': 'similarity'}]

        test_context = {
            'CHEMBL59': {
                'molecule_chembl_id': 'CHEMBL59',
                'similarity': 100.0
            }
        }
        progress_got = []
        progress_function = lambda progress: progress_got.append(progress)

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_writer.write_separated_values_file(
            desired_format=file_writer.OutputFormats.CSV,
            index_name=test_index_name, query=test_query,
            columns_to_download=test_columns_to_download,
            base_file_name=filename, context=test_context,
            id_property=id_property,
            contextual_columns=test_contextual_columns,
            progress_function=progress_function
        )

        is_ascending = all(progress_got[i] <= progress_got[i + 1] for i in range(len(progress_got) - 1))
        ends_with100 = progress_got[-1] == 100

        self.assertTrue(is_ascending, msg='The progress is not reported correctly, it should be ascending. '
                                          'I got this: {}\n'.format(str(progress_got)))

        self.assertTrue(ends_with100, msg='The progress must end with 100. I got this: {}\n'.format(
            str(progress_got)))

    # ------------------------------------------------------------------------------------------------------------------
    # SDF Files
    # ------------------------------------------------------------------------------------------------------------------
    def test_writes_simple_sdf_file(self):

        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        filename = 'test_sdf' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_writer.write_sdf_file(test_query, filename)

        # content_must_be = open(out_file_path, 'rt')
        print('out_file_path: ', out_file_path)
        with gzip.open(out_file_path, 'rt') as file_got:
            content_got = file_got.read()
            print('content_got: ')
            print(content_got)

