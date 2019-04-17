from django.http import HttpResponse, JsonResponse
from glados.api.unichem.services.similarity import get_similarity
from django.views.decorators.csrf import csrf_exempt

import logging

logger = logging.getLogger('django')

@csrf_exempt
def similarity(request):

    if request.method == "POST":
        body = request.body.decode('utf-8')
        logger.info("Called unichem similarity for {}".format(body))

        threshold = "0.9"

        if request.GET.get('threshold'):
            threshold = request.GET['threshold']

        similar_compounds = get_similarity(body, threshold)

        response = {'inchis': []}
        if bool(similar_compounds):
            response['inchis'] = similar_compounds
        else:
            response['message'] = "No similar compounds"
            json_response = JsonResponse(response)

            return json_response

        return JsonResponse(response)

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")
