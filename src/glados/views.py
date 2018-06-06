from .models import Acknowledgement
from .models import Faq
from .models import FaqCategory
from .models import FaqSubcategory
from django.shortcuts import render
from twitter import *
from django.conf import settings
from glados.utils import *
from django.core.cache import cache
from django.http import JsonResponse
import glados.url_shortener.url_shortener as url_shortener
from apiclient.discovery import build
from googleapiclient import *
import re
from elasticsearch_dsl import Search
import requests
import datetime
import timeago




# Returns all acknowledgements grouped by current and old
def visualise(request):
    context = {
        'hide_breadcrumbs': True
    }

    return render(request, 'glados/visualise.html', context)

def acks(request):
    ack_list = Acknowledgement.objects.order_by('id')
    context = {
        'current_acks': [ack for ack in ack_list if ack.is_current == 1],
        'old_acks': [ack for ack in ack_list if ack.is_current != 1]
    }
    return render(request, 'glados/acknowledgements.html', context)


# returns all Faqs grouped by category and subcategory
def faqs(request):
    # faqs_list = Faq.objects.all();
    # the categories are ordered by the position theu should have in the page
    categories = FaqCategory.objects.all();
    subcategories = FaqSubcategory.objects.all();

    faqs_structure = []

    for cat in categories:

        faqs_in_this_category = {}
        faqs_in_this_category['category'] = cat
        faqs_in_this_category['items'] = []
        faqs_structure.append(faqs_in_this_category)

        for subcat in subcategories:

            faqs_in_this_subcategory = {}
            faqs_in_this_subcategory['subcategory'] = subcat
            faqs_in_this_subcategory['items'] = []
            faqs_in_this_category['items'].append(faqs_in_this_subcategory)

            questions_by_subcategory = Faq.objects.filter(category=cat, subcategory=subcat)

            for q in questions_by_subcategory:
                faqs_in_this_subcategory['items'].append(q)

    context = {'faqs_structure': faqs_structure}

    return render(request, 'glados/faqs.html', context)


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
    cache_time = 3600  # time to live in seconds

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
    cache_time = 3600

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
    blogResponse = service.blogs().get(blogId=blogId).execute()

    total_count = blogResponse['posts']['totalItems']
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

    status_r = requests.get('https://www.ebi.ac.uk/chembl/api/data/status.json').json()
    drug_r = requests.get('https://www.ebi.ac.uk/chembl/api/data/drug.json').json()
    assays_r = requests.get('https://www.ebi.ac.uk/chembl/api/data/assay.json').json()
    cells_r = requests.get('https://www.ebi.ac.uk/chembl/api/data/cell_line.json').json()
    tissues_r = requests.get('https://www.ebi.ac.uk/chembl/api/data/tissue.json').json()

    response = {
        'Compounds': status_r['disinct_compounds'],
        'Drugs': drug_r['page_meta']['total_count'],
        'Assays': assays_r['page_meta']['total_count'],
        'Documents': status_r['publications'],
        'Targets': status_r['targets'],
        'Cells': cells_r['page_meta']['total_count'],
        'Tissues': tissues_r['page_meta']['total_count']
    }

    cache.set(cache_key, response, cache_time)

    return JsonResponse(response)

def get_github_details(request):

    last_commit = requests.get('https://api.github.com/repos/chembl/GLaDOS/commits/master').json()

    cache_key = 'github_details'
    cache_time = 7200
    cache_response = cache.get(cache_key)

    now = datetime.datetime.now()
    date = last_commit['commit']['author']['date'][:-1]
    date = datetime.datetime.strptime(date, '%Y-%m-%dT%H:%M:%S')
    time_ago = timeago.format(date, now)

    if cache_response != None:
        print('github details are in cache')
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



def main_html_base(request):
    return render(request, 'glados/mainGlados.html')


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


def extend_url(request, hash):
    resp_data = {
        'long_url': url_shortener.get_original_url(hash)
    }

    return JsonResponse(resp_data)

# ----------------------------------------------------------------------------------------------------------------------
# Report Cards
# ----------------------------------------------------------------------------------------------------------------------

def compound_report_card(request, chembl_id):

    cache_key = chembl_id + '_compound_report_card'
    cache_time = 604800
    cache_context = cache.get(cache_key)

    if cache_context != None:
        print('og tags for ' + chembl_id + ' are in cache')
        return render(request, 'glados/compoundReportCard.html', cache_context)

    print('og tags for ' + chembl_id + ' are not in cache')

    s = 'pref_name'
    q = {
        "term": {
          "_id": {
            "value": chembl_id
          }
        }
    }
    response = Search(index="chembl_molecule").query(q).source(s).execute()

    name = response['hits']['hits'][0]['_source']['pref_name']

    context = {
        'og_tags': {
            'chembl_id': chembl_id,
            'name': name
        }
    }

    cache.set(cache_key, context, cache_time)

    return render(request, 'glados/compoundReportCard.html', context)

def assay_report_card(request, chembl_id):

    cache_key = chembl_id + '_assay_report_card'
    cache_time = 604800
    cache_context = cache.get(cache_key)

    if cache_context != None:
        print('og tags for ' + chembl_id + ' are in cache')
        return render(request, 'glados/assayReportCard.html', cache_context)

    print('og tags for ' + chembl_id + ' are not in cache')

    s = 'description'
    q = {
        "term": {
          "_id": {
            "value": chembl_id
          }
        }
    }
    response = Search(index="chembl_assay").query(q).source(s).execute()

    description = response['hits']['hits'][0]['_source']['description']

    context = {
        'og_tags': {
            'chembl_id': chembl_id,
            'description': description
        }
    }

    cache.set(cache_key, context, cache_time)

    return render(request, 'glados/assayReportCard.html', context)




def wizard_step_json(request, step_id):
    """
    :param request: http request
    :return: A json response with the information of the first wizard step
    """

    lorem_ipsum = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vitae nulla sed nibh rutrum porta. ' \
                  'In ultricies scelerisque lacinia. Nulla vulputate consectetur tempor. Morbi odio enim, faucibus ' \
                  'eget tristique sit amet, tempus sed risus. Ut in libero sit amet arcu egestas fringilla id id ' \
                  'ligula. Proin posuere sem a tempus volutpat. Quisque varius mauris in nisi condimentum efficitur. ' \
                  'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed ' \
                  'accumsan, neque in mattis placerat, ligula velit rutrum velit, non porta massa neque eu lectus. ' \
                  'Duis dictum malesuada eros eget dignissim. Quisque ultricies dolor felis, id scelerisque justo ' \
                  'congue ut. Donec venenatis suscipit nulla in aliquam. Sed sit amet nisl et orci pellentesque ' \
                  'suscipit sed feugiat eros. Donec ullamcorper magna ut justo egestas, vitae tristique velit ' \
                  'convallis. Ut viverra eleifend felis, quis elementum lacus fringilla a. Integer at elit elit. ' \
                  'Nullam commodo vitae orci eget sollicitudin. Fusce semper volutpat est, ut bibendum lorem ultrices ' \
                  'sed. Ut molestie risus pellentesque, vulputate tortor eget, fermentum neque. Sed quis viverra sem. ' \
                  'Cras cursus laoreet lorem eu rutrum. Donec eros mauris, tincidunt ac maximus sed, venenatis vitae ' \
                  'dui. Aliquam quis elit tempor, blandit quam sed, rutrum sapien. Phasellus mattis ligula sit amet ' \
                  'lacinia vulputate. Integer sapien libero, varius eget pharetra ut, viverra a massa. Fusce gravida ' \
                  'sodales tellus sed malesuada. In in commodo lorem, posuere venenatis lorem. Fusce eu iaculis enim. ' \
                  'Curabitur enim eros, rutrum id neque in, feugiat iaculis risus. Curabitur in elementum risus. ' \
                  'Fusce eu venenatis diam, vitae convallis est. Phasellus in tellus vel augue imperdiet rhoncus vitae ' \
                  'a odio. Fusce lorem enim, gravida vitae sollicitudin eget, faucibus eget felis. Sed vel orci quam. ' \
                  'Donec ac placerat est, quis tincidunt diam. Fusce suscipit ante neque, consectetur sollicitudin ' \
                  'enim hendrerit quis. Sed eu hendrerit nisi. Cum sociis natoque penatibus et magnis dis parturient ' \
                  'montes, nascetur ridiculus mus. Pellentesque tellus ipsum, congue ut congue non, convallis at ' \
                  'neque. Curabitur vel vestibulum tellus. Integer auctor ipsum vel magna molestie accumsan. Vivamus ' \
                  'vitae sapien eu arcu congue elementum in vel turpis. In sollicitudin ex sodales enim lobortis, eu ' \
                  'vulputate est tempor. Aenean lectus quam, vestibulum at maximus ut, interdum et odio.'

    data = {

        'title': 'Downloads',
        'options': [
            {'title': 'SQL Data', 'icon': 'fa-database', 'description': 'Download our sql data.',
             'link': 'select_db_engine',
             'type': 'icon', 'is_default': 'yes'},
            {'title': 'Virtual Environments', 'icon': 'fa-cubes', 'description': 'ChEMBL Virtual Machines.',
             'link': 'select_db_engine', 'type': 'icon', 'is_default': 'no'},
            {'title': 'RDF', 'description': 'Download the ChEMBL-RDF.', 'link': 'select_db_engine', 'data_icon': 'R',
             'type': 'ebi-icon', 'is_default': 'no'},
            {'title': 'UniChem', 'icon': None, 'data_icon': 'U',
             'description': 'Data dumps from UniChem.', 'link': 'select_db_engine', 'type': 'ebi-icon',
             'is_default': 'no'},
            {'title': 'Patents', 'icon': 'fa-book', 'description': 'Patent compound exports.',
             'link': 'select_db_engine',
             'type': 'ebi-icon', 'is_default': 'no', 'data_icon': 'p'},
            {'title': 'Monomers', 'description': 'Monomers.', 'link': 'select_db_engine', 'data_icon': 'M',
             'type': 'ebi-icon', 'is_default': 'no'},
        ],
        'right_option': {'title': 'More...', 'link': '#', 'type': 'bottom'},
        'left_option': None,
        'previous_step': None,
        'identifier': 'first',
        'type': 'normal'
    }

    data2 = {

        'title': 'Select a Database Engine',
        'options': [
            {'title': 'PostgreSQL', 'icon': None, 'image': settings.STATIC_URL + 'img/logo_postgresql.png',
             'description': '', 'link': '',
             'type': 'image', 'is_default': 'yes'},
            {'title': 'Oracle', 'icon': None, 'image': settings.STATIC_URL + 'img/logo_oracle.png', 'description': '',
             'link': 'select_oracle_version', 'type': 'image', 'is_default': 'no'},
            {'title': 'MySQL', 'icon': None, 'image': settings.STATIC_URL + 'img/logo_mysql.png', 'description': '',
             'link': '',
             'type': 'image', 'is_default': 'no'},
            {'title': 'SQLite', 'icon': None, 'image': settings.STATIC_URL + 'img/logo_sqlite.gif', 'description': '',
             'link': '',
             'type': 'image', 'is_default': 'no'},
        ],
        'right_option': {'title': 'Browse FTP', 'link': 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/', 'type': 'bottom'},
        'left_option': None,
        'previous_step': 'first',
        'identifier': 'select_db_engine',
        'type': 'normal'

    }

    data3 = {

        'title': 'Select Oracle Version',
        'options': [
            {'title': '11g', 'icon': None, 'description': '', 'link': 'oracle_lic_agreement', 'type': 'text',
             'is_default': 'yes'},
            {'title': '10g', 'icon': None, 'description': '', 'link': 'oracle_lic_agreement', 'type': 'text',
             'is_default': 'no'},
            {'title': '9g', 'icon': None, 'description': '', 'link': 'oracle_lic_agreement', 'type': 'text',
             'is_default': 'no'},
        ],
        'right_option': {'title': 'Browse FTP', 'link': 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/', 'type': 'bottom'},
        'left_option': None,
        'previous_step': 'select_db_engine',
        'identifier': 'select_oracle_version',
        'type': 'normal'

    }

    data4 = {

        'title': 'License Agreement',
        'right_option': None,
        'license': lorem_ipsum,
        'left_option': None,
        'previous_step': 'select_oracle_version',
        'identifier': 'oracle_lic_agreement',
        'type': 'lic_agreement'

    }

    if step_id == 'first':
        return JsonResponse(data)
    elif step_id == 'select_db_engine':
        return JsonResponse(data2)
    elif step_id == 'select_oracle_version':
        return JsonResponse(data3)
    else:
        return JsonResponse(data4)
