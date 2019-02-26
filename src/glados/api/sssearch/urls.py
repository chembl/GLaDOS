from django.conf.urls import url
from . import structure_and_sequence_search_manager

urlpatterns = [
    url(r'submit_substructure_search/$',
        structure_and_sequence_search_manager.request_submit_substructure_search),
    url(r'sssearch-progress/(?P<search_id>.*)$', structure_and_sequence_search_manager.request_sssearch_status,
        name='get_sssearch_status'),
]