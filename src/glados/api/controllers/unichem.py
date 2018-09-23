from django.core import serializers
from django.http import HttpResponse
from glados.models import Parentsmile
from glados.api.cache.models import ChemCache
from simplejson import dumps
from django.views.decorators.csrf import csrf_exempt

ctab = """
Mrv0541 05211314572D          

 30 30  0  0  0  0            999 V2000
   -1.6745   -0.1185    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
   -2.0870   -0.8330    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -2.9120   -0.8330    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -3.3245   -1.5475    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -4.1495   -1.5475    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -4.5620   -2.2619    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -5.3870   -2.2619    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
   -4.1495   -2.9764    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -4.5620   -3.6909    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
   -3.3245   -2.9764    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -2.9120   -2.2619    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.8495   -0.1185    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.4370    0.5959    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    0.3880    0.5959    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    0.8005    1.3104    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    1.6255    1.3104    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    2.0380    0.5959    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    1.6255   -0.1185    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    2.0380   -0.8330    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    1.6255   -1.5475    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    2.0380   -2.2619    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    2.8630   -2.2619    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    3.2755   -2.9764    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    4.1005   -2.9764    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    4.5130   -2.2619    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    5.3380   -2.2619    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    5.7505   -1.5475    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    5.3380   -0.8330    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    5.7505   -0.1185    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.4370   -0.8330    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
  6  8  1  0  0  0  0
  8  9  1  0  0  0  0
  8 10  2  0  0  0  0
 10 11  1  0  0  0  0
  4 11  2  0  0  0  0
  1  2  1  0  0  0  0
  2  3  1  0  0  0  0
  3  4  1  0  0  0  0
  4  5  1  0  0  0  0
  5  6  2  0  0  0  0
  6  7  1  0  0  0  0
 12 13  1  0  0  0  0
 13 14  1  0  0  0  0
 14 15  1  0  0  0  0
 15 16  1  0  0  0  0
 16 17  1  0  0  0  0
 17 18  1  0  0  0  0
 18 19  1  0  0  0  0
 19 20  1  0  0  0  0
 20 21  2  0  0  0  0
 21 22  1  0  0  0  0
 22 23  1  0  0  0  0
 23 24  2  0  0  0  0
 24 25  1  0  0  0  0
 25 26  1  0  0  0  0
 26 27  2  0  0  0  0
 27 28  1  0  0  0  0
 28 29  1  0  0  0  0
 12 30  2  0  0  0  0
 12  1  1  0  0  0  0
M  END
"""

def validateExistence(ctab):
    col = ChemCache()
    if col.isCached(ctab):
        return True
    
    return False

@csrf_exempt
def test(request):

    if request.method == "POST":

        body = request.body.decode('utf-8')
        incoming_ctab = body
        
        if not incoming_ctab:
            incoming_ctab = ctab
        
        cole = ChemCache()
        query = '''
        SELECT
            a.n_parent
            , DBMS_LOB.SUBSTR(SMILES(a.ctab), 4000, 1) AS parent_smiles
            , b.inchikey
        FROM
                uc_ctabs          a
            JOIN uc_parents_map    b ON a.n_parent = b.n_parent
        WHERE
            SSS(a.ctab,
            '{ctab}') = 1
        '''.format(ctab=incoming_ctab)

        print("Le query: {query}".format(query=query))

        if validateExistence(incoming_ctab):
            cached_response = cole.getChached(incoming_ctab)
            print("ITS CACHED!!!")
            # print(json.loads(json_util.dumps(cached_response)))
            # return HttpResponse(cached_response.get("response"), content_type="application/json")
            return HttpResponse(dumps(cached_response.get("response")), content_type="application/json")

        parents = Parentsmile.objects.using('oradb').raw(query)
        
        mongo_parents = []
        for parent in parents:
            print (parent.n_parent)
            print (parent.inchikey)
            mongo_parents.append({
                "n_parent":parent.n_parent,
                "inchikey":parent.inchikey,
                "smiles":parent.parent_smiles
                })

        print (mongo_parents)

        cole.collection.insert_one({ 'ctab':incoming_ctab, 'response':mongo_parents})

        response = dumps(mongo_parents)

        return HttpResponse(response, content_type="application/json")

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")

