from glados.api.chembl.dynamic_downloads import jobs
from glados.es.es_properties_configuration import configuration_getter
from glados.api.chembl.dynamic_downloads.models import DownloadJobManager
from glados.api.chembl.dynamic_downloads.models import DownloadJob
from glados.usage_statistics import glados_server_statistics
import json
import os
from datetime import timezone
import logging

logger = logging.getLogger('django')


def queue_download_job(index_name, raw_query, desired_format, context_id):

    columns_to_download = configuration_getter.get_config_for_group(index_name, 'download')['default']
    raw_columns_to_download = json.dumps(columns_to_download)
    id_property = configuration_getter.get_id_property_for_index(index_name)

    try:
        download_job = jobs.queue_new_job(
            index_name=index_name,
            raw_columns_to_download=raw_columns_to_download,
            raw_query=raw_query,
            parsed_desired_format=desired_format.upper(),
            context_id=context_id,
            id_property=id_property
        )
    except DownloadJobManager.DownloadJobAlreadyExistsError:
        download_job_manager = DownloadJobManager()
        job_id = download_job_manager.get_download_id(index_name, raw_query, desired_format, context_id)
        download_job = DownloadJob.objects.get(job_id=job_id)

        if download_job.status == DownloadJob.ERROR:
            # if it was in error state, requeue it
            jobs.requeue_job(job_id, 'Job was in error state, queuing again.')

        elif download_job.status == DownloadJob.FINISHED:
            # verify that the job exists and save statistics
            try:
                file_size = os.path.getsize(download_job.file_path)
                glados_server_statistics.record_download(
                    download_id=job_id,
                    time_taken=0,
                    is_new=False,
                    file_size=file_size,
                    es_index=index_name,
                    es_query=raw_query,
                    desired_format=desired_format,
                    total_items=download_job.total_items
                )

            except FileNotFoundError:
                # if for some reason the file is not found. requeue que job
                jobs.requeue_job(job_id, 'File not found, queuing again.')

        elif download_job.status == DownloadJob.DELETING:
            # someone is deleting the job, I just need to wait until it is deleted and then re queue it
            logger.debug('job is being deleted! We need to wait until the process finishes')
            jobs.wait_until_job_is_deleted_and_requeue(job_id)

    return download_job.job_id


def get_download_status(download_id):

    download_job = DownloadJob.objects.get(job_id=download_id)
    status = download_job.status

    response = {
        'percentage': download_job.progress,
        'status': status
    }

    if status == DownloadJob.FINISHED:
        if download_job.expires is not None:
            expiration_time_str = download_job.expires.replace(tzinfo=timezone.utc).isoformat()
            response['expires'] = expiration_time_str

    return response


