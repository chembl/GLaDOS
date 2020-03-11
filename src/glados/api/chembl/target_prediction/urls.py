from django.conf.urls import url
from . import controller

urlpatterns = [
    url(r'predictions/(?P<molecule_chembl_id>.*)$', controller.get_target_prediction),
]