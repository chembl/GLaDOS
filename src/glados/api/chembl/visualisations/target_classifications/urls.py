from django.conf.urls import url
from . import controller

urlpatterns = [
    url(r'protein_class/$', controller.get_protein_classification),
    url(r'organism_taxonomy/$', controller.get_organism_taxonomy),
]