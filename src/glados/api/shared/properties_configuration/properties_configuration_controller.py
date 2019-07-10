from django.views.decorators.http import require_POST, require_GET
from django.http import JsonResponse, HttpResponse
from glados.es.es_properties_configuration import configuration_manager

@require_GET
def get_config_for_property(request, index_name, property_id):

    try:
        config_got = configuration_manager.get_config_for_prop(index_name, property_id)
    except configuration_manager.ESPropsConfigurationManagerError as err:
        return HttpResponse('Internal Server Error: ' + str(err), status=500)


    return JsonResponse({})
