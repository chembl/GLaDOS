from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.denormalization.source_handler import SourceDenormalizationHandler
from glados.es.ws2es.denormalization.assay_handler import AssayDenormalizationHandler
from glados.es.ws2es.util import put_js_path_in_dict
from glados.es.ws2es.es_util import DefaultMappings


class DocumentDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.DOCUMENT

    FIELDS_FOR_ACTIVITY = ['pubmed_id', 'volume', 'year', 'first_page']

    FIELDS_FOR_ACTIVITY_MAPPING = {}

    for field_i in FIELDS_FOR_ACTIVITY:
        put_js_path_in_dict(FIELDS_FOR_ACTIVITY_MAPPING, '._metadata.document_data.{0}'.format(field_i),
                            DefaultMappings.NO_INDEX_KEYWORD, es_properties_style=True)

    FIELDS_FOR_ASSAY = ['journal', 'year', 'volume', 'first_page', 'last_page', 'title', 'pubmed_id', 'doi']

    FIELDS_FOR_ASSAY_MAPPING = {}

    FIELDS_FOR_DOC_SIM_MAPPING = {}

    for field_i in FIELDS_FOR_ASSAY:
        put_js_path_in_dict(FIELDS_FOR_ASSAY_MAPPING, '._metadata.document_data.{0}'.format(field_i),
                            DefaultMappings.NO_INDEX_KEYWORD, es_properties_style=True)
        put_js_path_in_dict(FIELDS_FOR_DOC_SIM_MAPPING, '._metadata.similar_documents.{0}'.format(field_i),
                            DefaultMappings.NO_INDEX_KEYWORD, es_properties_style=True)

    def __init__(self, assay_dh: AssayDenormalizationHandler=None, source_dh: SourceDenormalizationHandler=None):
        super().__init__(source_dh is not None or assay_dh is not None)
        self.assay_dh = assay_dh
        self.source_dh = source_dh
        self.docs_for_assay_by_chembl_id = {}
        self.docs_for_activity_by_chembl_id = {}

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        doc_chembl_id = doc['document_chembl_id']
        fields_for_assay = {}
        for field_i in self.FIELDS_FOR_ASSAY:
            fields_for_assay[field_i] = doc[field_i]
        self.docs_for_assay_by_chembl_id[doc_chembl_id] = fields_for_assay

        fields_for_activity = {}
        for field_i in self.FIELDS_FOR_ACTIVITY:
            fields_for_activity[field_i] = doc[field_i]
        self.docs_for_activity_by_chembl_id[doc_chembl_id] = fields_for_activity

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += SourceDenormalizationHandler.METADATA_MAPPING
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        update_doc_md = {}

        src_ids = self.assay_dh.document_2_src_id.get(doc['document_chembl_id'], set())
        if 'src_id' in doc:
            src_ids.add(doc['src_id'])
        sources = []
        for src_id_i in src_ids:
            if self.source_dh and src_id_i in self.source_dh.sources_by_id:
                sources.append(self.source_dh.sources_by_id[src_id_i])
        if sources is not None:
            update_doc_md['source'] = sources

        return {
            '_metadata': update_doc_md
        }
