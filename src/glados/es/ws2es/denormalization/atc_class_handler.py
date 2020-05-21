from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.mappings.es_chembl_atc_class_mapping import mappings


class ATCClassDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.ATC_CLASS

    METADATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'atc_classifications': mappings
                }

            }
        }
    }

    def __init__(self):
        super().__init__()
        self.atc_class_by_level5 = {}

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        for i in range(1, 5):
            prop_name = 'level{0}'.format(i)
            prop_desc_name = 'level{0}_description'.format(i)
            level_val = doc.get(prop_name, None)
            if level_val is not None and len(level_val) > 0:
                doc[prop_desc_name] = '{0} - {1}'.format(level_val, doc.get(prop_desc_name, ''))

        self.atc_class_by_level5[doc['level5']] = doc
