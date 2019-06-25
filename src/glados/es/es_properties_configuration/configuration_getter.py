import glados.es.ws2es.resources_description as resources_description
from glados.es.ws2es.util import SummableDict
from glados.es.ws2es import resources_description
import yaml
from django.conf import settings
from django.core.cache import cache


class ESPropsConfigurationGetterError(Exception):
    """Base class for exceptions in GLaDOS configuration."""
    pass


CACHE_TIME = 3600


def get_config_for_prop(index_name, prop_id):
    cache_key = 'property_config-{index_name}-{prop_id}'.format(index_name=index_name, prop_id=prop_id)
    cache_response = cache.get(cache_key)
    if cache_response is not None:
        return cache_response

    index_mapping = resources_description.RESOURCES_BY_ALIAS_NAME.get(index_name)
    if index_mapping is None:
        raise ESPropsConfigurationGetterError("The index {} does not exist!".format(index_name))

    # Search for description in Elasticsearch
    simplified_mapping = index_mapping.get_simplified_mapping_from_es()
    es_property_description = simplified_mapping.get(prop_id)

    found_in_es = es_property_description is not None
    if not found_in_es:
        es_property_description = {}

    # Search for description in override
    config_override = yaml.load(open(settings.PROPERTIES_CONFIG_OVERRIDE_FILE, 'r'), Loader=yaml.FullLoader)
    found_in_override = False
    if config_override is not None:
        index_override = config_override.get(index_name)
        if index_override is not None:
            property_override_description = index_override.get(prop_id)
            found_in_override = property_override_description is not None

    config = {}
    if not found_in_es and not found_in_override:
        raise ESPropsConfigurationGetterError("The property {} does not exist in elasticsearch or as virtual property"
                                              .format(prop_id))

    elif found_in_es and not found_in_override:

        config = SummableDict({
            'index_name': index_name,
            'prop_id': prop_id,
        })
        config += SummableDict(es_property_description)

    elif not found_in_es and found_in_override:
        # this is a virtual property
        config = SummableDict({
            'index_name': index_name,
            'prop_id': prop_id,
        })

        based_on = property_override_description.get('based_on')
        if based_on is not None:
            base_description = simplified_mapping.get(based_on)
            if base_description is None:
                raise ESPropsConfigurationGetterError(
                    'The virtual property {prop_id} is based on {based_on} which does not exist in elasticsearch '
                    'index {index_name}'.format(prop_id=prop_id, based_on=based_on, index_name=index_name))
            config += SummableDict(base_description)
        else:
            if property_override_description.get('aggregatable') is None or \
                            property_override_description.get('type') is None or \
                            property_override_description.get('sortable') is None:
                raise ESPropsConfigurationGetterError('A contextual property must define the type and if it is '
                                                      'aggregatable and sortable')

        config += property_override_description

    elif found_in_es and found_in_override:
        # this is a normal
        config = SummableDict({
            'index_name': index_name,
            'prop_id': prop_id,
        })
        config += SummableDict(es_property_description)
        config += property_override_description

    cache.set(cache_key, config, CACHE_TIME)
    return config


def get_config_for_props_list(index_name, prop_ids):
    configs = []

    for prop_id in prop_ids:
        configs.append(get_config_for_prop(index_name, prop_id))

    return configs


def get_config_for_group(index_name, group_name):
    groups_config = yaml.load(open(settings.PROPERTIES_GROUPS_FILE, 'r'), Loader=yaml.FullLoader)
    if groups_config is None:
        raise ESPropsConfigurationGetterError("There is no configuration for groups")

    index_mapping = resources_description.RESOURCES_BY_ALIAS_NAME.get(index_name)
    if index_mapping is None:
        raise ESPropsConfigurationGetterError("The index {} does not exist!".format(index_name))

    index_groups = groups_config.get(index_name, {})
    group_config = index_groups.get(group_name)
    if group_config is None:
        raise ESPropsConfigurationGetterError("The group {} does not exist!".format(group_name))

    configs = {}

    for sub_group, props_list in group_config.items():
        if sub_group != '__default_sorting__':
            configs[sub_group] = get_config_for_props_list(index_name, props_list)
        else:
            configs[sub_group] = props_list

    return configs


def get_id_property_for_index(index_name):
    resources_desc = resources_description.RESOURCES_BY_ALIAS_NAME
    resource_desc = resources_desc.get(index_name)
    if resource_desc is None:
        raise ESPropsConfigurationGetterError('The index {} does not exist.'.format(index_name))

    resource_ids = resource_desc.resource_ids
    if len(resource_ids) > 1:
        raise ESPropsConfigurationGetterError('The index {} has a compound id. Which is not supported yet'
                                              .format(index_name))

    return resource_ids[0]
