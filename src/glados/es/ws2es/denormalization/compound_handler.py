from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.es_util import DefaultMappings
from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.denormalization.atc_class_handler import ATCClassDenormalizationHandler
from glados.es.ws2es.denormalization.target_prediction_handler import TargetPredictionDenormalizationHandler
import glados.es.ws2es.denormalization.unichem_helper as unichem_helper
import glados.es.ws2es.denormalization.xrefs_helper as xrefs_helper
from glados.es.ws2es.denormalization.compound_family_helper import CompoundFamiliesDir, CompoundFamilyNode
from glados.es.ws2es.denormalization.mol_file_helper import get_sdf_by_chembl_id
import re
import sys


class CompoundDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.MOLECULE

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
                            'max_phase': DefaultMappings.SHORT,
                            'num_ro5_violations': DefaultMappings.SHORT,
                            'full_mwt': DefaultMappings.DOUBLE,
                            'alogp': DefaultMappings.DOUBLE,
                            'image_file': DefaultMappings.KEYWORD
                        }
                    }
                }
            }
        }
    }

    AVAILABILITY_TYPE_LABELS = {
        -2: 'Withdrawn',
        -1: 'Unknown',
        0: 'Discontinued',
        1: 'Prescription Only',
        2: 'Over the Counter'
    }

    CHIRALITY_LABELS = {
        -1: 'Unknown',
        0: 'Racemic Mixture',
        1: 'Single Stereoisomer',
        2: 'Achiral Molecule'
    }

    def __init__(self, complete_x_refs: bool=False,
                 atc_dh: ATCClassDenormalizationHandler=None, tp_dh: TargetPredictionDenormalizationHandler=None,
                 analyze_hierarchy: bool=False):
        super().__init__(complete_x_refs or atc_dh is not None or tp_dh is not None)
        self.complete_x_refs = complete_x_refs
        self.atc_dh = atc_dh
        self.tp_dh = tp_dh
        self.molecule_activity_data = {}
        self.image_file_by_chembl_id = {}
        self.pref_name_by_chembl_id = {}
        self.inchi_key_by_chembl_id = {}
        self.analyze_hierarchy = analyze_hierarchy
        if analyze_hierarchy:
            self.molecule_family_desc = CompoundFamiliesDir()

    @staticmethod
    def get_non_structure_image_type(doc):
        image_type = 'unknown.svg'
        structure_type = doc.get('structure_type', None)
        if structure_type == 'NONE' or structure_type == 'SEQ':
            # see the cases here: 
            # https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?spaceKey=CHEMBL&title=ChEMBL+Interface
            # in the section Placeholder Compound Images
            mol_properties = doc.get('molecule_properties', None)
            full_molformula = None
            if mol_properties is not None:
                full_molformula = mol_properties.get('full_molformula', None)
            molecule_type = doc.get('molecule_type', None)
            if full_molformula and CompoundDenormalizationHandler.mol_formula_contains_metals(full_molformula):
                image_type = 'metalContaining.svg'
            elif molecule_type == 'Oligosaccharide':
                image_type = 'oligosaccharide.svg'
            elif molecule_type == 'Small molecule':

                if doc.get('natural_product', None) == '1':
                    image_type = 'naturalProduct.svg'
                elif doc.get('polymer_flag', None):
                    image_type = 'smallMolPolymer.svg'
                else:
                    image_type = 'smallMolecule.svg'

            elif molecule_type == 'Antibody':
                image_type = 'antibody.svg'
            elif molecule_type == 'Protein':
                image_type = 'peptide.svg'
            elif molecule_type == 'Oligonucleotide':
                image_type = 'oligonucleotide.svg'
            elif molecule_type == 'Enzyme':
                image_type = 'enzyme.svg'
            elif molecule_type == 'Cell':
                image_type = 'cell.svg'
        else:
            image_type = None
        return image_type

    @staticmethod
    def mol_formula_contains_metals(mol_formula):
        non_metals = ['H', 'C', 'N', 'O', 'P', 'S', 'F', 'Cl', 'Br', 'I']
        replace_regex = r'(\.|[0-9]|'+'|'.join(non_metals)+')'
        test_mol_formula = re.sub(replace_regex, '', mol_formula)
        return len(test_mol_formula) > 0

    def complete_hierarchy_data(self):
        if not self.analyze_hierarchy:
            print('ERROR! Compound Hierarchy was not analyzed!')
            return
        dn_data = self.molecule_family_desc.get_all_dn_dicts()

        self.update_mappings(CompoundFamilyNode.get_compound_dn_mapping())

        def get_update_script_and_size(doc_id, doc):
            update_size = len(doc['_metadata']['hierarchy']['all_family']) * 15
            return doc, update_size
        self.save_denormalization_dict(self.RESOURCE, dn_data, get_update_script_and_size)
        del dn_data

    def complete_unichem_data(self):
        pre_unichem_dn_dict = unichem_helper.load_all_chembl_unichem_data()

        # removal of non existent ids
        unichem_dn_dict = {}
        for m_c_id in pre_unichem_dn_dict:
            if m_c_id in self.molecule_activity_data:
                unichem_dn_dict[m_c_id] = pre_unichem_dn_dict[m_c_id]
            else:
                print('ERROR: CHEMBL ID {0} IS NOT PRESENT IN THE ELASTIC INDEX!'.format(m_c_id), file=sys.stderr)

        self.update_mappings(unichem_helper.UNICHEM_MAPPING)

        def get_update_script_and_size(doc_id, doc):
            update_size = len(doc['_metadata']['unichem']) * 4
            return doc, update_size
        self.save_denormalization_dict(self.RESOURCE, unichem_dn_dict, get_update_script_and_size)
        del unichem_dn_dict

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += unichem_helper.UNICHEM_MAPPING
        mappings += TargetPredictionDenormalizationHandler.METADATA_MAPPING
        mappings += ATCClassDenormalizationHandler.METADATA_MAPPING
        mappings += {
            'properties': {
                '_metadata': {
                    'properties': {
                        'compound_generated': {
                            'properties': {
                                'availability_type_label': DefaultMappings.KEYWORD,
                                'chirality_label': DefaultMappings.KEYWORD,
                                'image_file': DefaultMappings.KEYWORD,
                                'sdf_data': DefaultMappings.NO_INDEX_TEXT_NO_OFFSETS
                            }
                        }
                    }
                }
            }
        }
        return mappings

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):

        if self.analyze_hierarchy:
            self.molecule_family_desc.register_node(doc)
        self.molecule_activity_data[doc['molecule_chembl_id']] = {
            'max_phase': doc['max_phase']
        }
        if 'molecule_properties' in doc and isinstance(doc['molecule_properties'], dict):
            self.molecule_activity_data[doc['molecule_chembl_id']]['num_ro5_violations'] = \
                doc['molecule_properties']['num_ro5_violations']
            self.molecule_activity_data[doc['molecule_chembl_id']]['full_mwt'] = \
                doc['molecule_properties']['full_mwt']
            self.molecule_activity_data[doc['molecule_chembl_id']]['alogp'] = \
                doc['molecule_properties']['alogp']
        non_structure_image = self.get_non_structure_image_type(doc)
        if non_structure_image:
            self.image_file_by_chembl_id[doc['molecule_chembl_id']] = non_structure_image
            self.molecule_activity_data[doc['molecule_chembl_id']]['image_file'] = non_structure_image
        self.pref_name_by_chembl_id[doc['molecule_chembl_id']] = doc['pref_name']

    def get_doc_for_complete_data(self, doc: dict):
        update_doc_md = {}
        atc_class = None
        if self.atc_dh and doc['atc_classifications']:
            atc_class = []
            for atc_level_5_i in doc['atc_classifications']:
                atc_class_data = self.atc_dh.atc_class_by_level5.get(atc_level_5_i, None)
                if atc_class_data is None:
                    print('WARNING! ATC CLASS IS MISSING FOR {0}!'.format(atc_level_5_i), file=sys.stderr)
                else:
                    atc_class.append(atc_class_data)
        if atc_class is not None and len(atc_class) > 0:
            update_doc_md['atc_classifications'] = atc_class

        try:
            av_type = int(doc['availability_type'])
        except:
            av_type = -1
        try:
            chirality = int(doc['chirality'])
        except:
            chirality = -1
        compound_generated = {
            'availability_type_label': self.AVAILABILITY_TYPE_LABELS.get(av_type, 'Unknown'),
            'chirality_label': self.CHIRALITY_LABELS.get(chirality, 'Unknown')}
        non_structure_image = self.get_non_structure_image_type(doc)
        if non_structure_image:
            compound_generated['image_file'] = non_structure_image

        sdf_data = get_sdf_by_chembl_id(doc['molecule_chembl_id'])
        compound_generated['sdf_data'] = sdf_data

        update_doc_md['compound_generated'] = compound_generated

        target_predictions = None
        if self.tp_dh:
            target_predictions = self.tp_dh.molecule_chembl_id_2_target_predictions.get(doc['molecule_chembl_id'], None)
        if target_predictions and len(target_predictions) > 0:
            update_doc_md['target_predictions'] = target_predictions

        if self.complete_x_refs:
            xrefs_helper.complete_xrefs(doc['cross_references'])

        return {
            'cross_references': doc['cross_references'],
            '_metadata': update_doc_md
        }
