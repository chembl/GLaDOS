from django.http import JsonResponse
from django.views.decorators.http import require_GET


@require_GET
def get_target_prediction(request, molecule_chembl_id):
    return JsonResponse({'hello': molecule_chembl_id})
