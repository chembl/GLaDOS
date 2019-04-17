from django.http import HttpResponse, JsonResponse
from glados.api.unichem.services.similarity import get_image_uci
from django.views.decorators.csrf import csrf_exempt

import logging

logger = logging.getLogger('django')

@csrf_exempt
def images(request, uci):

    if request.method == "GET":

        img_svg = get_image_uci(uci)

        response = HttpResponse(img_svg)

        response['Content-Type'] = 'image/svg+xml'

        return response

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")
