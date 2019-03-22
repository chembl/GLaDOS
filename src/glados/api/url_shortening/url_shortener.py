import hashlib
import base64
from glados.models import TinyURL
from elasticsearch_dsl import Search
from django.http import JsonResponse
from datetime import datetime, timedelta


def process_shorten_url_request(request):
    if request.method == "POST":
        long_url = request.POST.get('long_url', '')
        short_url = shorten_url(long_url)

        resp_data = {
            'hash': short_url
        }
        return JsonResponse(resp_data)

    else:
        return JsonResponse({'error': 'this is only available via POST'})


def process_extend_url_request(request, hash):
    resp_data = {
        'long_url': get_original_url(hash)
    }

    return JsonResponse(resp_data)


# given a long url, it shortens it and saves it in elastic, it returns the hash obtained
def shorten_url(long_url):

  hex_digest = hashlib.md5(long_url.encode('utf-8')).digest()
  # replace / and + to avoid routing problems
  hash = base64.b64encode(hex_digest).decode('utf-8').replace('/', '_').replace('+', '-')

  # save this in elastic if it doesn't exist
  s = Search().filter('query_string', query='"' + hash + '"')
  response = s.execute()
  if response.hits.total == 0:

    dt = datetime.now()
    td = timedelta(days=4)
    expiration_date = dt + td
    expires = expiration_date.timestamp() * 1000

    tinyURL = TinyURL(long_url=long_url, hash=hash, expires=expires)
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
