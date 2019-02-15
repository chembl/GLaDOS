# this handles the management of the special searches, structure (similarity, substructure, connectivity) and
# sequence (blast)
from glados.models import SSSearchJob
import json
import hashlib
import base64
from . import glados_server_statistics
import datetime
import socket
from django_rq import job
import time
import traceback
import requests
import os
from django.conf import settings


class SSSearchError(Exception):
    """Base class for exceptions in this file."""
    pass


def get_results_file_path(job_id):
    return os.path.join(settings.SSSEARCH_RESULTS_DIR, job_id + '.json')


def get_search_id(search_type, raw_search_params):

    stable_raw_search_params = json.dumps(json.loads(raw_search_params), sort_keys=True)
    search_params_digest = hashlib.sha256(stable_raw_search_params.encode('utf-8')).digest()
    base64_search_params_digest = base64.b64encode(search_params_digest).decode('utf-8').replace('/', '_').replace('+', '-')

    job_id = '{}-{}'.format(search_type, base64_search_params_digest)
    return job_id

@job
def do_structure_search(job_id):

    start_time = time.time()
    search_job = SSSearchJob.objects.get(search_id=job_id)
    search_job.status = SSSearchJob.SEARCHING
    search_job.worker = socket.gethostname()
    search_job.save()
    append_to_job_log(search_job, 'Performing Search')
    print('processing job: ', job_id)

    raw_search_params = search_job.raw_search_params
    parsed_search_params = json.loads(raw_search_params)

    try:

        # set the initial url
        search_term = parsed_search_params['search_term']
        threshold = parsed_search_params['threshold']
        page_size = 1000
        append_to_job_log(search_job, 'page_size: {}'.format(page_size))

        search_url = 'https://www.ebi.ac.uk/chembl/api/data/similarity/{search_term}/{threshold}.json?limit={page_size}'\
            .format(search_term=search_term, threshold=threshold, page_size=page_size)

        page_num = 1
        results = {}
        # receive the results and then save them to the context file
        more_results_to_load = True
        while more_results_to_load:

            append_to_job_log(search_job, 'loading page: {}'.format(page_num))
            r = requests.get(search_url)
            response = r.json()

            for r in response['molecules']:
                results[r['molecule_chembl_id']] = {
                    'similarity': r['similarity']
                }

            next = response['page_meta']['next']
            if next is not None:
                search_url = 'https://www.ebi.ac.uk{}'.format(next)
                page_num += 1
            else:
                more_results_to_load = False

        output_file_path = get_results_file_path(job_id)
        append_to_job_log(search_job, 'output_file_path: {}'.format(output_file_path))
        with open(output_file_path, 'w') as outfile:
            json.dump(results, outfile)

    except:
        save_search_job_state(search_job, SSSearchJob.ERROR)
        tb = traceback.format_exc()
        append_to_job_log(search_job, "Error:\n{}".format(tb))
        print(tb)
        return


def generate_search_job(search_type, raw_search_params):

    search_types = [s[0] for s in SSSearchJob.SEARCH_TYPES]
    if search_type not in search_types:

        raise SSSearchError(
            "search_type: {} is unknown. Possible types are: {}".format(search_type, ', '.join(search_types))
        )

    glados_server_statistics.record_search(search_type)
    job_id = get_search_id(search_type, raw_search_params)

    try:
        sssearch_job = SSSearchJob.objects.get(search_id=job_id)
        if sssearch_job.status == SSSearchJob.ERROR:
            # if it was in error state, requeue it
            sssearch_job.status = SSSearchJob.SEARCH_QUEUED
            sssearch_job.save()
            append_to_job_log(sssearch_job, "Job was in error state, queuing again.")
            do_structure_search.delay(job_id)


    except SSSearchJob.DoesNotExist:

        sssearch_job = SSSearchJob(
            search_id=job_id,
            search_type=search_type,
            raw_search_params=raw_search_params,
            log=format_log_message('Job Queued')
        )
        sssearch_job.save()
        do_structure_search.delay(job_id)

    response = {
        'search_id': job_id
    }
    return response


def get_sssearch_status(search_id):

    print('get_sssearch_status ', search_id)
    try:
        sssearch_job = SSSearchJob.objects.get(search_id=search_id)
        response = {
            'status': sssearch_job.status

        }
        return response

    except SSSearchJob.DoesNotExist:
        response = {
            'msg': 'search job does not exist!',
            'status': SSSearchJob.ERROR
        }
        return response


def append_to_job_log(search_job, msg):

    if search_job.log is None:
        search_job.log = ''

    search_job.log += format_log_message(msg)
    search_job.save()


def format_log_message(msg):
    now = datetime.datetime.now()
    return "[{date}] {hostname}: {msg}\n".format(date=now, hostname=socket.gethostname(), msg=msg)


def save_search_job_state(search_job, new_state):
    search_job.status = new_state
    search_job.save()

