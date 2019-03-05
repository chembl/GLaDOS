from django.conf.urls import url
from . import search_manager

urlpatterns = [
    url(r'submit/$',
        search_manager.request_submit_substructure_search),
    url(r'sssearch-progress/(?P<search_id>.*)$', search_manager.request_sssearch_status,
        name='get_sssearch_status'),
]