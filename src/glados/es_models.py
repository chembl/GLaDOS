from elasticsearch_dsl.connections import connections
from elasticsearch_dsl import DocType, Text
from elasticsearch.helpers import bulk
from elasticsearch import Elasticsearch
from . import models

connections.create_connection()

class TinyURLIndex(DocType):
  long_url = Text()
  hash = Text()

  class Meta:
    index = 'chembl_glados_tiny_url'

  def indexing(self):
    obj = BlogPostIndex(
      meta={'id': self.id},
      author=self.author.username,
      posted_date=self.posted_date,
      title=self.title,
      text=self.text
    )
    obj.save()
    return obj.to_dict(include_meta=True)

def bulk_indexing():
  TinyURL.init()
  es = Elasticsearch()
  bulk(client=es, actions=(b.indexing() for b in models.TinyURL.objects.all().iterator()))