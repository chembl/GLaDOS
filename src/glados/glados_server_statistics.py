# This saves server statisticsic elastic search, like the usage of the elasticsearch cache.
from glados.models import ESCachedRequest
import json


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
