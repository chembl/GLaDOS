from glados.ws2es.denormalization import DenormalizationHandler
from glados.ws2es.util import SummableDict
from glados.ws2es.denormalization.compound_handler import CompoundDenormalizationHandler
from glados.ws2es.es_util import DefaultMappings


class MetabolismDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.METABOLISM

    def __init__(self, compound_dh: CompoundDenormalizationHandler=None):
        super().__init__(compound_dh is not None)
        self.compound_dh = compound_dh
        self.metabolism_groups_by_drug_id = {}

    @staticmethod
    def analyze_metabolism_group(met_nodes: list):
        compound_chembl_ids = set()
        metabolism_ids = []
        for met_node in met_nodes:
            compound_chembl_ids.add(met_node['drug_chembl_id'])
            compound_chembl_ids.add(met_node['metabolite_chembl_id'])
            compound_chembl_ids.add(met_node['substrate_chembl_id'])
            metabolism_ids.append(met_node['met_id'])

        return list(compound_chembl_ids), metabolism_ids

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        drug_c_id = doc['drug_chembl_id']
        if drug_c_id not in self.metabolism_groups_by_drug_id:
            self.metabolism_groups_by_drug_id[drug_c_id] = []
        self.metabolism_groups_by_drug_id[drug_c_id].append({
            'drug_chembl_id': drug_c_id,
            'metabolite_chembl_id': doc['metabolite_chembl_id'],
            'substrate_chembl_id': doc['substrate_chembl_id'],
            'met_id': doc['met_id']
        })

    def save_denormalization(self):
        dn_dict = {}
        for d_c_id, met_i in self.metabolism_groups_by_drug_id.items():
            compound_chembl_ids, metabolism_ids = MetabolismDenormalizationHandler.analyze_metabolism_group(met_i)
            for met_id in metabolism_ids:
                dn_dict[met_id] = compound_chembl_ids

        new_mappings = {
            'properties':
            {
                '_metadata':
                {
                    'properties':
                    {
                        'all_graph_chembl_ids': DefaultMappings.CHEMBL_ID_REF
                    }
                }
            }
        }
        self.update_mappings(new_mappings)

        def get_update_script_and_size(es_doc_id, es_doc):
            update_size = len(es_doc)

            update_doc = {
                '_metadata': {
                    'all_graph_chembl_ids': es_doc
                }
            }

            return update_doc, update_size

        self.save_denormalization_dict(
            DenormalizationHandler.AVAILABLE_RESOURCES.METABOLISM,
            dn_dict,
            get_update_script_and_size
        )

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += {
            'properties':
            {
                '_metadata':
                {
                    'properties':
                    {
                        'compound_data':
                        {
                            'properties':
                            {
                                'drug_image_file': DefaultMappings.KEYWORD,
                                'metabolite_image_file': DefaultMappings.KEYWORD,
                                'substrate_image_file': DefaultMappings.KEYWORD,
                                'drug_pref_name': DefaultMappings.KEYWORD,
                                'metabolite_pref_name': DefaultMappings.KEYWORD,
                                'substrate_pref_name': DefaultMappings.KEYWORD
                            }
                        }
                    }

                }
            }
        }
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        update_doc_md = {
            'compound_data': {}
        }

        drug_image_file = self.compound_dh.image_file_by_chembl_id.get(doc['drug_chembl_id'], None)
        if drug_image_file:
            update_doc_md['compound_data']['drug_image_file'] = drug_image_file

        metabolite_image_file = self.compound_dh.image_file_by_chembl_id.get(doc['metabolite_chembl_id'], None)
        if metabolite_image_file:
            update_doc_md['compound_data']['metabolite_image_file'] = metabolite_image_file

        substrate_image_file = self.compound_dh.image_file_by_chembl_id.get(doc['substrate_chembl_id'], None)
        if substrate_image_file:
            update_doc_md['compound_data']['substrate_image_file'] = substrate_image_file

        drug_pref_name = self.compound_dh.pref_name_by_chembl_id.get(doc['drug_chembl_id'], None)
        if drug_pref_name:
            update_doc_md['compound_data']['drug_pref_name'] = drug_pref_name

        metabolite_pref_name = self.compound_dh.pref_name_by_chembl_id.get(doc['metabolite_chembl_id'], None)
        if metabolite_pref_name:
            update_doc_md['compound_data']['metabolite_pref_name'] = metabolite_pref_name

        substrate_pref_name = self.compound_dh.pref_name_by_chembl_id.get(doc['substrate_chembl_id'], None)
        if substrate_pref_name:
            update_doc_md['compound_data']['substrate_pref_name'] = substrate_pref_name

        return {
            '_metadata': update_doc_md
        }
