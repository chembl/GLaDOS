from urllib.parse import urlencode
from urllib.request import urlopen, Request
from urllib.error import HTTPError
from . import search_manager
import json
from glados.models import SSSearchJob
import requests

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
        response = {
            'status': SSSearchJob.LOADING_RESULTS
        }
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

