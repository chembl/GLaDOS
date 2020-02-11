from django.http import JsonResponse
from django.views.decorators.http import require_GET
from . import service


@require_GET
def get_target_prediction(request, molecule_chembl_id):
    return JsonResponse(service.get_target_predictions(molecule_chembl_id))
