from elasticsearch_dsl.connections import connections
from elasticsearch_dsl import DocType, Text

connections.create_connection()

class TinyURL(DocType):
  long_url = Text()
  hash = Text()

  class Meta:
    index = 'chembl_glados_tiny_url'