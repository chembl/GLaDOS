from django.conf.urls import url
from . import controller

urlpatterns = [
    url(r'predictions/$', controller.get_target_prediction),
]