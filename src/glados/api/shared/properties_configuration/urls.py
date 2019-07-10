from django.urls import path
from . import properties_configuration_controller

urlpatterns = [
    path('property/<index_name>/<property_id>/', properties_configuration_controller.get_config_for_property,
         name='get_config_for_property'),
    path('group/<index_name>/<group_name>/', properties_configuration_controller.get_config_for_group,
         name='get_config_for_group'),

]
