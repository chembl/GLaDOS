from glados.ws2es.denormalization import DenormalizationHandler
from glados.ws2es.es_util import DefaultMappings


class ProteinClassDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.PROTEIN_CLASS

    METADATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'protein_classification':
                    {
                        'properties':
                        {
                            'l1': DefaultMappings.KEYWORD,
                            'l2': DefaultMappings.KEYWORD,
                            'l3': DefaultMappings.KEYWORD,
                            'l4': DefaultMappings.KEYWORD,
                            'l5': DefaultMappings.KEYWORD,
                            'l6': DefaultMappings.KEYWORD,
                            'protein_class_id': DefaultMappings.ID_REF,
                        }

                    }
                }
            }
        }
    }

    def __init__(self):
        super().__init__()
        self.protein_class_by_id = {}

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        self.protein_class_by_id['{0}'.format(doc['protein_class_id'])] = doc
