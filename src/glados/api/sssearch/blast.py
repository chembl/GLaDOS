from urllib.parse import urlencode
from urllib.request import urlopen, Request
from urllib.error import HTTPError
from . import search_manager
import json
from glados.models import SSSearchJob

BLAST_API_BASE_URL = 'https://www.ebi.ac.uk/Tools/services/rest/ncbiblast'


def get_sequence_search_status(search_id):

    print('get blast status: ', search_id)
    response = {
        'status': SSSearchJob.SEARCH_QUEUED
    }
    return response


def queue_blast_job(raw_search_params):

    print('queueing blast job')
    print(raw_search_params)

    run_url = '{}/runfhfhfhfh/'.format(BLAST_API_BASE_URL)
    params = json.loads(raw_search_params)

    request_data = urlencode(params)

    # r = requests.get(run_url, params=params)
    print('params: ', params)
    print('request_data: ', request_data)
    try:

        # req = Request(run_url)
        # req_handle = urlopen(req, request_data.encode(encoding=u'utf_8', errors=u'strict'))
        # job_id = req_handle.read()
        # print('job_id: ', job_id)
        # req_handle.close()
        job_id = 'blast_job'
        return job_id

    except HTTPError as ex:

        msg = 'Error while submitting BLAST job:\n{}'.format(repr(ex))
        raise search_manager.SSSearchError(msg)

