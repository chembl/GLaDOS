from django.http import JsonResponse, HttpResponse
from glados.usage_statistics import glados_server_statistics
import traceback
from glados.models import SSSearchJob
from glados.api.sssearch import search_manager
from django.core.cache import cache
import json
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
def get_page(request):

    if request.method == "POST":

        index_name = request.POST.get('index_name', '')
        raw_search_data = request.POST.get('search_data', '')
        context_id = request.POST.get('context_id')
        id_property = request.POST.get('id_property')
        raw_contextual_sort_data = request.POST.get('contextual_sort_data')
        print('raw_search_data: ', raw_search_data)

        try:
            if context_id is None or context_id == 'undefined' or context_id == 'null':
                print('no context id')
                response = glados_server_statistics.get_and_record_es_cached_response(index_name, raw_search_data)
            else:
                response = get_items_with_context(index_name, raw_search_data, context_id, id_property,
                                                  raw_contextual_sort_data)
        except Exception as e:
            traceback.print_exc()
            return HttpResponse('Internal Server Error', status=500)

        if response is None:
            return HttpResponse('ELASTIC SEARCH RESPONSE IS EMPTY!', status=500)

        return JsonResponse(response)
    else:
        return JsonResponse({'error': 'this is only available via POST! You crazy hacker! :P'})


def get_items_with_context(index_name, raw_search_data, context_id, id_property, raw_contextual_sort_data='{}'):

    sssearch_job = SSSearchJob.objects.get(search_id=context_id)
    context, total_results = search_manager.get_search_results_context(sssearch_job)

    # create a context index so access is faster
    context_index_key = 'context_index-{}'.format(context_id)
    context_index = cache.get(context_index_key)
    if context_index is None:
        context_index = {}

        for index, item in enumerate(context):
            context_index[item[id_property]] = item
            context_index[item[id_property]]['index'] = index

        cache.set(context_index_key, context_index, 3600)

    contextual_sort_data = json.loads(raw_contextual_sort_data)
    contextual_sort_data_keys = contextual_sort_data.keys()
    if len(contextual_sort_data_keys) == 0:
        # if nothing is specified use the default scoring script, which is to score them according to their original
        # position in the results
        score_property = 'index'
        score_script = "String id=doc['" + id_property + "'].value; " \
                       "return " + str(total_results) + " - params.scores[id]['" + score_property + "'];"
    else:

        raw_score_property = list(contextual_sort_data_keys)[0]
        score_property = raw_score_property.replace('{}.'.format(SSSearchJob.CONTEXT_PREFIX), '')
        sort_order = contextual_sort_data[raw_score_property]

        if sort_order == 'desc':
            score_script = "String id=doc['" + id_property + "'].value; " \
                           "return params.scores[id]['" + score_property + "'];"
        else:
            score_script = "String id=doc['" + id_property + "'].value; " \
                           "return 1 / params.scores[id]['" + score_property + "'];"

    scores_query = {
        'function_score': {
            'functions': [{
                'script_score': {
                    'script': {
                        'lang': "painless",
                        'params': {
                            'scores': context_index,
                        },
                        'source': score_script
                    }
                }
            }]
        }
    }

    parsed_search_data = json.loads(raw_search_data)
    parsed_search_data['query']['bool']['must'].append(scores_query)
    raw_search_data_with_scores = json.dumps(parsed_search_data)

    es_response = glados_server_statistics.get_and_record_es_cached_response(index_name, raw_search_data_with_scores)
    hits = es_response['hits']['hits']
    for hit in hits:
        hit_id = hit['_id']
        context_obj = context_index[hit_id]
        hit['_source'][SSSearchJob.CONTEXT_PREFIX] = context_obj
    return es_response
