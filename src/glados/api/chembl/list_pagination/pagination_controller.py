import traceback

from django.http import JsonResponse, HttpResponse
from glados.usage_statistics import glados_server_statistics
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST


from glados.api.chembl.list_pagination.services import pagination_service


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
            response = pagination_service.get_items_with_context(index_name, raw_search_data, raw_context, id_property,
                                                                 raw_contextual_sort_data)
    except Exception as e:
        traceback.print_exc()
        return HttpResponse('Internal Server Error', status=500)

    if response is None:
        return HttpResponse('ELASTIC SEARCH RESPONSE IS EMPTY!', status=500)

    return JsonResponse(response)


