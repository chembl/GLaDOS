# this handles the management of the special searches, structure (similarity, substructure, connectivity) and
# sequence (blast)
from glados.models import SSSearchJob
import json
import hashlib
import base64
import datetime
import socket
import traceback
import os
from django.conf import settings
import re
from django.http import JsonResponse, HttpResponse
import subprocess
from . import blast
from . import structure


class SSSearchError(Exception):
    """Base class for exceptions in this file."""
    pass


# ----------------------------------------------------------------------------------------------------------------------
# Entry functions
# ----------------------------------------------------------------------------------------------------------------------
def request_submit_substructure_search(request):

    if request.method == "POST":

        search_type = request.POST.get('search_type')
        raw_search_params = request.POST.get('raw_search_params')

        try:

            response = generate_search_job(search_type, raw_search_params)
            return JsonResponse(response)

        except Exception as e:

            traceback.print_exc()
            return HttpResponse("Internal Server Error: {}".format(repr(e)), status=500)

    else:
        return JsonResponse({'error': 'this is only available via POST! You crazy hacker! :P'})


def request_sssearch_status(request, search_id):

    if request.method != "GET":
        return JsonResponse({'error': 'This is only available via GET'})

    try:
        response = get_sssearch_status(search_id)
        return JsonResponse(response)
    except Exception as e:
        traceback.print_exc()
        return HttpResponse('Internal Server Error', status=500)


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


def generate_search_job(search_type, raw_search_params):

    search_types = [s[0] for s in SSSearchJob.SEARCH_TYPES]
    if search_type not in search_types:

        raise SSSearchError(
            "search_type: {} is unknown. Possible types are: {}".format(search_type, ', '.join(search_types))
        )

    if search_type in [SSSearchJob.SIMILARITY, SSSearchJob.SUBSTRUCTURE, SSSearchJob.CONNECTIVITY]:

        search_id = structure.queue_structure_search_job(search_type, raw_search_params)

    elif search_type == SSSearchJob.BLAST:

        search_id = blast.queue_blast_job()

    response = {
        'search_id': search_id
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

