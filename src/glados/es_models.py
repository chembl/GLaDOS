from elasticsearch_dsl import DocType, Text, connections
from typing import List


class TinyURLIndex(DocType):
    long_url = Text()
    hash = Text()

    class Meta:
        index = 'chembl_glados_tiny_url'


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
        raise Exception('ERROR: can\'t retrieve elastic search data!')

