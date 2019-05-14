from django.conf.urls import url
from . import game

urlpatterns = [
    url(r'initial_config/', game.get_initial_config)
]
