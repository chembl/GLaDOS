"""
Module that loads contexts from results
"""
from django.conf import settings


def get_context_url(context_dict):
    """
    returns the url for loading the context
    :param context_dict: dict describing
    """
    return settings.DELAYED_JOBS_BASE_URL + '/outputs' + '/' + context_dict['context_id'] + '/results.json'