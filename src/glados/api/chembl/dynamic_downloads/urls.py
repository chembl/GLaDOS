from django.conf.urls import url
from . import downloads_controller

urlpatterns = [
    url(r'queue-download.*$', downloads_controller.queue_download_job, name='queue-download'),
    # url(r'generate-download.*$', downloads_manager.request_generate_download_request),
    # url(r'download-progress/(?P<download_id>.*)$', downloads_manager.request_get_download_status, name='get_download_status'),
]