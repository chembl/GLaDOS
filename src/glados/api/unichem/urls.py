from django.conf.urls import url
from .controllers.similarity import similarity
from .controllers.images import images

urlpatterns = [
    url(r'similarity/$', similarity),
    url(r'images/(?P<uci>.*)$', images)
]
