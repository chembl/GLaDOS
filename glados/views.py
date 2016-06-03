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
    'old_acks' : [ack for ack in ack_list if ack.is_current != 1]
  }
  return render(request, 'glados/acknowledgements.html', context)

# returns all Faqs grouped by category and subcategory
def faqs(request):

  #faqs_list = Faq.objects.all();
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
      faqs_in_this_subcategory ['subcategory'] = subcat
      faqs_in_this_subcategory ['items'] = []
      faqs_in_this_category['items'].append(faqs_in_this_subcategory)

      questions_by_subcategory = Faq.objects.filter(category=cat, subcategory=subcat)

      for q in questions_by_subcategory:
        faqs_in_this_subcategory ['items'].append(q)

  context = {'faqs_structure': faqs_structure}


  return render(request, 'glados/faqs.html', context)

def get_latest_tweets():
  """
  Returns the latest tweets from chembl, It tries to find them in the cache first to avoid hammering twitter
  :return: The structure returned by the twitter api. If there is an error getting the tweets, it returns an
  empty list.
  """
  cache_key = 'latest_tweets'
  cache_time = 3600 # time to live in seconds

  tweets = cache.get(cache_key)

  # If they are found in the cache, just return them
  if tweets:
    print('Using cached tweets!')
    return tweets

  print('tweets not found in cache!')
  access_token =''
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

  t = Twitter( auth=OAuth(access_token, access_token_secret, consumer_key, consumer_secret))


  try:
    tweets = t.statuses.user_timeline(screen_name="chembl", count=2)
  except Exception as e:
    print_server_error(e)
    return []

  cache.set(cache_key, tweets, cache_time)
  return tweets

def replace_urls_from_entinies(html, urls):
  """
  :return: the html with the corresponding links from the entities
  """
  for url in urls:
    link = '<a href="%s">%s</a>' % (url['url'], url['display_url'])
    html = html.replace(url['url'], link)

  return html

def main_page(request):

  tweets = get_latest_tweets()
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

def wizard_first_step_json(request):
  """
  :param request: http request
  :return: A json response with the information of the first wizard step
  """

  data = {
  
    'title': 'Downloads',
    'options': [
        {'title':'SQL Data', 'icon':'fa-database', 'description': 'Download our sql data.'},
        {'title':'Virtual Environments', 'icon':'fa-cubes', 'description': 'ChEMBL Virtual Machines.'},
        {'title':'RDF', 'icon':'fa-sitemap', 'description': 'Download the ChEMBL-RDF.'},
        {'title':'UniChem', 'icon':'fa-smile-o', 'description': 'Data dumps from UniChem.'},
        {'title':'Patents', 'icon':'fa-book', 'description': 'Patent compound exports.'},
        {'title':'Monomers', 'icon':'fa-smile-o', 'description': 'Monomers.'},
        {'title':'Monomers', 'icon':'fa-smile-o', 'description': 'Monomers.'},
      ],
      'right_option': 'More...'
  }

  return JsonResponse(data)