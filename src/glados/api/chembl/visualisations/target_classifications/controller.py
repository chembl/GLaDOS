from django.http import JsonResponse
from django.views.decorators.http import require_GET
from src.glados.api.chembl.visualisations.target_classifications.services import protein_class
from src.glados.api.chembl.visualisations.target_classifications.services import organism_taxonomy


@require_GET
def get_protein_classification(request):
    return JsonResponse(protein_class.get_classification_tree())


@require_GET
def get_organism_taxonomy(request):
    return JsonResponse(organism_taxonomy.get_classification_tree())
