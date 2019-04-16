from django.http import HttpResponse, JsonResponse
from glados.api.unichem.services.similarity import get_svg_from_smile
from django.views.decorators.csrf import csrf_exempt

import logging

logger = logging.getLogger('django')

@csrf_exempt
def images(request, uci):

    if request.method == "GET":

        img_svg = get_svg_from_smile("COc1cc(-c2cc(-c3ccccc3)nc(Sc3ccc([N+](=O)[O-])cc3C=O)c2C#N)cc(OC)c1OC")

        response = HttpResponse(img_svg)

        response['Content-Type'] = 'image/svg+xml'

        return response

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")
