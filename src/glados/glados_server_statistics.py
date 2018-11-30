# This saves server statisticsic elastic search, like the usage of the elasticsearch cache.
from glados.models import ESCachedRequest
import json
import hashlib
import base64
from elasticsearch_dsl.connections import connections
from django.core.cache import cache
import traceback


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
        response = connections.get_connection().search(index=index_name, body=search_data)
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
        print('Error saving in elastic!')
