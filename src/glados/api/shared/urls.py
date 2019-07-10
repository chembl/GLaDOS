from django.conf.urls import include, url
urlpatterns = [
    url(r'downloads/', include('glados.api.shared.dynamic_downloads.urls')),
    url(r'properties_configuration/', include('glados.api.shared.properties_configuration.urls')),
]
