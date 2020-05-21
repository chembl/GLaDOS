import os
import re
from glados.es.ws2es.resources_description import ALL_WS_RESOURCES, RESOURCES_BY_IDX_NAME
from glados.es.ws2es.es_util import es_util, DefaultMappings
import glados.es.ws2es.es_resources_desc as es_resources_desc
import glados.es.ws2es.resources_description as resources_description
import requests
import traceback
import sys
from glados.es.ws2es.util import get_js_path_from_dict

__author__ = 'jfmosquera@ebi.ac.uk'

FILES_DIR = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'mappings_skeletons')
FILE_HEADER = '# Elastic search mapping definition for the Molecule entity\n'
FILE_HEADER += 'from glados.es.ws2es.es_util import DefaultMappings\n'
FILE_HEADER += '\n'
FILE_HEADER += '# Shards size - can be overridden from the default calculated value here\n'
FILE_HEADER += '# shards = 3,\n'
FILE_HEADER += 'replicas = 1\n'
FILE_HEADER += '\n'
FILE_HEADER += 'analysis = DefaultMappings.COMMON_ANALYSIS\n'
FILE_HEADER += '\n'
FILE_HEADER += 'mappings = \\\n'

MODULE_PATTERN = 'es_{0}_mapping.py'


def get_ws_count(resource):
    try:
        ws_url = '{0}/{1}.json?limit=1'.format(resources_description.WS_URL_TO_USE, resource)
        req = requests.get(ws_url)
        return req.json()['page_meta']['total_count']
    except:
        traceback.print_exc(file=sys.stderr)
        return -1


def is_numeric(var_value):
    try:
        float_value = float(var_value)
        return True
    except ValueError:
        return False


def is_boolean(var_value):
    return var_value is True or var_value is False or var_value.lower() == 'true' or var_value.lower() == 'false'


def infer_type(examples: list):
    inferred_type = 'TEXT'
    all_booleans = True
    all_numeric = True
    for ex_i in examples:
        # Removes extra quotes included in the examples
        ex_i = ex_i[1:-1]
        if not is_numeric(ex_i):
            all_numeric = False
        if not is_boolean(ex_i):
            all_booleans = False
        if not all_numeric and not all_booleans:
            break
    if all_booleans:
        inferred_type = 'BOOLEAN'
    elif all_numeric:
        inferred_type = 'NUMERIC'
    return inferred_type


def get_property_examples(es_index, es_property):
    examples = es_util.run_yaml_query(
        os.path.join(os.path.abspath(os.path.dirname(__file__)), './es_property_query.yaml'),
        es_index,
        {'<PROPERTY_NAME>': es_property}
    )
    examples_list = []
    for ex_i in examples:
        ex_value = get_js_path_from_dict(ex_i, es_property)
        example = ex_value
        if isinstance(ex_value, list):
            for list_val_i in ex_value:
                if list_val_i:
                    example = list_val_i
                    break
        if isinstance(example, list):
            if len(example) > 0:
                example = example[0]
            else:
                example = None
        examples_list.append(("'"+str(example)+"'"))
    str_examples = ' , '.join(examples_list)
    str_examples = re.sub(r'\s', ' ', str_examples)
    return str_examples, infer_type(examples_list)


def get_complete_property(es_property, parent_property):
    return (parent_property+'.' if parent_property else '')+es_property


def format_mappings_dict(es_index, data_dict, cur_indent=0, indent=4, append_comma=False,
                         current_parent_property=None, last_level_was_properties=False):
    output = ' '*cur_indent+'{\n'
    cur_indent += indent
    sorted_keys = sorted(data_dict.keys())
    max_line_length = 120
    for es_property in sorted_keys:
        es_property_val = data_dict[es_property]
        is_properties_level = False
        if es_property == 'properties' and not last_level_was_properties:
            property_i = current_parent_property
            is_properties_level = True
        else:
            property_i = get_complete_property(es_property, current_parent_property)

        if type(es_property_val) == dict and ((not is_properties_level and 'type' not in es_property_val) or
                                              is_properties_level):
            output += ' '*cur_indent+"'{0}': \n".format(es_property)
            output += format_mappings_dict(
                es_index, es_property_val, cur_indent=cur_indent, indent=indent,
                append_comma=(es_property != sorted_keys[-1]),
                current_parent_property=property_i, last_level_was_properties=is_properties_level
            )
        elif property_i:
            examples, inferred_type = get_property_examples(es_index, property_i)
            if examples:
                output += ' '*cur_indent+"'{0}': '{1}',\n".format(es_property, inferred_type)
                output += ' '*cur_indent+"# EXAMPLES:\n"
                length_chunk = max_line_length-cur_indent-2
                for chunk_index in range(0, len(examples), length_chunk):
                    output += ' ' * cur_indent + "# {0}\n".format(examples[chunk_index:chunk_index+length_chunk])
        else:
            print(es_index, property_i)

    cur_indent -= indent
    output += ' '*cur_indent+'}'+(',' if append_comma else '')+'\n'
    return output


def generate_mapping_skeleton(es_index):
    os.makedirs(FILES_DIR, exist_ok=True)
    alias = RESOURCES_BY_IDX_NAME[es_index].idx_alias
    with open(os.path.join(FILES_DIR, MODULE_PATTERN.format(alias)), 'w') as map_file:
        index_mapping = resources_description.RESOURCES_BY_IDX_NAME[es_index].get
        formatted_mappings = format_mappings_dict(es_index, index_mapping[es_index]['mappings'], cur_indent=4)
        map_file.write(FILE_HEADER)
        map_file.write(formatted_mappings)


def compare_mappings(resources=None):
    # import all the generated mappings only after the files have been generated
    import glados.es.ws2es.mappings_skeletons.es_chembl_activity_mapping as es_chembl_activity_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_activity_supplementary_data_by_activity_mapping as \
        es_chembl_activity_supplementary_data_by_activity_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_assay_mapping as es_chembl_assay_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_assay_class_mapping as es_chembl_assay_class_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_atc_class_mapping as es_chembl_atc_class_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_binding_site_mapping as es_chembl_binding_site_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_biotherapeutic_mapping as es_chembl_biotherapeutic_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_cell_line_mapping as es_chembl_cell_line_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_chembl_id_lookup_mapping as es_chembl_chembl_id_lookup_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_compound_record_mapping as es_chembl_compound_record_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_document_mapping as es_chembl_document_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_document_similarity_mapping as \
        es_chembl_document_similarity_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_drug_mapping as es_chembl_drug_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_drug_indication_mapping as es_chembl_drug_indication_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_go_slim_mapping as es_chembl_go_slim_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_mechanism_mapping as es_chembl_mechanism_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_metabolism_mapping as es_chembl_metabolism_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_molecule_mapping as es_chembl_molecule_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_molecule_form_mapping as es_chembl_molecule_form_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_organism_mapping as es_chembl_organism_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_protein_class_mapping as es_chembl_protein_class_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_source_mapping as es_chembl_source_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_target_mapping as es_chembl_target_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_target_component_mapping as es_chembl_target_component_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_target_relation_mapping as es_chembl_target_relation_mapping
    import glados.es.ws2es.mappings_skeletons.es_chembl_tissue_mapping as es_chembl_tissue_mapping

    generated_mappings = {
        'activity': es_chembl_activity_mapping,
        'activity_supplementary_data_by_activity':
            es_chembl_activity_supplementary_data_by_activity_mapping,
        'assay': es_chembl_assay_mapping,
        'assay_class': es_chembl_assay_class_mapping,
        'atc_class': es_chembl_atc_class_mapping,
        'binding_site': es_chembl_binding_site_mapping,
        'biotherapeutic': es_chembl_biotherapeutic_mapping,
        'cell_line': es_chembl_cell_line_mapping,
        'chembl_id_lookup': es_chembl_chembl_id_lookup_mapping,
        'compound_record': es_chembl_compound_record_mapping,
        'document': es_chembl_document_mapping,
        'document_similarity': es_chembl_document_similarity_mapping,
        'drug': es_chembl_drug_mapping,
        'drug_indication': es_chembl_drug_indication_mapping,
        'go_slim': es_chembl_go_slim_mapping,
        'mechanism': es_chembl_mechanism_mapping,
        'metabolism': es_chembl_metabolism_mapping,
        'molecule': es_chembl_molecule_mapping,
        'molecule_form': es_chembl_molecule_form_mapping,
        'organism': es_chembl_organism_mapping,
        'protein_class': es_chembl_protein_class_mapping,
        'source': es_chembl_source_mapping,
        'target': es_chembl_target_mapping,
        'target_component': es_chembl_target_component_mapping,
        'target_relation': es_chembl_target_relation_mapping,
        'tissue': es_chembl_tissue_mapping,
    }

    def get_full_prop_name(prop, parent):
        return (parent+'.' if parent else '')+prop

    numeric_types = [DefaultMappings.BYTE, DefaultMappings.SHORT, DefaultMappings.INTEGER, DefaultMappings.LONG,
                     DefaultMappings.FLOAT, DefaultMappings.DOUBLE]

    non_text_types = numeric_types+[DefaultMappings.BOOLEAN]

    def has_changed_defined_types_with_predicted_types(defined_type, predicted):
        if predicted == 'NUMERIC' and (defined_type in numeric_types or defined_type in [DefaultMappings.ID,
                                                                                         DefaultMappings.ID_REF,
                                                                                         DefaultMappings.KEYWORD]):
            return False
        elif predicted == 'BOOLEAN' and defined_type == DefaultMappings.BOOLEAN:
            return False
        elif predicted == 'TEXT' and defined_type not in non_text_types:
            return False
        return True

    def compare_old_and_new_mappings_recursive(old_m, new_m, cur_parent=None, include_type_change=True):
        mismatches_found = []
        old_key_set = set(old_m.keys())
        new_key_set = set(new_m.keys())
        removed_keys = sorted(list(old_key_set - new_key_set))
        added_keys = sorted(list(new_key_set - old_key_set))
        intersection_keys_sorted = sorted(list(new_key_set & old_key_set))
        for key_i in intersection_keys_sorted:
            next_parent = get_full_prop_name(key_i, cur_parent)
            next_old_m = old_m[key_i]
            next_new_m = new_m[key_i]
            if type(next_old_m) == dict and type(next_new_m) == dict:
                mismatches_found += compare_old_and_new_mappings_recursive(next_old_m, next_new_m, next_parent)
            elif include_type_change and has_changed_defined_types_with_predicted_types(next_old_m, next_new_m):
                mismatches_found.append(next_parent+": TYPE MIGHT HAVE CHANGED")
        for removed in removed_keys:
            mismatches_found.append(get_full_prop_name(removed, cur_parent) + ": REMOVED")
        for added in added_keys:
            mismatches_found.append(get_full_prop_name(added, cur_parent) + ": ADDED")
        return mismatches_found

    existing_mappings = es_resources_desc.resources_2_es_mapping
    for resource in resources_description.ALL_WS_RESOURCES_NAMES:
        if resources and resource not in resources:
            continue
        if resource not in existing_mappings:
            print('NEW ENTITY! {0}'.format(resource))
            continue
        old_mapping = existing_mappings[resource].mappings
        new_mapping = getattr(generated_mappings[resource], 'mappings', None)
        if new_mapping is None:
            print('NO MAPPING FOUND FOR! {0}'.format(resource))
            continue

        mismatches = compare_old_and_new_mappings_recursive(old_mapping, new_mapping)
        if mismatches:
            print(resource)
            for mismatch in mismatches:
                if mismatch.find('_metadata') >= 0:
                    continue
                print(" "*2+mismatch)
        else:
            print("No changes found for: {0}".format(resource))


def check_ws_vs_es_counts():
    for resource_i in ALL_WS_RESOURCES:
        ws_count = get_ws_count(resource_i.res_name)
        es_count = es_util.get_idx_count(resource_i.idx_name)
        mismatch = ws_count == -1 or es_count == -1 or ws_count != es_count
        mismatch_txt = 'MISMATCH' if mismatch else ''
        formatted_ws_count = '{0:,}'.format(ws_count)
        formatted_ws_count = ' '*(12-len(formatted_ws_count))+formatted_ws_count
        formatted_es_count = '{0:,}'.format(es_count)
        formatted_es_count = ' '*(12-len(formatted_es_count))+formatted_es_count
        print_txt = '{0}: ws_count: {1} - es_count: {2}  {3}'\
            .format(resource_i.get_res_name_for_print(), formatted_ws_count, formatted_es_count, mismatch_txt)
        print(print_txt)
