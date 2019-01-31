from django.conf.urls import url
from unichem.api.controllers.similarity import test

urlpatterns = [
    url(r'test', test)
]
