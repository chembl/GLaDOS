"""
Module that loads contexts from results
"""
from django.conf import settings

import requests


class ContextLoaderError(Exception):
    """Base class for exceptions in this module."""

WEB_RESULTS_SIZE_LIMIT = settings.FILTER_QUERY_MAX_CLAUSES


def get_context_url(context_dict):
    """
    returns the url for loading the context
    :param context_dict: dict describing
    """
    return settings.DELAYED_JOBS_BASE_URL + '/outputs' + '/' + context_dict['context_id'] + '/results.json'


def get_context(context_dict):
    """
    Returns the context described by the context dict
    :param context_dict: dictionary describing the context
    :return: the context loaded as an object
    """
    context_url = get_context_url(context_dict)
    context_request = requests.get(context_url)

    if context_request.status_code != 200:
        raise ContextLoaderError('There was an error while loading the context: ' + context_request.text)

    results = context_request.json()['search_results']

    total_results = len(results)
    if total_results > WEB_RESULTS_SIZE_LIMIT:
        results = results[0:WEB_RESULTS_SIZE_LIMIT]

    return results, total_results

