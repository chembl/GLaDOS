from datetime import datetime, timezone
import sys
from glados.models import SSSearchJob
from glados.api.chembl.sssearch import search_manager
from django.conf import settings
import socket
from pathlib import Path
import subprocess
from glados.settings import RunEnvs
import os


def delete_expired_searches():

    dry_run = '--dry-run' in sys.argv
    delete_unexpirable = '--deleteunexpirable' in sys.argv
    print('deleteunexpirable: ', delete_unexpirable)
    now = datetime.utcnow().replace(tzinfo=timezone.utc)

    print('I am going to delete the searches that expire before {}'.format(str(now)))
    if delete_unexpirable:
        really_expired_searches = SSSearchJob.objects.filter(expires__lte=now)
        unexpirable_searches = SSSearchJob.objects.filter(expires__isnull=True)
        expired_searches = really_expired_searches | unexpirable_searches
    else:
        expired_searches = SSSearchJob.objects.filter(expires__lte=now)
    num_expired_searches = expired_searches.count()

    if dry_run:
        print('I would have deleted {} saved searches (dry run).'.format(num_expired_searches))
    else:
        for sssearch_job in expired_searches:
            sssearch_job.status = SSSearchJob.DELETING
            sssearch_job.save()
            file_to_remove = search_manager.get_results_file_path(sssearch_job.search_id)
            delete_search_results_file(file_to_remove)
        expired_searches.delete()
        print('Deleted {} expired expired searches.'.format(num_expired_searches))
        if settings.RUN_ENV == RunEnvs.PROD:
            rsync_nfss()


def delete_search_results_file(path):

    print('Removing file: ', path)
    try:
        os.remove(path)
    except FileNotFoundError:
        print('File was not there anyway')


def rsync_nfss():
    print('Going to synchronise the nfs systems')

    hostname = socket.gethostname()
    if bool(re.match("wp-p1m.*", hostname)):
        rsync_destination_server = 'wp-p2m-54'
    else:
        rsync_destination_server = 'wp-p1m-54'

    rsync_destination = "{server}:{path}".format(server=rsync_destination_server,
                                                 path=Path(settings.SSSEARCH_RESULTS_DIR).parent)
    rsync_command = "rsync -avp --delete {source} {destination}".format(source=settings.SSSEARCH_RESULTS_DIR,
                                                                        destination=rsync_destination)
    print('rsync_command: ', rsync_command)
    rsync_command_parts = rsync_command.split(' ')
    subprocess.check_call(rsync_command_parts)