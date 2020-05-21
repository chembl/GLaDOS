import glados.es.ws2es.progress_bar_handler as progress_bar_handler
from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.denormalization.compound_family_helper import CompoundFamiliesDir
from glados.es.ws2es.es_util import DefaultMappings, es_util

from glados.es.ws2es.resources_description import MOLECULE, TARGET, BINDING_SITE, MECHANISM, MECHANISM_BY_PARENT_TARGET
import sys
import pprint


class MechanismDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.MECHANISM

    @staticmethod
    def get_new_index_mappings():
        return {
            'properties':
            {
                'parent_molecule':
                {
                    'properties': MOLECULE.get_resource_mapping_from_es()
                },
                'target':
                {
                    'properties': TARGET.get_resource_mapping_from_es()
                },
                'binding_site': {
                    'properties': BINDING_SITE.get_resource_mapping_from_es()
                },
                'mechanism_of_action': {
                    'properties': MECHANISM.get_resource_mapping_from_es()
                }
            }
        }

    def __init__(self, compound_families_dir: CompoundFamiliesDir=None):
        super().__init__(compound_families_dir is not None)
        self.compound_families_dir = compound_families_dir
        self.mechanisms_by_grouping_id = {}
        self.generated_resource = MECHANISM_BY_PARENT_TARGET

    def get_mechanism_grouping_id_parts(self, doc):
        if self.compound_families_dir is None:
            raise Exception('The grouping will not be correct if the compound families directory is not provided!')
        family_data = self.compound_families_dir.find_node(doc['molecule_chembl_id'])
        parent_chembl_id = family_data.get_family_parent_id()
        target_chembl_id = doc.get('target_chembl_id', None)
        return parent_chembl_id, target_chembl_id, doc.get('mechanism_of_action', None)

    def get_mechanism_grouping_id(self, doc):
        parent_chembl_id, target_chembl_id, mechanism_of_action = self.get_mechanism_grouping_id_parts(doc)
        target_chembl_id = 'N/A' if target_chembl_id is None else target_chembl_id
        mechanism_of_action = 'N/A' if mechanism_of_action is None else mechanism_of_action
        return '{0}-{1}-{2}'.format(parent_chembl_id, target_chembl_id, mechanism_of_action)

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        if self.compound_families_dir:
            grouping_id = self.get_mechanism_grouping_id(doc)
            if grouping_id not in self.mechanisms_by_grouping_id:
                self.mechanisms_by_grouping_id[grouping_id] = []
            self.mechanisms_by_grouping_id[grouping_id].append(doc)

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += {
            'properties':
            {
                '_metadata':
                {
                    'properties':
                    {
                        'all_molecule_chembl_ids': DefaultMappings.CHEMBL_ID_REF,
                        'parent_molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                        'should_appear_in_browser': DefaultMappings.BOOLEAN
                    }
                }
            }
        }
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        molecule_chembl_id = doc['molecule_chembl_id']
        family_data = self.compound_families_dir.find_node(molecule_chembl_id)
        parent_molecule_chembl_id = family_data.get_family_parent_id()
        all_family_ids = family_data.get_all_family_ids()
        dn_dict = {
            '_metadata': {
                'all_molecule_chembl_ids': all_family_ids,
                'parent_molecule_chembl_id': parent_molecule_chembl_id,
                'should_appear_in_browser': parent_molecule_chembl_id == molecule_chembl_id
            }
        }
        return dn_dict

    def save_denormalization(self):
        if self.compound_families_dir:
            es_util.delete_idx(self.generated_resource.idx_name)
            es_util.create_idx(self.generated_resource.idx_name, 3, 1, analysis=DefaultMappings.COMMON_ANALYSIS,
                       mappings=MechanismDenormalizationHandler.get_new_index_mappings())

            dn_dict = {}

            print('{0} GROUPED RECORDS WERE FOUND'.format(len(self.mechanisms_by_grouping_id)), file=sys.stderr)
            p_bar = progress_bar_handler.get_new_progressbar('mechanism_by_parent_target-dn-generation',
                                                             len(self.mechanisms_by_grouping_id))
            i = 0
            for group_mechanisms in self.mechanisms_by_grouping_id.values():
                base_mechanism = group_mechanisms[0]
                action_type = base_mechanism.get('action_type', None)
                bs_id = base_mechanism.get('site_id', None)
                mechanism_refs = []
                mechanism_comments_set = set()
                selectivity_comments_set = set()
                binding_site_comments_set = set()
                max_phase = 0
                for mechanism_i in group_mechanisms:
                    if action_type != mechanism_i.get('action_type', None):
                        print('ACTION TYPE SHOULD BE {0} FOR MECHANISM {1}!'.format(action_type, mechanism_i['mec_id'])
                              , file=sys.stderr)
                        print(pprint.pformat(group_mechanisms), file=sys.stderr)
                    if bs_id != mechanism_i.get('site_id', None):
                        print('BINDING SITE SHOULD BE {0} FOR MECHANISM {1}!'.format(bs_id, mechanism_i['mec_id'])
                              , file=sys.stderr)
                        print(pprint.pformat(group_mechanisms), file=sys.stderr)
                    if bs_id is None:
                        bs_id = mechanism_i.get('site_id', None)

                    mechanism_i_comment = mechanism_i.get('mechanism_comment', None)
                    if mechanism_i_comment is not None:
                        mechanism_comments_set.add(mechanism_i_comment)

                    mechanism_i_selectivity_comment = mechanism_i.get('selectivity_comment', None)
                    if mechanism_i_selectivity_comment is not None:
                        selectivity_comments_set.add(mechanism_i_selectivity_comment)

                    mechanism_i_binding_site_comment = mechanism_i.get('binding_site_comment', None)
                    if mechanism_i_binding_site_comment is not None:
                        binding_site_comments_set.add(mechanism_i_binding_site_comment)

                    mechanism_refs += mechanism_i.get('mechanism_refs', [])

                    max_phase = max(max_phase, mechanism_i.get('max_phase', 0))

                parent_chembl_id, target_chembl_id, mechanism_of_action = \
                    self.get_mechanism_grouping_id_parts(base_mechanism)

                new_mechanism_doc = {
                    'parent_molecule': MOLECULE.get_doc_by_id_from_es(parent_chembl_id),
                    'target': TARGET.get_doc_by_id_from_es(target_chembl_id),
                    'binding_site': BINDING_SITE.get_doc_by_id_from_es(bs_id),
                    'mechanism_of_action': base_mechanism
                }
                new_mechanism_doc['mechanism_of_action']['mechanism_comment'] = list(mechanism_comments_set)
                new_mechanism_doc['mechanism_of_action']['selectivity_comment'] = list(selectivity_comments_set)
                new_mechanism_doc['mechanism_of_action']['binding_site_comment'] = list(binding_site_comments_set)
                new_mechanism_doc['mechanism_of_action']['max_phase'] = max_phase
                doc_id = self.generated_resource.get_doc_id(new_mechanism_doc)

                if len(mechanism_comments_set) > 1:
                    print('MULTIPLE MECHANISM COMMENTS FOUND FOR {0}'.format(doc_id), file=sys.stderr)
                if len(selectivity_comments_set) > 1:
                    print('MULTIPLE SELECTIVITY COMMENTS FOUND FOR {0}'.format(doc_id), file=sys.stderr)
                if len(binding_site_comments_set) > 1:
                    print('MULTIPLE BINDING SITE COMMENTS FOUND FOR {0}'.format(doc_id), file=sys.stderr)

                dn_dict[doc_id] = new_mechanism_doc
                i += 1
                p_bar.update(i)
            p_bar.finish()

            self.save_denormalization_dict(
                self.generated_resource, dn_dict, DenormalizationHandler.default_update_script_and_size, do_index=True
            )
