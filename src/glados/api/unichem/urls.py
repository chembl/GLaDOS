from django.conf.urls import url
from .controllers.similarity import test

urlpatterns = [
    url(r'similarity/$', test),
]
