
import requests

import xml.etree.ElementTree as ET
from django.core.cache import cache


BLAST_API_BASE_URL = 'https://www.ebi.ac.uk/Tools/services/rest/ncbiblast'

# ----------------------------------------------------------------------------------------------------------------------
# Getting params
# ----------------------------------------------------------------------------------------------------------------------
PARAMS_SEARCH_LINKS = {
    'matrix': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
              '(ProteinDatabases)-matrix',
    'gapopen': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
               '(ProteinDatabases)-gapopen',
    'gapext': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
              '(ProteinDatabases)-gapext',
    'exp': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
           '(ProteinDatabases)-exp',
    'filter': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
              '(ProteinDatabases)-filter',
    'dropoff': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
               '(ProteinDatabases)-dropoff',
    'scores': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
              '(ProteinDatabases)-scores',
    'alignments': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST'
                  '+(ProteinDatabases)-alignments',
    'seqrange': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
                '(ProteinDatabases)-seqrange',
    'gapalign': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
                '(ProteinDatabases)-gapalign',
    'align': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
             '(ProteinDatabases)-align',
    'compstats': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
                 '(ProteinDatabases)-compstats'
}


def get_blast_params():

    cache_key = 'chembl-blast-params'
    cached_response = cache.get(cache_key)
    if cached_response is not None:
        return cached_response

    params_url = '{}/parameters'.format(BLAST_API_BASE_URL)

    r = requests.get(params_url)
    xml_response = r.text
    results_root = ET.fromstring(xml_response)

    all_param_names = [param.text for param in results_root]
    adjustable_params = [p for p in all_param_names if
                         p not in ['program', 'task', 'match_scores', 'stype', 'database', 'transltable']]
    final_params_list = []
    for param_id in adjustable_params:
        param_details_url = '{base_url}/parameterdetails/{param_id}'.format(base_url=BLAST_API_BASE_URL,
                                                                            param_id=param_id)
        rp = requests.get(param_details_url)
        rp_xml_response = rp.text
        params_root = ET.fromstring(rp_xml_response)

        param_name = params_root.find('name').text
        param_description = params_root.find('description').text
        param_type = params_root.find('type').text
        param_values = []
        allow_free_input = param_id in ['seqrange', 'sequence']

        values_elem = params_root.find('values')
        if values_elem is not None:
            for value_desc in values_elem:
                label = value_desc.find('label').text
                value = value_desc.find('value').text
                is_default_text = value_desc.find('defaultValue').text
                is_default = True if is_default_text == 'true' else False

                value_dict = {
                    'label': label,
                    'value': value,
                    'is_default': is_default,
                }
                param_values.append(value_dict)

        param_dict = {
            'param_id': param_id,
            'param_name': param_name,
            'param_description': param_description,
            'param_type': param_type,
            'param_values': param_values,
            'allow_free_input': allow_free_input,
            'param_help_link': PARAMS_SEARCH_LINKS.get(param_id)
        }

        if allow_free_input:
            for value_dict in param_values:
                if value_dict['is_default']:
                    default_value = value_dict['value']
                    param_dict['default_value'] = default_value
                    break

        final_params_list.append(param_dict)

    response = {
        'params': final_params_list
    }

    cache.set(cache_key, response, 86400)
    return response