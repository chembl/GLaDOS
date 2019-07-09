from django.conf.urls import include, url
urlpatterns = [
    url(r'downloads/', include('glados.api.shared.dynamic_downloads.urls')),
]