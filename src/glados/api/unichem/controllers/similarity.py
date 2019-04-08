from django.http import HttpResponse, JsonResponse
from glados.api.unichem.services.similarity import get_similarity
from django.views.decorators.csrf import csrf_exempt

import logging

logger = logging.getLogger('django')

@csrf_exempt
def similarity(request):

    if request.method == "POST":

        body = request.body.decode('utf-8')

        logger.info("Search for " + body)
        response = {'inchis': []}
        #
        # for i in range(0, 5):
        #     response['inchis'].append({
        #         "uci": i,
        #         "similarity": 'lslslslslsl',
        #         "standardinchi": 'lalalalal',
        #         "standardinchikey": 'lalalalal',
        #         })

        similar_compounds = get_similarity(body)

        if bool(similar_compounds):
            response['inchis'] = similar_compounds
        else:
            response['message'] = "No similar compounds"
            json_response = JsonResponse(response)

            return json_response

        return JsonResponse(response)

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")
