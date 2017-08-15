from arpeggio import Optional, PTNodeVisitor, OneOrMore, ZeroOrMore, EOF
from arpeggio import RegExMatch as _
from arpeggio import ParserPython
import arpeggio

import glados.grammar.common as common
import glados.grammar.smiles as smiles
import glados.grammar.inchi as inchi
import re
import json
import requests
import urllib.parse
import traceback
import time

from django.http import HttpResponse

BASE_EBI_URL = 'https://www.ebi.ac.uk'
BASE_EBI_DEV_URL = "https://wwwdev.ebi.ac.uk"

UNICHEM_DS = {}

req = requests.get(url=BASE_EBI_URL + '/unichem/rest/src_ids/', headers={'Accept': 'application/json'})
json_resp = req.json()
for ds_i in json_resp:
    ds_id_i = ds_i['src_id']
    req_i = requests.get(url=BASE_EBI_URL + '/unichem/rest/sources/{0}'.format(ds_id_i),
                         headers={'Accept': 'application/json'})
    UNICHEM_DS[ds_id_i] = req_i.json()[0]


def get_unichem_cross_reference_link_data(src_id: str, cross_reference_id: str) -> dict:
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
    return OneOrMore(_(r'[a-zA-Z0-9_\-]'))


def single_term():
    return common.correctly_parenthesised_non_space_char_sequence, common.term_end_lookahead


def exact_match_term():
    return (
        [
            (
              Optional(['+', '-']),
              [
                 ('"', _('[^"]+'), '"'),
                 ("'", _("[^']+"), "'")
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
                Optional(
                    (common.space_sequence, _(r'and|or', ignore_case=True))
                ),
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


def check_chembl(term_dict: dict):
    re_match = CHEMBL_REGEX.match(term_dict['term'])
    if re_match is not None:
        chembl_id_num = re_match.group(1)
        term_dict['references'].append(
            {'type': 'chembl_id', 'chembl_ids': ['CHEMBL{0}'.format(chembl_id_num)]}
        )


def check_integer(term_dict: dict):
    re_match = INTEGER_REGEX.match(term_dict['term'])
    if re_match is not None:
        term_dict['references'].append(
            {'type': 'integer_chembl_id', 'chembl_ids': ['CHEMBL{0}'.format(term_dict['term'])]}
        )


def check_doi(term_dict: dict):
    re_match = DOI_REGEX.match(term_dict['term'])
    if re_match is not None:
        try:
            chembl_ids = []
            response = requests.get(
                BASE_EBI_DEV_URL + '/chembl/glados-es/chembl_document/_search',
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
                }
            )
            json_response = response.json()
            for hit_i in json_response['hits']['hits']:
                chembl_ids.append(hit_i['_source']['document_chembl_id'])
            if chembl_ids:
                term_dict['references'].append(
                    {'type': 'doi', 'chembl_ids': chembl_ids}
                )
        except:
            traceback.print_exc()


def check_inchi(term_dict: dict, term_is_inchi_key=False):
    try:
        chembl_ids = []
        response = requests.get(
            BASE_EBI_DEV_URL + '/chembl/glados-es/chembl_molecule/_search',
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
            }
        )
        json_response = response.json()
        for hit_i in json_response['hits']['hits']:
            chembl_ids.append(hit_i['_source']['molecule_chembl_id'])
        if chembl_ids:
            term_dict['references'].append(
                {'type': 'inchi'+('_key' if term_is_inchi_key else ''), 'chembl_ids': chembl_ids}
            )
    except:
        traceback.print_exc()


def check_smiles(term_dict: dict):
    try:
        chembl_ids = []
        next_url_path = '/chembl/api/data/molecule.json?molecule_structures__canonical_smiles__flexmatch={0}'\
                        .format(urllib.parse.quote(term_dict['term']))
        while next_url_path:
            response = requests.get(BASE_EBI_URL + next_url_path,
                                    headers={'Accept': 'application/json'})
            json_response = response.json()
            if 'error_message' in json_response:
                return None
            for molecule_i in json_response['molecules']:
                chembl_ids.append(molecule_i['molecule_chembl_id'])
            next_url_path = json_response['page_meta']['next']
        if chembl_ids:
            term_dict['references'].append({'type': 'smiles', 'chembl_ids': chembl_ids})
    except:
        traceback.print_exc()


def check_unichem(term_dict: dict):
    try:
        response = requests.get(BASE_EBI_URL+'/unichem/rest/orphanIdMap/{0}'
                                .format(urllib.parse.quote(term_dict['term'])),
                                headers={'Accept': 'application/json'})
        json_response = response.json()
        if 'error' in json_response:
            return None
        chembl_ids = []
        unichem_cross_refs = {}
        for unichem_src_i in json_response:
            cross_references = []
            for link_i in json_response[unichem_src_i]:
                if link_i['src_id'] == '1':
                    chembl_ids.append(link_i['src_compound_id'])
                cross_references.append(
                    get_unichem_cross_reference_link_data(link_i['src_id'], link_i['src_compound_id'])
                )
            link_data_i = get_unichem_cross_reference_link_data(unichem_src_i, term_dict['term'])
            unichem_cross_refs[unichem_src_i] = {'cross_reference_link': link_data_i,
                                                 'cross_references': cross_references}

        if chembl_ids or unichem_cross_refs:
            term_dict['references'].append(
                {'type': 'unichem', 'chembl_ids': chembl_ids, 'cross_references': unichem_cross_refs}
            )
    except:
        print(term_dict)
        traceback.print_exc()




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
        last_was_and = False
        for child_i in children:
            str_child_i = str(child_i).strip().lower()
            if len(str_child_i) > 0:
                if str_child_i == 'and':
                    last_was_and = True
                elif str_child_i != 'or':
                    if last_was_and:
                        if type(['or'][-1]) == dict and 'and' in exp['or'][-1]:
                            exp['or'][-1]['and'].append(child_i)
                        else:
                            exp['or'][-1] = {'and': [exp['or'][-1], child_i]}

                        last_was_and = False
                    else:
                        exp['or'].append(child_i)
        return exp

    @staticmethod
    def get_term_dict(term: str, include_in_query=True) -> dict:
        return {
            'term': term,
            'include_in_query': include_in_query,
            'references': [],
            'exact_match_term': False
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

    def visit_property_term(self, node, children):
        term = ''.join(children)
        term_dict = self.get_term_dict(term, include_in_query=False)
        term_dict['exact_match_term'] = True
        return term_dict

    def visit_exact_match_term(self, node, children):
        term = ''.join(children)
        term_dict = self.get_term_dict(term, include_in_query=False)
        term_dict['exact_match_term'] = True
        return term_dict

    def visit_single_term(self, node, children):
        term = ''.join(children)
        term_dict = self.get_term_dict(term, include_in_query=False)
        check_unichem(term_dict)
        check_chembl(term_dict)
        check_integer(term_dict)
        check_doi(term_dict)
        return term_dict


def parse_query_str(query_string: str):
    if len(query_string.strip()) == 0:
        return {}
    query_string = re.sub(r'\s+', ' ', query_string)
    pt = parser.parse(query_string)
    result = arpeggio.visit_parse_tree(pt, TermsVisitor())
    json_result = json.dumps(result, indent=4)
    return json_result


# parse_query_str('[12H]-[He] [He]  [Cu]-[Zn]')

longest_chembl_smiles = r"CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC1OC(CO)C(O)C(O)C1O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+" \
                        r"]OC(CO)C(O)C(OC2OC(CO)C(O)C(O)C2O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC3OC(CO" \
                        r")C(O)C(O)C3O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC4OC(CO)C(O)C(O)C4O)C(O)CO.C" \
                        r"CCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC5OC(CO)C(O)C(O)C5O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]" \
                        r"OC(CO)C(O)C(OC6OC(CO)C(O)C(O)C6O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC7OC(CO)" \
                        r"C(O)C(O)C7O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC8OC(CO)C(O)C(O)C8O)C(O)CO.CC" \
                        r"CCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC9OC(CO)C(O)C(O)C9O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]O" \
                        r"C(CO)C(O)C(OC%10OC(CO)C(O)C(O)C%10O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC%11O" \
                        r"C(CO)C(O)C(O)C%11O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC%12OC(CO)C(O)C(O)C%12" \
                        r"O)C(O)CO.CCCCCCCCCC(C(=O)NCCc%13ccc(OP(=S)(Oc%14ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-" \
                        r"])cc%14)N(C)\N=C\c%15ccc(Op%16(Oc%17ccc(\C=N\N(C)P(=S)(Oc%18ccc(CCNC(=O)C(CCCCCCCCC" \
                        r")P(=O)(O)[O-])cc%18)Oc%19ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%19)cc%17)np(Oc%20c" \
                        r"cc(\C=N\N(C)P(=S)(Oc%21ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%21)Oc%22ccc(CCNC(=O)" \
                        r"C(CCCCCCCCC)P(=O)(O)[O-])cc%22)cc%20)(Oc%23ccc(\C=N\N(C)P(=S)(Oc%24ccc(CCNC(=O)C(CC" \
                        r"CCCCCCC)P(=O)(O)[O-])cc%24)Oc%25ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%25)cc%23)np" \
                        r"(Oc%26ccc(\C=N\N(C)P(=S)(Oc%27ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%27)Oc%28ccc(C" \
                        r"CNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%28)cc%26)(Oc%29ccc(\C=N\N(C)P(=S)(Oc%30ccc(CCNC(" \
                        r"=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%30)Oc%31ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%31)c" \
                        r"c%29)n%16)cc%15)cc%13)P(=O)(O)[O-]"


# t_ini = time.time()
# print(parse_query_str(
#     """
#     COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56
#
# AND C NCCc1ccc(O)c(O)c1
#
# C\C(=C\C(=O)O)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C
#
# and ( COC1(CN2CCC1CC2)C#CC(C#N)(c3ccccc3)c4ccccc4 or CN1C\C(=C/c2ccc(C)cc2)\C3=C(C1)C(C(=C(N)O3)C#N)c4ccc(C)cc4 )
#
# COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56
#
# CC(C)C[C@H](NC(=O)[C@@H](NC(=O)[C@H](Cc1c[nH]c2ccccc12)NC(=O)[C@H]3CCCN3C(=O)C(CCCCN)CCCCN)C(C)(C)C)C(=O)O
#
#     (InChI=1/BrH/h1H/i1[-]1)
#     ( Cc1nnc2CN=C(c3ccccc3)c4cc(Cl)ccc4-n12 or CN1C(=O)CN=C(c2ccccc2)c3cc(Cl)ccc13 and c and ccc cs or ccs or InChI=1s/BrH and c)
#     CC(C)(N)Cc1ccccc1
#     CCCc1nn(C)c2C(=O)NC(=Nc12)c3cc(ccc3OCC)S(=O)(=O)N4CCN(C)CC4.OC(=O)CC(O)(CC(=O)O)C(=O)O
#
#     VYFYYTLLBUKUHU-UHFFFAOYSA-N
#
#     Q86UW1
#
#     +json.port:\" asda asda asd \"
#     _metadata.api.json:>=10
#     _metadata.api.json:( 789 )
#     +US-68921(123) 'yes search for this mofo!! () ' aspirin eugenol ester
#
#     ChEMBL(25)
#
#     vitamin a
#
#     InChI=1/BrH/h1H/i1+1
#
#     10.1021/jm900587h
# InChI=1S/C20H28O2/c1-15(8-6-9-16(2)14-19(21)22)11-12-18-17(3)10-7-13-20(18,4)5/h6,8-9,11-12,14H,7,10,13H2,1-5H3,(H,21,22)/b9-6+,12-11+,15-8+,16-14+
# 1
#     """ + longest_chembl_smiles + " "+'C'*14+'-'+'C'*10+'-C'+"  ((CCO) or (C)C(O))"
# ), time.time()-t_ini)

# t_ini = time.time()
# print(parse_query_str("CCO"), time.time()-t_ini)

# req = requests.post(
#     url="http://ves-hx2-5e.ebi.ac.uk:9200/chembl_molecule/_search",
#     json=\
#         {
#             "size": 140,
#             "_source": ["pref_name","molecule_synonyms.*"],
#             "query": {
#                 "multi_match": {
#                     "query": "vitamin",
#                     "fields": ["*.std_analyzed"]
#                 }
#             }
#         }
#
# )
#
# json_doc = req.json()
#
# vitamins = []
# for hit_i in json_doc['hits']['hits']:
#     inner_group = set()
#     inner_group.add(hit_i['_id'])
#     if 'pref_name' in hit_i['_source'] and hit_i['_source']['pref_name'] is not None:
#         inner_group.add(hit_i['_source']['pref_name'].lower())
#     if 'molecule_synonyms' in hit_i['_source']:
#         for synonym_i in hit_i['_source']['molecule_synonyms']:
#             inner_group.add(synonym_i['synonyms'].lower())
#             inner_group.add(synonym_i['molecule_synonym'].lower())
#     vitamins.append(inner_group)
#
# for vit_i in vitamins:
#     print("'"+"','".join(sorted(vit_i))+"'")


def parse_url_search(request, search_string=None):
    return HttpResponse(parse_query_str(search_string))
