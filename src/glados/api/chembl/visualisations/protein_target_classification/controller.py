from django.views.decorators.http import require_GET
from django.http import JsonResponse
from . import service


@require_GET
def get_classification(request):
    return JsonResponse(service.get_classification_json())
