import glados.ws2es.resources_description as resources_description
from glados.ws2es.util import SummableDict


class ESPropsConfigurationGetterError(Exception):
    """Base class for exceptions in GLaDOS configuration."""
    pass


def get_config_for(index_name, prop_id):

    index_mapping = resources_description.RESOURCES_BY_ALIAS_NAME.get(index_name)
    if index_mapping is None:
        raise ESPropsConfigurationGetterError("The index {} does not exist!".format(index_name))

    simplified_mapping = index_mapping.get_simplified_mapping_from_es()
    property_description = simplified_mapping.get(prop_id)
    if property_description is None:
        raise ESPropsConfigurationGetterError("The property {} does not exist!".format(prop_id))

    print('property_description: ', property_description)

    # print('index_mapping: ', index_mapping)
    config = SummableDict({
        'index_name': index_name,
        'prop_id': prop_id,
    })

    config += SummableDict(property_description)
    return config
