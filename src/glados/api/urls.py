from django.conf.urls import include, url

urlpatterns = [
    url(r'chembl/', include('glados.api.chembl.urls')),
    url(r'shared/', include('glados.api.shared.urls')),
]
