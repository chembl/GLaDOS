from django.conf.urls import include, url

urlpatterns = [
    url(r'game/', include('glados.api.chembl_game.urls'))
]
