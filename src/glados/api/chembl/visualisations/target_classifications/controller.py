from django.http import JsonResponse
from django.views.decorators.http import require_GET
from glados.api.chembl.visualisations.target_classifications.services import protein_class
from glados.api.chembl.visualisations.target_classifications.services import organism_taxonomy
from glados.api.chembl.visualisations.target_classifications.services import go_slim


@require_GET
def get_protein_classification(request):
    return JsonResponse(protein_class.get_classification_tree())


@require_GET
def get_organism_taxonomy(request):
    return JsonResponse(organism_taxonomy.get_classification_tree())


@require_GET
def get_go_slim(request):
    return JsonResponse(go_slim.get_classification_tree())
