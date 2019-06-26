from glados.api.chembl.dynamic_downloads import jobs
from glados.es.es_properties_configuration import configuration_getter
from glados.api.chembl.dynamic_downloads.models import DownloadJobManager
from glados.api.chembl.dynamic_downloads.models import DownloadJob
import json


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

    return download_job.job_id


