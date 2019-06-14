import glados.es.ws2es.progress_bar_handler as progress_bar_handler
from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.denormalization import DenormalizationHandler
import glados.es.ws2es.mappings.es_chembl_drug_indication_mapping as drug_indication_mapping
from glados.es.ws2es.denormalization.compound_family_helper import CompoundFamiliesDir
from glados.es.ws2es.es_util import DefaultMappings, create_idx, delete_idx

from glados.es.ws2es.resources_description import MOLECULE, DRUG_INDICATION, DRUG_INDICATION_BY_PARENT
import sys


class DrugIndicationDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.DRUG_INDICATION

    @staticmethod
    def get_new_index_mappings():
        return {
            '_doc':
            {
                'properties':
                {
                    'parent_molecule':
                    {
                        'properties': MOLECULE.get_resource_mapping_from_es()
                    },
                    'drug_indication': {
                        'properties': SummableDict(**DRUG_INDICATION.get_resource_mapping_from_es()) -
                        ['efo_term', 'efo_id'] +
                        {
                            'efo': {
                                'properties': {
                                    'term': DefaultMappings.LOWER_CASE_KEYWORD + DefaultMappings.TEXT_STD,
                                    'id': DefaultMappings.ID
                                }
                            }
                        }
                    }
                }

            }
        }

    def __init__(self, compound_families_dir: CompoundFamiliesDir=None):
        super().__init__(compound_families_dir is not None)
        self.compound_families_dir = compound_families_dir
        self.compound_dict = {}
        self.drug_inds_by_grouping_id = {}
        self.generated_resource = DRUG_INDICATION_BY_PARENT

    def get_drug_ind_grouping_id_parts(self, doc):
        if self.compound_families_dir is None:
            raise Exception('The grouping will not be correct if the compound families directory is not provided!')
        family_data = self.compound_families_dir.find_node(doc['molecule_chembl_id'])
        parent_chembl_id = family_data.get_family_parent_id()
        return parent_chembl_id, doc.get('mesh_id')

    def get_drug_ind_grouping_id(self, doc):
        parent_chembl_id, mesh_id = self.get_drug_ind_grouping_id_parts(doc)
        return '{0}-{1}'.format(parent_chembl_id, mesh_id)

    def handle_doc(self, es_doc: dict, total_docs: int, index: int, first: bool, last: bool):
        molecule_c_id = es_doc.get('molecule_chembl_id', None)
        if molecule_c_id:
            if molecule_c_id not in self.compound_dict:
                self.compound_dict[molecule_c_id] = []
            self.compound_dict[molecule_c_id].append(es_doc)
        else:
            print('WARNING: drug-indication without compound :{0}'.format(molecule_c_id),
                  file=sys.stderr)

        if self.compound_families_dir:
            grouping_id = self.get_drug_ind_grouping_id(es_doc)
            if grouping_id not in self.drug_inds_by_grouping_id:
                self.drug_inds_by_grouping_id[grouping_id] = []
            self.drug_inds_by_grouping_id[grouping_id].append(es_doc)

    def save_denormalization(self):
        def get_update_script_and_size(es_doc_id, es_doc):
            update_size = len(es_doc)

            update_doc = {
                '_metadata': {
                    'drug_indications': es_doc
                }
            }

            return update_doc, update_size

        self.save_denormalization_dict(
            DenormalizationHandler.AVAILABLE_RESOURCES.MOLECULE,
            self.compound_dict,
            get_update_script_and_size,
            new_mappings={
                'properties': {
                    '_metadata': {
                        'properties': {
                            'drug_indications': drug_indication_mapping.mappings['_doc']
                        }
                    }
                }
            }
        )

        if self.compound_families_dir:
            self.save_denormalization_for_new_index()

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += {
            'properties':
            {
                '_metadata':
                {
                    'properties':
                    {
                        'all_molecule_chembl_ids': DefaultMappings.CHEMBL_ID_REF
                    }
                }
            }
        }
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        molecule_chembl_id = doc['molecule_chembl_id']
        all_branch_ids = self.compound_families_dir.find_node(molecule_chembl_id).get_all_branch_ids()
        return {
            '_metadata': {
                'all_molecule_chembl_ids': all_branch_ids
            }
        }

    def save_denormalization_for_new_index(self):
        delete_idx(self.generated_resource.idx_name)
        create_idx(self.generated_resource.idx_name, 3, 1, analysis=DefaultMappings.COMMON_ANALYSIS,
                   mappings=DrugIndicationDenormalizationHandler.get_new_index_mappings())

        dn_dict = {}

        print('{0} GROUPED RECORDS WERE FOUND'.format(len(self.drug_inds_by_grouping_id)), file=sys.stderr)
        p_bar = progress_bar_handler.get_new_progressbar('drug_inds_by_parent-dn-generation',
                                                         len(self.drug_inds_by_grouping_id))
        i = 0
        for group_drug_inds in self.drug_inds_by_grouping_id.values():
            base_drug_ind = group_drug_inds[0]
            max_phase = 0
            efo_data = {}
            indication_refs = []
            for drug_ind_i in group_drug_inds:

                max_phase_i = drug_ind_i.get('max_phase', 0)
                if max_phase_i > max_phase:
                    max_phase = max_phase_i

                efo_id_i = drug_ind_i.get('efo_id', None)
                if efo_id_i is not None:
                    efo_data[efo_id_i] = drug_ind_i.get('efo_term', None)

                indication_refs += drug_ind_i.get('indication_refs', [])

            parent_chembl_id, mesh_id = self.get_drug_ind_grouping_id_parts(base_drug_ind)

            drug_ind_data = SummableDict(**DRUG_INDICATION.get_doc_by_id_from_es(base_drug_ind['drugind_id']))
            drug_ind_data -= ['efo_term', 'efo_id']
            drug_ind_data['efo'] = [{'id': efo_id, 'term': term} for efo_id, term in efo_data.items()]
            drug_ind_data['max_phase'] = max_phase
            drug_ind_data['indication_refs'] = indication_refs

            new_mechanism_doc = {
                'parent_molecule': MOLECULE.get_doc_by_id_from_es(parent_chembl_id),
                'drug_indication': drug_ind_data
            }
            doc_id = self.generated_resource.get_doc_id(new_mechanism_doc)

            dn_dict[doc_id] = new_mechanism_doc
            i += 1
            p_bar.update(i)
        p_bar.finish()

        self.save_denormalization_dict(
            self.generated_resource, dn_dict, DenormalizationHandler.default_update_script_and_size, do_index=True
        )
