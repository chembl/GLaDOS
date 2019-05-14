from django.conf.urls import url
from . import url_shortener

urlpatterns = [
    url(r'shorten_url/$', url_shortener.process_shorten_url_request, name='shorten'),
    url(r'^extend_url/(?P<hash>.*?)$', url_shortener.process_extend_url_request, name='extend'),
]