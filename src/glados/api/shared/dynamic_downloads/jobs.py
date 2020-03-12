import time
from glados.api.shared.dynamic_downloads.models import DownloadJobManager
from glados.api.shared.dynamic_downloads.models import DownloadJob
import socket
import json
import traceback
from glados.es import file_generator
from django.conf import settings
from glados.settings import RunEnvs
import subprocess
import re
from glados.usage_statistics import glados_server_statistics
import os
from django_rq import job
import logging

logger = logging.getLogger('django')


class DownloadJobError(Exception):
    """Base class for exceptions in the download jobs."""
    pass


@job
def make_download_file(job_id):
    logger.info('MAKING DOWNLOAD FILE')
    logger.info(job_id)
    start_time = time.time()
    download_job = DownloadJob.objects.get(job_id=job_id)
    download_job.worker = socket.gethostname()
    download_job.save_download_job_state(DownloadJob.PROCESSING)
    download_job.append_to_job_log('Generating File')
    download_job.save()

    index_name = download_job.index_name
    raw_columns_to_download = download_job.raw_columns_to_download
    if raw_columns_to_download is None or raw_columns_to_download == '':
        all_columns_to_download = []
    else:
        all_columns_to_download = json.loads(raw_columns_to_download)

    own_columns = [col for col in all_columns_to_download if col.get('is_contextual', False) is not True]

    raw_query = download_job.raw_query
    query = json.loads(raw_query)
    base_file_name = job_id.split('.')[0]
    id_property = download_job.id_property
    raw_desired_format = download_job.desired_format
    context_id = download_job.context_id

    contextual_columns = []
    context_index = None
    if context_id is not None:
        # TODO The loading of the context needs to be refactored, as well as the structure based searches.

        context_file = os.path.join(settings.SSSEARCH_RESULTS_DIR, context_id + '.json')
        raw_context = json.loads(open(context_file).read())
        context_index = {}
        for item in raw_context:
            context_index[item[id_property]] = item
        contextual_columns = [col for col in all_columns_to_download if col.get('is_contextual', False) is True]

    if raw_desired_format.upper() == 'CSV':
        desired_format = file_generator.OutputFormats.CSV
    elif raw_desired_format.upper() == 'TSV':
        desired_format = file_generator.OutputFormats.TSV
    elif raw_desired_format.upper() == 'SDF':
        desired_format = file_generator.OutputFormats.SDF
    else:
        raise DownloadJobError('The format {} is not suooported'.format(raw_desired_format))

    try:

        def save_download_job_progress(progress_percentage):
            download_job.progress = progress_percentage
            download_job.save()

        print('own_columns: ', own_columns)
        print('all_columns_to_download: ', all_columns_to_download)

        if (desired_format is file_generator.OutputFormats.CSV) or (desired_format is file_generator.OutputFormats.TSV):
            out_file_path, total_items = file_generator.write_separated_values_file(
                desired_format=desired_format,
                index_name=index_name,
                query=query,
                columns_to_download=own_columns,
                base_file_name=base_file_name,
                context=context_index,
                id_property=id_property,
                contextual_columns=contextual_columns,
                progress_function=save_download_job_progress
            )
        else:
            out_file_path, total_items = file_generator.write_sdf_file(query=query, base_file_name=base_file_name,
                                                                    progress_function=save_download_job_progress)

        download_job.total_items = total_items
        download_job.file_path = out_file_path
        download_job.save()

        # if settings.RUN_ENV == RunEnvs.PROD:
        #     rsync_to_the_other_nfs(download_job)

        download_job.append_to_job_log('File Ready')
        logger.info('File Ready: ' + out_file_path)
        download_job.save_download_job_state(DownloadJob.FINISHED)

        # now save some statistics
        if settings.RUN_ENV != RunEnvs.TRAVIS:
            end_time = time.time()
            time_taken = end_time - start_time
            file_size = os.path.getsize(out_file_path)

            glados_server_statistics.record_download(
                download_id=job_id,
                time_taken=time_taken,
                is_new=True,
                file_size=file_size,
                es_index=index_name,
                es_query=raw_query,
                desired_format=raw_desired_format,
                total_items=total_items,
            )

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


@job
def wait_until_job_is_deleted_and_requeue(download_id):
    download_job = DownloadJob.objects.get(job_id=download_id)
    download_id = download_job.job_id
    index_name = download_job.index_name
    raw_columns_to_download = download_job.raw_columns_to_download
    raw_query = download_job.raw_query
    parsed_desired_format = download_job.desired_format
    context_id = download_job.context_id
    id_property = download_job.id_property

    logger.info('{} is being deleted. Will wait until deletion finishes and the requeue'.format(download_id))

    job_exists = True
    while job_exists:
        try:
            logger.info('job still exists')
            DownloadJob.objects.get(job_id=download_id)
            time.sleep(1)
        except DownloadJob.DoesNotExist:
            logger.info('job was deleted!')
            job_exists = False

    queue_new_job(index_name=index_name, raw_columns_to_download=raw_columns_to_download,
                  raw_query=raw_query, parsed_desired_format=parsed_desired_format, context_id=context_id,
                  id_property=id_property
                  )


def queue_new_job(index_name, raw_columns_to_download, raw_query, parsed_desired_format, context_id,
                  id_property):
    download_job_manager = DownloadJobManager()
    download_job = download_job_manager.create_download_job(
        index_name=index_name,
        raw_columns_to_download=raw_columns_to_download,
        raw_query=raw_query,
        desired_format=parsed_desired_format,
        log=DownloadJob.format_log_message('Job Queued'),
        context_id=context_id,
        id_property=id_property)

    download_job.save()
    download_id = download_job.job_id

    if settings.SPAWN_JOBS:
        make_download_file.delay(download_id)
    else:
        make_download_file(download_id)

    return download_job


def requeue_job(download_id, job_log_msg):
    # This queues again a job that exists but for any reason it needs to be put into the queue again
    download_job = DownloadJob.objects.get(job_id=download_id)
    download_job.progress = 0
    download_job.status = DownloadJob.QUEUED
    download_job.save()
    download_job.append_to_job_log(job_log_msg)

    if settings.SPAWN_JOBS:
        make_download_file.delay(download_id)
    else:
        make_download_file(download_id)
