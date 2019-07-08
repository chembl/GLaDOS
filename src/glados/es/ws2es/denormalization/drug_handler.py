import sys
from glados.es.ws2es.denormalization import DenormalizationHandler


class DrugDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.DRUG

    def __init__(self):
        super().__init__()
        self.compound_dict = {}

    def handle_doc(self, es_doc: dict, total_docs: int, index: int, first: bool, last: bool):
        molecule_c_id = es_doc.get('molecule_chembl_id', None)
        if molecule_c_id:
            if molecule_c_id not in self.compound_dict:
                self.compound_dict[molecule_c_id] = es_doc
        else:
            print('WARNING: drug without compound :{0}'.format(molecule_c_id),
                  file=sys.stderr)

    def save_denormalization(self):
        def get_update_script_and_size(es_doc_id, es_doc):
            update_size = len(es_doc)*10

            update_doc = {
                '_metadata': {
                    'drug': {
                        'is_drug': True,
                        'drug_data': es_doc
                    }
                }
            }

            return update_doc, update_size

        self.save_denormalization_dict(
            DenormalizationHandler.AVAILABLE_RESOURCES.MOLECULE,
            self.compound_dict,
            get_update_script_and_size
        )


