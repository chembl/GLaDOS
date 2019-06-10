import sys
import glados.ws2es.es_util as es_util
import glados.ws2es.es_resources_desc as es_resources_desc
import glados.ws2es.migration_logging as migration_logging
import glados.ws2es.es_mappings_skeleton_generator as es_mappings_skeleton_generator
import glados.ws2es.resources_description as resources_description
import subprocess
import importlib
from glados.ws2es.resources_metadata import resources_metadata
import copy

__author__ = 'jfmosquera@ebi.ac.uk'

# ----------------------------------------------------------------------------------------------------------------------
# LOGGING
# ----------------------------------------------------------------------------------------------------------------------

migration_logging.setup_migration_logging()
MIG_LOG = migration_logging.get_logger()

# ----------------------------------------------------------------------------------------------------------------------
# ELASTIC SEARCH
# ----------------------------------------------------------------------------------------------------------------------

MIG_TRIED_COUNT = {res_i: 0 for res_i in resources_description.ALL_WS_RESOURCES_NAMES}
MIG_SUCCESS_COUNT = {res_i: 0 for res_i in resources_description.ALL_WS_RESOURCES_NAMES}
MIG_TOTAL = {res_i: 0 for res_i in resources_description.ALL_WS_RESOURCES_NAMES}

UPDATE_AUTOCOMPLETE_ONLY = False


def get_index_name(res_name):
    return resources_description.RESOURCES_BY_RES_NAME[res_name].idx_name


def get_alias_name(res_name):
    return resources_description.RESOURCES_BY_RES_NAME[res_name].idx_alias


def create_res_idx(res_name, num_docs):
    global MIG_TOTAL
    MIG_TOTAL[res_name] = num_docs
    if UPDATE_AUTOCOMPLETE_ONLY:
        return
    idx_desc = es_resources_desc.resources_2_es_mapping.get(res_name, None)
    idx_name = get_index_name(res_name)
    n_shards = getattr(idx_desc, 'shards', es_util.num_shards_by_num_rows(num_docs))
    n_replicas = getattr(idx_desc, 'replicas', 1)
    res_analysis = getattr(idx_desc, 'analysis', None)
    res_mappings = getattr(idx_desc, 'mappings', None)
    es_util.create_idx(
                        idx_name,
                        shards=n_shards,
                        replicas=n_replicas,
                        analysis=res_analysis,
                        mappings=res_mappings,
                        logger=MIG_LOG
                      )
    MIG_LOG.info("ELASTIC INDEX CREATED: RESOURCE:{0}->INDEX:{1} SHARDS:{2} REPLICAS:{3}"
                 .format(res_name, idx_name, n_shards, n_replicas))


def update_res_idx(res_name):
    global MIG_TOTAL
    idx_desc = es_resources_desc.resources_2_es_mapping.get(res_name, None)
    idx_name = get_index_name(res_name)
    res_mappings = getattr(idx_desc, 'mappings', None)
    es_util.update_mappings_idx(idx_name, res_mappings)
    MIG_LOG.info("ELASTIC INDEX MAPPINGS UPDATED: RESOURCE:{0}->INDEX:{1}"
                 .format(res_name, idx_name))


def insert_in_dict_keep_max_value(dictionary: dict, key, value):
    dictionary[key] = max(dictionary.get(key, float('-inf')), value)


def insert_all_in_dict_keep_max(dic_1: dict, dict_2: dict):
    for dict_2_key_i in dict_2:
        insert_in_dict_keep_max_value(dic_1, dict_2_key_i, dict_2[dict_2_key_i])


def __get_autocomplete_data_recursive(cur_autocomplete_desc: dict, cur_doc_location):
    autocomplete_data = {}
    for autocomplete_path in cur_autocomplete_desc.keys():
        value = cur_autocomplete_desc[autocomplete_path]
        data_cur_level = cur_doc_location[autocomplete_path]
        if data_cur_level is None:
            continue
        if isinstance(value, (int, float)):
            if isinstance(data_cur_level, (list, set)):
                for data_list_i in data_cur_level:
                    if not isinstance(data_list_i, str):
                        raise Exception('Error, {0} is not of str type!'.format(data_list_i))
                    insert_in_dict_keep_max_value(autocomplete_data, data_list_i, value)
            elif isinstance(data_cur_level, (str, int, float)):
                insert_in_dict_keep_max_value(autocomplete_data, '{0}'.format(data_cur_level), value)
            else:
                print(data_cur_level, type(data_cur_level), file=sys.stderr)
                raise Exception('Error, {0} is not of None|str|int|float|list|set type!'.format(data_cur_level))
        elif isinstance(data_cur_level, (list, set)):
            for next_level_i in data_cur_level:
                next_level_data = __get_autocomplete_data_recursive(value, next_level_i)
                insert_all_in_dict_keep_max(autocomplete_data, next_level_data)
        elif isinstance(data_cur_level, dict):
            next_level_data = __get_autocomplete_data_recursive(value, data_cur_level)
            insert_all_in_dict_keep_max(autocomplete_data, next_level_data)
        else:
            raise Exception('Error, malformed document contains unknown type ({0})!'.format(type(data_cur_level)))
    return autocomplete_data


def fill_autocomplete(res_name, res_doc):
    idx_desc = es_resources_desc.resources_2_es_mapping.get(res_name, None)
    res_autocomplete_desc = getattr(idx_desc, 'autocomplete_settings', None)
    if res_autocomplete_desc:
        autocomplete_data = __get_autocomplete_data_recursive(res_autocomplete_desc, res_doc)
        for autocomplete_data_i in autocomplete_data.keys():
            if len(autocomplete_data_i) > 2:
                res_doc['_metadata']['es_completion'].append(
                    {
                        'input': autocomplete_data_i,
                        'weight': autocomplete_data[autocomplete_data_i]
                    }
                )


def write_res_doc2es_first_id(res_name, res_id_fields, res_doc):
    global MIG_TRIED_COUNT, MIG_SUCCESS_COUNT

    if res_name in resources_metadata:
        res_doc['_metadata'] = copy.deepcopy(resources_metadata[res_name])

    fill_autocomplete(res_name, res_doc)

    idx_name = get_index_name(res_name)
    MIG_TRIED_COUNT[res_name] += 1

    doc_id = resources_description.RESOURCES_BY_RES_NAME[res_name].get_doc_id(res_doc)

    if UPDATE_AUTOCOMPLETE_ONLY and '_metadata' in res_doc and 'es_completion' in res_doc['_metadata']\
            and res_doc['_metadata']['es_completion']:
        es_util.update_doc_bulk(idx_name, doc_id, doc={
            '_metadata': {
                'es_completion': res_doc['_metadata']['es_completion']
            }
        })
    else:
        es_util.index_doc_bulk(idx_name, doc_id, res_doc, logger=MIG_LOG)


def generate_mapping_skeleton_file(res_name):
    idx_name = get_index_name(res_name)
    es_mappings_skeleton_generator.generate_mapping_skeleton(idx_name)


def generate_mappings_for_resources(resources=None):
    imports = ''
    descriptions = '    {\n'
    es_mappings_skeleton_generator.check_ws_vs_es_counts()
    for res_i in sorted(resources_description.ALL_WS_RESOURCES_NAMES):
        if resources and res_i not in resources:
            continue
        index_alias = get_alias_name(res_i)
        index_name = get_index_name(res_i)
        module_name = es_mappings_skeleton_generator.MODULE_PATTERN.format(index_alias)
        es_mappings_skeleton_generator.generate_mapping_skeleton(index_name)
        imports += 'import glados.ws2es.mappings.{0} as {0}\n'.format(module_name)
        descriptions += '        \'{0}\': {1},\n'.format(res_i, module_name)
    descriptions += "    }\n"
    print(imports)
    print(descriptions)
    print('COMPARISON WITH EXISTING MAPPINGS!-------------------------------------------------------------------------')
    es_mappings_skeleton_generator.compare_mappings(resources)
