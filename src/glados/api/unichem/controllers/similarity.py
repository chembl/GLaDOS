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


        response['inchis'].append({
            "uci": 20549322,
            "similarity": '0.7',
            "standardinchi": 'InChI=1S/C18H24ClN3O4/c19-14-3-1-2-4-15(14)21-18(24)17(23)20-11-16(13-5-8-26-12-13)22-6-9-25-10-7-22/h1-4,13,16H,5-12H2,(H,20,23)(H,21,24)/t13-,16+/m1/s1',
            "standardinchikey": 'KXJWNSGKQUANCP-CJNGLKHVSA-N',
            "smiles": "O=C(NC[C@@H]([C@@H]1CCOC1)N1CCOCC1)C(=O)Nc1ccccc1Cl"
            })

        response['inchis'].append({
            "uci": 45436939,
            "similarity": '0.7',
            "standardinchi": 'InChI=1S/C28H21N3O6S/c1-35-24-12-18(13-25(36-2)27(24)37-3)21-14-23(17-7-5-4-6-8-17)30-28(22(21)15-29)38-26-10-9-20(31(33)34)11-19(26)16-32/h4-14,16H,1-3H3',
            "standardinchikey": 'CTNLGOXZJPLJPN-UHFFFAOYSA-N',
            "smiles": "COc1cc(-c2cc(-c3ccccc3)nc(Sc3ccc([N+](=O)[O-])cc3C=O)c2C#N)cc(OC)c1OC"
            })

        # for i in range(0, 5):
        #     response['inchis'].append({
        #         "uci": i,
        #         "similarity": 'lslslslslsl',
        #         "standardinchi": 'lalalalal',
        #         "standardinchikey": 'lalalalal',
        #         "smiles": "a;slkjdfqoiwefjlssldfjk"
        #         })

        # response['inchis'] = []
        # logger.info(response)
        # response['message'] = "No similar compounds"
        # json_response = JsonResponse(response)
        #
        # return json_response
        # similar_compounds = get_similarity(body)
        #
        # if bool(similar_compounds):
        #     response['inchis'] = similar_compounds
        # else:
        #     response['message'] = "No similar compounds"
        #     json_response = JsonResponse(response)
        #
        #     return json_response

        return JsonResponse(response)

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")
