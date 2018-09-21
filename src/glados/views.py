from django.shortcuts import render
from twitter import *
from django.conf import settings
from glados.utils import *
from django.core.cache import cache
from django.http import JsonResponse, HttpResponse
import glados.url_shortener.url_shortener as url_shortener
from apiclient.discovery import build
import re
from elasticsearch_dsl import Search
from elasticsearch_dsl.connections import connections
import requests
import datetime
import timeago
import json
import hashlib
import base64
from glados.models import ESCachedRequest
from . import og_tags_generator


def visualise(request):
    context = {
        'hide_breadcrumbs': True
    }

    return render(request, 'glados/visualise.html', context)


def get_latest_tweets(page_number=1, count=15):
    """
    Returns the latest tweets from chembl, It tries to find them in the cache first to avoid hammering twitter
    :return: The structure returned by the twitter api. If there is an error getting the tweets, it returns an
    empty list.
    """
    default_empty_response = ([], {}, 0)
    if not settings.TWITTER_ENABLED:
        return default_empty_response
    cache_key = str(page_number) + "-" + str(count)
    cache_time = 1800  # time to live in seconds

    t_cached_response = cache.get(cache_key)

    # If they are found in the cache, just return them
    if t_cached_response and isinstance(t_cached_response, tuple) and len(t_cached_response) == 3:
        print('Tweets are in cache')
        return t_cached_response

    print('tweets not found in cache!')

    try:
        access_token = settings.TWITTER_ACCESS_TOKEN
        access_token_secret = settings.TWITTER_ACCESS_TOKEN_SECRET
        consumer_key = settings.TWITTER_CONSUMER_KEY
        consumer_secret = settings.TWITTER_CONSUMER_SECRET
        t = Twitter(auth=OAuth(access_token, access_token_secret, consumer_key, consumer_secret))
        tweets = t.statuses.user_timeline(screen_name="chembl", count=count, page=page_number)
        users = t.users.lookup(screen_name="chembl")
        user_data = users[0]
        t_response = (tweets, user_data, user_data['statuses_count'])
        cache.set(cache_key, t_response, cache_time)

        return t_response
    except Exception as e:
        print_server_error(e)
        return default_empty_response


def get_latest_tweets_json(request):
    try:
        count = request.GET.get('limit', 15)
        offset = request.GET.get('offset', 0)
        page_number = str((int(offset) / int(count)) + 1)
        tweets_content, user_data, total_count = get_latest_tweets(page_number, count)
    except Exception as e:
        print_server_error(e)
        return JsonResponse({
            'tweets': [],
            'page_meta': {
                "limit": 0,
                "offset": 0,
                "total_count": 0
            },
            'ERROR': 'Unexpected error while processing your request!'
        })

    for tweet_i in tweets_content:
        tweet_i['id'] = str(tweet_i['id'])

    tweets = {
        'tweets': tweets_content,
        'page_meta': {
            "limit": int(count),
            "offset": int(offset),
            "total_count": total_count
        }
    }

    return JsonResponse(tweets)


def get_latest_blog_entries(request, pageToken):
    blogId = '2546008714740235720'
    key = settings.BLOGGER_KEY
    fetchBodies = True
    fetchImages = False
    maxResults = 15
    orderBy = 'published'

    cache_key = str(pageToken)
    cache_time = 1800

    # tries to get entries from cache
    cache_response = cache.get(cache_key)

    if cache_response != None:
        print('blog entries are in cache')
        return JsonResponse(cache_response)

    print('Blog entries not found in cache!')

    # gets blog entries from blogger api
    service = build('blogger', 'v3', developerKey=key)
    response = service.posts().list(blogId=blogId, orderBy=orderBy, pageToken=pageToken,
                                    fetchBodies=fetchBodies, fetchImages=fetchImages, maxResults=maxResults).execute()
    blog_response = service.blogs().get(blogId=blogId).execute()

    total_count = blog_response['posts']['totalItems']
    latest_entries_items = response['items']
    next_page_token = response['nextPageToken']

    blog_entries = []

    for blog_entry in latest_entries_items:
        date = blog_entry['published'].split('T')[0]
        content = blog_entry['content']

        html_comment = re.compile(r'<!--(.*?)-->')
        html = re.compile(r'<[^>]+>')
        url = re.compile(r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?')

        content = content.replace('\n', ' ')
        content = re.sub(html_comment, ' ', content)
        content = re.sub(html, ' ', content)
        content = re.sub(url, ' ', content)
        content = ' '.join(content.split())
        content = content[:100] + (content[100:] and '...')

        blog_entries.append({
            'title': blog_entry['title'],
            'url': blog_entry['url'],
            'author': blog_entry['author']['displayName'],
            'author_url': blog_entry['author']['url'],
            'date': date,
            'content': content

        })

    entries = {
        'entries': blog_entries,
        'nextPageToken': next_page_token,
        'totalCount': total_count
    }
    cache.set(cache_key, entries, cache_time)

    return JsonResponse(entries)


def get_database_summary(request):

    cache_key = 'deposited_datasets'
    cache_time = 604800
    q = {


        "bool": {
            "filter": {
                "term": {
                    "doc_type": "DATASET"
                }
            },
            "must": {
                "range": {
                    "_metadata.related_activities.count": {
                        "gt": 0
                    }
                }
            },
            "must_not": {
                "terms": {
                    "_metadata.source.src_id": [1, 7, 8, 9, 7, 8, 9, 11, 12, 13, 15, 18, 25, 26, 28, 31,
                                                35, 37, 38,
                                                39, 41, 42]
                }
            }
        }

    }

    # tries to get number from cache
    cache_response = cache.get(cache_key)

    if cache_response != None:
        print('datasets are in cache')
        return JsonResponse(cache_response)

    print('datasets are not in cache')

    s = Search(index="chembl_document").query(q)
    response = s.execute()
    response = { 'num_datasets': response.hits.total }
    cache.set(cache_key, response, cache_time)

    return JsonResponse(response)


def get_entities_records(request):

    cache_key = 'entities_records'
    cache_time = 604800
    cache_response = cache.get(cache_key)

    if cache_response != None:
        print('records are in cache')
        return JsonResponse(cache_response)

    print('records are not in cache')

    drugs_query = {

        "term": {
          "_metadata.drug.is_drug": True
        }

    }

    response = {
        'Compounds': Search(index="chembl_molecule").execute().hits.total,
        'Drugs': Search(index="chembl_molecule").query(drugs_query).execute().hits.total,
        'Assays': Search(index="chembl_assay").execute().hits.total,
        'Documents': Search(index="chembl_document").execute().hits.total,
        'Targets': Search(index="chembl_target").execute().hits.total,
        'Cells': Search(index="chembl_cell_line").execute().hits.total,
        'Tissues': Search(index="chembl_tissue").execute().hits.total
    }

    cache.set(cache_key, response, cache_time)

    return JsonResponse(response)


def get_github_details(request):

    last_commit = requests.get('https://api.github.com/repos/chembl/GLaDOS/commits/master').json()

    cache_key = 'github_details'
    cache_time = 1800
    cache_response = cache.get(cache_key)

    now = datetime.datetime.now()
    date = last_commit['commit']['author']['date'][:-1]
    date = datetime.datetime.strptime(date, '%Y-%m-%dT%H:%M:%S')
    time_ago = timeago.format(date, now)

    if cache_response != None:
        print('github details are in cache')
        cache_response['time_ago'] = time_ago
        return JsonResponse(cache_response)

    print('github details are not in cache')

    response = {
        'url': last_commit['html_url'],
        'author': last_commit['commit']['author']['name'],
        'time_ago': time_ago,
        'message': last_commit['commit']['message']
    }

    cache.set(cache_key, response, cache_time)

    return JsonResponse(last_commit)


def replace_urls_from_entinies(html, urls):
    """
    :return: the html with the corresponding links from the entities
    """
    for url in urls:
        link = '<a href="%s">%s</a>' % (url['url'], url['display_url'])
        html = html.replace(url['url'], link)

    return html


def main_page(request):
    context = {
        'main_page': True,
        'hide_breadcrumbs': True
    }
    return render(request, 'glados/main_page.html', context)


def design_components(request):
    context = {
        'hide_breadcrumbs': True
    }
    return render(request, 'glados/base/design_components.html', context)


def main_html_base_no_bar(request):
    return render(request, 'glados/mainGladosNoBar.html')


def render_params_from_hash(request, hash):
    context = {
        'shortened_params': url_shortener.get_original_url(hash)
    }
    return render(request, 'glados/mainGladosNoBar.html', context)


def render_params_from_hash_when_embedded(request, hash):
    context = {
        'shortened_params': url_shortener.get_original_url(hash)
    }
    return render(request, 'glados/Embedding/embed_base.html', context)


def shorten_url(request):
    if request.method == "POST":
        long_url = request.POST.get('long_url', '')
        short_url = url_shortener.shorten_url(long_url)

        print('short_url', short_url)
        resp_data = {
            'hash': short_url
        }
        return JsonResponse(resp_data)

    else:
        return JsonResponse({'error': 'this is only available via POST'})


# noinspection PyBroadException
def elasticsearch_cache(request):
    if request.method == "POST":

        print('elasticsearch_cache')
        index_name = request.POST.get('index_name', '')
        raw_search_data = request.POST.get('search_data', '')
        search_data_digest = hashlib.sha256(raw_search_data.encode('utf-8')).digest()
        base64_search_data_hash = base64.b64encode(search_data_digest).decode('utf-8')
        search_data = json.loads(raw_search_data)

        if not isinstance(search_data, dict):
            search_data = {}

        cache_key = "{}-{}".format(index_name, base64_search_data_hash)
        print('cache_key', cache_key)

        cache_response = None

        try:
            cache_response = cache.get(cache_key)
        except Exception as e:
            print('Error searching in cache!')

        response = None
        if cache_response is not None:
            print('results are in cache')
            response = cache_response
        else:
            print('results are NOT in cache')
            response = connections.get_connection().search(index=index_name, body=search_data)
            try:
                cache_time = 3000000
                cache.set(cache_key, response, cache_time)
            except Exception as e:
                traceback.print_exc()
                print('Error saving in the cache!')

        try:
            es_query = search_data.get('query', None)
            if es_query:
                if isinstance(es_query, dict) and len(es_query) == 1 and \
                        'query_string' in es_query and 'query' in es_query['query_string']:
                    es_query = es_query['query_string']['query'].strip()
                else:
                    es_query = json.dumps(es_query)
            es_aggs = search_data.get('aggs', None)
            if es_aggs:
                es_aggs = json.dumps(es_aggs)
            es_cache_req_data = ESCachedRequest(
                es_index=index_name,
                es_query=es_query,
                es_aggs=es_aggs,
                es_request_digest=base64_search_data_hash,
                is_cached=cache_response is not None
            )
            es_cache_req_data.indexing()
        except:
            traceback.print_exc()
            print('Error saving in elastic!')

        if response is None:
            return HttpResponse('ELASTIC SEARCH RESPONSE IS EMPTY!', status=500)

        return JsonResponse(response)
    else:
        return JsonResponse({'error': 'this is only available via POST! You crazy hacker! :P'})


def extend_url(request, hash):
    resp_data = {
        'long_url': url_shortener.get_original_url(hash)
    }

    return JsonResponse(resp_data)

# ----------------------------------------------------------------------------------------------------------------------
# Report Cards
# ----------------------------------------------------------------------------------------------------------------------
def compound_report_card(request, chembl_id):

    context = {
        'og_tags': og_tags_generator.get_og_tags_for_compound(chembl_id)
    }

    return render(request, 'glados/compoundReportCard.html', context)


def assay_report_card(request, chembl_id):

    context = {
        'og_tags': og_tags_generator.get_og_tags_for_assay(chembl_id)
    }

    return render(request, 'glados/assayReportCard.html', context)


def cell_line_report_card(request, chembl_id):

    context = {
        'og_tags': og_tags_generator.get_og_tags_for_cell_line(chembl_id)
    }

    return render(request, 'glados/cellLineReportCard.html', context)


def tissue_report_card(request, chembl_id):

    context = {
        'og_tags': og_tags_generator.get_og_tags_for_tissue(chembl_id)
    }

    return render(request, 'glados/tissueReportCard.html', context)


def target_report_card(request, chembl_id):

    context = {
        'og_tags': og_tags_generator.get_og_tags_for_target(chembl_id)
    }

    return render(request, 'glados/targetReportCard.html', context)


def document_report_card(request, chembl_id):

    context = {
        'og_tags': {
            'chembl_id': chembl_id
        }
    }

    return render(request, 'glados/documentReportCard.html', context)
