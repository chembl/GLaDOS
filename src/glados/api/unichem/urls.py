from django.conf.urls import url
from .controllers.similarity import similarity
from .controllers.images import images
from .controllers.sources import sources

urlpatterns = [
    url(r'similarity/$', similarity),
    url(r'images/(?P<uci>.*)$', images),
    url(r'sources/(?P<inchikey>.*)$', sources)
]
