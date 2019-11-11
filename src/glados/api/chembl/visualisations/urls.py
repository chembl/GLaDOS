from django.conf.urls import include, url

urlpatterns = [
    url(r'protein_target_classification/',
        include('glados.api.chembl.visualisations.protein_target_classification.urls')),
]