from django.test import RequestFactory, TestCase, override_settings
from django.conf import settings
import os
import json
from django.urls import reverse


class DownloadJobsControllerTester(TestCase):

    CONFIG_TEST_FILE = os.path.join(settings.GLADOS_ROOT, 'api/chembl/dynamic_downloads/tests/data/test_override.yml')
    GROUPS_TEST_FILE = os.path.join(settings.GLADOS_ROOT, 'api/chembl/dynamic_downloads/tests/data/test_groups.yml')

    def setUp(self):
        self.request_factory = RequestFactory()

    @override_settings(PROPERTIES_GROUPS_FILE=GROUPS_TEST_FILE, PROPERTIES_CONFIG_OVERRIDE_FILE=CONFIG_TEST_FILE)
    def test_queues_download_job(self):
        test_search_context_path = os.path.join(settings.SSSEARCH_RESULTS_DIR, 'test_search_context.json')
        test_raw_context = [{
            'molecule_chembl_id': 'CHEMBL59',
            'similarity': 100.0
        }]

        with open(test_search_context_path, 'wt') as test_search_file:
            test_search_file.write(json.dumps(test_raw_context))

        request = self.request_factory.get(reverse('queue-download'))

        os.remove(test_search_context_path)