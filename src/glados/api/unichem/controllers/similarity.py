from django.http import HttpResponse, JsonResponse
from glados.api.unichem.services.similarity import get_similarity
from django.views.decorators.csrf import csrf_exempt

import logging

logger = logging.getLogger('django')

@csrf_exempt
def similarity(request):

    if request.method != "POST":
        return HttpResponse("Method not supported", content_type="application/text")

    if request.method == "POST":
        body = request.body.decode('utf-8')
        logger.debug("Called unichem similarity for {}".format(body))

        init = 0
        end = 10
        response = {'inchis': []}

        if not is_int(request.GET['init']) & is_int(request.GET['end']):
            response['error'] = "Pagination params must be integers"

            return JsonResponse(response)

        threshold = request.GET.get('threshold')
        if threshold is None:
            threshold = "0.9"
        else:
            threshold = request.GET['threshold']

        raw_init = request.GET.get('init')
        if raw_init is not None:
            init = int(raw_init)

        raw_end = request.GET.get('end')
        if raw_end:
            end = int(raw_end)

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


def is_int(s):
    try:
        int(s)
        return True
    except ValueError:
        return False
