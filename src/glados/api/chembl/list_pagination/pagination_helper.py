from django.http import JsonResponse, HttpResponse
from glados.usage_statistics import glados_server_statistics
import traceback
from glados.models import SSSearchJob
from glados.api.chembl.sssearch import search_manager
from django.core.cache import cache
import json
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from glados.api.chembl.list_pagination.services import context_loader


@csrf_exempt
@require_POST
def get_page(request):

    index_name = request.POST.get('index_name', '')
    raw_search_data = request.POST.get('search_data', '')
    raw_context = request.POST.get('context_obj')

    id_property = request.POST.get('id_property')
    raw_contextual_sort_data = request.POST.get('contextual_sort_data')


    try:
        if raw_context is None or raw_context == 'undefined' or raw_context == 'null':
            response = glados_server_statistics.get_and_record_es_cached_response(index_name, raw_search_data)
        else:
            response = get_items_with_context(index_name, raw_search_data, raw_context, id_property,
                                              raw_contextual_sort_data)
    except Exception as e:
        traceback.print_exc()
        return HttpResponse('Internal Server Error', status=500)

    if response is None:
        return HttpResponse('ELASTIC SEARCH RESPONSE IS EMPTY!', status=500)

    return JsonResponse(response)


def get_items_with_context(index_name, raw_search_data, raw_context, id_property, raw_contextual_sort_data='{}'):

    context_dict = json.loads(raw_context)
    context, total_results = context_loader.get_context(context_dict)

    # create a context index so access is faster
    context_id = context_dict['context_id']
    context_index = load_context_index(context_id, id_property, context)

    parsed_search_data = json.loads(raw_search_data)

    contextual_sort_data = json.loads(raw_contextual_sort_data)
    scores_query = get_scores_query(contextual_sort_data, id_property, total_results, context_index)
    parsed_search_data['query']['bool']['must'].append(scores_query)

    ids_list = list(context_index.keys())
    ids_query = get_request_for_chembl_ids(id_property, ids_list)
    parsed_search_data['query']['bool']['filter'].append(ids_query)

    raw_search_data_with_injections = json.dumps(parsed_search_data)

    es_response = glados_server_statistics.get_and_record_es_cached_response(index_name, raw_search_data_with_injections)
    hits = es_response['hits']['hits']
    for hit in hits:
        hit_id = hit['_id']
        context_obj = context_index[hit_id]
        hit['_source'][SSSearchJob.CONTEXT_PREFIX] = context_obj
    return es_response


def load_context_index(context_id, id_property, context):
    """
    Loads an index based on the id property of the context, for fast access
    :param context_id: id of the context loaded
    :param id_property: property used to identify each item
    :param context: context loaded
    :return:
    """

    context_index_key = 'context_index-{}'.format(context_id)
    context_index = cache.get(context_index_key)
    if context_index is None:
        context_index = {}

        for index, item in enumerate(context):
            context_index[item[id_property]] = item
            context_index[item[id_property]]['index'] = index

        cache.set(context_index_key, context_index, 3600)

    return context_index


def get_scores_query(contextual_sort_data, id_property, total_results, context_index):
    """
    Returns the query with the scores for the data to sort it with the contextual properties.
    :param contextual_sort_data: dict describing the sorting by contextual properties
    :param id_property: property used to identity each item
    :param total_results: total number of results
    :param context_index: index with the context
    """

    contextual_sort_data_keys = contextual_sort_data.keys()
    if len(contextual_sort_data_keys) == 0:
        # if nothing is specified use the default scoring script, which is to score them according to their original
        # position in the results
        score_property = 'index'
        score_script = "String id=doc['" + id_property + "'].value; " \
                                                         "return " + str(
            total_results) + " - params.scores[id]['" + score_property + "'];"
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

    return scores_query


def get_request_for_chembl_ids(id_property, ids_list):
    """
    creates a terms query with the ids given as a parameter for the id_property given as parameter
    :param id_property: property that identifies the items
    :param ids_list: list of ids to query
    :return: the terms query to use
    """
    query = {
        'terms': {
            id_property: ids_list
        }
    }

    return query