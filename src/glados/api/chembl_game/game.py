from django.http import JsonResponse, HttpResponse


def get_initial_config(request):

    if request.method != "GET":
        return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")

    config = {
        'hello': 'world'
    }
    return JsonResponse(config)
