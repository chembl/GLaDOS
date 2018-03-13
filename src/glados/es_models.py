from elasticsearch_dsl.connections import connections
from elasticsearch_dsl import DocType, Text
from elasticsearch.helpers import bulk
from elasticsearch import Elasticsearch
from . import models
from django.conf import settings

if settings.ELASTICSEARCH_PASSWORD == None:
  connections.create_connection(hosts=[settings.ELASTICSEARCH_HOST])
else:
  connections.create_connection(hosts=[settings.ELASTICSEARCH_HOST],
                              http_auth=(settings.ELASTICSEARCH_USERNAME, settings.ELASTICSEARCH_PASSWORD))

class TinyURLIndex(DocType):
  long_url = Text()
  hash = Text()

  class Meta:
    index = 'chembl_glados_tiny_url'

def bulk_indexing():
  TinyURLIndex.init()
  es = Elasticsearch()
  bulk(client=es, actions=(b.indexing() for b in models.TinyURL.objects.all().iterator()))