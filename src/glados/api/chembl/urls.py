from django.conf.urls import include, url

urlpatterns = [
    url(r'sssearch/', include('glados.api.chembl.sssearch.urls')),
    url(r'url_shortening/', include('glados.api.chembl.url_shortening.urls')),
    url(r'visualisations/', include('glados.api.chembl.visualisations.urls')),
    url(r'target_prediction/', include('glados.api.chembl.target_prediction.urls')),
]
