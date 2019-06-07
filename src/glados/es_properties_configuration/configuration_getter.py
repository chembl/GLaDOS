import glados.ws2es.resources_description as resources_description


class ESPropsConfigurationGetterError(Exception):
    """Base class for exceptions in GLaDOS configuration."""
    pass


def get_config_for(index_name, prop_id):

    print('index_name: ', index_name)
    print('RESOURCES_BY_ALIAS_NAME: ', resources_description.RESOURCES_BY_ALIAS_NAME)
    index_mapping = resources_description.RESOURCES_BY_ALIAS_NAME.get(index_name)
    print('index_mapping: ', index_mapping)
    if index_mapping is None:
        raise ESPropsConfigurationGetterError("The index {} does not exist!".format(index_name))

    # simplified_mapping = index_mapping.get_simplified_mapping_from_es()
    # print('simplified_mapping: ', simplified_mapping)

    # print('index_mapping: ', index_mapping)
    config = {
        'index_name': index_name,
        'prop_id': prop_id,
    }

    return config
