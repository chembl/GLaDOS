from django.core import serializers
from django.http import HttpResponse
from glados.models import Parentsmile
from glados.api.cache.models import ChemCache
from simplejson import dumps
from django.views.decorators.csrf import csrf_exempt
import logging

logger = logging.getLogger('django')

ctab = """
      MJ161212                      

 30 34  0  0  0  0  0  0  0  0999 V2000
   -1.3054    1.2122    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.5895    0.7979    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
    0.5373   -0.7010    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    1.0606   -0.0250    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
    0.8577    0.7577    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.2967   -0.6970    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -0.7990   -0.0422    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    0.1299    1.1223    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    1.8871   -0.0626    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    2.2677   -0.7971    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    2.3328    0.6342    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
    1.8199   -1.4900    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    2.1999   -2.2241    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    3.0272   -2.2621    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    3.4730   -1.5602    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    3.0906   -0.8291    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    3.5846   -0.1646    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
    4.4118   -0.1773    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
    4.6795    0.6053    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    4.0178    1.1018    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
    3.3412    0.6259    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
    0.8998   -1.4446    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -1.3940    2.0354    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
   -2.0640    0.8771    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
   -2.6169    1.4922    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -2.2029    2.2066    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -2.6146    2.9202    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -3.4401    2.9207    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -3.8522    2.2014    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
   -3.4382    1.4908    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
 15 16  2  0  0  0  0
 16 10  1  0  0  0  0
 17 18  1  0  0  0  0
  6  7  1  0  0  0  0
  4  9  1  0  0  0  0
  1  2  1  0  0  0  0
  9 10  1  0  0  0  0
 18 19  2  0  0  0  0
 19 20  1  0  0  0  0
 20 21  2  0  0  0  0
 21 17  1  0  0  0  0
 16 17  1  0  0  0  0
  3  4  1  0  0  0  0
  3 22  1  6  0  0  0
  1 23  1  0  0  0  0
  9 11  2  0  0  0  0
  4  5  1  0  0  0  0
 23 26  1  0  0  0  0
 25 24  1  0  0  0  0
 24  1  2  0  0  0  0
 10 12  2  0  0  0  0
  3  6  1  0  0  0  0
 25 26  2  0  0  0  0
 12 13  1  0  0  0  0
 26 27  1  0  0  0  0
  7  2  1  0  0  0  0
 27 28  2  0  0  0  0
 13 14  2  0  0  0  0
 28 29  1  0  0  0  0
  2  8  1  0  0  0  0
 29 30  2  0  0  0  0
 30 25  1  0  0  0  0
 14 15  1  0  0  0  0
  8  5  1  0  0  0  0
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
            '
{ctab}
') = 1
AND rownum <= 100
        '''.format(ctab=incoming_ctab)

        print("Le query: {query}".format(query=query))

        # if validateExistence(incoming_ctab):
        #     cached_response = cole.getChached(incoming_ctab)
        #     print("ITS CACHED!!!")
        #     # print(json.loads(json_util.dumps(cached_response)))
        #     # return HttpResponse(cached_response.get("response"), content_type="application/json")
        #     return HttpResponse(dumps(cached_response.get("response")), content_type="application/json")

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

        logger.info(mongo_parents)

        # cole.collection.insert_one({ 'ctab':incoming_ctab, 'response':mongo_parents})

        response = dumps(mongo_parents)

        return HttpResponse(response, content_type="application/json")

    return HttpResponse("Method not supported, SORRY MATE", content_type="application/text")

