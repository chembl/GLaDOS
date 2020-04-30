"""
Module to test the context loader
"""
import unittest

from django.conf import settings

from glados.api.chembl.list_pagination.services import context_loader


class TestContextLoader(unittest.TestCase):
    """
    Class to test the functions used in the context loader
    """

    def test_generates_the_correct_context_url(self):
        """
        Tests that generates the initial url to load a context
        """
        context_dict = {
            'context_type': 'SIMILARITY',
            'context_id': 'STRUCTURE_SEARCH-V4s_piFIe9FL7sOuJ0jl6U0APMEsoV-b4HfFE_dtojc='
        }

        context_url_must_be = settings.DELAYED_JOBS_BASE_URL + '/outputs' + '/' + context_dict[
            'context_id'] + '/results.json'

        context_url_got = context_loader.get_context_url(context_dict)

        self.assertEqual(context_url_must_be, context_url_got, msg='The context url was not generated correctly!')
