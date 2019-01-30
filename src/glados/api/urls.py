from django.conf.urls import include, url
from glados.api.controllers.similarity import test

urlpatterns = [
    url(r'test', test)
]
