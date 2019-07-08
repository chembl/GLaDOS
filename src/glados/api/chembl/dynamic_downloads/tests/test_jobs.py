from django.test import TestCase
from glados.api.chembl.dynamic_downloads import jobs
from glados.api.chembl.dynamic_downloads.models import DownloadJob
import os
from datetime import timedelta
from django.utils import timezone
from django.conf import settings
import json
import gzip
from pathlib import Path


class DownloadJobsTester(TestCase):
    def setUp(self):
        DownloadJob.objects.all().delete()

    def tearDown(self):
        DownloadJob.objects.all().delete()

    def test_make_csv_download_file_no_context(self):
        job_id = 'CHEMBL25-chembl_molecule-gZ6DeuyotzHOwnHi1bKOiu_WHWBbLgOlaCGSTa4Hiuw=.csv'
        test_download_job = DownloadJob(
            job_id=job_id,
            index_name='chembl_molecule',
            raw_columns_to_download='[{"prop_id":"molecule_chembl_id","label":"ChEMBL ID"},'
                                    '{"prop_id":"pref_name","label":"Name"}]',
            raw_query='{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}',
            desired_format='csv',
            log=DownloadJob.format_log_message('Job Queued'),
            context_id=None,
            id_property='molecule_chembl_id'
        )
        test_download_job.save()

        # Here is the Tested Function!!!!
        out_file_path_got, total_items_got = jobs.make_download_file(job_id)
        finished_time = timezone.now()
        delta = timedelta(days=DownloadJob.DAYS_TO_EXPIRE)
        expiration_date_should_be = finished_time + delta
        expiration_date_should_be_seconds = expiration_date_should_be.timestamp()

        test_download_job.refresh_from_db()
        total_items_must_be = 1
        self.assertEqual(total_items_got, total_items_must_be, msg='The total items got is not correct')
        self.assertTrue(os.path.exists(out_file_path_got), msg='The output file was not generated!')

        final_status_must_be = DownloadJob.FINISHED
        final_progress_must_be = 100
        final_status_got = test_download_job.status
        final_progress_got = test_download_job.progress

        self.assertEqual(final_status_must_be, final_status_got, msg='The final status of the job '
                                                                     'is not "Finished"')
        self.assertEqual(final_progress_must_be, final_progress_got, msg='The final progress of the job must be 100')

        expiration_date_got = test_download_job.expires
        expiration_date_got_seconds = expiration_date_got.timestamp()
        self.assertAlmostEqual(expiration_date_got_seconds, expiration_date_should_be_seconds, delta=30,
                               msg='The expiration time was not calculated correctly')

        # finally. the file must have been created
        self.assertTrue(Path(out_file_path_got).is_file(), msg='The output file was not created!!!')

    def test_make_csv_download_file_with_context(self):
        # move a search results mock file for this test
        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')

        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        job_id = 'CHEMBL25-chembl_molecule-gZ6DeuyotzHOwnHi1bKOiu_WHWBbLgOlaCGSTa4Hiuw=.csv'
        context_id = 'test_search_context'
        test_download_job = DownloadJob(
            job_id=job_id,
            index_name='chembl_molecule',
            raw_columns_to_download='[{"prop_id":"molecule_chembl_id","label":"ChEMBL ID"},'
                                    '{"prop_id":"pref_name","label":"Name"},'
                                    '{"prop_id": "similarity","label": "Similarity","is_contextual": true}]',
            raw_query='{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}',
            desired_format='csv',
            log=DownloadJob.format_log_message('Job Queued'),
            context_id=context_id,
            id_property='molecule_chembl_id'
        )
        test_download_job.save()

        # Here is the Tested Function!!!!
        out_file_path_got, total_items_got = jobs.make_download_file(job_id)
        finished_time = timezone.now()
        delta = timedelta(days=DownloadJob.DAYS_TO_EXPIRE)
        expiration_date_should_be = finished_time + delta
        expiration_date_should_be_seconds = expiration_date_should_be.timestamp()

        test_download_job.refresh_from_db()
        total_items_must_be = 1
        self.assertEqual(total_items_got, total_items_must_be, msg='The total items got is not correct')
        self.assertTrue(os.path.exists(out_file_path_got), msg='The output file was not generated!')

        final_status_must_be = DownloadJob.FINISHED
        final_progress_must_be = 100
        final_status_got = test_download_job.status
        final_progress_got = test_download_job.progress

        self.assertEqual(final_status_must_be, final_status_got, msg='The final status of the job '
                                                                     'is not "Finished"')
        self.assertEqual(final_progress_must_be, final_progress_got, msg='The final progress of the job must be 100')

        expiration_date_got = test_download_job.expires
        expiration_date_got_seconds = expiration_date_got.timestamp()
        self.assertAlmostEqual(expiration_date_got_seconds, expiration_date_should_be_seconds, delta=1,
                               msg='The expiration time was not calculated correctly')

        with gzip.open(out_file_path_got, 'rt') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"Similarity";"ChEMBL ID";"Name"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"100.0";"CHEMBL59";"DOPAMINE"\n', 'Line is malformed!')

        # finally. the file must have been created
        self.assertTrue(Path(out_file_path_got).is_file(), msg='The output file was not created!!!')
        os.remove(test_search_context_path)

    def test_make_csv_download_file_with_context_and_virtual_properties(self):
        # move a search results mock file for this test
        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')

        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL2108809',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        job_id = 'CHEMBL2108809-chembl_molecule-gZ6DeuyotzHOwnHi1bKOiu_WHWBbLgOlaCGSTa4Hiuw=.csv'
        context_id = 'test_search_context'
        test_download_job = DownloadJob(
            job_id=job_id,
            index_name='chembl_molecule',
            raw_columns_to_download='[{"label": "ChEMBL ID", "prop_id": "molecule_chembl_id"}, '
                                    '{"label": "Research Codes", "prop_id": "research_codes", "is_virtual": true, '
                                    '"is_contextual": false, "based_on": "molecule_synonyms"}, '
                                    '{"prop_id": "similarity","label": "Similarity","is_contextual": true}]',
            raw_query='{"query_string": {"query": "molecule_chembl_id:(CHEMBL2108809)"}}',
            desired_format='csv',
            log=DownloadJob.format_log_message('Job Queued'),
            context_id=context_id,
            id_property='molecule_chembl_id'
        )
        test_download_job.save()

        # Here is the Tested Function!!!!
        out_file_path_got, total_items_got = jobs.make_download_file(job_id)
        finished_time = timezone.now()
        delta = timedelta(days=DownloadJob.DAYS_TO_EXPIRE)
        expiration_date_should_be = finished_time + delta
        expiration_date_should_be_seconds = expiration_date_should_be.timestamp()

        test_download_job.refresh_from_db()
        total_items_must_be = 1
        self.assertEqual(total_items_got, total_items_must_be, msg='The total items got is not correct')
        self.assertTrue(os.path.exists(out_file_path_got), msg='The output file was not generated!')

        final_status_must_be = DownloadJob.FINISHED
        final_progress_must_be = 100
        final_status_got = test_download_job.status
        final_progress_got = test_download_job.progress

        self.assertEqual(final_status_must_be, final_status_got, msg='The final status of the job '
                                                                     'is not "Finished"')
        self.assertEqual(final_progress_must_be, final_progress_got, msg='The final progress of the job must be 100')

        expiration_date_got = test_download_job.expires
        expiration_date_got_seconds = expiration_date_got.timestamp()
        self.assertAlmostEqual(expiration_date_got_seconds, expiration_date_should_be_seconds, delta=1,
                               msg='The expiration time was not calculated correctly')

        with gzip.open(out_file_path_got, 'rt') as file_got:
            lines_got = file_got.readlines()
            line_0 = lines_got[0]
            self.assertEqual(line_0, '"Similarity";"ChEMBL ID";"Research Codes"\n', 'Header line is malformed!')
            line_1 = lines_got[1]
            self.assertEqual(line_1, '"100.0";"CHEMBL2108809";"IMMU-MN3"\n', 'Line is malformed!')

        # finally. the file must have been created
        self.assertTrue(Path(out_file_path_got).is_file(), msg='The output file was not created!!!')
        os.remove(test_search_context_path)

    def test_fails_when_format_is_not_available(self):
        job_id = 'CHEMBL25-chembl_molecule-gZ6DeuyotzHOwnHi1bKOiu_WHWBbLgOlaCGSTa4Hiuw=.csv'
        test_download_job = DownloadJob(
            job_id=job_id,
            index_name='chembl_molecule',
            raw_columns_to_download='[{"prop_id":"molecule_chembl_id","label":"ChEMBL ID"},'
                                    '{"prop_id":"pref_name","label":"Name"}]',
            raw_query='{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}',
            desired_format='kgjhgjhgjhgjhghj',
            log=DownloadJob.format_log_message('Job Queued'),
            context_id=None,
            id_property='molecule_chembl_id'
        )
        test_download_job.save()

        with self.assertRaises(jobs.DownloadJobError,
                               msg='It should raise an error when the given format is not supported'):
            jobs.make_download_file(job_id)

    def test_make_sdf_download_file(self):
        job_id = 'CHEMBL25-chembl_molecule-gZ6DeuyotzHOwnHi1bKOiu_WHWBbLgOlaCGSTa4Hiuw=.csv'
        test_download_job = DownloadJob(
            job_id=job_id,
            index_name='chembl_molecule',
            raw_query='{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}',
            desired_format='sdf',
            log=DownloadJob.format_log_message('Job Queued'),
            context_id=None,
            id_property='molecule_chembl_id'
        )
        test_download_job.save()
        out_file_path_got, total_items_got = jobs.make_download_file(job_id)

        finished_time = timezone.now()
        delta = timedelta(days=DownloadJob.DAYS_TO_EXPIRE)
        expiration_date_should_be = finished_time + delta
        expiration_date_should_be_seconds = expiration_date_should_be.timestamp()

        test_download_job.refresh_from_db()
        total_items_must_be = 1
        self.assertEqual(total_items_got, total_items_must_be, msg='The total items got is not correct')
        self.assertTrue(os.path.exists(out_file_path_got), msg='The output file was not generated!')

        final_status_must_be = DownloadJob.FINISHED
        final_progress_must_be = 100
        final_status_got = test_download_job.status
        final_progress_got = test_download_job.progress

        self.assertEqual(final_status_must_be, final_status_got, msg='The final status of the job '
                                                                     'is not "Finished"')
        self.assertEqual(final_progress_must_be, final_progress_got, msg='The final progress of the job must be 100')

        expiration_date_got = test_download_job.expires
        expiration_date_got_seconds = expiration_date_got.timestamp()
        self.assertAlmostEqual(expiration_date_got_seconds, expiration_date_should_be_seconds, delta=30,
                               msg='The expiration time was not calculated correctly')

        self.assertTrue(Path(out_file_path_got).is_file(), msg='The output file was not created!!!')
