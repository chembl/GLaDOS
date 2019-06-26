from django.http import JsonResponse, HttpResponse
from django.views.decorators.http import require_POST, require_GET
from glados.api.chembl.dynamic_downloads import download_job_service
import traceback


@require_POST
def queue_download_job(request):

    index_name = request.POST.get('index_name', '')
    raw_query = request.POST.get('query', '')
    desired_format = request.POST.get('format', '')
    context_id = request.POST.get('context_id')

    if context_id == "null" or context_id == "undefined":
        context_id = None

    try:
        download_id = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        return JsonResponse({'download_id':download_id})

    except Exception as e:
        traceback.print_exc()
        return HttpResponse('Internal Server Error', status=500)


@require_GET
def get_download_status(request, download_id):

    response = download_job_service.get_download_status(download_id)
    return JsonResponse(response)
