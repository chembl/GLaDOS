from glados.ws2es.util import SummableDict
from glados.ws2es.denormalization import DenormalizationHandler
from glados.ws2es.denormalization.organism_handler import OrganismDenormalizationHandler
from glados.ws2es.denormalization.target_prediction_handler import TargetPredictionDenormalizationHandler
from glados.ws2es.es_util import DefaultMappings
import glados.ws2es.denormalization.xrefs_helper as xrefs_helper


class TargetDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.TARGET

    ACTIVITY_DATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'target_data':
                    {
                        'properties':
                        {
                            'target_type': DefaultMappings.LOWER_CASE_KEYWORD
                        }
                    }
                }
            }
        }
    }

    def __init__(self, complete_x_refs: bool=False, organism_dh: OrganismDenormalizationHandler=None,
                 tp_dh: TargetPredictionDenormalizationHandler=None):
        super().__init__(complete_x_refs or organism_dh is not None or tp_dh is not None)
        self.complete_x_refs = complete_x_refs
        self.organism_dh = organism_dh
        self.tp_dh = tp_dh
        self.target_2_target_type = {}
        self.target_by_id = {}

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        self.target_by_id[doc['target_chembl_id']] = doc
        self.target_2_target_type[doc['target_chembl_id']] = {'target_type': doc['target_type']}

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += self.RELATED_ENTITIES_DYNAMIC_MAPPING
        mappings += TargetPredictionDenormalizationHandler.METADATA_MAPPING
        mappings += OrganismDenormalizationHandler.METADATA_MAPPING
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        update_doc_md = {}

        organism_taxonomy = None
        if self.organism_dh and doc['tax_id'] in self.organism_dh.organism_by_id:
            organism_taxonomy = self.organism_dh.organism_by_id[doc['tax_id']]
        if organism_taxonomy is not None:
            update_doc_md['organism_taxonomy'] = organism_taxonomy

        target_predictions = None
        if self.tp_dh:
            target_predictions = self.tp_dh.target_chembl_id_2_target_predictions.get(doc['target_chembl_id'], None)
        if target_predictions and len(target_predictions) > 0:
            update_doc_md['target_predictions'] = target_predictions
        if self.complete_x_refs:
            xrefs_helper.complete_xrefs(doc['cross_references'])

        target_components_with_completed_xrefs = []
        initial_target_components = doc.get('target_components', [])
        for tc_i in initial_target_components:
            xrefs_helper.complete_xrefs(tc_i.get('target_component_xrefs', []))
            target_components_with_completed_xrefs.append(tc_i)

        return {
            'cross_references': doc['cross_references'],
            '_metadata': update_doc_md,
            'target_components': target_components_with_completed_xrefs
        }
