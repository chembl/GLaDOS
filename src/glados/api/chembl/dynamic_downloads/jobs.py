import time
from glados.api.chembl.dynamic_downloads.models import DownloadJob
from glados.api.chembl.dynamic_downloads import job_status
import socket
import json
import traceback


def make_download_file(download_id):

    print('MAKING DOWNLOAD FILE')
    start_time = time.time()
    download_job = DownloadJob.objects.get(job_id=download_id)
    download_job.worker = socket.gethostname()
    job_status.save_download_job_state(download_job, DownloadJob.PROCESSING)
    job_status.append_to_job_log(download_job, 'Generating File')
    download_job.save()

    index_name = download_job.index_name
    raw_columns_to_download = download_job.raw_columns_to_download
    cols_to_download = json.loads(raw_columns_to_download)
    raw_query = download_job.raw_query
    query = json.loads(raw_query)
    context_id = download_job.context_id
    id_property = download_job.id_property
    desired_format = download_job.desired_format

    # try:
    #     print('hola')
    # except:
    #     job_status.save_download_job_state(download_job, DownloadJob.ERROR)
    #     tb = traceback.format_exc()
    #     job_status.append_to_job_log(download_job, "Error:\n{}".format(tb))
    #     print(tb)
    #     return


