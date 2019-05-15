import django
django.setup()
from glados.models import DownloadJob
from datetime import datetime, timezone
import sys


def delete_expired_downloads():

    dry_run = '--dry-run' in sys.argv
    now = datetime.utcnow().replace(tzinfo=timezone.utc)

    print('I am going to delete the downloads that expire before {}'.format(str(now)))
    expired_downloads = DownloadJob.objects.filter(expires__lte=now)
    num_expired_downloads = expired_downloads.count()

    if dry_run:
        print('I would have deleted {} saved urls (dry run).'.format(num_expired_downloads))
    else:
        expired_downloads.delete()
        print('Deleted {} expired expired downloads.'.format(num_expired_downloads))
