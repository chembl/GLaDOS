# this handles the creation of dynamically generated downloads
import time
from django_rq import job
import hashlib
import base64
from glados.models import DownloadJob
from elasticsearch_dsl import Search
from elasticsearch.helpers import scan
from elasticsearch_dsl.connections import connections
import json
import traceback
from . import glados_server_statistics

class DownloadError(Exception):
    """Base class for exceptions in this file."""
    pass


def save_download_job_progress(download_job, progress_percentage):
    download_job.progress = progress_percentage
    download_job.save()


def save_download_job_state(download_job, new_state):
    download_job.status = new_state
    download_job.save()

@job
def generate_download_file(download_id):

    start_time = time.time()
    print('generate_download_file: ', download_id)
    download_job = DownloadJob.objects.get(job_id=download_id)
    download_job.status = DownloadJob.PROCESSING
    download_job.save()

    index_name = download_job.index_name
    raw_columns_to_download = download_job.raw_columns_to_download
    cols_to_download = json.loads(raw_columns_to_download)
    print('cols_to_download: ', cols_to_download)

    try:
        es_conn = connections.get_connection()
        query = {}
        print('searching...')
        search = Search(index=index_name).source([''])
        response = search.execute()
        total_items = response.hits.total

        print('size: ', total_items)
        print('source', [col['property_name'] for col in cols_to_download])
        scanner = scan(es_conn, index=index_name, size=1000, query={
            "_source": [col['property_name'] for col in cols_to_download]
        })

        i = 0
        previous_percentage = 0
        for doc_i in scanner:
            i += 1

            if i % 200000 == 0:
                print('doc_i: ', doc_i)

            percentage = int((i/total_items) * 100)
            if percentage != previous_percentage:
                previous_percentage = percentage
                print('percentage: ', percentage)
                save_download_job_progress(download_job, percentage)

        save_download_job_state(download_job, DownloadJob.FINISHED)

        end_time = time.time()
        time_taken = end_time - start_time
        date = time.time()
        glados_server_statistics.record_download(download_id, date, time_taken, is_new=True)

    except:
        save_download_job_state(download_job, DownloadJob.ERROR)
        traceback.print_exc()
        return



def get_download_id(index_name, raw_query, desired_format):

    # make sure the string generated is stable
    stable_raw_query = json.dumps(json.loads(raw_query), sort_keys=True)
    print('stable_raw_query:', stable_raw_query)

    parsed_desired_format = desired_format.lower()
    if parsed_desired_format not in ['csv', 'tsv', 'csv']:
        raise DownloadError("Format {} not supported".format(desired_format))

    latest_release_full = 'chembl_24_1'
    query_digest = hashlib.sha256(stable_raw_query.encode('utf-8')).digest()
    base64_query_digest = base64.b64encode(query_digest).decode('utf-8').replace('/', '_').replace('+', '-')

    download_id = "{}-{}-{}.{}".format(latest_release_full, index_name, base64_query_digest, parsed_desired_format)
    return download_id


def generate_download(index_name, raw_query, desired_format, raw_columns_to_download):
    response = {}
    download_id = get_download_id(index_name, raw_query, desired_format)
    print('download_id: ', download_id)

    try:
        download_job = DownloadJob.objects.get(job_id=download_id)
        print('job already in queue')
        if download_job.status == DownloadJob.ERROR:
            print('job was in error, retrying')
            download_job.progress = 0
            download_job.status = DownloadJob.QUEUED
            download_job.save()
            generate_download_file.delay(download_id)

    except DownloadJob.DoesNotExist:
        download_job = DownloadJob(
            job_id=download_id,
            index_name=index_name,
            raw_columns_to_download=raw_columns_to_download
        )
        download_job.save()
        generate_download_file.delay(download_id)
        print('new job created')

    response['download_id'] = download_id
    return response


def get_download_status(download_id):

    try:
        download_job = DownloadJob.objects.get(job_id=download_id)
        response = {
            'percentage': download_job.progress,
            'status': download_job.status

        }
        return response

    except DownloadJob.DoesNotExist:
        print('does not exist!')
        response = {
            'msg': 'download does not exist!',
            'status:': DownloadJob.ERROR
        }
        return response
