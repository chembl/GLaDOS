from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.es_util import DefaultMappings
from glados.es.ws2es.denormalization.source_handler import SourceDenormalizationHandler


class CompoundRecordDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.COMPOUND_RECORD

    ACTIVITY_DATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'parent_molecule_data':
                    {
                        'properties':
                        {
                            'compound_key': DefaultMappings.KEYWORD
                        }
                    }
                }
            }
        }
    }

    COMPOUND_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'compound_records':
                    {
                        'properties':
                        {
                            'compound_key': DefaultMappings.ALT_NAME,
                            'compound_name': DefaultMappings.ALT_NAME,
                            'src_description': DefaultMappings.KEYWORD,
                            'src_id': DefaultMappings.ID_REF,
                            'src_short_name': DefaultMappings.KEYWORD
                        }
                    }
                }
            }
        }
    }

    def __init__(self, source_dh: SourceDenormalizationHandler=None):
        super().__init__()
        self.source_dh = source_dh
        self.compound_dict = {}
        self.compound_record_activity_data = {}

    def handle_doc(self, es_doc: dict, total_docs: int, index: int, first: bool, last: bool):
        molecule_c_id = es_doc.get('molecule_chembl_id', None)
        record_id = es_doc['record_id']

        if molecule_c_id:
            if molecule_c_id not in self.compound_dict:
                self.compound_dict[molecule_c_id] = []
            new_record = {}
            compound_name = es_doc.get('compound_name', None)
            if compound_name:
                new_record['compound_name'] = compound_name
            compound_key = es_doc.get('compound_key', None)
            if compound_key:
                new_record['compound_key'] = compound_key

            src_id = es_doc['src_id']
            if src_id and self.source_dh:
                source_data = self.source_dh.sources_by_id.get(src_id, None)
                if source_data:
                    new_record['src_description'] = source_data['src_description']
                    new_record['src_id'] = source_data['src_id']
                    new_record['src_short_name'] = source_data['src_short_name']
            self.compound_dict[molecule_c_id].append(new_record)

            self.compound_record_activity_data[record_id] = {'compound_key': compound_key}

    def save_denormalization(self):
        def get_update_script_and_size(es_doc_id, es_doc):
            compound_record_data = list(es_doc)
            update_size = len(compound_record_data)*2

            update_doc = {
                '_metadata': {
                    'compound_records': compound_record_data
                }
            }

            return update_doc, update_size

        self.save_denormalization_dict(
            DenormalizationHandler.AVAILABLE_RESOURCES.MOLECULE,
            self.compound_dict,
            get_update_script_and_size, new_mappings=self.COMPOUND_MAPPING
        )
