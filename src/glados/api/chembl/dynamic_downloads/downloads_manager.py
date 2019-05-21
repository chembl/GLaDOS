# this handles the creation of dynamically generated downloads
import time
from django_rq import job
import hashlib
import base64
from glados.models import DownloadJob
from elasticsearch.helpers import scan
from elasticsearch_dsl.connections import connections
import json
import traceback
from glados.usage_statistics import glados_server_statistics
from glados.api.chembl.sssearch import search_manager
import gzip
import os
from django.conf import settings
from glados.settings import RunEnvs
import re
import subprocess
import socket
from datetime import datetime, timedelta, timezone
from glados.models import SSSearchJob
from django.http import JsonResponse, HttpResponse
from . import columns_parser
import logging

logger = logging.getLogger('django')
DAYS_TO_LIVE = 7


class DownloadError(Exception):
    """Base class for exceptions in this file."""
    pass


# ----------------------------------------------------------------------------------------------------------------------
# Entry functions
# ----------------------------------------------------------------------------------------------------------------------
def request_generate_download_request(request):

    if request.method != "POST":
        return JsonResponse({'error': 'This is only available via POST'})

    index_name = request.POST.get('index_name', '')
    raw_query = request.POST.get('query', '')
    desired_format = request.POST.get('format', '')
    raw_columns_to_download = request.POST.get('columns', '')
    context_id = request.POST.get('context_id')
    id_property = request.POST.get('id_property')

    if context_id == "null" or context_id == "undefined":
        context_id = None

    try:
        response = generate_download(index_name, raw_query, desired_format,
                                                               raw_columns_to_download, context_id, id_property)
        return JsonResponse(response)
    except Exception as e:
        traceback.print_exc()
        return HttpResponse('Internal Server Error', status=500)


def request_get_download_status(request, download_id):

        if request.method != "GET":
            return JsonResponse({'error': 'This is only available via GET'})

        try:
            response = get_download_status(download_id)
            return JsonResponse(response)
        except Exception as e:
            traceback.print_exc()
            return HttpResponse('Internal Server Error', status=500)
# ----------------------------------------------------------------------------------------------------------------------
# Download job helpers
# ----------------------------------------------------------------------------------------------------------------------


def save_download_job_progress(download_job, progress_percentage):
    download_job.progress = progress_percentage
    download_job.save()


def save_download_job_state(download_job, new_state):
    download_job.status = new_state
    if new_state == DownloadJob.FINISHED:
        dt = datetime.now()
        td = timedelta(days=DAYS_TO_LIVE)
        expiration_date = dt + td
        expiration_date.replace(tzinfo=timezone.utc)
        download_job.expires = expiration_date
    download_job.save()


# ----------------------------------------------------------------------------------------------------------------------
# Property getter
# ----------------------------------------------------------------------------------------------------------------------


class DotNotationGetter:
    DEFAULT_NULL_LABEL = ''

    def __init__(self, obj):
        self.obj = obj

    def get_property(self, obj, str_property):
        prop_parts = str_property.split('.')
        current_prop = prop_parts[0]
        if len(prop_parts) > 1:
            current_obj = obj.get(current_prop)
            if current_obj is None:
                return self.DEFAULT_NULL_LABEL
            else:
                return self.get_property(current_obj, '.'.join(prop_parts[1::]))
        else:

            value = obj.get(current_prop)
            value = self.DEFAULT_NULL_LABEL if value is None else value
            return value

    def get_from_string(self, dot_notation_property):
        return self.get_property(self.obj, dot_notation_property)


def format_cell(original_value):
    value = original_value
    if isinstance(value, str):
        value = value.replace('"', "'")

    return '"{}"'.format(value)


def parse_and_format_cell(original_value, index_name, property_name):
    value = columns_parser.static_parse_property(original_value, index_name, property_name)
    return format_cell(value)


def get_file_path(job_id):
    return os.path.join(settings.DYNAMIC_DOWNLOADS_DIR, job_id + '.gz')


# ----------------------------------------------------------------------------------------------------------------------
# Writing csv and tsv files
# ----------------------------------------------------------------------------------------------------------------------


def write_csv_or_tsv_file(scanner, download_job, cols_to_download, index_name, context_id, id_property, desired_format):
    file_path = get_file_path(download_job.job_id)
    total_items = download_job.total_items
    separator = ',' if desired_format == 'csv' else '\t'

    context = None
    if context_id is not None:
        sssearch_job = SSSearchJob.objects.get(search_id=context_id)
        context, total_results = search_manager.get_search_results_context(sssearch_job, False)
        context_index = {}
        for item in context:
            context_index[item[id_property]] = item

    with gzip.open(file_path, 'wt', encoding='utf-16-le') as out_file:

        own_columns = [col for col in cols_to_download if col.get('is_contextual') is not True]
        contextual_columns = [col for col in cols_to_download if col.get('is_contextual') is True]
        all_columns = own_columns + contextual_columns

        header_line = separator.join([format_cell(col['label']) for col in all_columns])
        out_file.write(header_line + '\n')

        i = 0
        previous_percentage = 0
        for doc_i in scanner:
            i += 1

            doc_source = doc_i['_source']
            dot_notation_getter = DotNotationGetter(doc_source)
            own_properties_to_get = [col['property_name'] for col in own_columns]

            own_values = [parse_and_format_cell(dot_notation_getter.get_from_string(prop_name), index_name, prop_name)
                          for prop_name in own_properties_to_get]

            contextual_values = []
            if context is not None:
                context_item = context_index[doc_i['_id']]
                for col in contextual_columns:
                    prop_name_in_context = col['property_name'].replace(
                        '{}.'.format(SSSearchJob.CONTEXT_PREFIX), '')
                    value = str(context_item[prop_name_in_context])
                    contextual_values.append(value)

            all_values = own_values + contextual_values
            item_line = separator.join(all_values)
            out_file.write(item_line + '\n')

            percentage = int((i / total_items) * 100)
            if percentage != previous_percentage:
                previous_percentage = percentage
                save_download_job_progress(download_job, percentage)

    file_size = os.path.getsize(file_path)
    return file_size


# ----------------------------------------------------------------------------------------------------------------------
# Writing sdf files
# ----------------------------------------------------------------------------------------------------------------------


def write_sdf_file(scanner, download_job):
    file_path = get_file_path(download_job.job_id)
    total_items = download_job.total_items
    with gzip.open(file_path, 'wt') as out_file:

        i = 0
        previous_percentage = 0
        for doc_i in scanner:
            i += 1

            doc_source = doc_i['_source']
            dot_notation_getter = DotNotationGetter(doc_source)
            sdf_value = dot_notation_getter.get_from_string('_metadata.compound_generated.sdf_data')
            if sdf_value is None:
                continue

            out_file.write(sdf_value)
            out_file.write('$$$$\n')

            percentage = int((i / total_items) * 100)
            if percentage != previous_percentage:
                previous_percentage = percentage
                save_download_job_progress(download_job, percentage)

    file_size = os.path.getsize(file_path)
    return file_size


@job
def generate_download_file(download_id):

    print('-----------------------------------------------------------------------------------------------------------')
    print('Processing job: ', download_id)
    print('-----------------------------------------------------------------------------------------------------------')
    start_time = time.time()
    download_job = DownloadJob.objects.get(job_id=download_id)
    download_job.status = DownloadJob.PROCESSING
    download_job.worker = socket.gethostname()
    download_job.save()
    append_to_job_log(download_job, 'Generating File')

    index_name = download_job.index_name
    raw_columns_to_download = download_job.raw_columns_to_download
    cols_to_download = json.loads(raw_columns_to_download)
    raw_query = download_job.raw_query
    query = json.loads(raw_query)
    context_id = download_job.context_id
    id_property = download_job.id_property
    desired_format = download_job.desired_format

    try:
        es_conn = connections.get_connection()
        total_items = es_conn.search(index=index_name, body={'query': query})['hits']['total']

        if desired_format in ['csv', 'tsv']:
            source = [col['property_name'] for col in cols_to_download]
        if desired_format == 'sdf':
            source = ['_metadata.compound_generated.sdf_data']

        scanner = scan(es_conn, index=index_name, scroll=u'1m', size=1000, request_timeout=60, query={
            "_source": source,
            "query": query
        })

        download_job.total_items = total_items
        download_job.save()

        if desired_format in ['csv', 'tsv']:
            file_size = write_csv_or_tsv_file(scanner, download_job, cols_to_download, index_name, context_id,
                                              id_property, desired_format)
        elif desired_format == 'sdf':
            file_size = write_sdf_file(scanner, download_job)

        if settings.RUN_ENV == RunEnvs.PROD:
            rsync_to_the_other_nfs(download_job)

        append_to_job_log(download_job, 'File Ready')
        # here

        logger.debug('File Ready: ' + get_file_path(download_job.job_id))
        save_download_job_state(download_job, DownloadJob.FINISHED)

        # now save some statistics
        end_time = time.time()
        time_taken = end_time - start_time
        glados_server_statistics.record_download(
            download_id=download_id,
            time_taken=time_taken,
            is_new=True,
            file_size=file_size,
            es_index=index_name,
            es_query=raw_query,
            desired_format=desired_format,
            total_items=total_items,
        )

    except:
        save_download_job_state(download_job, DownloadJob.ERROR)
        tb = traceback.format_exc()
        append_to_job_log(download_job, "Error:\n{}".format(tb))
        print(tb)
        return


def rsync_to_the_other_nfs(download_job):
    hostname = socket.gethostname()
    if bool(re.match("wp-p1m.*", hostname)):
        rsync_destination_server = 'wp-p2m-54'
    else:
        rsync_destination_server = 'wp-p1m-54'

    file_path = get_file_path(download_job.job_id)
    rsync_destination = "{server}:{path}".format(server=rsync_destination_server, path=file_path)
    rsync_command = "rsync -v {source} {destination}".format(source=file_path, destination=rsync_destination)
    rsync_command_parts = rsync_command.split(' ')

    append_to_job_log(download_job, "Rsyncing: {}".format(rsync_command))
    subprocess.check_call(rsync_command_parts)


def get_download_id(index_name, raw_query, desired_format, context_id):
    # make sure the string generated is stable
    stable_raw_query = json.dumps(json.loads(raw_query), sort_keys=True)

    parsed_desired_format = desired_format.lower()
    if parsed_desired_format not in ['csv', 'tsv', 'sdf']:
        raise DownloadError("Format {} not supported".format(desired_format))

    latest_release_full = settings.CURRENT_CHEMBL_RELEASE
    query_digest = hashlib.sha256(stable_raw_query.encode('utf-8')).digest()
    base64_query_digest = base64.b64encode(query_digest).decode('utf-8').replace('/', '_').replace('+', '-')

    if context_id is None:
        download_id = "{}-{}-{}.{}".format(latest_release_full, index_name, base64_query_digest, parsed_desired_format)
    else:
        download_id = "{}-{}-{}-{}.{}".format(latest_release_full, index_name, base64_query_digest,
                                              context_id, parsed_desired_format)
    return download_id

@job
def wait_until_job_is_deleted_and_requeue(download_id):

    download_job = DownloadJob.objects.get(job_id=download_id)
    download_id = download_job.job_id
    index_name = download_job.index_name
    raw_columns_to_download = download_job.raw_columns_to_download
    raw_query = download_job.raw_query
    parsed_desired_format = download_job.desired_format
    context_id = download_job.context_id
    id_property = download_job.id_property

    job_exists = True
    while job_exists:
        try:
            logger.debug('job still exists')
            DownloadJob.objects.get(job_id=download_id)
            time.sleep(1)
        except DownloadJob.DoesNotExist:
            logger.debug('job was deleted!')
            job_exists = False

    queue_job(download_id=download_id, index_name=index_name, raw_columns_to_download=raw_columns_to_download,
              raw_query=raw_query, parsed_desired_format=parsed_desired_format, context_id=context_id,
              id_property=id_property
              )


def queue_job(download_id, index_name, raw_columns_to_download, raw_query, parsed_desired_format, context_id,
              id_property):

    download_job = DownloadJob(
        job_id=download_id,
        index_name=index_name,
        raw_columns_to_download=raw_columns_to_download,
        raw_query=raw_query,
        desired_format=parsed_desired_format,
        log=format_log_message('Job Queued'),
        context_id=context_id,
        id_property=id_property
    )
    download_job.save()
    generate_download_file.delay(download_id)


def requeue_job(download_id, job_log_msg):
    # This queues again a job that exists but for any reason it needs to be put into the queue again
    download_job = DownloadJob.objects.get(job_id=download_id)
    download_job.progress = 0
    download_job.status = DownloadJob.QUEUED
    download_job.save()
    append_to_job_log(download_job, job_log_msg)
    generate_download_file.delay(download_id)


def generate_download(index_name, raw_query, desired_format, raw_columns_to_download, context_id, id_property):
    response = {}
    download_id = get_download_id(index_name, raw_query, desired_format, context_id)
    parsed_desired_format = desired_format.lower()

    try:
        download_job = DownloadJob.objects.get(job_id=download_id)
        if download_job.status == DownloadJob.ERROR:
            # if it was in error state, requeue it
            requeue_job(download_id, 'Job was in error state, queuing again.')

        elif download_job.status == DownloadJob.FINISHED:

            # if not, register the statistics
            try:
                file_path = get_file_path(download_id)
                file_size = os.path.getsize(file_path)

                glados_server_statistics.record_download(
                    download_id=download_id,
                    time_taken=0,
                    is_new=False,
                    file_size=file_size,
                    es_index=index_name,
                    es_query=raw_query,
                    desired_format=desired_format,
                    total_items=download_job.total_items
                )
            except FileNotFoundError:
                # if for some reason the file is not found. requeue que job
                requeue_job(download_id, 'File not found, queuing again.')

        elif download_job.status == DownloadJob.DELETING:
            # someone is deleting the job, I just need to wait until it is deleted and then re queue it
            logger.debug('job is being deleted! We need to wait until the process finishes')
            wait_until_job_is_deleted_and_requeue.delay(download_id)

    except DownloadJob.DoesNotExist:
        queue_job(download_id=download_id, index_name=index_name, raw_columns_to_download=raw_columns_to_download,
            raw_query=raw_query, parsed_desired_format=parsed_desired_format, context_id=context_id, id_property=id_property
        )

    response['download_id'] = download_id
    return response


def append_to_job_log(download_job, msg):
    if download_job.log is None:
        download_job.log = ''

    download_job.log += format_log_message(msg)
    download_job.save()


def format_log_message(msg):
    now = datetime.now()
    return "[{date}] {hostname}: {msg}\n".format(date=now, hostname=socket.gethostname(), msg=msg)


def get_download_status(download_id):
    try:
        download_job = DownloadJob.objects.get(job_id=download_id)
        status = download_job.status
        response = {
            'percentage': download_job.progress,
            'status': download_job.status

        }

        if status == DownloadJob.FINISHED:
            if download_job.expires is not None:
                expiration_time_str = download_job.expires.replace(tzinfo=timezone.utc).isoformat()
                response['expires'] = expiration_time_str

        return response

    except DownloadJob.DoesNotExist:
        response = {
            'msg': 'download does not exist!',
            'status': DownloadJob.ERROR,
        }
        return response
