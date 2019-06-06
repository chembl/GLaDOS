import sys
from glados.ws2es.denormalization import DenormalizationHandler
from glados.ws2es.es_util import DefaultMappings
from glados.ws2es.util import SummableDict
from glados.ws2es.denormalization.document_handler import DocumentDenormalizationHandler


class DocumentSimilarityHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.DOCUMENT_SIMILARITY

    def __init__(self, document_dh: DocumentDenormalizationHandler):
        super().__init__()
        self.document_dict = {}
        self.document_dh = document_dh

    def save_similarity_data(self, chembl_id_1, chembl_id_2, mol_tani, tid_tani):
        if chembl_id_1 not in self.document_dict:
            self.document_dict[chembl_id_1] = {}
        if chembl_id_2 not in self.document_dict[chembl_id_1]:
            self.document_dict[chembl_id_1][chembl_id_2] = []

        data_dict = SummableDict()
        data_dict += {
            'document_chembl_id': chembl_id_2,
            'mol_tani': mol_tani,
            'tid_tani': tid_tani
        }
        data_dict += self.document_dh.docs_for_assay_by_chembl_id[chembl_id_2]

        self.document_dict[chembl_id_1][chembl_id_2].append(data_dict)

    def handle_doc(self, es_doc: dict, total_docs: int, index: int, first: bool, last: bool):
        chembl_id_1 = es_doc['document_1_chembl_id']
        chembl_id_2 = es_doc['document_2_chembl_id']
        if chembl_id_1 == chembl_id_2:
            print('WARNING FOUND DUPLICATE CHEMBL ID FOR:', chembl_id_1, chembl_id_2, file=sys.stderr)
        self.save_similarity_data(chembl_id_1, chembl_id_2, es_doc['mol_tani'], es_doc['tid_tani'])
        self.save_similarity_data(chembl_id_2, chembl_id_1, es_doc['mol_tani'], es_doc['tid_tani'])

    def save_denormalization(self):
        for key_i, value_i in self.document_dict.items():
            for key_j, value_j in value_i.items():
                if len(value_j) != 1:
                    print('WARNING FOUND DUPLICATE DATA FOR:', key_i, key_j, value_j, file=sys.stderr)

        def get_update_script_and_size(es_doc_id, es_doc):
            similar_docs = []
            for chembl_id_other, similarity_list in es_doc.items():
                similar_docs.append(similarity_list[0])
            update_size = len(similar_docs)*10

            update_doc = {
                '_metadata': {
                    'similar_documents': similar_docs
                }
            }

            return update_doc, update_size

        new_mappings = SummableDict()
        new_mappings += {
            'properties': {
                '_metadata': {
                    'properties': {
                        'similar_documents': {
                            'properties': {
                                'document_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                                'mol_tani': DefaultMappings.FLOAT,
                                'tid_tani': DefaultMappings.FLOAT
                            }
                        }
                    }
                }
            }
        }
        new_mappings += DocumentDenormalizationHandler.FIELDS_FOR_DOC_SIM_MAPPING

        self.save_denormalization_dict(
            DenormalizationHandler.AVAILABLE_RESOURCES.DOCUMENT,
            self.document_dict,
            get_update_script_and_size,
            new_mappings=new_mappings
        )
