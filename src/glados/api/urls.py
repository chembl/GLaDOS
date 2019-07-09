from django.conf.urls import include, url

urlpatterns = [
    url(r'chembl/', include('glados.api.chembl.urls')),
    url(r'unichem/', include('glados.api.unichem.urls')),
    url(r'shared/', include('glados.api.shared.urls')),
]
