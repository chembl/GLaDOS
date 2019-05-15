import unittest
from glados.models import DownloadJob
from glados.utils import manage_downloads
from datetime import datetime, timezone, timedelta
from django.conf import settings
import os
from glados.api.chembl.dynamic_downloads import downloads_manager


class UtilsTester(unittest.TestCase):

    def setUp(self):
        print('Running Test: {0}'.format(self._testMethodName))
        DownloadJob.objects.all().delete()
        for root, dirs, files in os.walk(settings.DYNAMIC_DOWNLOADS_DIR):
            for name in files:
                os.remove(os.path.join(root, name))
            for name in dirs:
                os.rmdir(os.path.join(root, name))

    def tearDown(self):
        print('Test {0}'.format('Passed!' if self._outcome.success else 'Failed!'))

    def test_expired_downloads_deletion(self):

        # create 3 downloads that with undefined expired time
        for i in range(1, 4):

            job_id = 'never_expires_{}'.format(i)
            download_job = DownloadJob(job_id=job_id)
            download_job.save()
            touch_file(job_id)

        now = datetime.now()
        now.replace(tzinfo=timezone.utc)
        expired_date = now

        # create 3 downloads that will be expired
        for i in range(1, 4):
            job_id = 'expired_{}'.format(i)
            download_job = DownloadJob(job_id=job_id, expires=expired_date)
            download_job.save()
            touch_file(job_id)

        td = timedelta(days=1)
        valid_date = datetime.now() + td

        valid_date.replace(tzinfo=timezone.utc)
        # create 3 downloads that will not be expired
        for i in range(1, 4):
            job_id = 'not_expired_{}'.format(i)
            download_job = DownloadJob(job_id=job_id, expires=valid_date)
            download_job.save()
            touch_file(job_id)

        manage_downloads.delete_expired_downloads()

        for download_job in DownloadJob.objects.all():
            expires = download_job.expires
            if expires is not None:
                self.assertTrue(expires.replace(tzinfo=timezone.utc) > now.replace(tzinfo=timezone.utc),
                                'An expired download was not deleted!')

        # There must not be files that would correspond to expired downloads
        for root, dirs, files in os.walk(settings.DYNAMIC_DOWNLOADS_DIR):
            for file_name in files:

                job_id = file_name.split('.')[0]
                owner_job_count = DownloadJob.objects.filter(job_id=job_id).count()
                self.assertTrue(owner_job_count == 1, 'There were orphan download files left!')


def touch_file(job_id):

    file_path = downloads_manager.get_file_path(job_id)
    with open(file_path, 'wt') as out_file:
        out_file.write('GLaDOS')
