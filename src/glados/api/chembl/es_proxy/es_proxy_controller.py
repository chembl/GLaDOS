import traceback
import json
import hashlib
import base64

from django.http import JsonResponse, HttpResponse
from glados.usage_statistics import glados_server_statistics
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.core.cache import cache
from django.conf import settings


from glados.api.chembl.es_proxy.services import es_proxy_service


@csrf_exempt
@require_POST
def get_es_data(request):

    index_name = request.POST.get('index_name', '')
    raw_search_data = request.POST.get('search_data', '')
    raw_context = request.POST.get('context_obj')
    id_property = request.POST.get('id_property')
    raw_contextual_sort_data = request.POST.get('contextual_sort_data')

    cache_key = get_request_cache_key(index_name, raw_search_data, raw_context, id_property, raw_contextual_sort_data)

    cache_response = cache.get(cache_key)
    if cache_response is not None:
        return JsonResponse(cache_response)

    try:
        if raw_context is None or raw_context == 'undefined' or raw_context == 'null':
            response = glados_server_statistics.get_and_record_es_cached_response(index_name, raw_search_data)
        else:
            response = es_proxy_service.get_items_with_context(index_name, raw_search_data, raw_context, id_property,
                                                                 raw_contextual_sort_data)
    except Exception as e:
        traceback.print_exc()
        return HttpResponse('Internal Server Error', status=500)

    if response is None:
        return HttpResponse('ELASTIC SEARCH RESPONSE IS EMPTY!', status=500)

    cache_time = settings.ES_PROXY_CACHE_SECONDS
    cache.set(cache_key, response, cache_time)

    return JsonResponse(response)


def get_request_cache_key(index_name, raw_search_data, raw_context, id_property, raw_contextual_sort_data):
    """
    Returns a cache key from the request parameters
    :param index_name: name of the index for which the request is made
    :param raw_search_data: stringified dict with the query to send to ES
    :param raw_context: stringified dict describing the context of the request
    :param id_property: property used to identify the items
    :param raw_contextual_sort_data: stringified dict descibing the sorting by the contextual properties
    """

    stable_raw_search_data = json.dumps(json.loads(raw_search_data), sort_keys=True)
    stable_raw_context = json.dumps(json.loads(raw_context), sort_keys=True)
    stable_raw_contextual_sort_data = json.dumps(json.loads(raw_contextual_sort_data), sort_keys=True)

    merged_params = '{index_name}-{raw_search_data}-{raw_context}-{id_property}-{raw_contextual_sort_data}'.format(
        index_name=index_name,
        raw_search_data=stable_raw_search_data,
        raw_context=stable_raw_context,
        id_property=id_property,
        raw_contextual_sort_data=stable_raw_contextual_sort_data
    )

    merged_params_digest = hashlib.sha256(merged_params.encode('utf-8')).digest()
    base64_search_data_hash = base64.b64encode(merged_params_digest).decode('utf-8')

    return 'es_proxy-{}'.format(base64_search_data_hash)
