import glados.es.ws2es.mappings.es_chembl_activity_mapping as es_chembl_activity_mapping
import glados.es.ws2es.mappings.es_chembl_activity_supplementary_data_by_activity_mapping as \
    es_chembl_activity_supplementary_data_by_activity_mapping
import glados.es.ws2es.mappings.es_chembl_assay_mapping as es_chembl_assay_mapping
import glados.es.ws2es.mappings.es_chembl_assay_class_mapping as es_chembl_assay_class_mapping
import glados.es.ws2es.mappings.es_chembl_atc_class_mapping as es_chembl_atc_class_mapping
import glados.es.ws2es.mappings.es_chembl_binding_site_mapping as es_chembl_binding_site_mapping
import glados.es.ws2es.mappings.es_chembl_biotherapeutic_mapping as es_chembl_biotherapeutic_mapping
import glados.es.ws2es.mappings.es_chembl_cell_line_mapping as es_chembl_cell_line_mapping
import glados.es.ws2es.mappings.es_chembl_chembl_id_lookup_mapping as es_chembl_chembl_id_lookup_mapping
import glados.es.ws2es.mappings.es_chembl_compound_record_mapping as es_chembl_compound_record_mapping
import glados.es.ws2es.mappings.es_chembl_document_mapping as es_chembl_document_mapping
import glados.es.ws2es.mappings.es_chembl_document_similarity_mapping as es_chembl_document_similarity_mapping
import glados.es.ws2es.mappings.es_chembl_drug_mapping as es_chembl_drug_mapping
import glados.es.ws2es.mappings.es_chembl_drug_indication_mapping as es_chembl_drug_indication_mapping
import glados.es.ws2es.mappings.es_chembl_go_slim_mapping as es_chembl_go_slim_mapping
import glados.es.ws2es.mappings.es_chembl_mechanism_mapping as es_chembl_mechanism_mapping
import glados.es.ws2es.mappings.es_chembl_metabolism_mapping as es_chembl_metabolism_mapping
import glados.es.ws2es.mappings.es_chembl_molecule_mapping as es_chembl_molecule_mapping
import glados.es.ws2es.mappings.es_chembl_molecule_form_mapping as es_chembl_molecule_form_mapping
import glados.es.ws2es.mappings.es_chembl_organism_mapping as es_chembl_organism_mapping
import glados.es.ws2es.mappings.es_chembl_protein_class_mapping as es_chembl_protein_class_mapping
import glados.es.ws2es.mappings.es_chembl_source_mapping as es_chembl_source_mapping
import glados.es.ws2es.mappings.es_chembl_target_mapping as es_chembl_target_mapping
import glados.es.ws2es.mappings.es_chembl_target_component_mapping as es_chembl_target_component_mapping
import glados.es.ws2es.mappings.es_chembl_target_prediction_mapping as es_chembl_target_prediction_mapping
import glados.es.ws2es.mappings.es_chembl_target_relation_mapping as es_chembl_target_relation_mapping
import glados.es.ws2es.mappings.es_chembl_tissue_mapping as es_chembl_tissue_mapping

__author__ = 'jfmosquera@ebi.ac.uk'

resources_2_es_mapping = \
    {
        'activity': es_chembl_activity_mapping,
        'activity_supplementary_data_by_activity':
            es_chembl_activity_supplementary_data_by_activity_mapping,
        'assay': es_chembl_assay_mapping,
        'assay_class': es_chembl_assay_class_mapping,
        'atc_class': es_chembl_atc_class_mapping,
        'binding_site': es_chembl_binding_site_mapping,
        'biotherapeutic': es_chembl_biotherapeutic_mapping,
        'cell_line': es_chembl_cell_line_mapping,
        'chembl_id_lookup': es_chembl_chembl_id_lookup_mapping,
        'compound_record': es_chembl_compound_record_mapping,
        'document': es_chembl_document_mapping,
        'document_similarity': es_chembl_document_similarity_mapping,
        'drug': es_chembl_drug_mapping,
        'drug_indication': es_chembl_drug_indication_mapping,
        'go_slim': es_chembl_go_slim_mapping,
        'mechanism': es_chembl_mechanism_mapping,
        'metabolism': es_chembl_metabolism_mapping,
        'molecule': es_chembl_molecule_mapping,
        'molecule_form': es_chembl_molecule_form_mapping,
        'organism': es_chembl_organism_mapping,
        'protein_class': es_chembl_protein_class_mapping,
        'source': es_chembl_source_mapping,
        'target': es_chembl_target_mapping,
        'target_component': es_chembl_target_component_mapping,
        'target_prediction': es_chembl_target_prediction_mapping,
        'target_relation': es_chembl_target_relation_mapping,
        'tissue': es_chembl_tissue_mapping,
    }
