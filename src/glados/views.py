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


# Returns all acknowledgements grouped by current and old
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


def get_latest_tweets(page_number = 1, count = 15):
  """
  Returns the latest tweets from chembl, It tries to find them in the cache first to avoid hammering twitter
  :return: The structure returned by the twitter api. If there is an error getting the tweets, it returns an
  empty list.
  """
  if not settings.TWITTER_ENABLED:
    return []
  cache_key = str(page_number) + "-" + str(count)
  cache_time = 3600  # time to live in seconds

  tweets = cache.get(cache_key)

  # If they are found in the cache, just return them
  if tweets:
    print('Using cached tweets!')
    return tweets

  print('tweets not found in cache!')
  access_token = ''
  access_token_secret = ''
  consumer_key = ''
  consumer_secret = ''

  try:

    access_token = settings.TWITTER_ACCESS_TOKEN
    access_token_secret = settings.TWITTER_ACCESS_TOKEN_SECRET
    consumer_key = settings.TWITTER_CONSUMER_KEY
    consumer_secret = settings.TWITTER_CONSUMER_SECRET

  except AttributeError as e:
    print_server_error(e)
    return []

  t = Twitter(auth=OAuth(access_token, access_token_secret, consumer_key, consumer_secret))

  try:
    tweets = t.statuses.user_timeline(screen_name="chembl", count=count, page=page_number)
    users = t.users.lookup(screen_name="chembl")
    user_data = users[0]
  except Exception as e:
    print_server_error(e)
    return []

  cache.set(cache_key, tweets, cache_time)
  return [tweets, user_data]


def get_latest_tweets_json(request):
    count = request.GET.get('limit', '')
    offset = request.GET.get('offset', '')
    page_number = str((int(offset) / int(count)) + 1)
    tweets_data = get_latest_tweets(page_number, count)
    tweets = tweets_data[0]
    user_data = tweets_data[1]
    total_count = user_data['statuses_count']

    tweets = {
        'tweets': tweets,
        'page_meta': {
            "limit": int(count),
            # this may be useful if we need to download the tweets
            # "next": ,
            "offset": int(offset),
            # "previous": null,
            "total_count": total_count
        }
    }

    return JsonResponse(tweets)

def replace_urls_from_entinies(html, urls):
  """
  :return: the html with the corresponding links from the entities
  """
  for url in urls:
    link = '<a href="%s">%s</a>' % (url['url'], url['display_url'])
    html = html.replace(url['url'], link)

  return html


def main_page(request):
  tweets = get_latest_tweets()[0]
  simplified_tweets = []

  for t in tweets:

    html = t['text']

    for entity_type in t['entities']:

      entities = t['entities'][entity_type]

      if entity_type == 'urls':
        html = replace_urls_from_entinies(html, entities)

    simp_tweet = {
      'id': t['id'],
      'text': html,
      'created_at': '-'.join(t['created_at'].split(' ')[2:0:-1]),

      'user': {
        'name': t['user']['name'],
        'screen_name': t['user']['screen_name'],
        'profile_image_url': t['user']['profile_image_url']
      }

    }

    simplified_tweets.append(simp_tweet)

  context = {'tweets': simplified_tweets}

  return render(request, 'glados/mainPage.html', context)


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
      {'title': 'SQL Data', 'icon': 'fa-database', 'description': 'Download our sql data.', 'link': 'select_db_engine',
       'type': 'icon', 'is_default': 'yes'},
      {'title': 'Virtual Environments', 'icon': 'fa-cubes', 'description': 'ChEMBL Virtual Machines.',
       'link': 'select_db_engine', 'type': 'icon', 'is_default': 'no'},
      {'title': 'RDF', 'description': 'Download the ChEMBL-RDF.', 'link': 'select_db_engine', 'data_icon': 'R',
       'type': 'ebi-icon', 'is_default': 'no'},
      {'title': 'UniChem', 'icon': None, 'data_icon': 'U',
       'description': 'Data dumps from UniChem.', 'link': 'select_db_engine', 'type': 'ebi-icon', 'is_default': 'no'},
      {'title': 'Patents', 'icon': 'fa-book', 'description': 'Patent compound exports.', 'link': 'select_db_engine',
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
      {'title': 'PostgreSQL', 'icon': None, 'image': settings.STATIC_URL+'img/logo_postgresql.png', 'description': '', 'link': '',
       'type': 'image', 'is_default': 'yes'},
      {'title': 'Oracle', 'icon': None, 'image': settings.STATIC_URL+'img/logo_oracle.png', 'description': '',
       'link': 'select_oracle_version', 'type': 'image', 'is_default': 'no'},
      {'title': 'MySQL', 'icon': None, 'image': settings.STATIC_URL+'img/logo_mysql.png', 'description': '', 'link': '',
       'type': 'image', 'is_default': 'no'},
      {'title': 'SQLite', 'icon': None, 'image': settings.STATIC_URL+'img/logo_sqlite.gif', 'description': '', 'link': '',
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
