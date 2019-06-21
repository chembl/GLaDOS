from django.test import TestCase
from glados.api.chembl.dynamic_downloads import jobs
from glados.api.chembl.dynamic_downloads.models import DownloadJob
import os
from datetime import timedelta
from django.utils import timezone


class DownloadJobsTester(TestCase):
    def setUp(self):
        DownloadJob.objects.all().delete()

    def tearDown(self):
        DownloadJob.objects.all().delete()

    def test_make_csv_download_file_no_context(self):
        print('------------------------------------------------------------------------')
        print('test_make_download_file!!!')
        print('------------------------------------------------------------------------')

        job_id = 'CHEMBL25-chembl_molecule-gZ6DeuyotzHOwnHi1bKOiu_WHWBbLgOlaCGSTa4Hiuw=.csv'
        test_download_job = DownloadJob(
            job_id=job_id,
            index_name='chembl_molecule',
            raw_columns_to_download=
            '[{"property_name":"molecule_chembl_id","label":"ChEMBL ID"},{"property_name":"pref_name","label":"Name"}]',
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
        self.assertAlmostEqual(expiration_date_got_seconds, expiration_date_should_be_seconds, delta=1,
                               msg='The expiration time was not calculated correctly')

    # TODO: Test with context


