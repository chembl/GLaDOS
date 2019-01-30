from django.http import HttpResponse
from simplejson import dumps
from django.views.decorators.csrf import csrf_exempt
import logging

logger = logging.getLogger('django')

@csrf_exempt
def test(request):

    if request.method == "POST":

        body = request.body.decode('utf-8')

        logger.info(body)

        # if validateExistence(incoming_ctab):
        #     cached_response = cole.getChached(incoming_ctab)
        #     print("ITS CACHED!!!")
        #     # print(json.loads(json_util.dumps(cached_response)))
        #     # return HttpResponse(cached_response.get("response"), content_type="application/json")
        #     return HttpResponse(dumps(cached_response.get("response")), content_type="application/json")

        
        mongo_parents = []
        for i in range(5):
            mongo_parents.append({
                "n_parent":'lalalalal',
                "inchikey":'lalalalal',
                "smiles":'lalalalal',
                })


        # cole.collection.insert_one({ 'ctab':incoming_ctab, 'response':mongo_parents})

        response = dumps(mongo_parents)

        return HttpResponse(response, content_type="application/json")

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")

