from django.conf.urls import url
from . import pagination_helper

urlpatterns = [
    url(r'get_page', pagination_helper.get_page, name='chembl_list_helper'),
]