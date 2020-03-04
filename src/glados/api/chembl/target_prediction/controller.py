from django.http import JsonResponse, Http404
from django.views.decorators.http import require_GET
from . import service


@require_GET
def get_target_prediction(request, molecule_chembl_id):

    agent = request.headers['User-Agent']
    if 'wget' in agent.lower():
        print('Target prediction rejecting wget')
        return Http404('Not found')

    return JsonResponse(service.get_target_predictions(molecule_chembl_id))
