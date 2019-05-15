import django
django.setup()
from django.conf import settings
from glados.models import DownloadJob
from datetime import datetime, timezone
import sys
from glados.api.chembl.dynamic_downloads import downloads_manager
import os
import re
import socket
from pathlib import Path


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
            delete_download_file(file_to_remove)
        expired_downloads.delete()
        print('Deleted {} expired expired downloads.'.format(num_expired_downloads))
        rsync_nfss()


def delete_download_file(path):
    print('Removing file: ', path)
    os.remove(path)


def rsync_nfss():
    print('Going to synchronise the nfs systems')

    hostname = socket.gethostname()
    if bool(re.match("wp-p1m.*", hostname)):
        rsync_destination_server = 'wp-p2m-54'
    else:
        rsync_destination_server = 'wp-p1m-54'

    rsync_destination = "{server}:{path}".format(server=rsync_destination_server,
                                                 path=Path(settings.DYNAMIC_DOWNLOADS_DIR).parent)
    rsync_command = "rsync -avp --delete {source} {destination}".format(source=settings.DYNAMIC_DOWNLOADS_DIR,
                                                             destination=rsync_destination)
    print('rsync_command: ', rsync_command)
    # rsync_command_parts = rsync_command.split('')