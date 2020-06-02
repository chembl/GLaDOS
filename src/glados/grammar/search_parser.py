from arpeggio import Optional, PTNodeVisitor, OneOrMore, ZeroOrMore, EOF
from arpeggio import RegExMatch as _
from arpeggio import ParserPython
import arpeggio

import glados.grammar.common as common
import glados.grammar.smiles as smiles
import glados.grammar.inchi as inchi
import glados.grammar.fasta as fasta
import re
import json
import operator
import requests
import urllib.parse
import traceback
import time
import threading
import sys
from glados.usage_statistics import glados_server_statistics
from glados.models import ESSearchRecord

from django.http import HttpResponse
from glados.es.query_builder import QueryBuilder
from urllib.parse import urlparse
from django.conf import settings

BASE_EBI_URL = 'https://www.ebi.ac.uk'

UNICHEM_DS = None
UNICHEM_DS_LAST_LOAD = 0
UNICHEM_LOADING_THREAD = None
UNICHEM_LOADING_THREAD_LOCK = threading.Lock()

CHEMBL_ENTITIES = {
    'target': 'targets',
    'compound': 'compounds',
    'molecule': 'compounds',
    'document': 'documents',
    'assay': 'assays',
    'cell': 'cells',
    'tissue': 'tissues'
}

WS_PARSED_URL = urlparse(settings.WS_URL)
WS_DOMAIN = WS_PARSED_URL.scheme + '://' + WS_PARSED_URL.netloc
WS_BASE_PATH = WS_PARSED_URL.path


# noinspection PyBroadException
def __load_unichem_data():
    global UNICHEM_DS, UNICHEM_LOADING_THREAD, UNICHEM_DS_LAST_LOAD
    try:
        print('Loading UNICHEM data . . .')
        UNICHEM_DS = {}
        req = requests.get(
            url=BASE_EBI_URL + '/unichem/rest/src_ids/',
            headers={'Accept': 'application/json'},
            timeout=5
        )
        json_resp = req.json()
        for ds_i in json_resp:
            ds_id_i = ds_i['src_id']
            req_i = requests.get(url=BASE_EBI_URL + '/unichem/rest/sources/{0}'.format(ds_id_i),
                                 headers={'Accept': 'application/json'})
            UNICHEM_DS[ds_id_i] = req_i.json()[0]
        UNICHEM_DS_LAST_LOAD = time.time()
        print(' . . . UNICHEM data loaded!')
    except:
        print('Error, UNICHEM data is not available!', file=sys.stderr)
    UNICHEM_LOADING_THREAD = None
    UNICHEM_LOADING_THREAD_LOCK.release()


# noinspection PyBroadException
def load_unichem_data(wait=True):
    global UNICHEM_LOADING_THREAD, UNICHEM_LOADING_THREAD_LOCK, UNICHEM_DS_LAST_LOAD
    if time.time() - UNICHEM_DS_LAST_LOAD > 2*pow(60, 2) and UNICHEM_LOADING_THREAD is None:
        try:
            UNICHEM_LOADING_THREAD_LOCK.acquire()
            if UNICHEM_LOADING_THREAD is None:
                UNICHEM_LOADING_THREAD = threading.Thread(target=__load_unichem_data,
                                                          name='unichem-data-loader', daemon=True)
                UNICHEM_LOADING_THREAD.start()
        except:
            UNICHEM_LOADING_THREAD_LOCK.release()
    if wait:
        if UNICHEM_LOADING_THREAD is not None:
            UNICHEM_LOADING_THREAD.join()
        return UNICHEM_DS is not None
    return UNICHEM_DS is not None


# load_unichem_data(False)


def get_unichem_cross_reference_link_data(src_id: str, cross_reference_id: str) -> dict:
    global UNICHEM_DS
    if load_unichem_data():
        link_data = {
                'cross_reference_id': cross_reference_id,
                'cross_reference_link': None,
                'cross_reference_label': 'Unknown in UniChem'
            }
        if src_id in UNICHEM_DS:
            ds = UNICHEM_DS[src_id]
            if ds['base_id_url_available'] == '1':
                link_data['cross_reference_link'] = ds['base_id_url'] + cross_reference_id
            link_data['cross_reference_label'] = ds['name_label']
        return link_data


def property_term():
    return(
        Optional(['+', '-']),
        json_property_path_segment, ZeroOrMore('.', json_property_path_segment), ':',
        [
           ('"', _('[^"]+'), '"'),
           ("'", _("[^']+"), "'"),
           ("(", _("[^\(\)]+"), ")"),
           common.correctly_parenthesised_non_space_char_sequence
        ],
        common.term_end_lookahead
    )


def json_property_path_segment():
    return OneOrMore(_(r'[a-z0-9_\-]'))


def single_term():
    return common.correctly_parenthesised_non_space_char_sequence, common.term_end_lookahead


def exact_match_term():
    return (
        [
            (
              Optional(['+', '-']),
              [
                 ('"', _(r'((\\")|[^"])+'), '"'),
                 ("'", _(r"((\\')|[^'])+"), "'")
              ]
            ),
            (
              ['+', '-'], common.correctly_parenthesised_non_space_char_sequence
            )
        ],
        common.term_end_lookahead
    )


def expression_term():
    return [parenthesised_expression,
            smiles.smiles,
            inchi.inchi_key, inchi.inchi,
            fasta.fasta,
            property_term,
            exact_match_term,
            single_term]


def parenthesised_expression():
    return '(', expression, ')', common.term_end_lookahead


def expression():
    return \
        (
            Optional(common.space_sequence),
            expression_term,
            ZeroOrMore(
                # Optional(
                #     (common.space_sequence, _(r'and|or', ignore_case=True))
                # ),
                common.space_sequence,
                expression_term,
                common.term_end_lookahead
            ),
            Optional(common.space_sequence)
        )


parser = ParserPython(expression, skipws=False)


__CHEMBL_REGEX_STR = r'^chembl[^\d\s]{0,2}([\d]+)[^\d\s]{0,2}$'
CHEMBL_REGEX = re.compile(__CHEMBL_REGEX_STR, flags=re.IGNORECASE)
__DOI_REGEX_STR = r'^(10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?!["&\'<>|])\S)+)$'
DOI_REGEX = re.compile(__DOI_REGEX_STR)
INTEGER_REGEX = re.compile(r'^\d+$')


def adjust_exact_term(exact_term: str) -> str:
    if exact_term[-1] == '"':
        return exact_term
    elif exact_term[-1] == "'":
        first_char = 1
        prefix = ""
        if exact_term[0] == '+' or exact_term[0] == '-':
            first_char = 2
            prefix = exact_term[0]
        return prefix+'"'+exact_term[first_char:-1].replace(r"\'", r'\"')+'"'
    else:
        return exact_term[0]+'"'+exact_term[1:]+'"'


def get_chembl_id_dict(chembl_id, cross_references=[], include_in_query=True, score=None):
    return {
        'chembl_id': chembl_id,
        'cross_references': cross_references,
        'include_in_query': include_in_query,
        'score': score
    }


def get_chembl_id_list_dict(chembl_ids, cross_references=[], include_in_query=True):
    return [
        get_chembl_id_dict(
            chembl_id_i,
            cross_references[i] if i < len(cross_references) else [],
            include_in_query
        )
        for i, chembl_id_i in enumerate(chembl_ids)
    ]


def check_chembl(term_dict: dict):
    re_match = CHEMBL_REGEX.match(term_dict['term'])
    if re_match is not None:
        chembl_id_num = re_match.group(1)
        term_dict['references'].append(
            {
                'type': 'chembl_id',
                'label': 'ChEMBL ID',
                'chembl_ids': [
                    get_chembl_id_dict('CHEMBL{0}'.format(chembl_id_num))
                ],
                'include_in_query': True
            }
        )


def check_integer(term_dict: dict):
    re_match = INTEGER_REGEX.match(term_dict['term'])
    if re_match is not None:
        term_dict['references'].append(
            {
                'type': 'integer_chembl_id',
                'label': 'Integer as ChEMBL ID',
                'chembl_ids': [
                    get_chembl_id_dict('CHEMBL{0}'.format(term_dict['term']))
                ],
                'include_in_query': True
            }
        )


def check_chembl_entities(term_dict: dict):
    term = term_dict['term'].lower()
    if len(term) > 0 and term[-1] == 's':
        term = term[0:-1]
    if term in CHEMBL_ENTITIES:
        term_dict['chembl_entity'] = CHEMBL_ENTITIES[term]


def check_doi(term_dict: dict):
    re_match = DOI_REGEX.match(term_dict['term'])
    if re_match is not None:
        try:
            chembl_ids = []
            response = requests.get(
                '{es_url}/{index_prefix}document/_search'.format(
                    es_url=settings.ELASTICSEARCH_EXTERNAL_URL,
                    index_prefix=settings.CHEMBL_ES_INDEX_PREFIX
                ),
                json=
                {
                    'size': 10,
                    '_source': 'document_chembl_id',
                    'query': {
                        'term': {
                            'doi': {
                                'value': term_dict['term']
                            }
                        }
                    }
                },
                timeout=5
            )
            json_response = response.json()
            for hit_i in json_response['hits']['hits']:
                chembl_ids.append(hit_i['_source']['document_chembl_id'])
            if chembl_ids:
                term_dict['references'].append(
                    {
                        'type': 'doi',
                        'label': 'DOI (Digital Object Identifier)',
                        'chembl_ids': get_chembl_id_list_dict(chembl_ids),
                        'include_in_query': True,
                        'chembl_entity': 'document'
                    }
                )
        except:
            traceback.print_exc()


def check_inchi(term_dict: dict, term_is_inchi_key=False):
    try:
        chembl_ids = []
        response = requests.get(
            '{es_url}/{index_prefix}molecule/_search'.format(
                es_url=settings.ELASTICSEARCH_EXTERNAL_URL,
                index_prefix=settings.CHEMBL_ES_INDEX_PREFIX
            ),
            json=
            {
                'size': 10,
                '_source': 'molecule_chembl_id',
                'query': {
                    'term': {
                        'molecule_structures.standard_inchi'+('_key' if term_is_inchi_key else ''): {
                            'value': term_dict['term']
                        }
                    }
                }
            },
            timeout=5
        )
        json_response = response.json()
        for hit_i in json_response['hits']['hits']:
            chembl_ids.append(hit_i['_source']['molecule_chembl_id'])
        if chembl_ids:
            term_dict['references'].append(
                {
                    'type': 'inchi'+('_key' if term_is_inchi_key else ''),
                    'label': 'InChI'+(' Key' if term_is_inchi_key else ''),
                    'chembl_ids': get_chembl_id_list_dict(chembl_ids),
                    'include_in_query': True,
                    'chembl_entity': 'compound'
                }
            )
    except:
        traceback.print_exc()


def check_smiles(term_dict: dict):
    global WS_BASE_PATH
    try:
        chembl_ids = []
        next_url_path = '{ws_path}/molecule.json?molecule_structures__canonical_smiles__flexmatch={smiles}'\
                        .format(ws_path=WS_BASE_PATH, smiles=urllib.parse.quote(term_dict['term']))
        while next_url_path:
            response = requests.get(
                WS_DOMAIN + next_url_path,
                headers={'Accept': 'application/json'},
                timeout=5
            )
            json_response = response.json()
            if 'error_message' in json_response:
                return None
            for molecule_i in json_response['molecules']:
                chembl_ids.append(molecule_i['molecule_chembl_id'])
            next_url_path = json_response['page_meta']['next']
        if chembl_ids:
            term_dict['references'].append(
                {
                    'type': 'smiles',
                    'label': 'SMILES',
                    'chembl_ids': get_chembl_id_list_dict(chembl_ids),
                    'include_in_query': True,
                    'chembl_entity': 'compound'
                }
            )
    except:
        traceback.print_exc()


# noinspection PyBroadException
def check_unichem(term_dict: dict):
    pass
    # try:
    #     response = requests.get(
    #         BASE_EBI_URL+'/unichem/rest/orphanIdMap/{0}'
    #         .format(urllib.parse.quote(term_dict['term'])),
    #         headers={'Accept': 'application/json'},
    #         timeout=5
    #     )
    #     json_response = response.json()
    #     if 'error' in json_response:
    #         return None
    #     chembl_ids = []
    #     unichem_not_in_chembl_cross_refs = []
    #     for unichem_src_i in json_response:
    #         cross_references = []
    #         chembl_id_i = None
    #         for link_i in json_response[unichem_src_i]:
    #             if link_i['src_id'] == '1':
    #                 chembl_id_i = link_i['src_compound_id']
    #             elif unichem_src_i == '1':
    #                 chembl_id_i = term_dict['term']
    #             cross_references.append(
    #                 get_unichem_cross_reference_link_data(link_i['src_id'], link_i['src_compound_id'])
    #             )
    #         cross_references_dict = {
    #             'from': get_unichem_cross_reference_link_data(unichem_src_i, term_dict['term']),
    #             'also_in': cross_references
    #         }
    #         if chembl_id_i is not None:
    #             chembl_ids.append(get_chembl_id_dict(chembl_id_i, [cross_references_dict]))
    #         else:
    #             unichem_not_in_chembl_cross_refs.append(cross_references_dict)
    #
    #     if len(chembl_ids) > 0 or len(unichem_not_in_chembl_cross_refs) > 0:
    #         term_dict['references'].append(
    #             {
    #                 'type': 'unichem',
    #                 'label': 'UniChem',
    #                 'chembl_ids': chembl_ids,
    #                 'not_in_chembl': unichem_not_in_chembl_cross_refs,
    #                 'include_in_query': False,
    #                 'chembl_entity': 'compound'
    #             }
    #         )
    # except:
    #     traceback.print_exc()


class TermsVisitor(PTNodeVisitor):

    def __init__(self):
        super().__init__()

    def visit__default__(self, node, children):
        """
        Called if no visit method is defined for the node.

        Args:
            node(ParseTreeNode):
            children(processed children ParseTreeNode-s):
        """
        if isinstance(node, arpeggio.Terminal):
            return arpeggio.text(node)
        else:
            # term = ''.join([str(child_i) for child_i in children])
            # check_unichem(term)
            return ''.join([str(child_i) for child_i in children])

    def visit_expression_term(self, node, children):
        return children[0]

    def visit_parenthesised_expression(self, node, children):
        return children[1]

    def visit_expression(self, node, children):
        exp = {'or': []}
        previous_single_term_lc = None
        for child_i in children:
            str_child_i_lc = str(child_i).strip().lower()
            term_dict = None
            if len(str_child_i_lc) > 0:

                if str_child_i_lc == 'and' or str_child_i_lc == 'or':
                    term_dict = self.get_term_dict(str(child_i).strip(), include_in_query=False)
                    check_unichem(term_dict)
                last_term_is_and_group = len(exp['or']) > 0 and type(exp['or'][-1]) == dict and 'and' in exp['or'][-1]
                if str_child_i_lc == 'and' and not last_term_is_and_group:
                    if len(exp['or']) > 0:
                        exp['or'][-1] = {'and': [exp['or'][-1], term_dict]}
                    else:
                        exp['or'].append({'and': [term_dict]})
                elif last_term_is_and_group and (str_child_i_lc == 'and' or previous_single_term_lc == 'and'):
                    if term_dict:
                        exp['or'][-1]['and'].append(term_dict)
                    else:
                        exp['or'][-1]['and'].append(child_i)
                else:
                    if term_dict:
                        exp['or'].append(term_dict)
                    else:
                        exp['or'].append(child_i)
                previous_single_term_lc = str_child_i_lc
        if len(exp['or']) == 1:
            return exp['or'][0]
        return exp

    @staticmethod
    def get_term_dict(term: str, include_in_query=True) -> dict:
        return {
            'term': term,
            'include_in_query': include_in_query,
            'references': [],
            'exact_match_term': False,
            'filter_term': False,
            'chembl_entity': None
        }

    def visit_smiles(self, node, children):
        term = ''.join(children)
        include_in_query = len(term) <= 4
        term_dict = self.get_term_dict(term, include_in_query=include_in_query)
        check_smiles(term_dict)
        if include_in_query:
            check_unichem(term_dict)
        if inchi.is_inchi_key(term):
            check_inchi(term_dict)
        return term_dict

    def visit_inchi(self, node, children):
        term = ''.join(children)
        term_dict = self.get_term_dict(term, include_in_query=False)
        check_inchi(term_dict)
        return term_dict

    def visit_inchi_key(self, node, children):
        term = ''.join(children)
        term_dict = self.get_term_dict(term, include_in_query=False)
        check_inchi(term_dict, term_is_inchi_key=True)
        return term_dict

    def visit_fasta(self, node, children):
        term = ''.join(children)
        term_dict = self.get_term_dict(term, include_in_query=False)
        # check_fasta(term_dict)
        return term_dict

    def visit_property_term(self, node, children):
        term = ''.join(children)
        term_dict = self.get_term_dict(term)
        term_dict['filter_term'] = True
        return term_dict

    def visit_exact_match_term(self, node, children):
        term = ''.join(children)
        term = adjust_exact_term(term)
        term_dict = self.get_term_dict(term)
        term_dict['exact_match_term'] = True
        return term_dict

    def visit_single_term(self, node, children):
        term = ''.join(children)
        term_lc = term.lower()
        if term_lc == 'or' or term_lc == 'and':
            return term
        term_dict = self.get_term_dict(term)
        check_unichem(term_dict)
        check_chembl(term_dict)
        check_integer(term_dict)
        check_doi(term_dict)
        check_chembl_entities(term_dict)
        return term_dict


def parse_query_str(query_string: str):
    if len(query_string.strip()) == 0:
        return {}
    query_string = re.sub(r'[\s&&[^\n]]+', ' ', query_string)
    pt = parser.parse(query_string)
    result = arpeggio.visit_parse_tree(pt, TermsVisitor())
    return result


def parse_url_search(request):
    if request.method == 'GET':
        return HttpResponse('INVALID USAGE! PLEASE USE POST!', status=400)
    elif request.method == 'POST':

        start_time = time.time()
        query_string = request.POST.get('query_string', '')
        indexes_str = request.POST.get('es_indexes', '')
        indexes = indexes_str.split(',')
        selected_es_index = request.POST.get('selected_es_index', None)
        parsed_query = parse_query_str(query_string)
        best_queries, sorted_indexes_by_score = QueryBuilder.get_best_es_query(parsed_query, indexes, selected_es_index)

        response_dict = {
            'parsed_query': parsed_query,
            'best_es_base_queries': best_queries,
            'sorted_indexes_by_score': sorted_indexes_by_score
        }
        end_time = time.time()
        time_taken = end_time - start_time
        glados_server_statistics.record_search(ESSearchRecord.FREE_TEXT, time_taken)

        return HttpResponse(json.dumps(response_dict))
