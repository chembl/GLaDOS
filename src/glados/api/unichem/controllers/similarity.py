from django.http import HttpResponse, JsonResponse
from simplejson import dumps
import glados.api.unichem.services
from django.views.decorators.csrf import csrf_exempt

import logging

logger = logging.getLogger('django')

@csrf_exempt
def test(request):

    if request.method == "POST":

        body = request.body.decode('utf-8')

        logger.info(body)
        response = {'inchis': []}

        for i in range(0, 5):
            response['inchis'].append({
                "uci": i,
                "similarity": 'lslslslslsl',
                "standardinchi": 'lalalalal',
                "standardinchikey": 'lalalalal',
                })

        return JsonResponse(response)

        similarity = services.get_similarity(body)



        for sim_uci in similarity:

            inchis.append({
                "uci": sim_uci[0],
                "similarity": sim_uci[1],
                "standardinchi": 'lalalalal',
                "standardinchikey": 'lalalalal',
                })

        # if validateExistence(incoming_ctab):
        #     cached_response = cole.getChached(incoming_ctab)
        #     print("ITS CACHED!!!")
        #     # print(json.loads(json_util.dumps(cached_response)))
        #     # return HttpResponse(cached_response.get("response"), content_type="application/json")
        #     return HttpResponse(dumps(cached_response.get("response")), content_type="application/json")


        # query = "select uci, standardinchi, STANDARDINCHIKEY from uc_inchi where uci = 151374835;"
        #
        # similar_inchis = UciInchi.objects.using('oradb').raw(query)
        #
        # inchis = []
        # for uci_inchi in similar_inchis:
        #     inchis.append({
        #         "uci": uci_inchi.uci,
        #         "standardinchi": uci_inchi.standardinchi,
        #         "standardinchikey": uci_inchi.standardinchikey
        #     })
        #
        # logger.info(inchis)

        # cole.collection.insert_one({ 'ctab':incoming_ctab, 'response':mongo_parents})



        response = dumps(inchis)

        return HttpResponse(response, content_type="application/json")

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")

