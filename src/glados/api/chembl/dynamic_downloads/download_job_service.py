from glados.api.chembl.dynamic_downloads import jobs
from glados.es.es_properties_configuration import configuration_getter
from glados.api.chembl.dynamic_downloads.models import DownloadJobManager
from glados.api.chembl.dynamic_downloads.models import DownloadJob
from glados.usage_statistics import glados_server_statistics
import json
import os


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


    return download_job.job_id


