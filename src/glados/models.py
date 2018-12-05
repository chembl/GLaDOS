from django.db import models
from glados.es_models import TinyURLIndex, ESCachedRequestIndex
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


# This is to keep track of the status of a download job
class DownloadJob(models.Model):
    job_id = models.TextField(primary_key=True)
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

