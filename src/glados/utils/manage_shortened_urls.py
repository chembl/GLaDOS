from elasticsearch_dsl.connections import connections
from glados import es_connection
from elasticsearch.helpers import scan, bulk
from datetime import datetime
import sys

ES_INDEX = 'chembl_glados_tiny_url'
BULK_SIZE = 1000


def delete_expired_urls():

    dryn_run = '--dry-run' in sys.argv
    now = datetime.now()

    print('I am going to delete the urls that expire before {}'.format(str(now)))

    es_connection.setup_glados_es_connection()
    es_conn = connections.get_connection()

    query = {

        "query":{
            "range": {
                "expires": {
                    "lte": str(int(now.timestamp() * 1000))
                }

            }
        }
    }

    total_items = es_conn.search(index=ES_INDEX, body=query)['hits']['total']
    if dryn_run:
        print('I would have deleted {} saved urls (dry run).'.format(total_items))
    else:
        bulk(es_conn, stream_items(es_conn, query), chunk_size=BULK_SIZE)
        print('Deleted {} expired shortened urls.'.format(total_items))


def stream_items(es_conn, query):

    for doc_i in scan(es_conn, query=query, index=ES_INDEX, doc_type='_doc', scroll='1m'):

        del doc_i['_score']
        doc_i['_op_type'] = 'delete'
        yield doc_i
