import hashlib
import base64
from glados.models import TinyURL
from elasticsearch_dsl import Search
from django.http import JsonResponse
from datetime import datetime, timedelta, timezone


def process_shorten_url_request(request):
    if request.method == "POST":
        long_url = request.POST.get('long_url', '')
        short_url, expiration_str = shorten_url(long_url)

        resp_data = {
            'hash': short_url,
            'expires': expiration_str
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
    url_hash = base64.b64encode(hex_digest).decode('utf-8').replace('/', '_').replace('+', '-')

    # save this in elastic if it doesn't exist
    s = Search().filter('query_string', query='"' + url_hash + '"')
    response = s.execute()
    if response.hits.total == 0:
        dt = datetime.now()
        td = timedelta(days=4)
        expiration_date = dt + td
        expires = expiration_date.timestamp() * 1000
        tinyURL = TinyURL(long_url=long_url, hash=url_hash, expires=expires)
        tinyURL.indexing()
        expiration_date_str = expiration_date.replace(tzinfo=timezone.utc).isoformat()
    else:

        try:
            expires = response.hits[0].expires
            expiration_date = datetime.utcfromtimestamp(expires / 1000)
            expiration_date_str = expiration_date.replace(tzinfo=timezone.utc).isoformat()
        except AttributeError:
            expiration_date_str = 'Never'

    return url_hash, expiration_date_str


def get_original_url(hash):
    # look here in elastic
    s = Search().filter('query_string', query='"' + hash + '"')
    response = s.execute(ignore_cache=True)

    if response.hits.total == 0:
        return None

    try:
        expires = response.hits[0].expires
        expiration_date = datetime.utcfromtimestamp(expires / 1000)

    except AttributeError:
        # no expiration time means that it never expires
        pass

    url = response.hits[0].long_url
    return url
