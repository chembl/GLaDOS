from glados.es_models import TinyURLIndex, ESCachedRequestIndex, ESDownloadRecordIndex, ESViewRecordIndex, \
    ESSearchRecordIndex, ESTinyURLUsageRecordIndex
import time

from django.db import models
from django.conf import settings
import socket


class TinyURL(models.Model):
    long_url = models.TextField()
    hash = models.CharField(max_length=100)
    expires = models.BigIntegerField(null=True)

    def indexing(self):
        obj = TinyURLIndex(
            meta={'id': self.hash},
            long_url=self.long_url,
            hash=self.hash,
            expires=self.expires
        )
        obj.save(refresh='wait_for')
        return obj.to_dict(include_meta=True)


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
            request_date=int(time.time() * 1000)
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


class ESTinyURLUsageRecord(models.Model):
    URL_SHORTENED = 'URL_SHORTENED'
    URL_EXPANDED = 'URL_EXPANDED'

    EVENTS = (
        (URL_SHORTENED, URL_SHORTENED),
        (URL_EXPANDED, URL_EXPANDED)
    )

    event = models.CharField(max_length=200, choices=EVENTS)
    host = models.TextField(default='')
    run_env_type = models.TextField()

    def indexing(self):
        obj = ESTinyURLUsageRecordIndex(
            event=self.event,
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
    view_name = models.CharField(max_length=20, default='')
    view_type = models.CharField(max_length=100, default='')
    entity_name = models.CharField(max_length=100, default='')
    run_env_type = models.TextField()
    host = models.TextField(default='')

    def indexing(self):
        obj = ESViewRecordIndex(
            view_name=self.view_name,
            view_type=self.view_type,
            entity_name=self.entity_name,
            run_env_type=settings.RUN_ENV,
            host=socket.gethostname(),
            request_date=int(time.time() * 1000)
        )
        obj.save()
        return obj.to_dict(include_meta=True)


class ESSearchRecord(models.Model):
    FREE_TEXT = 'FREE_TEXT'
    SUBSTRUCTURE = 'SUBSTRUCTURE'
    SIMILARITY = 'SIMILARITY'
    CONNECTIVITY = 'CONNECTIVITY'
    BLAST = 'BLAST'
    OTHER = 'OTHER'

    SEARCH_TYPES = (
        (FREE_TEXT, FREE_TEXT),
        (SUBSTRUCTURE, SUBSTRUCTURE),
        (SIMILARITY, SIMILARITY),
        (CONNECTIVITY, CONNECTIVITY),
        (BLAST, BLAST),
        (OTHER, OTHER)
    )

    search_type = models.CharField(max_length=20, choices=SEARCH_TYPES, default=OTHER)
    run_env_type = models.TextField()
    host = models.TextField(default='')
    time_taken = models.IntegerField(default=0)
    is_new = models.BooleanField(default=True)

    def indexing(self):
        obj = ESSearchRecordIndex(
            search_type=self.search_type,
            time_taken=self.time_taken,
            is_new=self.is_new,
            run_env_type=settings.RUN_ENV,
            host=socket.gethostname(),
            request_date=int(time.time() * 1000)
        )
        obj.save()
        return obj.to_dict(include_meta=True)
