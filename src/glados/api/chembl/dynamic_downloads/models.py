from django.db import models
from datetime import datetime, timedelta, timezone
import socket


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

    @staticmethod
    def format_log_message(msg):
        now = datetime.now()
        return "[{date}] {hostname}: {msg}\n".format(date=now, hostname=socket.gethostname(), msg=msg)

    def append_to_job_log(self, msg):
        if self.log is None:
            self.log = ''

        self.log += DownloadJob.format_log_message(msg)
        self.save()

    def save_download_job_state(self, new_state):
        self.status = new_state
        if new_state == DownloadJob.FINISHED:
            dt = datetime.now()
            td = timedelta(days=7)
            expiration_date = dt + td
            expiration_date.replace(tzinfo=timezone.utc)
            self.expires = expiration_date
        self.save()
