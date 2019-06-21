import time
from glados.api.chembl.dynamic_downloads.models import DownloadJob
import socket
import json
import traceback
from glados.es import file_writer
from django.conf import settings
from glados.settings import RunEnvs
import subprocess
import re
import logging

logger = logging.getLogger('django')


def make_download_file(job_id):

    print('MAKING DOWNLOAD FILE')
    print(job_id)
    start_time = time.time()
    download_job = DownloadJob.objects.get(job_id=job_id)
    download_job.worker = socket.gethostname()
    download_job.save_download_job_state(DownloadJob.PROCESSING)
    download_job.append_to_job_log('Generating File')
    download_job.save()

    index_name = download_job.index_name
    raw_columns_to_download = download_job.raw_columns_to_download
    columns_to_download = json.loads(raw_columns_to_download)
    raw_query = download_job.raw_query
    query = json.loads(raw_query)
    base_file_name = job_id.split('.')[0]
    context_id = download_job.context_id
    context = None
    id_property = download_job.id_property

    if download_job.desired_format in ['csv', 'CSV']:
        desired_format = file_writer.OutputFormats.CSV
    elif download_job.desired_format in ['tsv', 'TSV']:
        desired_format = file_writer.OutputFormats.TSV

    try:

        def save_download_job_progress(progress_percentage):
            download_job.progress = progress_percentage
            download_job.save()

        out_file_path, total_items = file_writer.write_separated_values_file(
            desired_format=desired_format,
            index_name=index_name,
            query=query,
            columns_to_download=columns_to_download,
            base_file_name=base_file_name,
            context=context,
            id_property=id_property,
            progress_function=save_download_job_progress
        )

        download_job.total_items = total_items
        download_job.file_path = out_file_path
        download_job.save()

        if settings.RUN_ENV == RunEnvs.PROD:
            rsync_to_the_other_nfs(download_job)

        download_job.append_to_job_log('File Ready')
        logger.debug('File Ready: ' + out_file_path)
        download_job.save_download_job_state(DownloadJob.FINISHED)

        return out_file_path, total_items

    except:
        download_job.save_download_job_state(DownloadJob.ERROR)
        tb = traceback.format_exc()
        download_job.append_to_job_log("Error:\n{}".format(tb))
        print(tb)
        return None


def rsync_to_the_other_nfs(download_job):
    hostname = socket.gethostname()
    if bool(re.match("wp-p1m.*", hostname)):
        rsync_destination_server = 'wp-p2m-54'
    else:
        rsync_destination_server = 'wp-p1m-54'

    file_path = download_job.file_path
    rsync_destination = "{server}:{path}".format(server=rsync_destination_server, path=file_path)
    rsync_command = "rsync -v {source} {destination}".format(source=file_path, destination=rsync_destination)
    rsync_command_parts = rsync_command.split(' ')

    download_job.append_to_job_log("Rsyncing: {}".format(rsync_command))
    subprocess.check_call(rsync_command_parts)


