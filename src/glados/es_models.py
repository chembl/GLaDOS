from elasticsearch_dsl.connections import connections
from elasticsearch_dsl import DocType, Text
from elasticsearch.helpers import bulk
from elasticsearch import Elasticsearch
from . import models

ELASTICSEARCH_HOST = 'https://wwwdev.ebi.ac.uk/chembl/glados-es/__secret/'
ELASTICSEARCH_USERNAME = 'GLaDOS'
ELASTICSEARCH_PASSWORD = 'GLaDOS ToP S3CRe7'
connections.create_connection(hosts=[ELASTICSEARCH_HOST], http_auth=(ELASTICSEARCH_USERNAME, ELASTICSEARCH_PASSWORD))

class TinyURLIndex(DocType):
  long_url = Text()
  hash = Text()

  class Meta:
    index = 'chembl_glados_tiny_url'

def bulk_indexing():
  TinyURLIndex.init()
  es = Elasticsearch()
  bulk(client=es, actions=(b.indexing() for b in models.TinyURL.objects.all().iterator()))