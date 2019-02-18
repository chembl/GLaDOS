import hashlib
import base64
from glados.models import TinyURL
from elasticsearch_dsl import Search


# given a long url, it shortens it and saves it in elastic, it returns the hash obtained
def shorten_url(long_url):

  hex_digest = hashlib.md5(long_url.encode('utf-8')).digest()
  # replace / and + to avoid routing problems
  hash = base64.b64encode(hex_digest).decode('utf-8').replace('/', '_').replace('+', '-')
  print('shorten url')
  print('long_url: ', long_url)
  print('hash: ', hash)
  # save this in elastic if it doesn't exist
  s = Search().filter('query_string', query='"' + hash + '"')
  response = s.execute()
  if response.hits.total == 0:
    tinyURL = TinyURL(long_url=long_url, hash=hash)
    tinyURL.indexing()
    print('has not been saved before!')

  return hash

def get_original_url(hash):

  #look here in elastic
  s = Search().filter('query_string', query='"' + hash + '"')
  response = s.execute(ignore_cache=True)
  if response.hits.total == 0:
    return None

  url = response.hits[0].long_url
  return url
