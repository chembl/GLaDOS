from elasticsearch_dsl import DocType, Text, Keyword, Boolean, Integer, Long
from elasticsearch_dsl.connections import connections
from typing import List
import traceback


class TinyURLIndex(DocType):
    long_url = Text()
    hash = Text()

    class Meta:
        index = 'chembl_glados_tiny_url'


class ESCachedRequestIndex(DocType):
    es_index = Keyword()
    es_query = Keyword()
    es_aggs = Keyword()
    es_request_digest = Keyword()
    host = Keyword()
    run_env_type = Keyword()
    is_cached = Boolean()
    # Do not use elasticsearch_dsl Date type, it does not serializes correctly
    request_date = Integer()

    class Meta:
        index = 'chembl_glados_es_cache_usage'
        doc_type = 'es_cached_request'

        
class ESDownloadRecordIndex(DocType):
    download_id = Keyword()
    time_taken = Integer()
    is_new = Boolean()
    file_size = Long()
    es_index = Keyword()
    es_query = Keyword()
    run_env_type = Keyword()
    desired_format = Keyword()
    total_items = Integer()
    # Do not use elasticsearch_dsl Date type, it does not serialize correctly
    request_date = Integer()

    class Meta:
        index = 'chembl_glados_es_download_record'
        doc_type = 'es_download_record'


class ESViewRecordIndex(DocType):
    view_name = Keyword()
    run_env_type = Keyword()
    host = Keyword()
    request_date = Integer()

    class Meta:
        index = 'chembl_glados_es_view_record'
        doc_type = 'es_view_record'


class ElasticSearchMultiSearchQuery:

    def __init__(self, index, body):
        self.index = index
        self.body = body


def do_multi_search(queries: List[ElasticSearchMultiSearchQuery]):
    try:
        conn = connections.get_connection()
        multi_search_body = []
        for query_i in queries:
            multi_search_body.append({'index': query_i.index})
            multi_search_body.append(query_i.body)
        return conn.msearch(body=multi_search_body)
    except Exception as e:
        traceback.print_exc()
        raise Exception('ERROR: can\'t retrieve elastic search data!')
