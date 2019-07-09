from django.conf.urls import url

from . import downloads_controller

urlpatterns = [
    url(r'queue_download.*$', downloads_controller.queue_download_job, name='queue_download'),
    url(r'download_status/(?P<download_id>.*)$', downloads_controller.get_download_status,
        name='get_download_status'),
]