from django.http import JsonResponse
from django.views.decorators.http import require_GET
from glados.api.chembl.visualisations.assay_classifications.services import in_vivo


@require_GET
def get_in_vivo_classification(request):
    return JsonResponse(in_vivo.get_classification_tree())
