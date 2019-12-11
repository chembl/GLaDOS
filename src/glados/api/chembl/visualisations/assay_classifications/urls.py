from django.conf.urls import url
from . import controller

urlpatterns = [
    url(r'in_vivo/$', controller.get_in_vivo_classification),
]
