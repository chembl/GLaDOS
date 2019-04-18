from django.http import HttpResponse, JsonResponse
from glados.api.unichem.services.similarity import get_similarity
from django.views.decorators.csrf import csrf_exempt

import logging

logger = logging.getLogger('django')

@csrf_exempt
def similarity(request):

    if request.method == "POST":
        body = request.body.decode('utf-8')
        logger.debug("Called unichem similarity for {}".format(body))

        threshold = "0.9"
        init = 0
        end = 10
        response = {'inchis': []}

        if not is_int(request.GET['init']) & is_int(request.GET['end']):
            response['error'] = "Pagination params must be integers"

            return JsonResponse(response)

        if request.GET.get('threshold'):
            threshold = request.GET['threshold']

        if request.GET.get('init'):
            init = int(request.GET['init'])

        if request.GET.get('end'):
            end = int(request.GET['end'])

        if init >= end:
            response['error'] = "Pagination params end must be greater than init"

            return JsonResponse(response)

        total_count, similar_compounds = get_similarity(body, threshold, init, end)

        if bool(similar_compounds):
            response['inchis'] = similar_compounds
            response['totalCount'] = total_count
        else:
            response['message'] = "No similar compounds"
            json_response = JsonResponse(response)

            return json_response

        return JsonResponse(response)

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")


def is_int(s):
    try:
        int(s)
        return True
    except ValueError:
        return False
