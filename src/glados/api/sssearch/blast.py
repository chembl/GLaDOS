from urllib.parse import urlencode
from urllib.request import urlopen, Request
from urllib.error import HTTPError
from . import search_manager
import json
from glados.models import SSSearchJob
import requests
import os

BLAST_API_BASE_URL = 'https://www.ebi.ac.uk/Tools/services/rest/ncbiblast'


def get_sequence_search_status(search_id):

    status_url = '{}/status/{}'.format(BLAST_API_BASE_URL, search_id)
    print('get blast status: ', search_id)
    print('status_url: ', status_url)
    r = requests.get(status_url)
    status_response = r.text

    print('status_response: ', status_response)
    if status_response == 'NOT_FOUND':
        response = {
            'status': SSSearchJob.ERROR,
            'msg': 'Search submission not found, it may have expired. Please run the search again.'
        }
    elif status_response == 'RUNNING':
        response = {
            'status': SSSearchJob.SEARCH_QUEUED
        }
    elif status_response == 'FINISHED':
        response = check_blast_job_results(search_id)
    else:
        response = {
            'status': SSSearchJob.SEARCH_QUEUED
        }

    return response


def queue_blast_job(raw_search_params):

    print('queueing blast job')
    print(raw_search_params)

    run_url = '{}/run/'.format(BLAST_API_BASE_URL)
    params = json.loads(raw_search_params)
    request_data = urlencode(params)

    print('params: ', params)
    print('request_data: ', request_data)
    try:

        # req = Request(run_url)
        # req_handle = urlopen(req, request_data.encode(encoding=u'utf_8', errors=u'strict'))
        # job_id = req_handle.read().decode(encoding=u'utf_8', errors=u'strict')
        # print('job_id: ', job_id)
        # req_handle.close()
        job_id = 'ncbiblast-R20190301-141319-0915-15816979-p1m'
        return job_id

    except HTTPError as ex:

        msg = 'Error while submitting BLAST job:\n{}'.format(repr(ex))
        raise search_manager.SSSearchError(msg)


def check_blast_job_results(search_id):
    # only at this stage I create a model in the database, because now the task is entirely mine, to load the
    # results into a context object
    context_file_path_must_be = search_manager.get_results_file_path(search_id)
    print('context_file_path_must_be: ', context_file_path_must_be)
    try:
        os.path.getsize(context_file_path_must_be)
    except FileNotFoundError:

        sssearch_job = SSSearchJob(
            search_id=search_id,
            search_type=SSSearchJob.BLAST,
            log=search_manager.format_log_message('Queuing Download of Results')
        )
        sssearch_job.save()


    response = {
        'status': SSSearchJob.LOADING_RESULTS
    }
    return response


def download_results(search_id):

    print('going to load results')
    sssearch_job = SSSearchJob.objects.get(search_id=job_id)
