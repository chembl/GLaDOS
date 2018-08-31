from django.conf.urls import include, url
from glados.api.servi import test

urlpatterns = [
    url(r'test', test)
]
