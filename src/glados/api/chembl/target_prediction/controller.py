from django.http import JsonResponse, Http404
from django.views.decorators.http import require_GET
from django.conf import settings
from ratelimit.decorators import ratelimit

from . import service


@require_GET
@ratelimit(key=settings.RATE_LIMIT_KEY, rate='2/m', block=True)
def get_target_prediction(request, molecule_chembl_id):

    print('RATE LIMIT KEY: ', settings.RATE_LIMIT_KEY)
    # was_limited = getattr(request, 'limited', False)
    # print('was_limited: ', was_limited)
    return JsonResponse(service.get_target_predictions(molecule_chembl_id))
