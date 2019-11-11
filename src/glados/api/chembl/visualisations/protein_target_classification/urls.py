from django.conf.urls import url
from . import controller

urlpatterns = [
    url(r'classification/$', controller.get_classification),
]