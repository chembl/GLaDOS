import glados.ws2es.es_util as es_util


def get_config_for(index_name, prop_id):

    index_mapping = es_util.get_index_mapping(index_name)

    print('index_mapping: ', index_mapping)
    config = {
        'index_name': index_name,
        'prop_id': prop_id,
    }

    return config
