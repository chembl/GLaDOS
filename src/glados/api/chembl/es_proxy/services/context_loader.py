"""
Module that loads contexts from results
"""
from django.conf import settings
from django.core.cache import cache

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


def load_context_index(context_id, id_property, context):
    """
    Loads an index based on the id property of the context, for fast access
    :param context_id: id of the context loaded
    :param id_property: property used to identify each item
    :param context: context loaded
    :return:
    """

    context_index_key = 'context_index-{}'.format(context_id)
    context_index = cache.get(context_index_key)
    if context_index is None:
        context_index = {}

        for index, item in enumerate(context):
            context_index[item[id_property]] = item
            context_index[item[id_property]]['index'] = index

        cache.set(context_index_key, context_index, 3600)

    return context_index

