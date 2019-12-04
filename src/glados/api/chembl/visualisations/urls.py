from django.conf.urls import include, url

urlpatterns = [
    url(r'target_classifications/',
        include('glados.api.chembl.visualisations.target_classifications.urls')),
]
