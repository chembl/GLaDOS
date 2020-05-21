
__author__ = 'jfmosquera@ebi.ac.uk'
import requests
import sys
import traceback
import glados.es.ws2es.util as util
from glados.es.ws2es.es_util import es_util, simplify_es_properties
import re
from functools import lru_cache

########################################################################################################################

WS_DEV_URL = 'http://wwwdev.ebi.ac.uk/chembl/api/data'
WS_PROD_URL = 'http://www.ebi.ac.uk/chembl/api/data'

WS_URL_TO_USE = WS_DEV_URL


def set_ws_env(prod):
    global WS_URL_TO_USE
    if prod:
        WS_URL_TO_USE = WS_PROD_URL


RESOURCES_BY_RES_NAME = {}
RESOURCES_BY_IDX_NAME = {}
RESOURCES_BY_ALIAS_NAME = {}
ALL_RESOURCES = []
ALL_RESOURCES_NAMES = []
ALL_WS_RESOURCES = []
ALL_WS_RESOURCES_NAMES = []
CURRENT_INDEX_VERSION = '27'
MAX_RES_NAME_LENGTH = 0


@lru_cache(maxsize=64)
def memoized_get_resource_mapping_from_es(idx_name):
    mapping = es_util.get_index_mapping(idx_name)
    return mapping['properties']


@lru_cache(maxsize=64)
def memoized_get_simplified_mapping_from_es(res_name, idx_name):
    mapping = memoized_get_resource_mapping_from_es(idx_name)
    return simplify_es_properties(res_name, mapping)


class ResourceDescription(object):

    INDEX_PREFIX = "chembl"

    @classmethod
    def __get_index_name(cls, res_name):
        return '{0}_{1}_{2}'.format(cls.INDEX_PREFIX, CURRENT_INDEX_VERSION, res_name)

    @classmethod
    def __get_index_alias(cls, res_name):
        return '{0}_{1}'.format(cls.INDEX_PREFIX, res_name)

    def __init__(self, res_name, resource_ids, ws_resource=True):
        global RESOURCES_BY_RES_NAME, ALL_RESOURCES, MAX_RES_NAME_LENGTH
        self.res_name = res_name
        self.idx_name = self.__get_index_name(res_name)
        self.idx_alias = self.__get_index_alias(res_name)
        self.resource_ids = resource_ids
        self.ws_resource = ws_resource
        MAX_RES_NAME_LENGTH = max(MAX_RES_NAME_LENGTH, len(self.res_name))
        RESOURCES_BY_RES_NAME[res_name] = self
        RESOURCES_BY_IDX_NAME[self.idx_name] = self
        RESOURCES_BY_ALIAS_NAME[self.idx_alias] = self
        ALL_RESOURCES.append(self)
        ALL_RESOURCES_NAMES.append(res_name)
        if self.ws_resource:
            ALL_WS_RESOURCES.append(self)
            ALL_WS_RESOURCES_NAMES.append(res_name)

    def get_res_name_for_print(self):
        global MAX_RES_NAME_LENGTH
        return self.res_name+' '*(MAX_RES_NAME_LENGTH-len(self.res_name)+1)

    def get_doc_id(self, doc):
        ids_parts = [
            re.sub(r'\s', '__', str(util.get_js_path_from_dict(doc, prop_i, 'N/A'))) for prop_i in self.resource_ids
        ]
        return '___'.join(ids_parts)

    # noinspection PyBroadException
    def create_alias(self, es_host='localhost', es_port=9200, user=None, password=None):
        try:
            auth_data = None
            if user is not None and password is not None:
                auth_data = (user, password)
            req = requests.post(
                'http://{0}:{1}/_aliases'.format(es_host, es_port),
                json={
                    "actions": [
                        {"remove": {"index": "*", "alias": self.idx_alias}},
                        {"add": {"index": self.idx_name, "alias": self.idx_alias}}
                    ]
                },
                auth=auth_data
            )
            if req.status_code != 200:
                raise Exception(req.content)
            print('INDEX ALIAS CREATED FOR {0}!'.format(self.idx_alias))
        except Exception as e:
            traceback.print_exc(file=sys.stderr)
            print('ERROR: Failed to create alias for {0}'.format(self.idx_alias), file=sys.stderr)

    def get_resource_mapping_from_es(self):
        return memoized_get_resource_mapping_from_es(self.idx_name)

    def get_simplified_mapping_from_es(self):
        return memoized_get_simplified_mapping_from_es(self.res_name, self.idx_name)

    def get_doc_by_id_from_es(self, doc_id):
        return es_util.get_doc_by_id(self.idx_name, doc_id)

    @staticmethod
    def create_all_aliases(es_host='localhost', es_port=9200, user=None, password=None):
        for res_i in ALL_RESOURCES:
            res_i.create_alias(es_host, es_port, user, password)


# Resources coming from the Web Services
ACTIVITY = ResourceDescription('activity', ['activity_id'])
ACTIVITY_SUPPLEMENTARY_DATA_BY_ACTIVITY =\
    ResourceDescription('activity_supplementary_data_by_activity', ['activity_id'])
ASSAY = ResourceDescription('assay', ['assay_chembl_id'])
ASSAY_CLASS = ResourceDescription('assay_class', ['assay_class_id'])
ATC_CLASS = ResourceDescription('atc_class', ['level5'])
BINDING_SITE = ResourceDescription('binding_site', ['site_id'])
BIOTHERAPEUTIC = ResourceDescription('biotherapeutic', ['molecule_chembl_id'])
CELL_LINE = ResourceDescription('cell_line', ['cell_chembl_id'])
CHEMBL_ID_LOOKUP = ResourceDescription('chembl_id_lookup', ['chembl_id'])
COMPOUND_RECORD = ResourceDescription('compound_record', ['record_id'])
DOCUMENT = ResourceDescription('document', ['document_chembl_id'])
DOCUMENT_SIMILARITY = ResourceDescription('document_similarity', ['document_1_chembl_id', 'document_2_chembl_id',
                                                                  'mol_tani', 'tid_tani'])
DRUG = ResourceDescription('drug', ['molecule_chembl_id'])
MECHANISM = ResourceDescription('mechanism', ['mec_id'])
MOLECULE = ResourceDescription('molecule', ['molecule_chembl_id'])
MOLECULE_FORM = ResourceDescription('molecule_form', ['molecule_chembl_id'])
ORGANISM = ResourceDescription('organism', ['tax_id'])
PROTEIN_CLASS = ResourceDescription('protein_class', ['protein_class_id'])
SOURCE = ResourceDescription('source', ['src_id'])
TARGET = ResourceDescription('target', ['target_chembl_id'])
TARGET_COMPONENT = ResourceDescription('target_component', ['component_id'])
TARGET_RELATION = ResourceDescription('target_relation', ['target_chembl_id', 'related_target_chembl_id'])
TISSUE = ResourceDescription('tissue', ['tissue_chembl_id'])
METABOLISM = ResourceDescription('metabolism', ['met_id'])
DRUG_INDICATION = ResourceDescription('drug_indication', ['drugind_id'])
GO_SLIM = ResourceDescription('go_slim', ['go_id'])


# Generated Resources
MECHANISM_BY_PARENT_TARGET = ResourceDescription(
    'mechanism_by_parent_target',
    ['parent_molecule.molecule_chembl_id', 'target.target_chembl_id', 'mechanism_of_action.mec_id'],
    ws_resource=False
)
DRUG_INDICATION_BY_PARENT = ResourceDescription(
    'drug_indication_by_parent', ['parent_molecule.molecule_chembl_id', 'drug_indication.mesh_id'],
    ws_resource=False
)
