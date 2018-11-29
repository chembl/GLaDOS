# this handles the creation of dynamically generated downloads
import time
from django_rq import job
import hashlib
import base64
from glados.models import DownloadJob

@job
def generate_download_file():

    num = 10
    for i in range(num):
        print('i: ', i)
        time.sleep(1)


def get_download_id(index_name, raw_query):
    latest_release_full = 'chembl_24_1'
    query_digest = hashlib.sha256(raw_query.encode('utf-8')).digest()
    base64_query_digest = base64.b64encode(query_digest).decode('utf-8')

    download_id = "{}-{}-{}".format(latest_release_full, index_name, base64_query_digest)
    return download_id


def generate_download(index_name, raw_query):
    response = {}
    download_id = get_download_id(index_name, raw_query)

    try:
        DownloadJob.objects.get(job_id=download_id)
    except DownloadJob.DoesNotExist:
        download_job = DownloadJob(job_id=download_id)
        download_job.save()

    response['download_id'] = download_id
    return response
