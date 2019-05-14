from django.http import HttpResponse, JsonResponse
from glados.api.unichem.services.similarity import get_sources_from_inchi
from django.views.decorators.csrf import csrf_exempt

import logging

logger = logging.getLogger('django')


@csrf_exempt
def sources(request, inchikey):
    if request.method == "GET":

        response = {'sources': []}

        unichem_sources = get_sources_from_inchi(inchikey)

        if bool(unichem_sources):
            response['sources'] = unichem_sources
        else:
            response['message'] = "No sources found"
            json_response = JsonResponse(response)

            return json_response

        return JsonResponse(response)

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")
