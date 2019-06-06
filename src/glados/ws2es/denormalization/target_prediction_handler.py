from glados.ws2es.denormalization import DenormalizationHandler
from glados.ws2es.mappings.es_chembl_target_prediction_mapping import mappings as tp_mappings
from glados.ws2es.es_util import DefaultMappings
from glados.ws2es.util import SummableDict


class TargetPredictionDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.TARGET_PREDICTION

    METADATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'target_predictions': tp_mappings['_doc']
                }
            }
        }
    }

    def __init__(self, target_dh=None):
        super().__init__(target_dh is not None)
        self.target_dh = target_dh
        self.target_chembl_id_2_target_predictions = {}
        self.molecule_chembl_id_2_target_predictions = {}

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += {
            'properties': {
                'target_pref_name': DefaultMappings.KEYWORD
            }
        }
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        target_chembl_id = doc['target_chembl_id']
        target_pref_name = self.target_dh.target_by_id.get(target_chembl_id, {}).get('pref_name', None)
        return {
            'target_pref_name': target_pref_name
        }

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        molecule_chembl_id = doc['molecule_chembl_id']
        if molecule_chembl_id not in self.molecule_chembl_id_2_target_predictions:
            self.molecule_chembl_id_2_target_predictions[molecule_chembl_id] = []
        self.molecule_chembl_id_2_target_predictions[molecule_chembl_id].append(doc)

        target_chembl_id = doc['target_chembl_id']
        if target_chembl_id not in self.target_chembl_id_2_target_predictions:
            self.target_chembl_id_2_target_predictions[target_chembl_id] = []
        self.target_chembl_id_2_target_predictions[target_chembl_id].append(doc)
