from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.es_util import DefaultMappings
from glados.es.ws2es.denormalization.source_handler import SourceDenormalizationHandler
from glados.es.ws2es.denormalization.organism_handler import OrganismDenormalizationHandler
from glados.es.ws2es.progress_bar_handler import get_new_progressbar


class AssayDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.ASSAY

    ACTIVITY_DATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'assay_data':
                    {
                        'properties':
                        {
                            'assay_organism': DefaultMappings.LOWER_CASE_KEYWORD,
                            'assay_tissue': DefaultMappings.LOWER_CASE_KEYWORD,
                            'assay_cell_type': DefaultMappings.LOWER_CASE_KEYWORD,
                            'assay_subcellular_fraction': DefaultMappings.LOWER_CASE_KEYWORD,
                            'cell_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                            'tissue_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                            'type_label': DefaultMappings.KEYWORD
                        }
                    }
                }
            }
        }
    }

    def __init__(self, complete_from_assay: bool=False, organism_dh: OrganismDenormalizationHandler=None,
                 source_dh: SourceDenormalizationHandler=None, document_dh=None):
        super().__init__(complete_from_assay or source_dh is not None or organism_dh is not None or
                         document_dh is not None)
        self.source_dh = source_dh
        self.organism_dh = organism_dh
        self.cell_dict = {}
        self.document_dict = {}
        self.target_dict = {}
        self.tissue_dict = {}

        self.assay_2_cell_n_tissue = {}
        self.cell_2_assay = {}
        self.tissue_2_assay = {}
        self.assay_activity_data = {}
        self.document_2_src_id = {}
        self.tissue_2_tax_id = {}
        self.document_dh = document_dh
        self.document_dh_mappings = None
        if document_dh:
            self.document_dh_mappings = self.document_dh.FIELDS_FOR_ASSAY_MAPPING

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        self.collect_data(doc, self.cell_dict, 'cell_chembl_id', [
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ASSAY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.DOCUMENT],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.TARGET],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.TISSUE],
            ]
        )
        self.collect_data(doc, self.document_dict, 'document_chembl_id', [
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.CELL_LINE],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.TISSUE],
            ]
        )
        self.collect_data(doc, self.target_dict, 'target_chembl_id', [
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.CELL_LINE],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.TISSUE],
            ]
        )
        self.collect_data(doc, self.tissue_dict, 'tissue_chembl_id', [
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ASSAY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.CELL_LINE],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.DOCUMENT],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.TARGET],
            ]
        )

        self.assay_2_cell_n_tissue[doc['assay_chembl_id']] = {
            'cell_chembl_id': doc['cell_chembl_id'],
            'tissue_chembl_id': doc['tissue_chembl_id'],
        }
        if doc['cell_chembl_id']:
            if doc['cell_chembl_id'] not in self.cell_2_assay:
                self.cell_2_assay[doc['cell_chembl_id']] = set()
            self.cell_2_assay[doc['cell_chembl_id']].add(doc['assay_chembl_id'])
        if doc['tissue_chembl_id']:
            if doc['tissue_chembl_id'] not in self.tissue_2_assay:
                self.tissue_2_assay[doc['tissue_chembl_id']] = set()
            self.tissue_2_assay[doc['tissue_chembl_id']].add(doc['assay_chembl_id'])

        self.assay_activity_data[doc['assay_chembl_id']] = {
            'assay_organism': doc['assay_organism'],
            'assay_tissue': doc['assay_tissue'],
            'assay_cell_type': doc['assay_cell_type'],
            'assay_subcellular_fraction': doc['assay_subcellular_fraction'],
            'cell_chembl_id': doc['cell_chembl_id'],
            'tissue_chembl_id': doc['tissue_chembl_id'],
            'type_label': '{0} - {1}'.format(doc['assay_type'], doc['assay_type_description'])
        }
        if doc['document_chembl_id']:
            # TODO documents should not have multiple src_ids, but we'll have to wait until CHEMBL_24
            if doc['document_chembl_id'] not in self.document_2_src_id:
                self.document_2_src_id[doc['document_chembl_id']] = set()
            self.document_2_src_id[doc['document_chembl_id']].add(doc['src_id'])

        if doc['tissue_chembl_id']:
            if doc['tissue_chembl_id'] not in self.tissue_2_tax_id:
                self.tissue_2_tax_id[doc['tissue_chembl_id']] = set()
            self.tissue_2_tax_id[doc['tissue_chembl_id']].add(doc['assay_tax_id'])

    def save_denormalization(self):
        self.submit_docs_collected_data(self.cell_dict,
                                        DenormalizationHandler.AVAILABLE_RESOURCES.CELL_LINE)
        self.submit_docs_collected_data(self.document_dict,
                                        DenormalizationHandler.AVAILABLE_RESOURCES.DOCUMENT)
        self.submit_docs_collected_data(self.target_dict,
                                        DenormalizationHandler.AVAILABLE_RESOURCES.TARGET)
        self.submit_docs_collected_data(self.tissue_dict,
                                        DenormalizationHandler.AVAILABLE_RESOURCES.TISSUE)

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += SourceDenormalizationHandler.METADATA_MAPPING
        mappings += OrganismDenormalizationHandler.METADATA_MAPPING
        mappings += {
            'properties':
            {
                '_metadata':
                {
                    'properties':
                    {
                        'assay_generated':
                        {
                            'properties':
                            {
                                'confidence_label': DefaultMappings.KEYWORD,
                                'relationship_label': DefaultMappings.KEYWORD,
                                'type_label': DefaultMappings.KEYWORD
                            }
                        }
                    }

                }
            }
        }
        if self.document_dh_mappings:
            mappings += self.document_dh_mappings
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        update_doc_md = {}

        source = None
        if self.source_dh and doc['src_id'] in self.source_dh.sources_by_id:
            source = self.source_dh.sources_by_id[doc['src_id']]
        if source is not None:
            update_doc_md['source'] = source

        organism_taxonomy = None
        if self.organism_dh and doc['assay_tax_id'] in self.organism_dh.organism_by_id:
            organism_taxonomy = self.organism_dh.organism_by_id[doc['assay_tax_id']]
        if organism_taxonomy is not None:
            update_doc_md['organism_taxonomy'] = organism_taxonomy

        confidence_label = '{0} - {1}'.format(doc['confidence_score'], doc['confidence_description'])
        relationship_label = '{0} - {1}'.format(doc['relationship_type'], doc['relationship_description'])
        type_label = '{0} - {1}'.format(doc['assay_type'], doc['assay_type_description'])
        update_doc_md['assay_generated'] = {
            'confidence_label': confidence_label,
            'relationship_label': relationship_label,
            'type_label': type_label,
        }

        update_doc_md['document_data'] = self.document_dh.docs_for_assay_by_chembl_id\
            .get(doc.get('document_chembl_id', None), None)

        return {
            '_metadata': update_doc_md
        }

    def complete_cell_n_tissue(self, assay_2_compound: dict, ac_dh_assay_dict: dict):
        pb = get_new_progressbar('cell-completion', len(self.cell_2_assay))
        for i, cell_id in enumerate(self.cell_2_assay):
            if cell_id not in self.cell_dict:
                self.cell_dict[cell_id] = {}
            self.cell_dict[cell_id]['related_activities'] = {
                'count': 0,
                'all_chembl_ids': set()
            }
            self.cell_dict[cell_id]['related_compounds'] = {
                'count': 0,
                'all_chembl_ids': set()
            }
            for assay in self.cell_2_assay.get(cell_id, []):
                compounds = assay_2_compound.get(assay, {})
                for compound_i in compounds:
                    if compound_i not in self.cell_dict[cell_id]['related_compounds']['all_chembl_ids']:
                        self.cell_dict[cell_id]['related_compounds']['count'] += 1
                        self.cell_dict[cell_id]['related_compounds']['all_chembl_ids'].add(compound_i)
                if ac_dh_assay_dict.get(assay, None):
                    self.cell_dict[cell_id]['related_activities']['count'] += ac_dh_assay_dict[assay].get(
                        'related_activities', {}
                    ).get('count', 0)
            pb.update(i)
        pb.finish()

        pb = get_new_progressbar('tissue-completion', len(self.tissue_2_assay))
        for i, tissue_id in enumerate(self.tissue_2_assay):
            if tissue_id not in self.tissue_dict:
                self.tissue_dict[tissue_id] = {}
            self.tissue_dict[tissue_id]['related_activities'] = {
                'count': 0,
                'all_chembl_ids': set()
            }
            self.tissue_dict[tissue_id]['related_compounds'] = {
                'count': 0,
                'all_chembl_ids': set()
            }
            for assay in self.tissue_2_assay.get(tissue_id, []):
                compounds = assay_2_compound.get(assay, {})
                for compound_i in compounds:
                    if compound_i not in self.tissue_dict[tissue_id]['related_compounds']['all_chembl_ids']:
                        self.tissue_dict[tissue_id]['related_compounds']['count'] += 1
                        self.tissue_dict[tissue_id]['related_compounds']['all_chembl_ids'].add(compound_i)
                if ac_dh_assay_dict.get(assay, None):
                    self.tissue_dict[tissue_id]['related_activities']['count'] += ac_dh_assay_dict[assay].get(
                        'related_activities', {}
                    ).get('count', 0)
            pb.update(i)
        pb.finish()

