import hashlib
import base64
from glados.models import TinyURL
from elasticsearch_dsl import Search
from django.http import JsonResponse
from datetime import datetime, timedelta, timezone
from glados.usage_statistics import glados_server_statistics
from glados.models import ESTinyURLUsageRecord
from glados.es_connection import DATA_CONNECTION, MONITORING_CONNECTION

DAYS_TO_LIVE = 7


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

    long_url, expiration_str = get_original_url(hash)
    resp_data = {
        'long_url': long_url,
        'expiration_date': expiration_str
    }

    return JsonResponse(resp_data)


# given a long url, it shortens it and saves it in elastic, it returns the hash obtained
def shorten_url(long_url):
    hex_digest = hashlib.md5(long_url.encode('utf-8')).digest()
    # replace / and + to avoid routing problems
    url_hash = base64.b64encode(hex_digest).decode('utf-8').replace('/', '_').replace('+', '-')

    # save this in elastic if it doesn't exist
    s = Search(index='chembl_glados_tiny_url')\
        .extra(track_total_hits=True).using(DATA_CONNECTION).filter('query_string', query='"' + url_hash + '"')
    response = s.execute()
    if response.hits.total.value == 0:
        dt = datetime.now()
        td = timedelta(days=DAYS_TO_LIVE)
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

    glados_server_statistics.record_tiny_url_usage(ESTinyURLUsageRecord.URL_SHORTENED)
    return url_hash, expiration_date_str


def get_original_url(url_hash):
    # look here in elastic
    s = Search(index='chembl_glados_tiny_url')\
        .extra(track_total_hits=True).using(DATA_CONNECTION).filter('query_string', query='"' + url_hash + '"')
    response = s.execute(ignore_cache=True)

    if response.hits.total.value == 0:
        return None, None

    try:
        expires = response.hits[0].expires
        expiration_date = datetime.utcfromtimestamp(expires / 1000)
        now = datetime.now()
        expired = now > expiration_date
        if expired:
            return None, None
        else:
            url = response.hits[0].long_url
            glados_server_statistics.record_tiny_url_usage(ESTinyURLUsageRecord.URL_EXPANDED)
            expiration_date_str = expiration_date.replace(tzinfo=timezone.utc).isoformat()
            return url, expiration_date_str

    except AttributeError:
        # no expiration time means that it never expires
        url = response.hits[0].long_url
        glados_server_statistics.record_tiny_url_usage(ESTinyURLUsageRecord.URL_EXPANDED)
        return url, None


