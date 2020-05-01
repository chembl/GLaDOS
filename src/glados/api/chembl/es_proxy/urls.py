from django.conf.urls import url
from . import es_proxy_controller

urlpatterns = [
    url(r'get_es_data', es_proxy_controller.get_es_data, name='chembl_list_helper'),
]