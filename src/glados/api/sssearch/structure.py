from glados.models import SSSearchJob
import json
from glados import glados_server_statistics
import socket
from django_rq import job
import time
import traceback
import requests
import os
from django.conf import settings
from . import search_manager


def get_structure_search_status(search_id):

    try:
        sssearch_job = SSSearchJob.objects.get(search_id=search_id)
        response = {
            'status': sssearch_job.status
        }
        if sssearch_job.status == SSSearchJob.FINISHED:
            context, total_results = search_manager.get_search_results_context(sssearch_job)
            response['ids'] = [k['molecule_chembl_id'] for k in context]
            response['total_results'] = total_results
            response['size_limit'] = search_manager.WEB_RESULTS_SIZE_LIMIT
        elif sssearch_job.status == SSSearchJob.ERROR:
            response['msg'] = sssearch_job.error_message

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


def queue_structure_search_job(search_type, raw_search_params):

    job_id = search_manager.get_search_id(search_type, raw_search_params)

    try:
        sssearch_job = SSSearchJob.objects.get(search_id=job_id)
        if sssearch_job.status == SSSearchJob.ERROR:
            # if it was in error state, requeue it
            sssearch_job.status = SSSearchJob.SEARCH_QUEUED
            sssearch_job.save()
            search_manager.append_to_job_log(sssearch_job, "Job was in error state, queuing again.")
            do_structure_search.delay(job_id)

        elif sssearch_job.status == SSSearchJob.FINISHED:

            # check that the results file exists and save statistics, if not, queue it again
            try:

                file_path = search_manager.get_results_file_path(job_id)
                os.path.getsize(file_path)
                glados_server_statistics.record_search(sssearch_job.search_type, 0, False)

            except FileNotFoundError:

                sssearch_job.status = SSSearchJob.SEARCH_QUEUED
                sssearch_job.save()
                search_manager.append_to_job_log(sssearch_job, "Results File not found, queuing again.")
                do_structure_search.delay(job_id)

    except SSSearchJob.DoesNotExist:

        sssearch_job = SSSearchJob(
            search_id=job_id,
            search_type=search_type,
            raw_search_params=raw_search_params,
            log=search_manager.format_log_message('Job Queued')
        )
        sssearch_job.save()
        do_structure_search.delay(job_id)

    return job_id

@job
def do_structure_search(job_id):

    start_time = time.time()
    search_job = SSSearchJob.objects.get(search_id=job_id)
    search_job.status = SSSearchJob.SEARCHING
    search_job.worker = socket.gethostname()
    search_job.save()
    search_manager.append_to_job_log(search_job, 'Performing Search')
    print('processing job: ', job_id)

    raw_search_params = search_job.raw_search_params
    parsed_search_params = json.loads(raw_search_params)

    try:

        search_url = get_initial_search_url(parsed_search_params, search_job)
        page_num = 1
        results = []
        # receive the results and then save them to the context file
        # I will save all the results sorted as I receive them. It is responsibility of anyone who reads the
        # results to load only a subset if necessary. For example, loading only the first 10000.
        more_results_to_load = True
        while more_results_to_load:

            search_manager.append_to_job_log(search_job, 'loading page: {} url: {}'.format(page_num, search_url))
            r = requests.get(search_url)
            response = r.json()
            append_to_results_from_response_page(response, results, search_job.search_type)

            next_page = response['page_meta']['next']
            if next_page is not None:
                search_url = 'https://www.ebi.ac.uk{}'.format(next_page)
                page_num += 1
            else:
                more_results_to_load = False

        search_manager.save_results_file(results, search_job)
        search_manager.append_to_job_log(search_job, 'Results Ready')
        search_manager.save_search_job_state(search_job, SSSearchJob.FINISHED)

        end_time = time.time()
        time_taken = end_time - start_time
        glados_server_statistics.record_search(search_job.search_type, time_taken)

    except search_manager.SSSearchError as sssearch_error:

        search_job.error_message = repr(sssearch_error)
        search_manager.save_search_job_state(search_job, SSSearchJob.ERROR)
        tb = traceback.format_exc()
        search_manager.append_to_job_log(search_job, "Error:\n{}".format(tb))
        print(tb)

    except:

        search_manager.save_search_job_state(search_job, SSSearchJob.ERROR)
        tb = traceback.format_exc()
        search_manager.append_to_job_log(search_job, "Error:\n{}".format(tb))
        print(tb)
        return


def get_initial_search_url(search_params, search_job):

    search_term = search_params['search_term']
    page_size = 1000
    search_manager.append_to_job_log(search_job, 'page_size: {}'.format(page_size))
    search_type = search_job.search_type

    if search_type == SSSearchJob.SIMILARITY:

        threshold = search_params['threshold']
        search_url = '{ws_url}/similarity/{search_term}/{threshold}.json' \
                     '?limit={page_size}&only=molecule_chembl_id,similarity'.format(ws_url=settings.WS_URL,
                                                                                    search_term=search_term,
                                                                                    threshold=threshold,
                                                                                    page_size=page_size)

    elif search_type == SSSearchJob.SUBSTRUCTURE:

        search_url = '{ws_url}/substructure/{search_term}.json' \
                     '?limit={page_size}&only=molecule_chembl_id'.format(ws_url=settings.WS_URL,
                                                                         search_term=search_term, page_size=page_size)

    elif search_type == SSSearchJob.CONNECTIVITY:

        search_url = '{ws_url}/molecule.json?limit={page_size}' \
                     '&only=molecule_chembl_id' \
                     '&molecule_structures__canonical_smiles__flexmatch={search_term}'.format(
                        ws_url=settings.WS_URL,
                        search_term=search_term, page_size=page_size
                     )

    return search_url


def append_to_results_from_response_page(response, results, search_type):

    error_message = response.get('error_message')
    if error_message is not None:
        raise search_manager.SSSearchError(error_message)

    if search_type == SSSearchJob.SIMILARITY:

        for r in response['molecules']:
            results.append({
                'molecule_chembl_id': r['molecule_chembl_id'],
                'similarity': float(r['similarity'])
            })

    elif search_type == SSSearchJob.SUBSTRUCTURE or search_type == SSSearchJob.CONNECTIVITY:

        for r in response['molecules']:
            results.append(r)
