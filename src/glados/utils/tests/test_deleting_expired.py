from django.test import TestCase
from glados.api.chembl.dynamic_downloads.models import DownloadJob
from glados.models import SSSearchJob
from glados.utils import manage_downloads, manage_saved_searches
from datetime import datetime, timezone, timedelta
from django.conf import settings
import os
from glados.api.chembl.dynamic_downloads.models import DownloadJob
from glados.api.chembl.sssearch import search_manager


class UtilsTester(TestCase):

    def setUp(self):
        print('Running Test: {0}'.format(self._testMethodName))
        DownloadJob.objects.all().delete()
        SSSearchJob.objects.all().delete()
        for root, dirs, files in os.walk(settings.DYNAMIC_DOWNLOADS_DIR):
            for name in files:
                os.remove(os.path.join(root, name))
            for name in dirs:
                os.rmdir(os.path.join(root, name))
        for root, dirs, files in os.walk(settings.SSSEARCH_RESULTS_DIR):
            for name in files:
                os.remove(os.path.join(root, name))
            for name in dirs:
                os.rmdir(os.path.join(root, name))

    def tearDown(self):
        print('Test {0}'.format('Passed!' if self._outcome.success else 'Failed!'))

    def test_expired_downloads_deletion(self):

        num_unexpirable = 3
        # create 3 downloads that with undefined expired time
        for i in range(1, num_unexpirable + 1):

            job_id = 'never_expires_{}'.format(i)
            download_job = DownloadJob(
                job_id=job_id,
                file_path= os.path.join(settings.DYNAMIC_DOWNLOADS_DIR, job_id + '.gz')
            )
            download_job.save()
            touch_download_file(job_id)

        now = datetime.now()
        now.replace(tzinfo=timezone.utc)
        expired_date = now

        num_expired = 3
        # create 3 downloads that will be expired
        for i in range(1, num_expired + 1):
            job_id = 'expired_{}'.format(i)
            download_job = DownloadJob(
                job_id=job_id,
                expires=expired_date,
                file_path=os.path.join(settings.DYNAMIC_DOWNLOADS_DIR, job_id + '.gz')
            )
            download_job.save()
            touch_download_file(job_id)

        td = timedelta(days=1)
        valid_date = datetime.now() + td

        num_still_valid = 3
        valid_date.replace(tzinfo=timezone.utc)
        # create 3 downloads that will not be expired
        for i in range(1, num_still_valid + 1):
            job_id = 'not_expired_{}'.format(i)
            download_job = DownloadJob(
                job_id=job_id,
                expires=valid_date,
                file_path=os.path.join(settings.DYNAMIC_DOWNLOADS_DIR, job_id + '.gz')
            )
            download_job.save()
            touch_download_file(job_id)

        manage_downloads.delete_expired_downloads()

        all_downloads = DownloadJob.objects.all()
        for download_job in all_downloads:
            expires = download_job.expires
            if expires is not None:
                self.assertTrue(expires.replace(tzinfo=timezone.utc) > now.replace(tzinfo=timezone.utc),
                                'An expired download was not deleted!')

        num_surviving_downloads = num_still_valid + num_unexpirable
        self.assertTrue(num_surviving_downloads == all_downloads.count(), 'Some valid downloads are missing!')

        # There must not be files that would correspond to expired downloads
        for root, dirs, files in os.walk(settings.DYNAMIC_DOWNLOADS_DIR):
            for file_name in files:

                job_id = file_name.split('.')[0]
                owner_job_count = DownloadJob.objects.filter(job_id=job_id).count()
                self.assertTrue(owner_job_count == 1, 'There were orphan download files left!')

    def test_expired_searches_deletion(self):

        num_unexpirable = 3
        # create 3 searches that with undefined expired time
        for i in range(1, num_unexpirable + 1):
            job_id = 'never_expires_{}'.format(i)
            sssearch_job = SSSearchJob(search_id=job_id)
            sssearch_job.save()
            touch_search_results_file(job_id)

        now = datetime.now()
        now.replace(tzinfo=timezone.utc)
        expired_date = now

        num_expired = 3
        # create 3 downloads that will be expired
        for i in range(1, num_expired + 1):
            job_id = 'expired_{}'.format(i)
            sssearch_job = SSSearchJob(search_id=job_id, expires=expired_date)
            sssearch_job.save()
            touch_search_results_file(job_id)

        td = timedelta(days=1)
        valid_date = datetime.now() + td

        num_still_valid = 3
        valid_date.replace(tzinfo=timezone.utc)
        # create 3 downloads that will not be expired
        for i in range(1, num_still_valid + 1):
            job_id = 'not_expired_{}'.format(i)
            sssearch_job = SSSearchJob(search_id=job_id, expires=valid_date)
            sssearch_job.save()
            touch_search_results_file(job_id)

        manage_saved_searches.delete_expired_searches()

        all_searches = SSSearchJob.objects.all()
        for sssearch_job in all_searches:
            expires = sssearch_job.expires
            if expires is not None:
                self.assertTrue(expires.replace(tzinfo=timezone.utc) > now.replace(tzinfo=timezone.utc),
                                'An expired search was not deleted!')

        num_surviving = num_still_valid + num_unexpirable
        self.assertTrue(num_surviving == all_searches.count(), 'Some valid searches are missing!')

        # There must not be files that would correspond to expired searches
        for root, dirs, files in os.walk(settings.SSSEARCH_RESULTS_DIR):
            for file_name in files:
                job_id = file_name.split('.')[0]
                owner_job_count = SSSearchJob.objects.filter(search_id=job_id).count()
                self.assertTrue(owner_job_count == 1, 'There were orphan search results files left!')


def touch_download_file(job_id):

    download_job = DownloadJob.objects.get(job_id=job_id)
    file_path = download_job.file_path
    with open(file_path, 'wt') as out_file:
        out_file.write('GLaDOS')


def touch_search_results_file(job_id):

    file_path = search_manager.get_results_file_path(job_id)
    with open(file_path, 'wt') as out_file:
        out_file.write('GLaDOS')
