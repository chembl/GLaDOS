from django.http import JsonResponse, Http404
from django.views.decorators.http import require_GET
from . import service


@require_GET
def get_target_prediction(request, molecule_chembl_id):

    print('Target prediction request headers')
    print(request.headers)
    print('^^^')
    agent = request.headers['User-Agent']
    if 'wget' in agent.lower():
        print('Target prediction rejecting wget')
        raise Http404('Not found')

    return JsonResponse(service.get_target_predictions(molecule_chembl_id))
