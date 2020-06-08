# this handles the management of the special searches, structure (similarity, substructure, connectivity) and
# sequence (blast)

import traceback
from django.http import JsonResponse, HttpResponse
from . import blast


DAYS_TO_LIVE = 7

def get_blast_params(request):
    if request.method != "GET":
        return JsonResponse({'error': 'This is only available via GET'})

    try:

        response = blast.get_blast_params()
        return JsonResponse(response)

    except Exception as e:

        traceback.print_exc()
        return HttpResponse('Internal Server Error', status=500)
