from django.conf.urls import url
from .controllers.similarity import similarity

urlpatterns = [
    url(r'similarity/$', similarity),
]
