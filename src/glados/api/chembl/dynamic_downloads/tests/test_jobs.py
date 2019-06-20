from django.test import TestCase
from glados.api.chembl.dynamic_downloads import jobs

class DownloadJobsTester(TestCase):

    def test_make_download_file(self):
        print('------------------------------------------------------------------------')
        print('test_make_download_file!!!')
        print('------------------------------------------------------------------------')
