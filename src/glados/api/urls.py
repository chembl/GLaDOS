from django.conf.urls import include, url
from glados.api.controllers.unichem import test

urlpatterns = [
    url(r'test', test)
]
