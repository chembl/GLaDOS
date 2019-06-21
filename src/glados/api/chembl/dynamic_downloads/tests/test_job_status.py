from django.test import TestCase
from glados.api.chembl.dynamic_downloads import job_status


class DownloadJobsTester(TestCase):

    def test_creates_job(self):
        print('------------------------------------------------------------------------')
        print('test_creates_job!!!')
        print('------------------------------------------------------------------------')