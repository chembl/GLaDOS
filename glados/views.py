from .models import Acknowledgement
from .models import Faq
from .models import FaqCategory
from .models import FaqSubcategory
from django.shortcuts import render
from twitter import *

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

  print ('getting tweets!!!')

  token='732582863107981312-dZ8OEZZdNCsltXtN2pTp3xShPMYHxkE'
  token_key = 'NeyIr4Qol3iOYUMhXQlYbrY7MTpZAjYTiXa2aMjjxPFPP'

  consumer_key='Icu63OEakLyDasHfykeVnABPkaFNnw3xYEiEf85VUGlbFCBWvE'

  consumer_secret='du50tzw6Ixrk6skymWntOZXCS'

  t = Twitter( auth=OAuth(token, token_key, consumer_secret, consumer_key))

  tweets = t.statuses.user_timeline(screen_name="chembl", count=2)
  return tweets

def main_page(request):

  tweets = get_latest_tweets()

  simplified_tweets = []

  print(tweets[0])
  print('^^^')

  for t in tweets:
    print ('---')
    print("t['text']")
    print(t['text'])
    print("t['entities']")
    print(t['entities'])
    print("t['created_at']")
    print(t['created_at'])
    print("t['user']['profile_image_url']")
    print(t['user']['profile_image_url'])
    print("t['user']['screen_name']")
    print(t['user']['screen_name'])
    print("t['user']['name']")
    print(t['user']['name'])

    simp_tweet = {
      'text': 'hola',
      'created_at': 'date'
    }

  return render(request, 'glados/mainPage.html')