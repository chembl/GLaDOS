from django.test import TestCase
from glados.api.chembl.dynamic_downloads import jobs
from glados.api.chembl.dynamic_downloads import job_status
from glados.api.chembl.dynamic_downloads.models import DownloadJob


class DownloadJobsTester(TestCase):

    def setUp(self):
        DownloadJob.objects.all().delete()

    def tearDown(self):
        DownloadJob.objects.all().delete()

    def test_make_csv_download_file(self):
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
            log=job_status.format_log_message('Job Queued'),
            context_id=None,
            id_property='molecule_chembl_id'
        )
        test_download_job.save()

        jobs.make_download_file(job_id)
