from django.db import models
from glados.es_models import TinyURLIndex, ESCachedRequestIndex, ESDownloadRecordIndex, ESViewRecordIndex
import time
import socket
from django.conf import settings


class TinyURL(models.Model):

    long_url = models.TextField()
    hash = models.CharField(max_length=100)

    def indexing(self):
        obj = TinyURLIndex(
            meta={'id': self.hash},
            long_url=self.long_url,
            hash=self.hash,
        )
        obj.save(refresh='wait_for')
        return obj.to_dict(include_meta=True)


class Country(models.Model):
    country_id = models.CharField(max_length=30, primary_key=True)
    country_name = models.CharField(max_length=35)
    region_id = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'COUNTRIES'
        managed = False

    def __str__(self):
        return self.country_name

# ----------------------------------------------------------------------------------------------------------------------
# Server Statistics
# ----------------------------------------------------------------------------------------------------------------------


class ESCachedRequest(models.Model):
    es_index = models.CharField(max_length=200)
    es_query = models.TextField()
    es_aggs = models.TextField()
    es_request_digest = models.TextField()
    is_cached = models.BooleanField()
    host = models.TextField()
    run_env_type = models.TextField()

    def indexing(self):
        obj = ESCachedRequestIndex(
          es_index=self.es_index,
          es_query=self.es_query,
          es_aggs=self.es_aggs,
          es_request_digest=self.es_request_digest,
          host=socket.gethostname(),
          run_env_type=settings.RUN_ENV,
          is_cached=self.is_cached,
          request_date=int(time.time()*1000)
        )
        obj.save()
        return obj.to_dict(include_meta=True)


class ESDownloadRecord(models.Model):
    download_id = models.TextField()
    time_taken = models.IntegerField(default=0)
    is_new = models.BooleanField()
    file_size = models.BigIntegerField()
    es_index = models.CharField(max_length=200)
    es_query = models.TextField()
    run_env_type = models.TextField()
    desired_format = models.CharField(max_length=20)
    total_items = models.IntegerField(default=0)
    host = models.TextField(default='')

    def indexing(self):
        obj = ESDownloadRecordIndex(
            download_id=self.download_id,
            time_taken=self.time_taken,
            is_new=self.is_new,
            file_size=self.file_size,
            es_index=self.es_index,
            es_query=self.es_query,
            desired_format=self.desired_format,
            total_items=self.total_items,
            host=socket.gethostname(),
            run_env_type=settings.RUN_ENV,
            request_date=int(time.time() * 1000)
        )
        obj.save()
        return obj.to_dict(include_meta=True)

# ----------------------------------------------------------------------------------------------------------------------
# Tracking
# ----------------------------------------------------------------------------------------------------------------------


class ESViewRecord(models.Model):

    view_name = models.CharField(max_length=20)
    run_env_type = models.TextField()
    host = models.TextField(default='')

    def indexing(self):
        obj = ESViewRecordIndex(
            view_name=self.view_name,
            run_env_type=settings.RUN_ENV,
            host=socket.gethostname(),
            request_date=int(time.time() * 1000)
        )
        obj.save()
        return obj.to_dict(include_meta=True)

# ----------------------------------------------------------------------------------------------------------------------
# Download Jobs
# ----------------------------------------------------------------------------------------------------------------------


# This is to keep track of the status of a download job
class DownloadJob(models.Model):
    job_id = models.TextField(max_length=250)
    progress = models.PositiveSmallIntegerField(default=0)
    total_items = models.PositiveIntegerField(default=0)
    raw_columns_to_download = models.TextField(null=True)
    raw_query = models.TextField(null=True)

    QUEUED = 'QUEUED'
    PROCESSING = 'PROCESSING'
    ERROR = 'ERROR'
    FINISHED = 'FINISHED'
    STATUSES = (
        (QUEUED, QUEUED),
        (PROCESSING, PROCESSING),
        (FINISHED, FINISHED),
        (ERROR, ERROR),
    )
    status = models.CharField(max_length=20, choices=STATUSES, default=QUEUED)
    index_name = models.CharField(max_length=200, null=True)
    desired_format = models.CharField(max_length=200, null=True)
    worker = models.TextField(max_length=250, null=True)
    log = models.TextField(null=True)

