import glados.ws2es.resources_description as resources_description
from glados.ws2es.util import SummableDict
import yaml
from django.conf import settings
from django.core.cache import cache
import base64
import hashlib


class ESPropsConfigurationGetterError(Exception):
    """Base class for exceptions in GLaDOS configuration."""
    pass

CACHE_TIME = 3600


def get_config_for(index_name, prop_id):

    cache_key = 'property_config-{index_name}-{prop_id}'.format(index_name=index_name, prop_id=prop_id)
    cache_response = cache.get(cache_key)
    if cache_response is not None:
        return cache_response

    index_mapping = resources_description.RESOURCES_BY_ALIAS_NAME.get(index_name)
    if index_mapping is None:
        raise ESPropsConfigurationGetterError("The index {} does not exist!".format(index_name))

    simplified_mapping = index_mapping.get_simplified_mapping_from_es()
    property_description = simplified_mapping.get(prop_id)
    if property_description is None:
        raise ESPropsConfigurationGetterError("The property {} does not exist!".format(prop_id))

    # print('index_mapping: ', index_mapping)
    config = SummableDict({
        'index_name': index_name,
        'prop_id': prop_id,
    })

    config += SummableDict(property_description)

    config_override = yaml.load(open(settings.PROPERTIES_CONFIG_OVERRIDE_FILE, 'r'), Loader=yaml.FullLoader)
    property_override = config_override[index_name].get(prop_id)
    if property_override is not None:
        config += SummableDict(property_override)

    cache.set(cache_key, config, CACHE_TIME)
    return config


def get_config_for_props_list(index_name, prop_ids):
    pass

def get_config_for_group(index_name, group_name):

    index_mapping = resources_description.RESOURCES_BY_ALIAS_NAME.get(index_name)
    if index_mapping is None:
        raise ESPropsConfigurationGetterError("The index {} does not exist!".format(index_name))