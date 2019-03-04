from urllib.parse import urlencode
from urllib.request import urlopen, Request
from urllib.error import HTTPError
from . import search_manager
import json
from glados.models import SSSearchJob
import requests
import os
from django_rq import job
import xml.etree.ElementTree as ET
import re
import traceback

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

        sssearch_job = SSSearchJob.objects.get(search_id=search_id)
        if sssearch_job.status == SSSearchJob.ERROR:
            response = {
                'status': SSSearchJob.ERROR,
                'msg': sssearch_job.error_message
            }
        else:
            os.path.getsize(context_file_path_must_be)
            response = {
                'status': SSSearchJob.LOADING_RESULTS
            }

        return response

    except (FileNotFoundError, SSSearchJob.DoesNotExist) as ex:

        print('creating search job')
        sssearch_job = SSSearchJob(
            search_id=search_id,
            search_type=SSSearchJob.BLAST,
            status=SSSearchJob.LOADING_RESULTS,
            log=search_manager.format_log_message('Queuing Download of Results')
        )
        sssearch_job.save()
        download_results.delay(search_id)

        response = {
            'status': SSSearchJob.LOADING_RESULTS
        }
        return response

@job
def download_results(search_id):

    print('going to load results')
    sssearch_job = SSSearchJob.objects.get(search_id=search_id)

    try:
        1/0
        search_manager.append_to_job_log(sssearch_job, 'Starting to download results')

        ids_url = '{}/result/{}/xml'.format(BLAST_API_BASE_URL, search_id)
        print('ids_url: ', ids_url)
        r = requests.get(ids_url)
        xml_response = r.text
        results_root = ET.fromstring(xml_response)

        ebi_schema_url = '{http://www.ebi.ac.uk/schema}'
        results_path = '{schema_url}SequenceSimilaritySearchResult/{schema_url}hits'.format(schema_url=ebi_schema_url)
        blast_results = results_root.find(results_path)

        results_context = []
        id_regex = re.compile('CHEMBL\d+')
        best_alignment_path = '{schema_url}alignments/{schema_url}alignment'.format(schema_url=ebi_schema_url)
        score_path = '{schema_url}score'.format(schema_url=ebi_schema_url)
        score_bits_path = '{schema_url}bits'.format(schema_url=ebi_schema_url)
        identities_path = '{schema_url}identity'.format(schema_url=ebi_schema_url)
        positives_path = '{schema_url}identity'.format(schema_url=ebi_schema_url)
        expectation_path = '{schema_url}identity'.format(schema_url=ebi_schema_url)

        for result_child in blast_results:
            id = id_regex.match(result_child.get('id')).group()
            length = result_child.get('length')
            best_alignment = result_child.find(best_alignment_path)
            best_score = float(best_alignment.find(score_path).text)
            best_score_bits = float(best_alignment.find(score_bits_path).text)
            best_identities = float(best_alignment.find(identities_path).text)
            best_positives = float(best_alignment.find(positives_path).text)
            best_expectation = float(best_alignment.find(expectation_path).text)

            new_result = {
                'id': id,
                'length': length,
                'best_score': best_score,
                'best_score_bits': best_score_bits,
                'best_identities': best_identities,
                'best_positives': best_positives,
                'best_expectation': best_expectation
            }
            results_context.append(new_result)

        print('results:')
        print(results_context)

    except Exception as ex:

        search_manager.save_search_job_state(sssearch_job, SSSearchJob.ERROR, repr(ex))
        tb = traceback.format_exc()
        search_manager.append_to_job_log(sssearch_job, "Error:\n{}".format(tb))
        print(tb)






