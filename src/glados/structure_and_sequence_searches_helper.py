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
from glados.settings import RunEnvs
import re
from elasticsearch_dsl.connections import connections
import subprocess
from django.core.cache import cache


class SSSearchError(Exception):
    """Base class for exceptions in this file."""
    pass

# ----------------------------------------------------------------------------------------------------------------------
# results size limit
# ----------------------------------------------------------------------------------------------------------------------
WEB_RESULTS_SIZE_LIMIT = settings.FILTER_QUERY_MAX_CLAUSES
CONTEXT_PREFIX = '_context'


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
        results = []
        # receive the results and then save them to the context file
        # I will save all the results sorted as I receive them. It is responsibility of anyone who reads the
        # results to load only a subset if necessary. For example, loading only the first 10000.
        more_results_to_load = True
        while more_results_to_load:

            append_to_job_log(search_job, 'loading page: {} url: {}'.format(page_num, search_url))
            r = requests.get(search_url)
            response = r.json()

            for r in response['molecules']:
                results.append({
                    'molecule_chembl_id': r['molecule_chembl_id'],
                    'similarity': float(r['similarity'])
                })

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

        if settings.RUN_ENV == RunEnvs.PROD:
            rsync_to_the_other_nfs(search_job)

        append_to_job_log(search_job, 'Results Ready')
        save_search_job_state(search_job, SSSearchJob.FINISHED)

        end_time = time.time()
        time_taken = end_time - start_time
        glados_server_statistics.record_search(search_job.search_type, time_taken)

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

    job_id = get_search_id(search_type, raw_search_params)

    try:
        sssearch_job = SSSearchJob.objects.get(search_id=job_id)
        if sssearch_job.status == SSSearchJob.ERROR:
            # if it was in error state, requeue it
            sssearch_job.status = SSSearchJob.SEARCH_QUEUED
            sssearch_job.save()
            append_to_job_log(sssearch_job, "Job was in error state, queuing again.")
            do_structure_search.delay(job_id)

        elif sssearch_job.status == SSSearchJob.FINISHED:

            # check that the results file exists and save statistics, if not, queue it again
            try:

                file_path = get_results_file_path(job_id)
                file_size = os.path.getsize(file_path)
                glados_server_statistics.record_search(sssearch_job.search_type, 0, False)

            except FileNotFoundError:

                sssearch_job.status = SSSearchJob.SEARCH_QUEUED
                sssearch_job.save()
                append_to_job_log(sssearch_job, "Resuls File not found, queuing again.")
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

    try:
        sssearch_job = SSSearchJob.objects.get(search_id=search_id)
        response = {
            'status': sssearch_job.status
        }
        if sssearch_job.status == SSSearchJob.FINISHED:
            context, total_results = get_search_results_context(sssearch_job)
            response['ids'] = [k['molecule_chembl_id'] for k in context]
            response['total_results'] = total_results
            response['size_limit'] = WEB_RESULTS_SIZE_LIMIT

        return response

    except SSSearchJob.DoesNotExist:

        response = {
            'msg': 'search job does not exist!',
            'status': SSSearchJob.ERROR
        }
        return response

    except FileNotFoundError:

        response = {
            'msg': 'Search results not found, they may have expired. Please run the search again.',
            'status': SSSearchJob.ERROR
        }
        return response


# ----------------------------------------------------------------------------------------------------------------------
# Loading context
# ----------------------------------------------------------------------------------------------------------------------
def get_search_results_context(sssearch_job, limited=True):

    results_file_path = get_results_file_path(sssearch_job.search_id)
    with open(results_file_path) as f:
        context = json.load(f)

    total_results = len(context)
    if total_results > WEB_RESULTS_SIZE_LIMIT and limited:
        context = context[0:WEB_RESULTS_SIZE_LIMIT]

    return context, total_results


def get_items_with_context(index_name, raw_search_data, context_id, id_property, raw_contextual_sort_data='{}'):

    sssearch_job = SSSearchJob.objects.get(search_id=context_id)
    context, total_results = get_search_results_context(sssearch_job)

    # create a context index so access is faster
    context_index_key = 'context_index-{}'.format(context_id)
    context_index = cache.get(context_index_key)
    if context_index is None:
        context_index = {}

        for index, item in enumerate(context):
            context_index[item[id_property]] = item
            context_index[item[id_property]]['index'] = index

        cache.set(context_index_key, context_index, 3600)

    contextual_sort_data = json.loads(raw_contextual_sort_data)
    contextual_sort_data_keys = contextual_sort_data.keys()
    if len(contextual_sort_data_keys) == 0:
        # if nothing is specified use the default scoring script, which is to score them according to their original
        # position in the results
        score_property = 'index'
        score_script = "String id=doc['" + id_property + "'].value; " \
                       "return " + str(total_results) + " - params.scores[id]['" + score_property + "'];"
    else:

        raw_score_property = list(contextual_sort_data_keys)[0]
        score_property = raw_score_property.replace('{}.'.format(CONTEXT_PREFIX), '')
        sort_order = contextual_sort_data[raw_score_property]

        if sort_order == 'desc':
            score_script = "String id=doc['" + id_property + "'].value; " \
                           "return params.scores[id]['" + score_property + "'];"
        else:
            score_script = "String id=doc['" + id_property + "'].value; " \
                           "return 1 / params.scores[id]['" + score_property + "'];"

    scores_query = {
        'function_score': {
            'query': {},
            'functions': [{
                'script_score': {
                    'script': {
                        'lang': "painless",
                        'params': {
                            'scores': context_index,
                        },
                        'inline': score_script
                    }
                }
            }]
        }
    }

    parsed_search_data = json.loads(raw_search_data)
    parsed_search_data['query']['bool']['must'].append(scores_query)
    raw_search_data_with_scores = json.dumps(parsed_search_data)

    es_response = glados_server_statistics.get_and_record_es_cached_response(index_name, raw_search_data_with_scores)
    hits = es_response['hits']['hits']
    for hit in hits:
        hit_id = hit['_id']
        context_obj = context_index[hit_id]
        hit['_source'][CONTEXT_PREFIX] = context_obj
    return es_response


# ----------------------------------------------------------------------------------------------------------------------
# Syncing nfs
# ----------------------------------------------------------------------------------------------------------------------
def rsync_to_the_other_nfs(search_job):

    hostname = socket.gethostname()
    if bool(re.match("wp-p1m.*", hostname)):
        rsync_destination_server = 'wp-p2m-54'
    else:
        rsync_destination_server = 'wp-p1m-54'

    file_path = get_results_file_path(search_job.search_id)
    rsync_destination = "{server}:{path}".format(server=rsync_destination_server, path=file_path)
    rsync_command = "rsync -v {source} {destination}".format(source=file_path, destination=rsync_destination)
    rsync_command_parts = rsync_command.split(' ')

    append_to_job_log(search_job, "Rsyncing: {}".format(rsync_command))
    subprocess.check_call(rsync_command_parts)


# ----------------------------------------------------------------------------------------------------------------------
# Logging to job and saving state
# ----------------------------------------------------------------------------------------------------------------------
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

