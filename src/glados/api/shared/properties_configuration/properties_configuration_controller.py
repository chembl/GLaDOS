from django.views.decorators.http import require_POST, require_GET
from django.http import JsonResponse, HttpResponse
from glados.es.es_properties_configuration import configuration_manager


@require_GET
def get_config_for_property(request, index_name, property_id):

    try:
        config = configuration_manager.get_config_for_prop(index_name, property_id)
        return JsonResponse(config)
    except configuration_manager.ESPropsConfigurationManagerError as err:
        return HttpResponse('Error: ' + str(err), status=500)


@require_GET
def get_config_for_group(request, index_name, group_name):

    try:
        config = configuration_manager.get_config_for_group(index_name, group_name)
        return JsonResponse(config)
    except configuration_manager.ESPropsConfigurationManagerError as err:
        return HttpResponse('Error: ' + str(err), status=500)
