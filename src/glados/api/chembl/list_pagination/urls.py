from django.conf.urls import url
from . import pagination_controller

urlpatterns = [
    url(r'get_page', pagination_controller.get_page, name='chembl_list_helper'),
]