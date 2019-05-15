import unittest
from glados.models import DownloadJob
from glados.utils import manage_downloads
from datetime import datetime, timezone, timedelta


class UtilsTester(unittest.TestCase):

    def setUp(self):
        print('Running Test: {0}'.format(self._testMethodName))
        DownloadJob.objects.all().delete()

    def tearDown(self):
        print('Test {0}'.format('Passed!' if self._outcome.success else 'Failed!'))

    def test_expired_downloads_deletion(self):

        # create 3 downloads that with undefined expired time
        for i in range(1, 4):
            download_job = DownloadJob(job_id='never_expires:{}'.format(i))
            download_job.save()

        now = datetime.now()
        now.replace(tzinfo=timezone.utc)
        expired_date = now

        # create 3 downloads that will be expired
        for i in range(1, 4):
            download_job = DownloadJob(job_id='expired:{}'.format(i), expires=expired_date)
            download_job.save()

        td = timedelta(days=1)
        valid_date = datetime.now() + td

        valid_date.replace(tzinfo=timezone.utc)
        # create 3 downloads that will not expired
        for i in range(1, 4):
            download_job = DownloadJob(job_id=i, expires=valid_date)
            download_job.save()

        manage_downloads.delete_expired_downloads()

        for download_job in DownloadJob.objects.all():
            expires = download_job.expires
            if expires is not None:
                self.assertTrue(expires.replace(tzinfo=timezone.utc) > now.replace(tzinfo=timezone.utc),
                                'An expired download was not deleted!')