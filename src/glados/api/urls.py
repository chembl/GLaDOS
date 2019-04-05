from django.conf.urls import include, url

urlpatterns = [
    url(r'game/', include('glados.api.chembl_game.urls')),
    url(r'downloads/', include('glados.api.dynamic-downloads.urls')),
    url(r'sssearch/', include('glados.api.sssearch.urls')),
    url(r'list_pagination/', include('glados.api.list_pagination.urls')),
    url(r'url_shortening/', include('glados.api.url_shortening.urls')),
    url(r'unichem/', include('glados.api.unichem.urls')),
]
