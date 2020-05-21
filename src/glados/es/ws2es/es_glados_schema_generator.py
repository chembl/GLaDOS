import os
import re
from glados.es.ws2es.resources_description import RESOURCES_BY_RES_NAME, RESOURCES_BY_IDX_NAME
from glados.es.ws2es.es_util import es_util, DefaultMappings


PROPERTY_REGEX = re.compile('[0-9A-Za-z_]*')
PROPERTY_NAME_IDS = {}
CAPS_REGEX = re.compile('[A-Z]')
VOWELS_REGEX = re.compile('[aeiouy]', flags=re.IGNORECASE)
SPACE_REGEX = re.compile(r'\s')
REPEATED_CHARACTERS_REGEX = re.compile(r'(.)\1+')


def get_complete_property(es_property, parent_property):
    return (parent_property + '.' if parent_property else '') + es_property


def remove_duplicate_words(sentence):
    words = SPACE_REGEX.split(sentence)
    words_set = set()
    clean_sentence = ''
    for word in words:
        if word.lower() == 'pref':
            continue
        if word not in words_set:
            clean_sentence += word + ' '
            if word.endswith('s'):
                words_set.add(word[:-1])
            elif word.endswith('es'):
                words_set.add(word[:-2])
            elif word.endswith('ies'):
                words_set.add(word[:-3])
            else:
                words_set.add(word)
    return clean_sentence


def standardize_label(prop_part, entity_name=None):
    std_label = re.sub('_+', ' ', prop_part).strip()
    std_label = std_label.title()
    std_label = re.sub(r'\batc\b', 'ATC', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bbao\b', 'BAO', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bchembl\b', 'ChEMBL', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bid\b', 'ID', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\busan\b', 'USAN', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bbei\b', 'BEI', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\ble\b', 'LE', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\blle\b', 'LLE', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bsei\b', 'SEI', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\befo\b', 'EFO', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\buberon\b', 'UBERON', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bmesh\b', 'MESH', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bnum\b', '#', std_label, flags=re.IGNORECASE)
    if entity_name is not None:
        std_label = re.sub(r'\bgenerated\b', '', std_label, flags=re.IGNORECASE)
        std_label = re.sub(r'\b'+entity_name+r'\b', '', std_label, flags=re.IGNORECASE)
        if entity_name == 'molecule':
            std_label = re.sub(r'\bcompound\b', '', std_label, flags=re.IGNORECASE)
        if entity_name == 'cell_line':
            std_label = re.sub(r'\bcell\b', '', std_label, flags=re.IGNORECASE)
            std_label = re.sub(r'\bline\b', '', std_label, flags=re.IGNORECASE)

    return std_label.strip()


def abbreviate_word(word, max_word_length):
    if len(word) <= max_word_length:
        return word
    total_caps = len(CAPS_REGEX.findall(word))
    if total_caps > round(len(word)/2):
        return word
    inner_word = word[1:]
    next_vowel_match = VOWELS_REGEX.search(inner_word)
    if next_vowel_match is not None:
        next_vowel_idx = next_vowel_match.pos
        after_vowel = inner_word[next_vowel_idx+1:]
        pre_vowel = inner_word[:next_vowel_idx+1]

        inner_word = pre_vowel + VOWELS_REGEX.sub('', after_vowel)
        if REPEATED_CHARACTERS_REGEX.search(inner_word):
            inner_word = REPEATED_CHARACTERS_REGEX.sub(r'\1', inner_word)
    return word[0] + inner_word[:max_word_length-1] + '.'


def abbreviate_label(std_label):
    words = SPACE_REGEX.split(std_label)
    max_word_length = 10
    if 15 < len(std_label) <= 20:
        max_word_length = 6
    elif len(std_label) > 20:
        max_word_length = 4

    abbreviated_words = []
    for word in words:
        abbreviated_words.append(abbreviate_word(word, max_word_length))
    return ' '.join(abbreviated_words)


def get_label_from_property_name(es_doc_type, prop_name, idx_name):
    entity_name = RESOURCES_BY_IDX_NAME[idx_name].res_name
    prop_parts = prop_name.split('.')
    label = ''
    prop_label_id = 'glados_es_gs__' + entity_name + '__'
    if len(prop_parts) > 1:
        if not prop_parts[-2] in ['_metadata', 'drug_data']:
            prop_label_id += prop_parts[-2] + '___'
            if not prop_parts[-2] in ['molecule_properties', 'drug']:
                label += standardize_label(prop_parts[-2], entity_name) + ' '
    label += standardize_label(prop_parts[-1], entity_name)
    if len(label) == 0:
        label = standardize_label(prop_parts[-1])
    label = remove_duplicate_words(label)
    label = label.strip()
    label_mini = abbreviate_label(label)
    prop_label_id += prop_parts[-1]
    return prop_label_id, label, label_mini


def get_js_mapping(prop_name, es_util_mapping, level, es_doc_type, idx_name):
    global PROPERTY_NAME_IDS
    mapping_type = es_util_mapping.get('type', None)
    es_aggregatable = 'true' if mapping_type in DefaultMappings.AGGREGATABLE_TYPES else 'false'

    if mapping_type == DefaultMappings.BOOLEAN['type']:
        js_type = "Boolean"
    elif mapping_type in DefaultMappings.NUMERIC_TYPES:
        js_type = "Number"
    elif isinstance(es_util_mapping, dict) and 'properties' in es_util_mapping:
        js_type = "Object"
    else:
        js_type = "String"

    property_name = re.sub(r'\.[0-9]+$', '', prop_name)
    prop_label_id, label, label_mini = get_label_from_property_name(es_doc_type, property_name, idx_name)
    PROPERTY_NAME_IDS[prop_label_id + '__label'] = label
    PROPERTY_NAME_IDS[prop_label_id + '__label__mini'] = label_mini

    js_mapping = '\n'
    js_mapping += ' ' * level + 'type : {0}\n'.format(js_type)
    if js_type == "Number":
        es_integer = 'true' if mapping_type in DefaultMappings.INTEGER_NUMERIC_TYPES else 'false'
        js_mapping += ' ' * level + 'integer : {0}\n'.format(es_integer)
        js_mapping += ' ' * level + 'year : {0}\n'.format('true' if 'year' in prop_name else 'false')
    js_mapping += ' ' * level + 'aggregatable : {0}\n'.format(es_aggregatable)
    js_mapping += ' ' * level + 'label_id : \'{0}\'\n'.format(prop_label_id + '__label')
    js_mapping += ' ' * level + 'label_mini_id : \'{0}\'\n'.format(prop_label_id + '__label__mini')

    return js_mapping


def summarize_mapping_definition(es_doc_type, mapping, parent_property=None, level=0, idx_name=''):
    properties_summary = []
    for es_property in sorted(mapping.keys()):
        next_parent = get_complete_property(es_property, parent_property)
        es_property_mapping = mapping[es_property]
        has_sub_properties = type(es_property_mapping) == dict and 'properties' in es_property_mapping
        if not has_sub_properties:
            matches = re.findall(r'\.[0-9]+$', next_parent)
            if len(matches) > 0:
                continue
        else:
            properties_summary += summarize_mapping_definition(
                es_doc_type,
                es_property_mapping['properties'],
                next_parent,
                level=level,
                idx_name=idx_name
            )
        property_name = next_parent
        formatted_prop_name = next_parent
        if PROPERTY_REGEX.fullmatch(next_parent) is None:
            formatted_prop_name = '\'{0}\''.format(next_parent)
        properties_summary.append(
            '{0} : {1}'.format(
                formatted_prop_name,
                get_js_mapping(property_name, es_property_mapping, level + 2, es_doc_type, idx_name)
            )
        )
    return properties_summary


def summarize_mappings_types(mappings, glados_schema_file, level=0, idx_name=''):
    for es_doc_type in sorted(mappings.keys()):
        props_summary = summarize_mapping_definition(es_doc_type, mappings[es_doc_type]['properties'], level=level,
                                                     idx_name=idx_name)
        for prop in props_summary:
            print(" "*level+prop, file=glados_schema_file)


def generate_glados_schema_and_po_files():
    global PROPERTY_NAME_IDS

    generated_files_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'generated_files')
    resources_to_export = [
        'activity',
        'assay',
        'cell_line',
        'document',
        'molecule',
        'target',
        'tissue',
        'mechanism_by_parent_target',
        'drug_indication_by_parent',
    ]
    print('GENERATING SCHEMA FILE . . . ')
    with open(os.path.join(generated_files_dir, 'GLaDOS_es_GeneratedSchema.coffee'), 'w') as glados_schema_file:
        # noinspection PyTypeChecker
        print(
            'glados.useNameSpace \'glados.models.paginatedCollections.esSchema\',\n' +
            '# The contents of this file were generated from the GLaDOS-es project\n',
            file=glados_schema_file
        )
        # noinspection PyTypeChecker
        print(' '*2+'GLaDOS_es_GeneratedSchema:', file=glados_schema_file)
        for resource in sorted(resources_to_export):
            # noinspection PyTypeChecker
            print(' '*4+RESOURCES_BY_RES_NAME[resource].idx_name+':', file=glados_schema_file)
            summarize_mappings_types(
                es_util.get_index_mapping(RESOURCES_BY_RES_NAME[resource].idx_name),
                glados_schema_file,
                level=6,
                idx_name=RESOURCES_BY_RES_NAME[resource].idx_name
            )
        print(' . . . DONE!')
    print('GENERATING PO FILE . . . ')
    with open(os.path.join(generated_files_dir, 'glados_es_generated.po'), 'w') as glados_po_file:
        sorted_labels = sorted(PROPERTY_NAME_IDS.keys())
        for label_id in sorted_labels:
            # noinspection PyTypeChecker
            print('msgid "{0}"\nmsgstr "{1}"\n\n'.format(label_id, PROPERTY_NAME_IDS[label_id]), file=glados_po_file)
        print(' . . . DONE!')


if __name__ == '__main__':
    es_util.setup_connection('wp-p2m-50.ebi.ac.uk', 9200)
    generate_glados_schema_and_po_files()
