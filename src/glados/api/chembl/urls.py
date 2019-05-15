from django.conf.urls import include, url

urlpatterns = [
    url(r'game/', include('glados.api.chembl.chembl_game.urls')),
    url(r'downloads/', include('glados.api.chembl.dynamic_downloads.urls')),
    url(r'sssearch/', include('glados.api.chembl.sssearch.urls')),
    url(r'list_pagination/', include('glados.api.chembl.list_pagination.urls')),
    url(r'url_shortening/', include('glados.api.chembl.url_shortening.urls')),
]
