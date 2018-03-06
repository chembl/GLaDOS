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
from django.views.decorators.csrf import csrf_exempt
import glados.url_shortener.url_shortener
import json


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
    print('Using cached tweets!')
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
  return render(request, 'glados/mainPage.html')

def main_html_base(request):

  return render(request, 'glados/mainGlados.html')

def main_html_base_no_bar(request):

  return render(request, 'glados/mainGladosNoBar.html')

def render_params_from_hash(request, hash):

  url = '#browse/activities/filter/molecule_chembl_id%3A(%22CHEMBL59%22%20OR%20%22CHEMBL1557%22%20OR%20%22CHEMBL531%22%20OR%20%22CHEMBL301265%22%20OR%20%22CHEMBL1201087%22%20OR%20%22CHEMBL589%22%20OR%20%22CHEMBL1303%22%20OR%20%22CHEMBL1371770%22%20OR%20%22CHEMBL1009%22%20OR%20%22CHEMBL493%22%20OR%20%22CHEMBL718%22%20OR%20%22CHEMBL588%22%20OR%20%22CHEMBL1200748%22%20OR%20%22CHEMBL53%22%20OR%20%22CHEMBL1201236%22%20OR%20%22CHEMBL2103827%22%20OR%20%22CHEMBL459%22%20OR%20%22CHEMBL273575%22%20OR%20%22CHEMBL1256842%22%20OR%20%22CHEMBL3039565%22%20OR%20%22CHEMBL1201728%22%20OR%20%22CHEMBL1201066%22%20OR%20%22CHEMBL1118%22%20OR%20%22CHEMBL637%22%20OR%20%22CHEMBL708%22%20OR%20%22CHEMBL1200997%22%20OR%20%22CHEMBL1615372%22%20OR%20%22CHEMBL1237021%22%20OR%20%22CHEMBL1712%22%20OR%20%22CHEMBL1201342%22%20OR%20%22CHEMBL6437%22%20OR%20%22CHEMBL3187365%22%20OR%20%22CHEMBL54%22%20OR%20%22CHEMBL328190%22%20OR%20%22CHEMBL848%22%20OR%20%22CHEMBL516%22%20OR%20%22CHEMBL887%22%20OR%20%22CHEMBL781%22%20OR%20%22CHEMBL395110%22%20OR%20%22CHEMBL567%22%20OR%20%22CHEMBL42%22%20OR%20%22CHEMBL760%22%20OR%20%22CHEMBL1112%22%20OR%20%22CHEMBL1729%22%20OR%20%22CHEMBL1378%22%20OR%20%22CHEMBL304902%22%20OR%20%22CHEMBL1201328%22%20OR%20%22CHEMBL716%22%20OR%20%22CHEMBL278398%22%20OR%20%22CHEMBL728%22%20OR%20%22CHEMBL715%22%20OR%20%22CHEMBL87708%22%20OR%20%22CHEMBL422%22%20OR%20%22CHEMBL2105760%22%20OR%20%22CHEMBL726%22%20OR%20%22CHEMBL2106915%22%20OR%20%22CHEMBL15023%22%20OR%20%22CHEMBL1085%22%20OR%20%22CHEMBL946%22%20OR%20%22CHEMBL833%22%20OR%20%22CHEMBL1909072%22%20OR%20%22CHEMBL49%22%20OR%20%22CHEMBL1697766%22%20OR%20%22CHEMBL621%22%20OR%20%22CHEMBL251940%22%20OR%20%22CHEMBL1201747%22%20OR%20%22CHEMBL1200959%22%20OR%20%22CHEMBL623%22%20OR%20%22CHEMBL415%22%20OR%20%22CHEMBL11%22%20OR%20%22CHEMBL831%22%20OR%20%22CHEMBL72%22%20OR%20%22CHEMBL1697851%22%20OR%20%22CHEMBL462605%22%20OR%20%22CHEMBL468%22%20OR%20%22CHEMBL28218%22%20OR%20%22CHEMBL46399%22%20OR%20%22CHEMBL71%22%20OR%20%22CHEMBL654%22%20OR%20%22CHEMBL534%22%20OR%20%22CHEMBL1201216%22%20OR%20%22CHEMBL2107011%22%20OR%20%22CHEMBL3275586%22%20OR%20%22CHEMBL465026%22%20OR%20%22CHEMBL1106%22%20OR%20%22CHEMBL592%22%20OR%20%22CHEMBL43452%22%20OR%20%22CHEMBL1614644%22%20OR%20%22CHEMBL439849%22%20OR%20%22CHEMBL1200986%22%20OR%20%22CHEMBL1201758%22%20OR%20%22CHEMBL1492%22%20OR%20%22CHEMBL1584%22%20OR%20%22CHEMBL1615350%22%20OR%20%22CHEMBL1625607%22%20OR%20%22CHEMBL896%22%20OR%20%22CHEMBL841%22%20OR%20%22CHEMBL52440%22%20OR%20%22CHEMBL376359%22%20OR%20%22CHEMBL1113%22%20OR%20%22CHEMBL549%22%20OR%20%22CHEMBL1508%22%20OR%20%22CHEMBL2105458%22%20OR%20%22CHEMBL1626%22%20OR%20%22CHEMBL1078261%22%20OR%20%22CHEMBL46516%22%20OR%20%22CHEMBL2028019%22%20OR%20%22CHEMBL1198%22%20OR%20%22CHEMBL1000%22%20OR%20%22CHEMBL303933%22%20OR%20%22CHEMBL570%22%20OR%20%22CHEMBL1172%22%20OR%20%22CHEMBL1200714%22%20OR%20%22CHEMBL1200854%22%20OR%20%22CHEMBL797%22%20OR%20%22CHEMBL471737%22%20OR%20%22CHEMBL297302%22%20OR%20%22CHEMBL1201191%22%20OR%20%22CHEMBL117287%22%20OR%20%22CHEMBL19019%22%20OR%20%22CHEMBL1108%22%20OR%20%22CHEMBL564%22%20OR%20%22CHEMBL1200951%22%20OR%20%22CHEMBL86304%22%20OR%20%22CHEMBL157138%22%20OR%20%22CHEMBL231068%22%20OR%20%22CHEMBL92870%22%20OR%20%22CHEMBL360328%22%20OR%20%22CHEMBL1266%22%20OR%20%22CHEMBL203266%22%20OR%20%22CHEMBL1295%22%20OR%20%22CHEMBL479%22%20OR%20%22CHEMBL12713%22%20OR%20%22CHEMBL314437%22%20OR%20%22CHEMBL1623%22%20OR%20%22CHEMBL30008%22%20OR%20%22CHEMBL1189679%22%20OR%20%22CHEMBL1201203%22%20OR%20%22CHEMBL502%22%20OR%20%22CHEMBL1254682%22%20OR%20%22CHEMBL1201%22%20OR%20%22CHEMBL864%22%20OR%20%22CHEMBL277474%22%20OR%20%22CHEMBL3707371%22%20OR%20%22CHEMBL1088%22%20OR%20%22CHEMBL117785%22%20OR%20%22CHEMBL1423%22%20OR%20%22CHEMBL1201217%22%20OR%20%22CHEMBL1201347%22%20OR%20%22CHEMBL445%22%20OR%20%22CHEMBL629%22%20OR%20%22CHEMBL982%22%20OR%20%22CHEMBL809%22%20OR%20%22CHEMBL325109%22%20OR%20%22CHEMBL1457%22%20OR%20%22CHEMBL1201349%22%20OR%20%22CHEMBL1201271%22%20OR%20%22CHEMBL648%22%20OR%20%22CHEMBL594%22%20OR%20%22CHEMBL15245%22%20OR%20%22CHEMBL668%22%20OR%20%22CHEMBL1201356%22%20OR%20%22CHEMBL656%22%20OR%20%22CHEMBL28333%22%20OR%20%22CHEMBL2111030%22%20OR%20%22CHEMBL1754%22%20OR%20%22CHEMBL524004%22%20OR%20%22CHEMBL193482%22%20OR%20%22CHEMBL691%22%20OR%20%22CHEMBL1442422%22%20OR%20%22CHEMBL1200973%22%20OR%20%22CHEMBL70418%22%20OR%20%22CHEMBL14376%22%20OR%20%22CHEMBL21731%22%20OR%20%22CHEMBL22108%22%20OR%20%22CHEMBL288470%22%20OR%20%22CHEMBL398707%22%20OR%20%22CHEMBL963%22%20OR%20%22CHEMBL70%22%20OR%20%22CHEMBL296419%22%20OR%20%22CHEMBL315985%22%20OR%20%22CHEMBL3707301%22%20OR%20%22CHEMBL9967%22%20OR%20%22CHEMBL279516%22%20OR%20%22CHEMBL1734%22%20OR%20%22CHEMBL15891%22%20OR%20%22CHEMBL219916%22%20OR%20%22CHEMBL46469%22%20OR%20%22CHEMBL135%22%20OR%20%22CHEMBL1908311%22%20OR%20%22CHEMBL1201250%22%20OR%20%22CHEMBL1450%22%20OR%20%22CHEMBL2111135%22%20OR%20%22CHEMBL2105581%22%20OR%20%22CHEMBL1201208%22%20OR%20%22CHEMBL1186579%22%20OR%20%22CHEMBL976%22%20OR%20%22CHEMBL85%22%20OR%20%22CHEMBL1742423%22%20OR%20%22CHEMBL24924%22%20OR%20%22CHEMBL3%22%20OR%20%22CHEMBL1201245%22%20OR%20%22CHEMBL77622%22%20OR%20%22CHEMBL33986%22%20OR%20%22CHEMBL19215%22%20OR%20%22CHEMBL1744%22%20OR%20%22CHEMBL596%22%20OR%20%22CHEMBL1101%22%20OR%20%22CHEMBL2110569%22%20OR%20%22CHEMBL908%22%20OR%20%22CHEMBL13828%22%20OR%20%22CHEMBL1738797%22%20OR%20%22CHEMBL485%22%20OR%20%22CHEMBL659%22%20OR%20%22CHEMBL242338%22%20OR%20%22CHEMBL43064%22%20OR%20%22CHEMBL1324%22%20OR%20%22CHEMBL1201151%22%20OR%20%22CHEMBL936%22%20OR%20%22CHEMBL1275%22%20OR%20%22CHEMBL765%22%20OR%20%22CHEMBL418995%22%20OR%20%22CHEMBL657%22%20OR%20%22CHEMBL51%22%20OR%20%22CHEMBL1405%22%20OR%20%22CHEMBL1138%22%20OR%20%22CHEMBL46740%22%20OR%20%22CHEMBL1263%22%20OR%20%22CHEMBL1068%22%20OR%20%22CHEMBL953%22%20OR%20%22CHEMBL1595%22%20OR%20%22CHEMBL285802%22%20OR%20%22CHEMBL511142%22%20OR%20%22CHEMBL364713%22%20OR%20%22CHEMBL87992%22%20OR%20%22CHEMBL2104445%22%20OR%20%22CHEMBL1026%22%20OR%20%22CHEMBL119443%22%20OR%20%22CHEMBL86%22%20OR%20%22CHEMBL22242%22%20OR%20%22CHEMBL1075%22%20OR%20%22CHEMBL1160160%22%20OR%20%22CHEMBL849%22%20OR%20%22CHEMBL1183717%22%20OR%20%22CHEMBL779%22%20OR%20%22CHEMBL17157%22%20OR%20%22CHEMBL1511%22%20OR%20%22CHEMBL253376%22%20OR%20%22CHEMBL1065%22%20OR%20%22CHEMBL169901%22%20OR%20%22CHEMBL81%22%20OR%20%22CHEMBL3707367%22%20OR%20%22CHEMBL1024%22%20OR%20%22CHEMBL1404%22%20OR%20%22CHEMBL1619528%22%20OR%20%22CHEMBL1097630%22%20OR%20%22CHEMBL35228%22%20OR%20%22CHEMBL1743263%22%20OR%20%22CHEMBL1201165%22%20OR%20%22CHEMBL496%22%20OR%20%22CHEMBL1425%22%20OR%20%22CHEMBL451%22%20OR%20%22CHEMBL3184437%22%20OR%20%22CHEMBL18442%22%20OR%20%22CHEMBL1198857%22%20OR%20%22CHEMBL644%22%20OR%20%22CHEMBL86882%22%20OR%20%22CHEMBL1492500%22%20OR%20%22CHEMBL673%22%20OR%20%22CHEMBL1670%22%20OR%20%22CHEMBL660%22%20OR%20%22CHEMBL658%22%20OR%20%22CHEMBL119423%22%20OR%20%22CHEMBL1480%22%20OR%20%22CHEMBL243712%22%20OR%20%22CHEMBL80%22%20OR%20%22CHEMBL679%22%20OR%20%22CHEMBL969%22%20OR%20%22CHEMBL26%22%20OR%20%22CHEMBL2105224%22%20OR%20%22CHEMBL306700%22%20OR%20%22CHEMBL396778%22%20OR%20%22CHEMBL290106%22%20OR%20%22CHEMBL1200515%22%20OR%20%22CHEMBL1201212%22%20OR%20%22CHEMBL2111112%22%20OR%20%22CHEMBL1278%22%20OR%20%22CHEMBL998%22%20OR%20%22CHEMBL1628227%22%20OR%20%22CHEMBL288441%22%20OR%20%22CHEMBL2105395%22%20OR%20%22CHEMBL640%22%20OR%20%22CHEMBL972%22%20OR%20%22CHEMBL1437%22%20OR%20%22CHEMBL524%22%20OR%20%22CHEMBL1201319%22%20OR%20%22CHEMBL1909286%22%20OR%20%22CHEMBL639%22%20OR%20%22CHEMBL1561%22%20OR%20%22CHEMBL1200370%22%20OR%20%22CHEMBL1200370%22%20OR%20%22CHEMBL370805%22%20OR%20%22CHEMBL1561%22%20OR%20%22CHEMBL895%22%20OR%20%22CHEMBL1271%22%20OR%20%22CHEMBL799%22%20OR%20%22CHEMBL807%22%20OR%20%22CHEMBL412873%22%20OR%20%22CHEMBL188952%22%20OR%20%22CHEMBL697%22%20OR%20%22CHEMBL814%22%20OR%20%22CHEMBL254857%22%20OR%20%22CHEMBL1201251%22%20OR%20%22CHEMBL1201234%22%20OR%20%22CHEMBL926%22%20OR%20%22CHEMBL473%22%20OR%20%22CHEMBL1206%22%20OR%20%22CHEMBL461522%22%20OR%20%22CHEMBL583%22%20OR%20%22CHEMBL107%22%20OR%20%22CHEMBL1510%22%20OR%20%22CHEMBL24778%22%20OR%20%22CHEMBL94454%22%20OR%20%22CHEMBL2107004%22%20OR%20%22CHEMBL1237044%22%20OR%20%22CHEMBL126224%22%20OR%20%22CHEMBL2111101%22%20OR%20%22CHEMBL223228%22%20OR%20%22CHEMBL505%22%20OR%20%22CHEMBL711%22%20OR%20%22CHEMBL1350%22%20OR%20%22CHEMBL1493%22%20OR%20%22CHEMBL914%22%20OR%20%22CHEMBL1201353%22%20OR%20%22CHEMBL1201269%22%20OR%20%22CHEMBL264374%22%20OR%20%22CHEMBL1256391%22%20OR%20%22CHEMBL305187%22%20OR%20%22CHEMBL346977%22%20OR%20%22CHEMBL1764%22%20OR%20%22CHEMBL83%22%20OR%20%22CHEMBL1697737%22%20OR%20%22CHEMBL311498%22%20OR%20%22CHEMBL22097%22%20OR%20%22CHEMBL723%22%20OR%20%22CHEMBL465%22%20OR%20%22CHEMBL1290%22%20OR%20%22CHEMBL1738%22%20OR%20%22CHEMBL444186%22%20OR%20%22CHEMBL3833412%22%20OR%20%22CHEMBL1029%22%20OR%20%22CHEMBL434394%22%20OR%20%22CHEMBL53418%22%20OR%20%22CHEMBL3833382%22%20OR%20%22CHEMBL1346%22%20OR%20%22CHEMBL267648%22%20OR%20%22CHEMBL750%22%20OR%20%22CHEMBL505851%22%20OR%20%22CHEMBL1685%22%20OR%20%22CHEMBL460%22%20OR%20%22CHEMBL463%22%20OR%20%22CHEMBL855%22%20OR%20%22CHEMBL1681%22%20OR%20%22CHEMBL2104993%22%20OR%20%22CHEMBL315838%22%20OR%20%22CHEMBL443605%22%20OR%20%22CHEMBL1086%22%20OR%20%22CHEMBL707%22%20OR%20%22CHEMBL1874750%22%20OR%20%22CHEMBL1201256%22%20OR%20%22CHEMBL2110774%22%20OR%20%22CHEMBL684%22%20OR%20%22CHEMBL652%22%20OR%20%22CHEMBL562%22%20OR%20%22CHEMBL2110990%22%20OR%20%22CHEMBL12%22%20OR%20%22CHEMBL276520%22%20OR%20%22CHEMBL6966%22%20OR%20%22CHEMBL1228%22%20OR%20%22CHEMBL490%22%20OR%20%22CHEMBL3707205%22%20OR%20%22CHEMBL900%22%20OR%20%22CHEMBL61006%22%20OR%20%22CHEMBL2110926%22%20OR%20%22CHEMBL16476%22%20OR%20%22CHEMBL1027%22%20OR%20%22CHEMBL1201308%22%20OR%20%22CHEMBL827%22%20OR%20%22CHEMBL607%22%20OR%20%22CHEMBL1618018%22%20OR%20%22CHEMBL796%22%20OR%20%22CHEMBL14370%22%20OR%20%22CHEMBL1276308%22%20OR%20%22CHEMBL2105527%22%20OR%20%22CHEMBL2103774%22%20OR%20%22CHEMBL2368925%22%20OR%20%22CHEMBL16%22%20OR%20%22CHEMBL416956%22%20OR%20%22CHEMBL1175%22%20OR%20%22CHEMBL1201338%22%20OR%20%22CHEMBL75880%22%20OR%20%22CHEMBL641%22%20OR%20%22CHEMBL1224%22%20OR%20%22CHEMBL1771%22%20OR%20%22CHEMBL1187846%22%20OR%20%22CHEMBL56564%22%20OR%20%22CHEMBL517712%22%20OR%20%22CHEMBL41%22%20OR%20%22CHEMBL1331216%22%20OR%20%22CHEMBL669%22%20OR%20%22CHEMBL220491%22%20OR%20%22CHEMBL1490%22%20OR%20%22CHEMBL1201227%22%20OR%20%22CHEMBL398440%22%20OR%20%22CHEMBL2010507%22%20OR%20%22CHEMBL1215%22%20OR%20%22CHEMBL1615438%22%20OR%20%22CHEMBL267936%22%20OR%20%22CHEMBL99946%22%20OR%20%22CHEMBL980%22%20OR%20%22CHEMBL86715%22%20OR%20%22CHEMBL968%22%20OR%20%22CHEMBL1201325%22%20OR%20%22CHEMBL1189432%22%20OR%20%22CHEMBL259209%22%20OR%20%22CHEMBL1051%22%20OR%20%22CHEMBL1655%22%20OR%20%22CHEMBL1621%22%20OR%20%22CHEMBL3092041%22%20OR%20%22CHEMBL1262%22%20OR%20%22CHEMBL560%22%20OR%20%22CHEMBL1201264%22%20OR%20%22CHEMBL894%22%20OR%20%22CHEMBL2110633%22%20OR%20%22CHEMBL1697760%22%20OR%20%22CHEMBL1987462%22%20OR%20%22CHEMBL1257%22%20OR%20%22CHEMBL1651998%22%20OR%20%22CHEMBL447629%22%20OR%20%22CHEMBL770%22%20OR%20%22CHEMBL1396%22%20OR%20%22CHEMBL434%22%20OR%20%22CHEMBL1201295%22%20OR%20%22CHEMBL1201313%22%20OR%20%22CHEMBL2146883%22%20OR%20%22CHEMBL1201262%22%20OR%20%22CHEMBL533%22%20OR%20%22CHEMBL1201335%22%20OR%20%22CHEMBL416898%22%20OR%20%22CHEMBL761%22%20OR%20%22CHEMBL830%22%20OR%20%22CHEMBL680%22%20OR%20%22CHEMBL363295%22%20OR%20%22CHEMBL1491%22%20OR%20%22CHEMBL19236%22%20OR%20%22CHEMBL3707331%22%20OR%20%22CHEMBL429910%22%20OR%20%22CHEMBL260538%22%20OR%20%22CHEMBL1094%22%20OR%20%22CHEMBL1201192%22%20OR%20%22CHEMBL1306%22%20OR%20%22CHEMBL211456%22%20OR%20%22CHEMBL701%22%20OR%20%22CHEMBL1444%22%20OR%20%22CHEMBL2103877%22%20OR%20%22CHEMBL134%22%20OR%20%22CHEMBL1512677%22%20OR%20%22CHEMBL253371%22%20OR%20%22CHEMBL1005%22%20OR%20%22CHEMBL2218896%22%20OR%20%22CHEMBL374731%22%20OR%20%22CHEMBL190677%22%20OR%20%22CHEMBL1200934%22%20OR%20%22CHEMBL1197%22%20OR%20%22CHEMBL1623992%22%20OR%20%22CHEMBL1590%22%20OR%20%22CHEMBL17860%22%20OR%20%22CHEMBL201960%22%20OR%20%22CHEMBL1180725%22%20OR%20%22CHEMBL951%22%20OR%20%22CHEMBL15677%22%20OR%20%22CHEMBL1159717%22%20OR%20%22CHEMBL2107830%22%20OR%20%22CHEMBL1237132%22%20OR%20%22CHEMBL1525%22%20OR%20%22CHEMBL24072%22%20OR%20%22CHEMBL1419%22%20OR%20%22CHEMBL1094636%22%20OR%20%22CHEMBL1908373%22%20OR%20%22CHEMBL1305%22%20OR%20%22CHEMBL1162%22%20OR%20%22CHEMBL1628502%22%20OR%20%22CHEMBL940%22%20OR%20%22CHEMBL861%22%20OR%20%22CHEMBL1373%22%20OR%20%22CHEMBL49080%22%20OR%20%22CHEMBL2105745%22%20OR%20%22CHEMBL2103822%22%20OR%20%22CHEMBL282575%22%20OR%20%22CHEMBL190%22%20OR%20%22CHEMBL1218%22%20OR%20%22CHEMBL1098%22%20OR%20%22CHEMBL488%22%20OR%20%22CHEMBL46%22%20OR%20%22CHEMBL1077896%22%20OR%20%22CHEMBL126%22%20OR%20%22CHEMBL1095777%22%20OR%20%22CHEMBL1201193%22%20OR%20%22CHEMBL1371%22%20OR%20%22CHEMBL277100%22%20OR%20%22CHEMBL289469%22%20OR%20%22CHEMBL1110%22%20OR%20%22CHEMBL1279%22%20OR%20%22CHEMBL1471%22%20OR%20%22CHEMBL168815%22%20OR%20%22CHEMBL53292%22%20OR%20%22CHEMBL527%22%20OR%20%22CHEMBL829%22%20OR%20%22CHEMBL1596%22%20OR%20%22CHEMBL1358%22%20OR%20%22CHEMBL328560%22%20OR%20%22CHEMBL1201260%22%20OR%20%22CHEMBL75753%22%20OR%20%22CHEMBL709%22%20OR%20%22CHEMBL218490%22%20OR%20%22CHEMBL2104356%22%20OR%20%22CHEMBL229128%22%20OR%20%22CHEMBL1257015%22%20OR%20%22CHEMBL64195%22%20OR%20%22CHEMBL108%22%20OR%20%22CHEMBL3707370%22%20OR%20%22CHEMBL305906%22%20OR%20%22CHEMBL1200430%22%20OR%20%22CHEMBL436%22%20OR%20%22CHEMBL423%22%20OR%20%22CHEMBL434200%22%20OR%20%22CHEMBL24171%22%20OR%20%22CHEMBL2105420%22%20OR%20%22CHEMBL469%22%20OR%20%22CHEMBL1201274%22%20OR%20%22CHEMBL839%22%20OR%20%22CHEMBL1488%22%20OR%20%22CHEMBL575%22%20OR%20%22CHEMBL1378024%22%20OR%20%22CHEMBL101%22%20OR%20%22CHEMBL1102%22%20OR%20%22CHEMBL502135%22%20OR%20%22CHEMBL1185%22%20OR%20%22CHEMBL489411%22%20OR%20%22CHEMBL2105755%22%20OR%20%22CHEMBL1200522%22%20OR%20%22CHEMBL1908906%22%20OR%20%22CHEMBL2106324%22%20OR%20%22CHEMBL1200623%22%20OR%20%22CHEMBL139835%22%20OR%20%22CHEMBL526%22%20OR%20%22CHEMBL1389%22%20OR%20%22CHEMBL1479%22%20OR%20%22CHEMBL1200810%22%20OR%20%22CHEMBL1200694%22%20OR%20%22CHEMBL193240%22%20OR%20%22CHEMBL1200614%22%20OR%20%22CHEMBL646%22%20OR%20%22CHEMBL634%22%20OR%20%22CHEMBL108545%22%20OR%20%22CHEMBL1601669%22%20OR%20%22CHEMBL91%22%20OR%20%22CHEMBL1159650%22%20OR%20%22CHEMBL991%22%20OR%20%22CHEMBL1042%22%20OR%20%22CHEMBL1364%22%20OR%20%22CHEMBL1200908%22%20OR%20%22CHEMBL1289%22%20OR%20%22CHEMBL1200807%22%20OR%20%22CHEMBL1201287%22%20OR%20%22CHEMBL312448%22%20OR%20%22CHEMBL73234%22%20OR%20%22CHEMBL1256786%22%20OR%20%22CHEMBL811%22%20OR%20%22CHEMBL959%22%20OR%20%22CHEMBL1651990%22%20OR%20%22CHEMBL557555%22%20OR%20%22CHEMBL649%22%20OR%20%22CHEMBL2103846%22%20OR%20%22CHEMBL1533%22%20OR%20%22CHEMBL566315%22%20OR%20%22CHEMBL787%22%20OR%20%22CHEMBL3707307%22%20OR%20%22CHEMBL13376%22%20OR%20%22CHEMBL2105720%22%20OR%20%22CHEMBL1200790%22%20OR%20%22CHEMBL406%22%20OR%20%22CHEMBL1201284%22%20OR%20%22CHEMBL1237119%22%20OR%20%22CHEMBL8%22%20OR%20%22CHEMBL31%22%20OR%20%22CHEMBL1505%22%20OR%20%22CHEMBL1520%22%20OR%20%22CHEMBL802%22%20OR%20%22CHEMBL1040%22%20OR%20%22CHEMBL1200790%22%20OR%20%22CHEMBL1201284%22%20OR%20%22CHEMBL1237119%22%20OR%20%22CHEMBL8%22%20OR%20%22CHEMBL31%22%20OR%20%22CHEMBL406%22%20OR%20%22CHEMBL1505%22%20OR%20%22CHEMBL1520%22%20OR%20%22CHEMBL1619785%22%20OR%20%22CHEMBL1194666%22%20OR%20%22CHEMBL1239%22%20OR%20%22CHEMBL1593566%22%20OR%20%22CHEMBL1013%22%20OR%20%22CHEMBL1076347%22%20OR%20%22CHEMBL2107797%22%20OR%20%22CHEMBL23%22%20OR%20%22CHEMBL1363%22%20OR%20%22CHEMBL1201220%22%20OR%20%22CHEMBL1201146%22%20OR%20%22CHEMBL1536%22%20OR%20%22CHEMBL604608%22%20OR%20%22CHEMBL742%22%20OR%20%22CHEMBL395091%22%20OR%20%22CHEMBL565%22%20OR%20%22CHEMBL3707340%22%20OR%20%22CHEMBL3707265%22%20OR%20%22CHEMBL1201075%22%20OR%20%22CHEMBL1497%22%20OR%20%22CHEMBL1200455%22%20OR%20%22CHEMBL277522%22%20OR%20%22CHEMBL46286%22%20OR%20%22CHEMBL1167%22%20OR%20%22CHEMBL2079611%22%20OR%20%22CHEMBL1909288%22%20OR%20%22CHEMBL416%22%20OR%20%22CHEMBL231779%22%20OR%20%22CHEMBL1095%22%20OR%20%22CHEMBL1187833%22%20OR%20%22CHEMBL1413%22%20OR%20%22CHEMBL1201753%22%20OR%20%22CHEMBL93047%22%20OR%20%22CHEMBL1185568%22%20OR%20%22CHEMBL3707390%22%20OR%20%22CHEMBL494753%22%20OR%20%22CHEMBL345524%22%20OR%20%22CHEMBL712%22%20OR%20%22CHEMBL1697838%22%20OR%20%22CHEMBL472%22%20OR%20%22CHEMBL411%22%20OR%20%22CHEMBL932%22%20OR%20%22CHEMBL9%22%20OR%20%22CHEMBL631%22%20OR%20%22CHEMBL1454%22%20OR%20%22CHEMBL1565476%22)/state/matrix_fs_Compounds'

  context = {
    'shortened_params': url
  }
  return render(request, 'glados/mainGladosNoBar.html', context)

@csrf_exempt
def shorten_url(request):

   if request.method == "POST":

      req_data = json.loads(request.body.decode('utf-8'))
      print('req body: ', request.body)
      print('test', glados.url_shortener.url_shortener.shorten_url('tetas'))

      resp_data = {
        'long_url': req_data['long_url'],
        'short_url': 'afcacd18e184f8976b193f4677215840c1c17c19e440f117e11eabc7cf078c0e'
      }
      return JsonResponse(resp_data)

   else:
      return JsonResponse({'error': 'this is only available via POST'})

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
