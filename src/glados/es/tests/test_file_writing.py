from django.test import TestCase
from glados.es import file_generator
import json
import time
import gzip
from django.conf import settings
import os


class FileWriterTester(TestCase):
    def test_generates_source(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Name', 'prop_id': 'pref_name'}]

        source_must_be = ['molecule_chembl_id', 'pref_name']
        source_got = file_generator.get_search_source(test_columns_to_download)
        self.assertEqual(source_must_be, source_got, 'The search source is not generated correctly')

    def test_generates_source_for_virtual_properties(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Research Codes', 'prop_id': 'research_codes', 'is_virtual': True,
                                     'is_contextual': True, 'based_on': 'molecule_synonyms'}]

        source_must_be = ['molecule_chembl_id', 'molecule_synonyms']
        source_got = file_generator.get_search_source(test_columns_to_download)
        self.assertEqual(source_must_be, source_got, 'The search source is not generated correctly')

    def test_fails_when_output_format_is_not_available(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Name', 'prop_id': 'pref_name'}]
        test_index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())

        with self.assertRaises(file_generator.FileGeneratorError,
                               msg='It should raise an error when the given format is not supported'):
            file_generator.write_separated_values_file(desired_format='XLSX',
                                                    index_name=test_index_name,
                                                    query=test_query,
                                                    columns_to_download=test_columns_to_download,
                                                    base_file_name='test' + str(int(round(time.time() * 1000))))

    def test_fails_when_index_name_is_not_provided(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Name', 'prop_id': 'pref_name'}]
        test_index_name = None
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())

        with self.assertRaises(file_generator.FileGeneratorError,
                               msg='It should raise an error when the index name is not given'):
            file_generator.write_separated_values_file(desired_format=file_generator.OutputFormats.CSV,
                                                    index_name=test_index_name,
                                                    query=test_query,
                                                    columns_to_download=test_columns_to_download,
                                                    base_file_name='test' + str(int(round(time.time() * 1000))))

    def test_downloads_and_writes_csv_file_no_parsing_required(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Name', 'prop_id': 'pref_name'}]
        test_index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_generator.write_separated_values_file(
            desired_format=file_generator.OutputFormats.CSV,
            index_name=test_index_name, query=test_query,
            columns_to_download=test_columns_to_download,
            base_file_name=filename)

        with gzip.open(out_file_path, 'rt') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"ChEMBL ID";"Name"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"CHEMBL59";"DOPAMINE"\n', 'Line is malformed!')

    def test_downloads_and_writes_csv_file_parsing_required(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'prop_id': 'molecule_synonyms'}]
        test_index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'

        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_generator.write_separated_values_file(
            desired_format=file_generator.OutputFormats.CSV,
            index_name=test_index_name, query=test_query,
            columns_to_download=test_columns_to_download,
            base_file_name=filename)

        with gzip.open(out_file_path, 'rt') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"ChEMBL ID";"Synonyms"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"CHEMBL59";"Carbilev|DOPAMINE|Dopamine|Intropin|Parcopa|Sinemet"\n',
                             'Line is malformed!')

    def test_fails_with_context_but_no_id_property(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'prop_id': 'molecule_synonyms'}]
        test_index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        test_contextual_columns = [{'label': 'Similarity', 'prop_id': 'similarity'}]

        test_context = {
            'ChEMBL59': {
                'molecule_chembl_id': 'ChEMBL59',
                'similarity': 100.0
            }
        }

        filename = 'test' + str(int(round(time.time() * 1000)))
        with self.assertRaises(file_generator.FileGeneratorError,
                               msg='It should raise an error when the conexts is given but no id property'):
            out_file_path, total_items = file_generator.write_separated_values_file(
                desired_format=file_generator.OutputFormats.CSV,
                index_name=test_index_name, query=test_query,
                columns_to_download=test_columns_to_download,
                base_file_name=filename, context=test_context,
                contextual_columns=test_contextual_columns)

    def test_fails_with_context_but_no_contextual_columns(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'prop_id': 'molecule_synonyms'}]
        test_index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
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
        with self.assertRaises(file_generator.FileGeneratorError,
                               msg='It should raise an error when the conexts is given but no contextual columns '
                                   'description'):
            out_file_path, total_items = file_generator.write_separated_values_file(
                desired_format=file_generator.OutputFormats.CSV,
                index_name=test_index_name, query=test_query,
                columns_to_download=test_columns_to_download,
                base_file_name=filename, context=test_context,
                id_property=id_property)

    def test_writes_csv_files_with_context(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'prop_id': 'molecule_synonyms'}]
        test_index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query0.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        id_property = 'molecule_chembl_id'
        test_contextual_columns = [{'label': 'Similarity', 'prop_id': 'similarity'}]

        test_context = {
            'CHEMBL59': {
                'molecule_chembl_id': 'CHEMBL59',
                'similarity': 100.0
            }
        }

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_generator.write_separated_values_file(
            desired_format=file_generator.OutputFormats.CSV,
            index_name=test_index_name, query=test_query,
            columns_to_download=test_columns_to_download,
            base_file_name=filename, context=test_context,
            id_property=id_property,
            contextual_columns=test_contextual_columns)

        with gzip.open(out_file_path, 'rt') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"Similarity";"ChEMBL ID";"Synonyms"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"100.0";"CHEMBL59";"Carbilev|DOPAMINE|Dopamine|Intropin|Parcopa|Sinemet"\n',
                             'Line is malformed!')

    def test_writes_csv_files_with_virual_properties(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Research Codes', 'prop_id': 'research_codes', 'is_virtual': True,
                                     'is_contextual': False, 'based_on': 'molecule_synonyms'}]
        test_index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query6.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        id_property = 'molecule_chembl_id'
        test_contextual_columns = [{'label': 'Similarity', 'prop_id': 'similarity'}]

        test_context = {
            'CHEMBL2108809': {
                'molecule_chembl_id': 'CHEMBL2108809',
                'similarity': 100.0
            }
        }

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_generator.write_separated_values_file(
            desired_format=file_generator.OutputFormats.CSV,
            index_name=test_index_name, query=test_query,
            columns_to_download=test_columns_to_download,
            base_file_name=filename, context=test_context,
            id_property=id_property,
            contextual_columns=test_contextual_columns)

        with gzip.open(out_file_path, 'rt') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"Similarity";"ChEMBL ID";"Research Codes"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"100.0";"CHEMBL2108809";"IMMU-MN3"\n',
                             'Line is malformed!')

    def test_reports_file_writing_progress(self):
        test_columns_to_download = [{'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id'},
                                    {'label': 'Synonyms', 'prop_id': 'molecule_synonyms'}]
        test_index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'

        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query1.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        id_property = 'molecule_chembl_id'
        test_contextual_columns = [{'label': 'Similarity', 'prop_id': 'similarity'}]

        test_context = {
            'CHEMBL59': {
                'molecule_chembl_id': 'CHEMBL59',
                'similarity': 100.0
            }
        }
        progress_got = []

        def progress_function(progress):
            progress_got.append(progress)

        filename = 'test' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_generator.write_separated_values_file(
            desired_format=file_generator.OutputFormats.CSV,
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
        out_file_path, total_items = file_generator.write_sdf_file(test_query, filename)

        sdf_must_be_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/simple_sdf_must_be.sdf')
        sdf_must_be = open(sdf_must_be_path, 'rt').read()
        num_items_must_be = 1
        with gzip.open(out_file_path, 'rt') as file_got:
            content_got = file_got.read()
            self.assertEqual(sdf_must_be, content_got, msg='The sdf was not generated properly!')
            self.assertEqual(num_items_must_be, total_items, msg='The total number of items was not returned properly')

    def test_writes_simple_sdf_file_when_some_items_have_no_structure(self):

        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query3.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        filename = 'test_sdf' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_generator.write_sdf_file(test_query, filename)

        sdf_must_be_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/simple_sdf_must_be.sdf')
        sdf_must_be = open(sdf_must_be_path, 'rt').read()
        num_items_must_be = 1

        with gzip.open(out_file_path, 'rt') as file_got:
            content_got = file_got.read()
            self.assertEqual(sdf_must_be, content_got, msg='The sdf was not generated properly!')
            self.assertEqual(num_items_must_be, total_items, msg='The total number of items was not returned properly')

    def test_writes_simple_sdf_file_when_no_items_have_structure(self):

        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query4.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        filename = 'test_sdf' + str(int(round(time.time() * 1000)))
        out_file_path, total_items = file_generator.write_sdf_file(test_query, filename)

        sdf_must_be_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/sdf_when_no_structures_must_be.sdf')
        sdf_must_be = open(sdf_must_be_path, 'rt').read()
        num_items_must_be = 0

        with gzip.open(out_file_path, 'rt') as file_got:
            content_got = file_got.read()
            self.assertEqual(sdf_must_be, content_got, msg='The sdf was not generated properly!')
            self.assertEqual(num_items_must_be, total_items, msg='The total number of items was not returned properly')

    def test_reports_sdf_file_writing_progress(self):

        query_file_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/test_query5.json')
        test_query = json.loads(open(query_file_path, 'r').read())
        filename = 'test_sdf' + str(int(round(time.time() * 1000)))

        progress_got = []

        def progress_function(progress):
            progress_got.append(progress)

        out_file_path, total_items = file_generator.write_sdf_file(test_query, filename,
                                                                progress_function=progress_function)

        sdf_must_be_path = os.path.join(settings.GLADOS_ROOT, 'es/tests/data/sdf_with_3_structures_must_be.sdf')
        sdf_must_be = open(sdf_must_be_path, 'rt').read()
        num_items_must_be = 3

        with gzip.open(out_file_path, 'rt') as file_got:
            content_got = file_got.read()

            self.assertEqual(sdf_must_be, content_got, msg='The sdf was not generated properly!')
            self.assertEqual(num_items_must_be, total_items, msg='The total number of items was not returned properly')

        is_ascending = all(progress_got[i] <= progress_got[i + 1] for i in range(len(progress_got) - 1))
        ends_with100 = progress_got[-1] == 100

        self.assertTrue(is_ascending, msg='The progress is not reported correctly, it should be ascending. '
                                          'I got this: {}\n'.format(str(progress_got)))

        self.assertTrue(ends_with100, msg='The progress must end with 100. I got this: {}\n'.format(
            str(progress_got)))
