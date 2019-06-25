from django.db import models
from datetime import timedelta
import socket
from django.utils import timezone
import json
from django.conf import settings
import hashlib
import base64


class DownloadJobManager(models.Manager):

    class DownloadJobManagerError(Exception):
        pass

    def get_download_id(self, index_name, raw_query, desired_format, context_id):
        # make sure the string generated is stable
        stable_raw_query = json.dumps(json.loads(raw_query), sort_keys=True)

        parsed_desired_format = desired_format.upper()

        latest_release_full = settings.CURRENT_CHEMBL_RELEASE_NAME
        query_digest = hashlib.sha256(stable_raw_query.encode('utf-8')).digest()
        base64_query_digest = base64.b64encode(query_digest).decode('utf-8').replace('/', '_').replace('+', '-')

        if context_id is None:
            download_id = "{}-{}-{}.{}".format(latest_release_full, index_name, base64_query_digest,
                                               parsed_desired_format)
        else:
            download_id = "{}-{}-{}-{}.{}".format(latest_release_full, index_name, base64_query_digest,
                                                  context_id, parsed_desired_format)
        return download_id

    def create_download_job(self, index_name, raw_columns_to_download, raw_query, desired_format, log, context_id,
                            id_property):
        job_id = self.get_download_id(index_name, raw_query, desired_format, context_id)

        try:
            DownloadJob.objects.get(job_id=job_id)
            raise DownloadJobManager.DownloadJobManagerError('A job with the same parametrers already exists')
        except DownloadJob.DoesNotExist:
            pass
            
        download_job = DownloadJob(
            job_id=job_id,
            index_name=index_name,
            raw_columns_to_download=raw_columns_to_download,
            raw_query=raw_query,
            desired_format=desired_format,
            log=log,
            context_id=context_id,
            id_property=id_property
        )
        return download_job


# This is to keep track of the status of a download job
class DownloadJob(models.Model):

    DAYS_TO_EXPIRE = 7

    job_id = models.CharField(max_length=250, primary_key=True)
    progress = models.PositiveSmallIntegerField(default=0)
    total_items = models.PositiveIntegerField(default=0)
    raw_columns_to_download = models.TextField(null=True)
    raw_query = models.TextField(null=True)

    QUEUED = 'QUEUED'
    PROCESSING = 'PROCESSING'
    ERROR = 'ERROR'
    FINISHED = 'FINISHED'
    DELETING = 'DELETING'
    STATUSES = (
        (QUEUED, QUEUED),
        (PROCESSING, PROCESSING),
        (FINISHED, FINISHED),
        (ERROR, ERROR),
        (DELETING, DELETING)
    )
    status = models.CharField(max_length=20, choices=STATUSES, default=QUEUED)
    index_name = models.CharField(max_length=200, null=True)
    desired_format = models.CharField(max_length=200, null=True)
    worker = models.TextField(max_length=250, null=True)
    log = models.TextField(null=True)
    context_id = models.TextField(max_length=500, null=True)
    id_property = models.CharField(max_length=100)
    expires = models.DateTimeField(null=True)
    file_path = models.TextField(null=True)

    @staticmethod
    def format_log_message(msg):
        now = timezone.now()
        return "[{date}] {hostname}: {msg}\n".format(date=now, hostname=socket.gethostname(), msg=msg)

    def append_to_job_log(self, msg):
        if self.log is None:
            self.log = ''

        self.log += DownloadJob.format_log_message(msg)
        self.save()

    def save_download_job_state(self, new_state):
        self.status = new_state
        if new_state == DownloadJob.FINISHED:
            finished_time = timezone.now()
            delta = timedelta(days=DownloadJob.DAYS_TO_EXPIRE)
            expiration_date = finished_time + delta
            self.expires = expiration_date
        self.save()
