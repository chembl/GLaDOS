from django.test import TestCase, override_settings
from glados.api.shared.dynamic_downloads.models import DownloadJob
import json
import os
from django.conf import settings
from glados.api.shared.dynamic_downloads import download_job_service
from datetime import timezone
from glados.es_connection import setup_glados_es_connection, DATA_CONNECTION, MONITORING_CONNECTION


class DownloadJobsServiceTester(TestCase):
    CONFIG_TEST_FILE = os.path.join(settings.GLADOS_ROOT, 'api/shared/dynamic_downloads/tests/data/test_override.yml')
    GROUPS_TEST_FILE = os.path.join(settings.GLADOS_ROOT, 'api/shared/dynamic_downloads/tests/data/test_groups.yml')

    def setUp(self):
        DownloadJob.objects.all().delete()
        setup_glados_es_connection(connection_type=DATA_CONNECTION)
        setup_glados_es_connection(connection_type=MONITORING_CONNECTION)

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

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'

        job_id = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        download_job_got = DownloadJob.objects.get(job_id=job_id)

        id_property_must_be = 'molecule_chembl_id'
        id_property_got = download_job_got.id_property
        self.assertEqual(id_property_must_be, id_property_got, msg='The id property was not set correctly!')

        columns_to_download_must_be = [
            {'aggregatable': True, 'type': 'string', 'label': 'ChEMBL ID', 'prop_id': 'molecule_chembl_id',
             'sortable': True, 'index_name': settings.CHEMBL_ES_INDEX_PREFIX+'molecule', 'label_mini': 'ChEMBL ID'},
            {'aggregatable': True, 'type': 'string', 'label': 'Name', 'prop_id': 'pref_name', 'sortable': True,
             'index_name': settings.CHEMBL_ES_INDEX_PREFIX+'molecule', 'label_mini': 'Name'}]

        raw_columns_to_download_got = download_job_got.raw_columns_to_download
        columns_to_download_got = json.loads(raw_columns_to_download_got)

        self.assertEqual(columns_to_download_must_be, columns_to_download_got,
                         msg='The columns to download were not set correctly')

        os.remove(test_search_context_path)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_queues_download_job_with_custom_groups(self):

        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'

        custom_columns_group = 'download_drugs'
        job_id = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id,
                                                         custom_columns_group)
        download_job_got = DownloadJob.objects.get(job_id=job_id)

        id_property_must_be = 'molecule_chembl_id'
        id_property_got = download_job_got.id_property
        self.assertEqual(id_property_must_be, id_property_got, msg='The id property was not set correctly!')

        columns_to_download_must_be = [
            {'aggregatable': True, 'label_mini': 'ChEMBL ID', 'type': 'string', 'prop_id': 'molecule_chembl_id',
             'sortable': True, 'index_name': settings.CHEMBL_ES_INDEX_PREFIX+'molecule', 'label': 'ChEMBL ID'},
            {'aggregatable': True, 'label_mini': 'Max Phase', 'type': 'integer', 'prop_id': 'max_phase',
             'sortable': True, 'index_name': settings.CHEMBL_ES_INDEX_PREFIX+'molecule', 'label': 'Max Phase'}]

        raw_columns_to_download_got = download_job_got.raw_columns_to_download
        columns_to_download_got = json.loads(raw_columns_to_download_got)

        self.assertEqual(columns_to_download_must_be, columns_to_download_got,
                         msg='The columns to download were not set correctly')

        os.remove(test_search_context_path)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_does_not_queue_job_when_already_exists(self):

        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'

        # Queue the job for the first time
        job_id_0 = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        download_job_got_0 = DownloadJob.objects.get(job_id=job_id_0)
        expires_0 = download_job_got_0.expires
        log_0 = download_job_got_0.log

        # Queue a job again with exactly the same parameters
        job_id_1 = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        download_job_got_1 = DownloadJob.objects.get(job_id=job_id_1)
        expires_1 = download_job_got_1.expires
        log_1 = download_job_got_1.log

        self.assertEqual(job_id_0, job_id_1, msg='The ids should be exactly the same.')
        self.assertEqual(expires_0, expires_1, msg='The expiration time should have never been changed.')
        self.assertEqual(log_0, log_1, msg='The logs should be the same, because the job was not run again.')

        os.remove(test_search_context_path)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_requeues_job_when_was_in_error(self):

        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'

        # Queue the job for the first time
        job_id_0 = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        download_job_got_0 = DownloadJob.objects.get(job_id=job_id_0)
        expires_0 = download_job_got_0.expires
        log_0 = download_job_got_0.log

        # now simulate an error in the job
        download_job_got_0.status = DownloadJob.ERROR
        download_job_got_0.save()

        # Queue a job again with exactly the same parameters
        job_id_1 = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        download_job_got_1 = DownloadJob.objects.get(job_id=job_id_1)
        expires_1 = download_job_got_1.expires
        log_1 = download_job_got_1.log

        self.assertEqual(job_id_0, job_id_1, msg='The ids should be exactly the same.')
        self.assertNotEqual(expires_0, expires_1, msg='The expiration time should have changed.')
        self.assertNotEqual(log_0, log_1, msg='The logs should be the different, because the job was run again.')

        os.remove(test_search_context_path)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_requeues_job_when_file_is_missing(self):

        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'

        # Queue the job for the first time
        job_id_0 = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        download_job_got_0 = DownloadJob.objects.get(job_id=job_id_0)
        expires_0 = download_job_got_0.expires
        log_0 = download_job_got_0.log

        # now delete the download file
        file_path = download_job_got_0.file_path
        os.remove(file_path)

        # Queue a job again with exactly the same parameters
        job_id_1 = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        download_job_got_1 = DownloadJob.objects.get(job_id=job_id_1)
        expires_1 = download_job_got_1.expires
        log_1 = download_job_got_1.log

        self.assertEqual(job_id_0, job_id_1, msg='The ids should be exactly the same.')
        self.assertNotEqual(expires_0, expires_1, msg='The expiration time should have changed.')
        self.assertNotEqual(log_0, log_1, msg='The logs should be the different, because the job was run again.')
        try:
            file_size = os.path.getsize(download_job_got_1.file_path)
        except FileNotFoundError:
            self.fail('The file was not created again!')

        os.remove(test_search_context_path)

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_returns_status_of_a_job(self):

        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
        raw_query = '{"query_string": {"query": "molecule_chembl_id:(CHEMBL59)"}}'
        desired_format = 'csv'
        context_id = 'test_search_context'

        job_id = download_job_service.queue_download_job(index_name, raw_query, desired_format, context_id)
        download_job_got = DownloadJob.objects.get(job_id=job_id)

        response_got = download_job_service.get_download_status(job_id)
        satus_got = response_got['status']
        status_must_be = download_job_got.status
        self.assertEqual(satus_got, status_must_be, msg='The status was not given correctly!')

        percentage_got = response_got['percentage']
        percentage_must_be = download_job_got.progress
        self.assertEqual(percentage_got, percentage_must_be, msg='The progress was not given correctly!')

        expires_got = response_got['expires']
        expires_must_be = download_job_got.expires.replace(tzinfo=timezone.utc).isoformat()
        self.assertEqual(expires_got, expires_must_be, msg='The sexpiration time was not given correctly!')

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_raises_error_when_job_does_not_exist(self):

        with self.assertRaises(DownloadJob.DoesNotExist,
                               msg='This should raise an error because the download does not exist'):
            download_job_service.get_download_status('does_not_exist')
