from django.conf.urls import url
from . import search_manager

urlpatterns = [
    url(r'blast-params/$', search_manager.get_blast_params),
]
