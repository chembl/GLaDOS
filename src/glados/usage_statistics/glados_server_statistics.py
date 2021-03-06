# This saves server statisticsic elastic search, like the usage of the elasticsearch cache.
from glados.models import ESCachedRequest
from glados.models import ESDownloadRecord
from glados.models import ESViewRecord
from glados.models import ESSearchRecord
from glados.models import ESTinyURLUsageRecord
import json
import hashlib
import base64
from elasticsearch_dsl.connections import connections
from django.core.cache import cache
import traceback
from django.conf import settings
from glados.settings import RunEnvs
from glados.es_connection import DATA_CONNECTION


def get_and_record_es_cached_response(index_name, raw_search_data):
    # executes a query to elasticsearch, if cached returns the cache, if not, saves it to cache, then records
    # the usage in elasticsearch

    print('elasticsearch_cache')
    stable_raw_search_data = json.dumps(json.loads(raw_search_data), sort_keys=True)
    search_data_digest = hashlib.sha256(stable_raw_search_data.encode('utf-8')).digest()
    base64_search_data_hash = base64.b64encode(search_data_digest).decode('utf-8')
    search_data = json.loads(raw_search_data)

    if not isinstance(search_data, dict):
        search_data = {}

    cache_key = "{}-{}".format(index_name, base64_search_data_hash)
    print('cache_key', cache_key)

    cache_response = None
    try:
        cache_response = cache.get(cache_key)
    except Exception as e:
        print('Error searching in cache!')

    response = None
    if cache_response is not None:
        print('results are in cache')
        response = cache_response
    else:
        print('results are NOT in cache')
        if search_data is None:
            search_data = {}
        search_data['track_total_hits'] = True
        response = connections.get_connection(alias=DATA_CONNECTION).search(index=index_name, body=search_data)
        try:
            cache_time = 3000000
            cache.set(cache_key, response, cache_time)
        except Exception as e:
            traceback.print_exc()
            print('Error saving in the cache!')

    record_elasticsearch_cache_usage(index_name, search_data, base64_search_data_hash, cache_response)

    return response


def record_elasticsearch_cache_usage(index_name, search_data, base64_search_data_hash, cache_response):

    try:
        es_query = search_data.get('query', None)
        if es_query:
            if isinstance(es_query, dict) and len(es_query) == 1 and \
                            'query_string' in es_query and 'query' in es_query['query_string']:
                es_query = es_query['query_string']['query'].strip()
            else:
                es_query = json.dumps(es_query)
        es_aggs = search_data.get('aggs', None)
        if es_aggs:
            es_aggs = json.dumps(es_aggs)
        es_cache_req_data = ESCachedRequest(
            es_index=index_name,
            es_query=es_query,
            es_aggs=es_aggs,
            es_request_digest=base64_search_data_hash,
            is_cached=cache_response is not None
        )
        es_cache_req_data.indexing()
    except:
        traceback.print_exc()
        print('Error saving cache record in elastic!')


def record_download(download_id, time_taken, is_new, file_size, desired_format, es_index, es_query='',
                    total_items=0):

    if settings.RUN_ENV == RunEnvs.TRAVIS:
        return

    try:
        download_record = ESDownloadRecord(
            download_id=download_id,
            time_taken=time_taken,
            is_new=is_new,
            file_size=file_size,
            desired_format=desired_format,
            es_index=es_index,
            es_query=es_query,
            total_items=total_items
        )
        download_record.indexing()
    except:
        traceback.print_exc()
        print('Error saving download record in elastic!')


def record_view_usage(view_name, view_type, entity_name):

    try:
        view_record = ESViewRecord(
            view_name=view_name,
            view_type=view_type,
            entity_name=entity_name
        )
        print('-------------------------------------------------')
        print('server statistics')
        print('record_view_usage: ', view_name)
        print('-------------------------------------------------')
        view_record.indexing()
    except:
        traceback.print_exc()
        print('Error saving view record in elastic!')


def record_search(search_type, time_taken, is_new=True):

    try:
        search_record = ESSearchRecord(
            search_type=search_type,
            time_taken=time_taken,
            is_new=is_new
        )
        print('-------------------------------------------------')
        print('server statistics')
        print('record_search: ', search_type)
        print('time_taken: ', time_taken)
        print('is_new: ', is_new)
        print('-------------------------------------------------')
        search_record.indexing()
    except:
        traceback.print_exc()
        print('Error saving search record in elastic!')


def record_tiny_url_usage(event):

    try:
        usage_record = ESTinyURLUsageRecord(event=event)
        print('-------------------------------------------------')
        print('server statistics')
        print('record tiny url usage event: ', event)
        print('-------------------------------------------------')
        usage_record.indexing()
    except:
        traceback.print_exc()
        print('Error saving tiny url usage record in elastic!')