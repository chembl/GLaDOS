from django.test import RequestFactory, TestCase, override_settings
from django.conf import settings
import os
import json
from django.urls import reverse
from glados.api.chembl.dynamic_downloads import downloads_controller
from glados.api.chembl.dynamic_downloads.models import DownloadJob
import glados.es.ws2es.es_util as es_util
from glados.settings import RunEnvs


class DownloadJobsControllerTester(TestCase):

    CONFIG_TEST_FILE = os.path.join(settings.GLADOS_ROOT, 'api/chembl/dynamic_downloads/tests/data/test_override.yml')
    GROUPS_TEST_FILE = os.path.join(settings.GLADOS_ROOT, 'api/chembl/dynamic_downloads/tests/data/test_groups.yml')

    def setUp(self):
        DownloadJob.objects.all().delete()
        self.request_factory = RequestFactory()
        if settings.RUN_ENV == RunEnvs.TRAVIS:
            es_util.setup_connection_from_full_url(settings.ELASTICSEARCH_EXTERNAL_URL)
        else:
            es_util.setup_connection_from_full_url(settings.ELASTICSEARCH_HOST)

    def tearDown(self):
        DownloadJob.objects.all().delete()

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_queues_download_job(self):
        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        index_name = 'chembl_molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'

        data = {
            'index_name': index_name,
            'query': raw_query,
            'format': desired_format,
            'context_id': context_id
        }

        request = self.request_factory.post(reverse('queue_download'), data)
        response_got = downloads_controller.queue_download_job(request)
        data_got = json.loads(response_got.content.decode('utf-8'))
        job_id_got = data_got['download_id']
        download_job_got = DownloadJob.objects.get(job_id=job_id_got)

        os.remove(test_search_context_path)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_queues_download_job_with_custom_group(self):
        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        index_name = 'chembl_molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'
        custom_download_columns_group = 'download_drugs'

        data = {
            'index_name': index_name,
            'query': raw_query,
            'format': desired_format,
            'context_id': context_id,
            'download_columns_group': custom_download_columns_group
        }

        request = self.request_factory.post(reverse('queue_download'), data)
        response_got = downloads_controller.queue_download_job(request)
        data_got = json.loads(response_got.content.decode('utf-8'))
        job_id_got = data_got['download_id']
        download_job_got = DownloadJob.objects.get(job_id=job_id_got)

        os.remove(test_search_context_path)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_returns_download_job_status(self):
        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        index_name = 'chembl_molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'

        data = {
            'index_name': index_name,
            'query': raw_query,
            'format': desired_format,
            'context_id': context_id
        }

        queue_job_request = self.request_factory.post(reverse('queue_download'), data)
        response_got = downloads_controller.queue_download_job(queue_job_request)
        data_got = json.loads(response_got.content.decode('utf-8'))
        job_id_got = data_got['download_id']

        job_status_url = reverse('get_download_status', args=[job_id_got])
        job_status_request = self.request_factory.get(job_status_url)
        job_status_response = downloads_controller.get_download_status(job_status_request, job_id_got)
        status_data_got = json.loads(job_status_response.content.decode('utf-8'))

        os.remove(test_search_context_path)
