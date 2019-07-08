import sys
from glados.es.ws2es.es_util import DefaultMappings
from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.denormalization.assay_handler import AssayDenormalizationHandler
from glados.es.ws2es.denormalization.compound_handler import CompoundDenormalizationHandler
from glados.es.ws2es.denormalization.compound_record_handler import CompoundRecordDenormalizationHandler
from glados.es.ws2es.denormalization.organism_handler import OrganismDenormalizationHandler
from glados.es.ws2es.denormalization.source_handler import SourceDenormalizationHandler
from glados.es.ws2es.denormalization.target_component_handler import TargetComponentDenormalizationHandler
from glados.es.ws2es.denormalization.target_handler import TargetDenormalizationHandler
from glados.es.ws2es.denormalization.protein_class_handler import ProteinClassDenormalizationHandler
from glados.es.ws2es.progress_bar_handler import get_new_progressbar


class ActivityDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.ACTIVITY

    def __init__(self, complete_from_activity: bool=False, assay_dh: AssayDenormalizationHandler=None,
                 compound_dh: CompoundDenormalizationHandler=None, organism_dh: OrganismDenormalizationHandler=None,
                 source_dh: SourceDenormalizationHandler=None, target_dh: TargetDenormalizationHandler=None,
                 target_component_dh: TargetComponentDenormalizationHandler=None,
                 compound_record_dh: CompoundRecordDenormalizationHandler=None):
        super().__init__(complete_from_activity or
                         assay_dh is not None or
                         compound_dh is not None or
                         organism_dh is not None or
                         source_dh is not None or
                         target_dh is not None or
                         target_component_dh is not None or
                         compound_record_dh is not None)
        self.assay_dh = assay_dh
        self.compound_dh = compound_dh
        self.organism_dh = organism_dh
        self.source_dh = source_dh
        self.target_dh = target_dh
        self.target_component_dh = target_component_dh
        self.compound_record_dh = compound_record_dh

        self.assay_dict = {}
        self.compound_dict = {}
        self.document_dict = {}
        self.target_dict = {}

        self.compound_2_assay = {}
        self.assay_2_compound = {}

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        self.collect_data(doc, self.assay_dict, 'assay_chembl_id', [
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ACTIVITY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.DOCUMENT],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.MOLECULE],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.TARGET],
            ]
        )
        self.collect_data(doc, self.document_dict, 'document_chembl_id', [
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ACTIVITY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ASSAY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.MOLECULE],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.TARGET],
            ]
        )
        self.collect_data(doc, self.compound_dict, 'molecule_chembl_id', [
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ACTIVITY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ASSAY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.DOCUMENT],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.TARGET],
            ]
        )
        self.collect_data(doc, self.target_dict, 'target_chembl_id', [
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ACTIVITY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.ASSAY],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.DOCUMENT],
                self.DENORMALIZATION_CONFIGURATIONS[self.AVAILABLE_RESOURCES.MOLECULE],
            ]
        )

        if doc['molecule_chembl_id'] not in self.compound_2_assay:
            self.compound_2_assay[doc['molecule_chembl_id']] = set()
        self.compound_2_assay[doc['molecule_chembl_id']].add(doc['assay_chembl_id'])

        if doc['assay_chembl_id'] not in self.assay_2_compound:
            self.assay_2_compound[doc['assay_chembl_id']] = set()
        self.assay_2_compound[doc['assay_chembl_id']].add(doc['molecule_chembl_id'])

    def save_denormalization(self):
        self.submit_docs_collected_data(self.assay_dict,
                                        DenormalizationHandler.AVAILABLE_RESOURCES.ASSAY)
        self.submit_docs_collected_data(self.compound_dict,
                                        DenormalizationHandler.AVAILABLE_RESOURCES.MOLECULE)
        self.submit_docs_collected_data(self.document_dict,
                                        DenormalizationHandler.AVAILABLE_RESOURCES.DOCUMENT)
        self.submit_docs_collected_data(self.target_dict,
                                        DenormalizationHandler.AVAILABLE_RESOURCES.TARGET)

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += AssayDenormalizationHandler.ACTIVITY_DATA_MAPPING
        mappings += CompoundDenormalizationHandler.ACTIVITY_DATA_MAPPING
        mappings += SourceDenormalizationHandler.METADATA_MAPPING
        mappings += OrganismDenormalizationHandler.METADATA_MAPPING
        mappings += CompoundRecordDenormalizationHandler.ACTIVITY_DATA_MAPPING
        mappings += TargetDenormalizationHandler.ACTIVITY_DATA_MAPPING
        mappings += ProteinClassDenormalizationHandler.METADATA_MAPPING
        mappings += {
            'properties':
            {
                '_metadata':
                {
                    'properties':
                    {
                        'activity_generated':
                        {
                            'properties':
                            {
                                'short_data_validity_comment': DefaultMappings.KEYWORD
                            }
                        }
                    }
                }
            }
        }
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        update_doc_md = {}
        assay_data = None
        if self.assay_dh and doc['assay_chembl_id'] in self.assay_dh.assay_activity_data:
            assay_data = self.assay_dh.assay_activity_data[doc['assay_chembl_id']]
        if assay_data is not None:
            update_doc_md['assay_data'] = assay_data

        compound_data = None
        if self.compound_dh and doc['molecule_chembl_id'] in self.compound_dh.molecule_activity_data:
            compound_data = self.compound_dh.molecule_activity_data[doc['molecule_chembl_id']]
        if compound_data is not None:
            update_doc_md['parent_molecule_data'] = compound_data

        compound_record_data = None
        if self.compound_record_dh and \
                doc['record_id'] in self.compound_record_dh.compound_record_activity_data:
            compound_record_data = self.compound_record_dh.compound_record_activity_data[doc['record_id']]
        if compound_record_data is not None:
            if 'parent_molecule_data' not in update_doc_md:
                update_doc_md['parent_molecule_data'] = {}
            update_doc_md['parent_molecule_data']['compound_key'] = compound_record_data['compound_key']

        source = None
        if self.source_dh and doc['src_id'] in self.source_dh.sources_by_id:
            source = self.source_dh.sources_by_id[doc['src_id']]
        if source is not None:
            update_doc_md['source'] = source

        organism_taxonomy = None
        try:
            if doc['target_tax_id']:
                tax_id = int(doc['target_tax_id'])
                if self.organism_dh and tax_id in self.organism_dh.organism_by_id:
                    organism_taxonomy = self.organism_dh.organism_by_id[tax_id]
                if organism_taxonomy is not None:
                    update_doc_md['organism_taxonomy'] = organism_taxonomy
        except:
            print('ERROR: taxonomy id is not a number {0}'.format(doc['target_tax_id']), file=sys.stderr)

        protein_classification = None
        if self.target_component_dh:
            protein_classification = self.target_component_dh.get_protein_classifications(doc['target_chembl_id'])
        if protein_classification is not None:
            update_doc_md['protein_classification'] = protein_classification

        target_data = None
        if self.target_dh:
            target_data = self.target_dh.target_2_target_type.get(doc['target_chembl_id'], None)
        if target_data:
            update_doc_md['target_data'] = target_data

        return {
            '_metadata': update_doc_md
        }

    def complete_compound(self):
        pb = get_new_progressbar('compound-completion', len(self.compound_2_assay))
        for i, molecule_chembl_id in enumerate(self.compound_2_assay):
            if molecule_chembl_id not in self.compound_dict:
                self.compound_dict[molecule_chembl_id] = {}
            self.compound_dict[molecule_chembl_id]['related_cell_lines'] = {
                'count': 0,
                'all_chembl_ids': set()
            }
            self.compound_dict[molecule_chembl_id]['related_tissues'] = {
                'count': 0,
                'all_chembl_ids': set()
            }
            for assay in self.compound_2_assay.get(molecule_chembl_id, []):
                cell_n_tissue = self.assay_dh.assay_2_cell_n_tissue.get(assay, {})
                cell_id = cell_n_tissue.get('cell_chembl_id', None)
                tissue_id = cell_n_tissue.get('tissue_chembl_id', None)
                if cell_id and \
                        cell_id not in self.compound_dict[molecule_chembl_id]['related_cell_lines']['all_chembl_ids']:
                    self.compound_dict[molecule_chembl_id]['related_cell_lines']['count'] += 1
                    self.compound_dict[molecule_chembl_id]['related_cell_lines']['all_chembl_ids'].add(cell_id)
                if tissue_id and \
                        tissue_id not in self.compound_dict[molecule_chembl_id]['related_tissues']['all_chembl_ids']:
                    self.compound_dict[molecule_chembl_id]['related_tissues']['count'] += 1
                    self.compound_dict[molecule_chembl_id]['related_tissues']['all_chembl_ids'].add(tissue_id)
            pb.update(i)
        pb.finish()
