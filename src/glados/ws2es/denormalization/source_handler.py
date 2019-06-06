from glados.ws2es.denormalization import DenormalizationHandler
from glados.ws2es.es_util import DefaultMappings


class SourceDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.SOURCE

    METADATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'source':
                    {
                        'properties':
                        {
                            'src_description': DefaultMappings.KEYWORD,
                            'src_id': DefaultMappings.ID_REF,
                            'src_short_name': DefaultMappings.KEYWORD
                        }
                    }
                }

            }
        }
    }

    def __init__(self):
        super().__init__()
        self.sources_by_id = {}

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        self.sources_by_id[doc['src_id']] = doc
