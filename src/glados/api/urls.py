from django.conf.urls import include, url

urlpatterns = [
    url(r'chembl/', include('glados.api.chembl.urls')),
]
