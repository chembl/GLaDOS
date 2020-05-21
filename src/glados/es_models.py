from elasticsearch_dsl import Document, Text, Keyword, Boolean, Integer, Long
from elasticsearch_dsl.connections import connections
from typing import List
import traceback
from glados.es_connection import DATA_CONNECTION, MONITORING_CONNECTION


class TinyURLIndex(Document):

    long_url = Text()
    hash = Text()
    expires = Integer()

    class Index:
        name = 'chembl_glados_tiny_url'
        using = DATA_CONNECTION


class ESCachedRequestIndex(Document):
    es_index = Keyword()
    es_query = Keyword()
    es_aggs = Keyword()
    es_request_digest = Keyword()
    host = Keyword()
    run_env_type = Keyword()
    is_cached = Boolean()
    # Do not use elasticsearch_dsl Date type, it does not serializes correctly
    request_date = Integer()

    class Index:
        name = 'chembl_glados_es_cache_usage'
        using = MONITORING_CONNECTION

        
class ESDownloadRecordIndex(Document):
    download_id = Keyword()
    time_taken = Integer()
    is_new = Boolean()
    file_size = Long()
    es_index = Keyword()
    es_query = Keyword()
    run_env_type = Keyword()
    host = Keyword()
    desired_format = Keyword()
    total_items = Integer()
    # Do not use elasticsearch_dsl Date type, it does not serialize correctly
    request_date = Integer()

    class Index:
        name = 'chembl_glados_es_download_record'
        using = MONITORING_CONNECTION


class ESTinyURLUsageRecordIndex(Document):
    event = Keyword()
    host = Keyword()
    run_env_type = Keyword()
    request_date = Integer()

    class Index:
        name = 'chembl_glados_es_tinyurl_usage_record'
        using = MONITORING_CONNECTION


class ESSearchRecordIndex(Document):

    search_type = Keyword()
    run_env_type = Keyword()
    host = Keyword()
    request_date = Integer()
    time_taken = Integer()
    is_new = Boolean()

    class Index:
        name = 'chembl_glados_es_search_record'
        using = MONITORING_CONNECTION


class ESViewRecordIndex(Document):
    view_name = Keyword()
    view_type = Keyword()
    entity_name = Keyword()
    run_env_type = Keyword()
    host = Keyword()
    request_date = Integer()

    class Index:
        name = 'chembl_glados_es_view_record'
        using = MONITORING_CONNECTION


class ElasticSearchMultiSearchQuery:

    def __init__(self, index, body):
        self.index = index
        self.body = body


def do_multi_search(queries: List[ElasticSearchMultiSearchQuery], connection_type=DATA_CONNECTION):
    try:
        conn = connections.get_connection(alias=connection_type)
        multi_search_body = []
        for query_i in queries:
            multi_search_body.append({'index': query_i.index})
            if query_i.body is None:
                query_i.body = {}
            query_i.body['track_total_hits'] = True
            multi_search_body.append(query_i.body)
        return conn.msearch(body=multi_search_body)
    except Exception as e:
        traceback.print_exc()
        raise Exception('ERROR: can\'t retrieve elastic search data!')
