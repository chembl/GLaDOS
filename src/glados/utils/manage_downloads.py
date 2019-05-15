import django
django.setup()
from glados.models import DownloadJob
from datetime import datetime, timezone
import sys
from glados.api.chembl.dynamic_downloads import downloads_manager
import os


def delete_expired_downloads():

    dry_run = '--dry-run' in sys.argv
    now = datetime.utcnow().replace(tzinfo=timezone.utc)

    print('I am going to delete the downloads that expire before {}'.format(str(now)))
    expired_downloads = DownloadJob.objects.filter(expires__lte=now)
    num_expired_downloads = expired_downloads.count()

    if dry_run:
        print('I would have deleted {} saved urls (dry run).'.format(num_expired_downloads))
    else:
        for download_job in expired_downloads:
            file_to_remove = downloads_manager.get_file_path(download_job.job_id)
            print('file_to_remove: ', file_to_remove)
            os.remove(file_to_remove)
        expired_downloads.delete()
        print('Deleted {} expired expired downloads.'.format(num_expired_downloads))
