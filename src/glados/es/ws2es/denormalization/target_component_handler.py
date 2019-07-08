import sys
from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.denormalization.protein_class_handler import ProteinClassDenormalizationHandler
from glados.es.ws2es.mappings.es_chembl_target_component_mapping import mappings as tc_mappings
import glados.es.ws2es.denormalization.xrefs_helper as xrefs_helper


class TargetComponentDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.TARGET_COMPONENT

    METADATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'target_component': tc_mappings['_doc']
                }
            }
        }
    }

    def __init__(self, complete_x_refs: bool=False, protein_class_dn_handler: ProteinClassDenormalizationHandler=None):
        super().__init__(complete_x_refs)
        self.complete_x_refs = complete_x_refs
        self.target_dict = {}
        self.target_component_dict = {}
        self.protein_class_dn_handler = protein_class_dn_handler

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        targets = doc.get('targets', [])
        self.target_component_dict[doc['component_id']] = doc
        for target_i in targets:
            target_chembl_id = target_i.get('target_chembl_id', None)
            if target_chembl_id:
                if target_chembl_id not in self.target_dict:
                    self.target_dict[target_chembl_id] = []
                self.target_dict[target_chembl_id].append(doc)

    def get_protein_classifications(self, target_chembl_id):
        protein_classifications = []
        for target_component_i in self.target_dict.get(target_chembl_id, []):
            for p_class_j in target_component_i['protein_classifications']:
                pc_data = self.protein_class_dn_handler.protein_class_by_id.get(
                    '{0}'.format(p_class_j['protein_classification_id']), None
                )
                if pc_data:
                    protein_classifications.append(pc_data)
                else:
                    print(
                        'ERROR: missing protein classification data for id \'{0}\''
                        .format(p_class_j['protein_classification_id'])
                        , file=sys.stderr
                    )
        return protein_classifications

    def save_denormalization(self):

        mappings = SummableDict()
        mappings += self.METADATA_MAPPING
        mappings += ProteinClassDenormalizationHandler.METADATA_MAPPING

        def get_update_script_and_size(doc_id, doc):
            update_size = len(doc)*20
            protein_classifications = self.get_protein_classifications(doc_id)

            update_doc = {
                '_metadata': {
                    'target_component': doc,
                    'protein_classification': protein_classifications
                }
            }

            return update_doc, update_size

        self.save_denormalization_dict(
            DenormalizationHandler.AVAILABLE_RESOURCES.TARGET,
            self.target_dict,
            get_update_script_and_size, mappings
        )

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        return mappings

    def get_doc_for_complete_data(self, doc: dict):

        if self.complete_x_refs:
            xrefs_helper.complete_xrefs(doc['target_component_xrefs'])

        return {
            'target_component_xrefs': doc['target_component_xrefs']
        }
