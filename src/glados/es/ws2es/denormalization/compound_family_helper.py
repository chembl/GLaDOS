import sys
from glados.es.ws2es.util import get_js_path_from_dict, put_js_path_in_dict, SummableDict
from glados.es.ws2es.es_util import DefaultMappings
import glados.es.ws2es.mappings.es_chembl_molecule_n_drug_shared_mapping as molecule_n_drug_mapping
from glados.es.ws2es.progress_bar_handler import get_new_progressbar


def get_inchi_connectivity_layer(inchi_key_str):
    if isinstance(inchi_key_str, str) and len(inchi_key_str.strip()) > 0:
        if inchi_key_str.find('-') == -1:
            print('WARNING: {0} is not a valid inchi key.'.format(inchi_key_str), file=sys.stderr)
            return None
        return inchi_key_str.split('-')[0]
    return None


class CompoundFamilyNode:

    DRUG_SOURCES = {9, 12, 36, 41, 42}

    USAN_SOURCES = {8, 13}.union(DRUG_SOURCES)

    def __init__(self, chembl_id: str, parent_node, families_dir, unchecked_parent_insert=False):
        self.chembl_id = chembl_id
        self.children = {}
        self.parent_node = parent_node
        self.unchecked_parent_insert = unchecked_parent_insert
        self.families_dir = families_dir
        self.families_dir.all_nodes[chembl_id] = self
        self.fields_to_merge = {}
        self.fields_to_keep_separated = {}
        self.compound_data = None

    @classmethod
    def get_compound_dn_mapping(cls):
        mappings_dict = {}
        src_mapping = {
            'src_id': DefaultMappings.SHORT,
            'src_description': DefaultMappings.KEYWORD,
            'src_short_name': DefaultMappings.KEYWORD
        }
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.family_inchi_connectivity_layer',
            DefaultMappings.KEYWORD, es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.is_approved_drug', DefaultMappings.BOOLEAN, es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.is_usan', DefaultMappings.BOOLEAN, es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.all_family.inchi', DefaultMappings.KEYWORD,
            es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.all_family.inchi_connectivity_layer', DefaultMappings.KEYWORD,
            es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.all_family.inchi_key', DefaultMappings.KEYWORD,
            es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.all_family.chembl_id', DefaultMappings.CHEMBL_ID_REF,
            es_properties_style=True
        )
        # Parent properties
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.parent.chembl_id', DefaultMappings.CHEMBL_ID_REF,
            es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.parent.sources.', src_mapping,
            es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.parent.synonyms', molecule_n_drug_mapping.molecule_synonyms,
            es_properties_style=True
        )
        # Children properties
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.children.chembl_id', DefaultMappings.CHEMBL_ID_REF,
            es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.children.sources.', src_mapping,
            es_properties_style=True
        )
        put_js_path_in_dict(
            mappings_dict, '._metadata.hierarchy.children.synonyms', molecule_n_drug_mapping.molecule_synonyms,
            es_properties_style=True
        )
        return mappings_dict

    @classmethod
    def get_drug_and_usan_flags_and_src_data(cls, doc: dict):
        max_phase = get_js_path_from_dict(doc, 'max_phase', 0)
        compound_records = get_js_path_from_dict(doc, '_metadata.compound_records', default=[])
        src_data = {}
        for cr_i in compound_records:
            src_id = get_js_path_from_dict(cr_i, 'src_id', default=None)
            if src_id is not None and src_id not in src_data:
                src_data[src_id] = {
                    'src_description': get_js_path_from_dict(cr_i, 'src_description', default=None),
                    'src_id': src_id,
                    'src_short_name': get_js_path_from_dict(cr_i, 'src_short_name', default=None),
                }
        source_ids_set = set(src_data.keys())
        usan_intersection = source_ids_set.intersection(cls.USAN_SOURCES)
        drug_intersection = usan_intersection.intersection(cls.DRUG_SOURCES)
        is_usan_src = len(usan_intersection) >= 1
        is_drug_src = len(drug_intersection) >= 1

        is_db_drug = get_js_path_from_dict(doc, '_metadata.drug.is_drug')
        return is_drug_src, is_usan_src, is_db_drug, max_phase, list(src_data.values())

    def get_node_data(self):
        return {
            'chembl_id': self.chembl_id,
            'sources': self.compound_data['src_data'],
            'synonyms': self.compound_data['synonyms']
        }

    def get_denormalization_dict(self):
        dn_dict = SummableDict()
        is_drug_src = self.compound_data['is_drug_src']
        is_usan_src = self.compound_data['is_usan_src']
        is_db_drug = self.compound_data['is_db_drug']
        max_phase = self.compound_data['max_phase']

        shared_family_data = [{
            'chembl_id': self.chembl_id,
            'inchi': self.compound_data['inchi'],
            'inchi_connectivity_layer': get_inchi_connectivity_layer(self.compound_data['inchi_key']),
            'inchi_key': self.compound_data['inchi_key']
        }]

        node_data = self.get_node_data()
        children_data = []

        for chembl_id_i, node in self.children.items():
            is_drug_src |= node.compound_data['is_drug_src']
            is_usan_src |= node.compound_data['is_usan_src']
            max_phase = max(max_phase, node.compound_data['max_phase'])
            dn_data_i, sf_data_i, nd_i = node.get_denormalization_dict()
            children_data.append(nd_i)
            put_js_path_in_dict(dn_data_i, node.chembl_id+'._metadata.hierarchy.parent', node_data)
            dn_dict += dn_data_i
            shared_family_data += sf_data_i
        # Warning checks!
        if is_db_drug and is_db_drug != ((is_usan_src or is_drug_src) and self.is_family_parent()):
            print(
                'WARNING! {0} has db_drug {1} and sources_drug {2}'.format(
                    self.chembl_id, is_db_drug, (is_usan_src or is_drug_src)
                ), file=sys.stderr
            )
        if max_phase != self.compound_data['max_phase']:
            print(
                'WARNING! {0} has db_max_phase of {1} and children max_phase of {2}'.format(
                    self.chembl_id, self.compound_data['max_phase'], max_phase
                ), file=sys.stderr
            )

        dn_dict[self.chembl_id] = {}

        put_js_path_in_dict(dn_dict[self.chembl_id], '_metadata.hierarchy', {
            'is_approved_drug': (is_drug_src and max_phase == 4),
            'is_usan': is_usan_src,
            'children': children_data
         })

        # If root collect the shared family data
        if self.is_family_parent():
            family_inchi_connectivity_layer = get_inchi_connectivity_layer(self.compound_data['inchi_key'])
            for dn_data in dn_dict.values():
                put_js_path_in_dict(dn_data, '_metadata.hierarchy.all_family', shared_family_data)
                put_js_path_in_dict(dn_data, '_metadata.hierarchy.family_inchi_connectivity_layer',
                                    family_inchi_connectivity_layer)
        return dn_dict, shared_family_data, node_data

    def collect_str_sub_tree(self, cur_depth=0):
        total_str = (' '*4*cur_depth)+'- '+self.chembl_id+'\n'
        if self.compound_data is not None:
            total_str += (' '*4*cur_depth)+'- {0} {1} {2}'.format(
                self.compound_data['is_db_drug'], self.compound_data['is_drug_src'], self.compound_data['is_usan_src']
            )+'\n'
            total_str += (' '*4*cur_depth)+'- {0}'.format(self.compound_data['src_data'])+'\n'
        else:
            total_str += (' ' * 4 * cur_depth) + '-  MISSING C_DATA\n'

        max_depth = cur_depth
        family_size = 1
        for children_i in self.children.values():
            c_total_str, cf_size, c_max_depth = children_i.collect_str_sub_tree(cur_depth=cur_depth+1)
            total_str += c_total_str
            family_size += cf_size
            max_depth = max(max_depth, c_max_depth)
        # if self.compound_data is None:
        #     print(total_str)
        return total_str, family_size, max_depth

    def is_family_parent(self):
        """
        :return: True if it is the parent (including virtual parents) molecule of a family of molecules
        e.g. CHEMBL192(SILDENAFIL) -> True, but CHEMBL1737(SILDENAFIL CITRATE or VIAGRA) -> False
        """
        return isinstance(self.parent_node, CompoundFamiliesDir)

    def fill_node_data(self, doc: dict):
        is_drug_src, is_usan_src, is_db_drug, max_phase, src_data = self.get_drug_and_usan_flags_and_src_data(doc)
        self.compound_data = {
            'is_drug_src': is_drug_src,
            'is_usan_src': is_usan_src,
            'is_db_drug': is_db_drug,
            'src_data': src_data,
            'inchi': get_js_path_from_dict(doc, 'molecule_structures.standard_inchi'),
            'inchi_key': get_js_path_from_dict(doc, 'molecule_structures.standard_inchi_key'),
            'synonyms': get_js_path_from_dict(doc, 'molecule_synonyms'),
            'max_phase': max_phase,
        }

    def get_family_parent_id(self):
        current_node = self
        while not current_node.is_family_parent():
            current_node = current_node.parent_node
        return current_node.chembl_id

    def get_all_family_ids(self):
        current_parent = self
        while isinstance(current_parent.parent_node, CompoundFamilyNode):
            current_parent = current_parent.parent_node

        cur_level = [current_parent]
        all_ids = []

        while cur_level:
            next_level = []
            for node_i in cur_level:
                all_ids.append(node_i.chembl_id)
                next_level += node_i.children.values()
            cur_level = next_level

        return all_ids

    def get_all_branch_ids(self):
        all_ids = []
        current_node = self
        while isinstance(current_node, CompoundFamilyNode):
            all_ids.append(current_node.chembl_id)
            current_node = current_node.parent_node
        return all_ids


class CompoundFamiliesDir:

    def __init__(self):
        self.all_nodes = {}
        self.children = {}

    def remove_child_node(self, chembl_id: str):
        if chembl_id in self.children:
            self.children.pop(chembl_id, None)

    def find_node(self, chembl_id: str):
        return self.all_nodes.get(chembl_id, None)

    def register_node(self, doc: dict):
        chembl_id = doc['molecule_chembl_id']
        parent_id = None
        hierarchy = doc.get('molecule_hierarchy', None)
        if hierarchy is not None:
            parent_id = hierarchy.get('parent_chembl_id', None)

        if chembl_id == parent_id:
            parent_id = None
        chembl_id_node = self.find_node(chembl_id)
        if chembl_id_node is None:
            if parent_id is None:
                self.children[chembl_id] = CompoundFamilyNode(chembl_id, self, self)
                self.children[chembl_id].fill_node_data(doc)
            else:
                parent_node = self.find_node(parent_id)
                if parent_node is None:
                    parent_node = CompoundFamilyNode(parent_id, self, self, True)
                    self.children[parent_id] = parent_node
                parent_node.children[chembl_id] = CompoundFamilyNode(chembl_id, parent_node, self)
                parent_node.children[chembl_id].fill_node_data(doc)
        else:
            if parent_id is None:
                if chembl_id_node.unchecked_parent_insert and \
                   isinstance(chembl_id_node.parent_node, CompoundFamiliesDir):
                    chembl_id_node.unchecked_parent_insert = False
                    chembl_id_node.fill_node_data(doc)
                elif chembl_id_node.parent_node.chembl_id is not None:
                    print('WARNING! {0} was already registered to {1}, and should be parentless!'.format(
                        chembl_id, chembl_id_node.parent_node.chembl_id
                    ), file=sys.stderr)
            else:
                parent_node = self.find_node(parent_id)
                if chembl_id_node.unchecked_parent_insert:
                    if parent_node is None:
                        parent_node = CompoundFamilyNode(parent_id, self, self, True)
                        self.children[parent_id] = parent_node
                    parent_node.children[chembl_id] = chembl_id_node
                    chembl_id_node.unchecked_parent_insert = False
                    self.remove_child_node(chembl_id)
                else:
                    if isinstance(chembl_id_node.parent_node, CompoundFamiliesDir):
                        print('WARNING! {0} was already registered and checked as parentless. However, it was requested'
                              ' again with {1}!'.format(chembl_id, parent_id),
                              file=sys.stderr)
                    else:
                        print('WARNING! {0} was already registered and checked with {1}. However, it was requested '
                              'again with {2}!'.format(chembl_id, chembl_id_node.parent_node.chembl_id, parent_id),
                              file=sys.stderr)

    def get_all_dn_dicts(self):
        total_dn_dict = SummableDict()
        pb = get_new_progressbar('built-dn-hierarchy-dict', len(self.children))
        current = 0
        for node in self.children.values():
            dn_dict_i, shared_family_data, node_data = node.get_denormalization_dict()
            for chembl_id, dn_data in dn_dict_i.items():
                total_dn_dict[chembl_id] = dn_data
            current += 1
            pb.update(current)
        pb.finish()
        return total_dn_dict

    def print_tree(self):
        total_root_no_children = 0
        total_root_with_subtree = 0
        total_families_2_only = 0
        total_max_depth = 0
        max_family_size = 0
        for node in self.children.values():
            if len(node.children) == 0:
                total_root_no_children += 1
            else:
                total_root_with_subtree += 1
                total_str, family_size, max_depth = node.collect_str_sub_tree()
                total_max_depth = max(total_max_depth, max_depth)
                if family_size > max_family_size:
                    max_family_size = family_size
                    print(total_str, file=sys.stderr)
                if family_size == 2:
                    total_families_2_only += 1

        print('Families without children:', total_root_no_children, file=sys.stderr)
        print('Families with children:', total_root_with_subtree, file=sys.stderr)
        print('Families of 2 only:', total_families_2_only, file=sys.stderr)
        print('Max Family Size:', max_family_size, file=sys.stderr)
        print('Max Depth:', total_max_depth, file=sys.stderr)
        sys.stderr.flush()
