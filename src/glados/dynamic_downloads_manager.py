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
import gzip
import os
from django.conf import settings

class DownloadError(Exception):
    """Base class for exceptions in this file."""
    pass

# ----------------------------------------------------------------------------------------------------------------------
# Download job helpers
# ----------------------------------------------------------------------------------------------------------------------


def save_download_job_progress(download_job, progress_percentage):
    download_job.progress = progress_percentage
    download_job.save()


def save_download_job_state(download_job, new_state):
    download_job.status = new_state
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

# ----------------------------------------------------------------------------------------------------------------------
# Columns Parsing
# ----------------------------------------------------------------------------------------------------------------------


class ColumnsParsing:

    def static_parse_synonyms(raw_synonyms):
        true_synonyms = set()
        for raw_syn in raw_synonyms:
            true_synonyms.add(raw_syn['synonyms'])
        return '|'.join(true_synonyms)

    def static_parse_property(original_value, index_name, property_name):

        if index_name == 'chembl_molecule':
            if property_name == 'molecule_synonyms':
                value = ColumnsParsing.static_parse_synonyms(original_value)
                return value
            else:
                return original_value
        else:
            return original_value


def format_cell(original_value):

    value = original_value
    if isinstance(value, str):
        value = value.replace('"', "'")

    return '"{}"'.format(value)


def parse_and_format_cell(original_value, index_name, property_name):

    value = ColumnsParsing.static_parse_property(original_value, index_name, property_name)
    return format_cell(value)


def get_file_path(job_id):
    return os.path.join(settings.DYNAMIC_DOWNLOADS_DIR, job_id + '.gz')
# ----------------------------------------------------------------------------------------------------------------------
# Writing csv and tsv files
# ----------------------------------------------------------------------------------------------------------------------


def write_csv_or_tsv_file(scanner, download_job, cols_to_download, index_name, desired_format):
    file_path = get_file_path(download_job.job_id)
    total_items = download_job.total_items
    separator = ',' if desired_format == 'csv' else '\t'

    with gzip.open(file_path, 'wt', encoding='utf-16-le') as out_file:

        header_line = separator.join([format_cell(col['label']) for col in cols_to_download])
        out_file.write(header_line + '\n')

        i = 0
        previous_percentage = 0
        for doc_i in scanner:
            i += 1

            doc_source = doc_i['_source']
            dot_notation_getter = DotNotationGetter(doc_source)
            properties_to_get = [col['property_name'] for col in cols_to_download]
            values = [parse_and_format_cell(dot_notation_getter.get_from_string(prop_name), index_name, prop_name) for
                      prop_name in properties_to_get]
            item_line = separator.join(values)
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

    start_time = time.time()
    download_job = DownloadJob.objects.get(job_id=download_id)
    download_job.status = DownloadJob.PROCESSING
    download_job.save()

    print('processing job: ', download_id)

    index_name = download_job.index_name
    raw_columns_to_download = download_job.raw_columns_to_download
    cols_to_download = json.loads(raw_columns_to_download)
    raw_query = download_job.raw_query
    query = json.loads(raw_query)
    desired_format = download_job.desired_format

    try:
        es_conn = connections.get_connection()
        total_items = es_conn.search(index=index_name, body={'query': query})['hits']['total']

        if desired_format in ['csv', 'tsv']:
            source = [col['property_name'] for col in cols_to_download]
        if desired_format == 'sdf':
            source = ['_metadata.compound_generated.sdf_data']

        scanner = scan(es_conn, index=index_name, size=1000, query={
            "_source": source,
            "query": query
        })

        download_job.total_items = total_items
        download_job.save()

        if desired_format in ['csv', 'tsv']:
            file_size = write_csv_or_tsv_file(scanner, download_job, cols_to_download, index_name, desired_format)
        elif desired_format == 'sdf':
            file_size = write_sdf_file(scanner, download_job)

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
            total_items=total_items
        )

    except:
        save_download_job_state(download_job, DownloadJob.ERROR)
        traceback.print_exc()
        return


def get_download_id(index_name, raw_query, desired_format):

    # make sure the string generated is stable
    stable_raw_query = json.dumps(json.loads(raw_query), sort_keys=True)

    parsed_desired_format = desired_format.lower()
    if parsed_desired_format not in ['csv', 'tsv', 'sdf']:
        raise DownloadError("Format {} not supported".format(desired_format))

    latest_release_full = 'chembl_24_1'
    query_digest = hashlib.sha256(stable_raw_query.encode('utf-8')).digest()
    base64_query_digest = base64.b64encode(query_digest).decode('utf-8').replace('/', '_').replace('+', '-')

    download_id = "{}-{}-{}.{}".format(latest_release_full, index_name, base64_query_digest, parsed_desired_format)
    return download_id


def generate_download(index_name, raw_query, desired_format, raw_columns_to_download):
    response = {}
    download_id = get_download_id(index_name, raw_query, desired_format)
    parsed_desired_format = desired_format.lower()

    try:
        download_job = DownloadJob.objects.get(job_id=download_id)
        if download_job.status == DownloadJob.ERROR:
            # if it was in error state, requeue it
            download_job.progress = 0
            download_job.status = DownloadJob.QUEUED
            download_job.save()
            generate_download_file.delay(download_id)
        elif download_job.status == DownloadJob.FINISHED:
            # if not, register the statistics
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

    except DownloadJob.DoesNotExist:
        download_job = DownloadJob(
            job_id=download_id,
            index_name=index_name,
            raw_columns_to_download=raw_columns_to_download,
            raw_query=raw_query,
            desired_format=parsed_desired_format
        )
        download_job.save()
        generate_download_file.delay(download_id)

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
        response = {
            'msg': 'download does not exist!',
            'status:': DownloadJob.ERROR
        }
        return response
