from django.http import JsonResponse, HttpResponse
from django.views.decorators.http import require_POST


@require_POST
def queue_download_job(request):

    print('METHOD: ', request.method)
    if request.method != "POST":
        return JsonResponse({'error': 'This is only available via POST'})

    response = {}

    return response