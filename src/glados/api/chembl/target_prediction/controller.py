from django.http import JsonResponse
from django.views.decorators.http import require_GET


@require_GET
def get_target_prediction(request):
    return JsonResponse({'hello': 'world'})
