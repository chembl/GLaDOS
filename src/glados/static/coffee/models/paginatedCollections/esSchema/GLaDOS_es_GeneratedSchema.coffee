glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
# The contents of this file were generated from the GLaDOS-es project

  GLaDOS_es_GeneratedSchema:
    chembl_26_activity:
      '_metadata.activity_generated.short_data_validity_comment' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_generated___short_data_validity_comment__label'
        label_mini_id : 'glados_es_gs__activity__activity_generated___short_data_validity_comment__label__mini'

      '_metadata.activity_generated' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__activity_generated__label'
        label_mini_id : 'glados_es_gs__activity__activity_generated__label__mini'

      '_metadata.assay_data.assay_cell_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_data___assay_cell_type__label'
        label_mini_id : 'glados_es_gs__activity__assay_data___assay_cell_type__label__mini'

      '_metadata.assay_data.assay_organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_data___assay_organism__label'
        label_mini_id : 'glados_es_gs__activity__assay_data___assay_organism__label__mini'

      '_metadata.assay_data.assay_subcellular_fraction' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_data___assay_subcellular_fraction__label'
        label_mini_id : 'glados_es_gs__activity__assay_data___assay_subcellular_fraction__label__mini'

      '_metadata.assay_data.assay_tissue' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_data___assay_tissue__label'
        label_mini_id : 'glados_es_gs__activity__assay_data___assay_tissue__label__mini'

      '_metadata.assay_data.cell_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_data___cell_chembl_id__label'
        label_mini_id : 'glados_es_gs__activity__assay_data___cell_chembl_id__label__mini'

      '_metadata.assay_data.tissue_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_data___tissue_chembl_id__label'
        label_mini_id : 'glados_es_gs__activity__assay_data___tissue_chembl_id__label__mini'

      '_metadata.assay_data.type_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_data___type_label__label'
        label_mini_id : 'glados_es_gs__activity__assay_data___type_label__label__mini'

      '_metadata.assay_data' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__assay_data__label'
        label_mini_id : 'glados_es_gs__activity__assay_data__label__mini'

      '_metadata.organism_taxonomy.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__organism_taxonomy___l1__label'
        label_mini_id : 'glados_es_gs__activity__organism_taxonomy___l1__label__mini'

      '_metadata.organism_taxonomy.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__organism_taxonomy___l2__label'
        label_mini_id : 'glados_es_gs__activity__organism_taxonomy___l2__label__mini'

      '_metadata.organism_taxonomy.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__organism_taxonomy___l3__label'
        label_mini_id : 'glados_es_gs__activity__organism_taxonomy___l3__label__mini'

      '_metadata.organism_taxonomy.oc_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__organism_taxonomy___oc_id__label'
        label_mini_id : 'glados_es_gs__activity__organism_taxonomy___oc_id__label__mini'

      '_metadata.organism_taxonomy.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__organism_taxonomy___tax_id__label'
        label_mini_id : 'glados_es_gs__activity__organism_taxonomy___tax_id__label__mini'

      '_metadata.organism_taxonomy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__organism_taxonomy__label'
        label_mini_id : 'glados_es_gs__activity__organism_taxonomy__label__mini'

      '_metadata.parent_molecule_data.alogp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__parent_molecule_data___alogp__label'
        label_mini_id : 'glados_es_gs__activity__parent_molecule_data___alogp__label__mini'

      '_metadata.parent_molecule_data.compound_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__parent_molecule_data___compound_key__label'
        label_mini_id : 'glados_es_gs__activity__parent_molecule_data___compound_key__label__mini'

      '_metadata.parent_molecule_data.full_mwt' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__parent_molecule_data___full_mwt__label'
        label_mini_id : 'glados_es_gs__activity__parent_molecule_data___full_mwt__label__mini'

      '_metadata.parent_molecule_data.image_file' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__parent_molecule_data___image_file__label'
        label_mini_id : 'glados_es_gs__activity__parent_molecule_data___image_file__label__mini'

      '_metadata.parent_molecule_data.max_phase' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__parent_molecule_data___max_phase__label'
        label_mini_id : 'glados_es_gs__activity__parent_molecule_data___max_phase__label__mini'

      '_metadata.parent_molecule_data.num_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__parent_molecule_data___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__activity__parent_molecule_data___num_ro5_violations__label__mini'

      '_metadata.parent_molecule_data' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__parent_molecule_data__label'
        label_mini_id : 'glados_es_gs__activity__parent_molecule_data__label__mini'

      '_metadata.protein_classification.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__protein_classification___l1__label'
        label_mini_id : 'glados_es_gs__activity__protein_classification___l1__label__mini'

      '_metadata.protein_classification.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__protein_classification___l2__label'
        label_mini_id : 'glados_es_gs__activity__protein_classification___l2__label__mini'

      '_metadata.protein_classification.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__protein_classification___l3__label'
        label_mini_id : 'glados_es_gs__activity__protein_classification___l3__label__mini'

      '_metadata.protein_classification.l4' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__protein_classification___l4__label'
        label_mini_id : 'glados_es_gs__activity__protein_classification___l4__label__mini'

      '_metadata.protein_classification.l5' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__protein_classification___l5__label'
        label_mini_id : 'glados_es_gs__activity__protein_classification___l5__label__mini'

      '_metadata.protein_classification.l6' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__protein_classification___l6__label'
        label_mini_id : 'glados_es_gs__activity__protein_classification___l6__label__mini'

      '_metadata.protein_classification.protein_class_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__protein_classification___protein_class_id__label'
        label_mini_id : 'glados_es_gs__activity__protein_classification___protein_class_id__label__mini'

      '_metadata.protein_classification' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__protein_classification__label'
        label_mini_id : 'glados_es_gs__activity__protein_classification__label__mini'

      '_metadata.source.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__source___src_description__label'
        label_mini_id : 'glados_es_gs__activity__source___src_description__label__mini'

      '_metadata.source.src_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__source___src_id__label'
        label_mini_id : 'glados_es_gs__activity__source___src_id__label__mini'

      '_metadata.source.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__source___src_short_name__label'
        label_mini_id : 'glados_es_gs__activity__source___src_short_name__label__mini'

      '_metadata.source' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__source__label'
        label_mini_id : 'glados_es_gs__activity__source__label__mini'

      '_metadata.target_data.target_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__target_data___target_type__label'
        label_mini_id : 'glados_es_gs__activity__target_data___target_type__label__mini'

      '_metadata.target_data' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__target_data__label'
        label_mini_id : 'glados_es_gs__activity__target_data__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity___metadata__label'
        label_mini_id : 'glados_es_gs__activity___metadata__label__mini'

      activity_comment : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_comment__label'
        label_mini_id : 'glados_es_gs__activity__activity_comment__label__mini'

      activity_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_id__label'
        label_mini_id : 'glados_es_gs__activity__activity_id__label__mini'

      'activity_properties.relation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___relation__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___relation__label__mini'

      'activity_properties.result_flag' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___result_flag__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___result_flag__label__mini'

      'activity_properties.standard_relation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___standard_relation__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___standard_relation__label__mini'

      'activity_properties.standard_text_value' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___standard_text_value__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___standard_text_value__label__mini'

      'activity_properties.standard_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___standard_type__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___standard_type__label__mini'

      'activity_properties.standard_units' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___standard_units__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___standard_units__label__mini'

      'activity_properties.standard_value' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___standard_value__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___standard_value__label__mini'

      'activity_properties.text_value' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___text_value__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___text_value__label__mini'

      'activity_properties.type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___type__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___type__label__mini'

      'activity_properties.units' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___units__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___units__label__mini'

      'activity_properties.value' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_properties___value__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties___value__label__mini'

      activity_properties : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__activity_properties__label'
        label_mini_id : 'glados_es_gs__activity__activity_properties__label__mini'

      assay_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_chembl_id__label'
        label_mini_id : 'glados_es_gs__activity__assay_chembl_id__label__mini'

      assay_description : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_description__label'
        label_mini_id : 'glados_es_gs__activity__assay_description__label__mini'

      assay_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_type__label'
        label_mini_id : 'glados_es_gs__activity__assay_type__label__mini'

      bao_endpoint : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__bao_endpoint__label'
        label_mini_id : 'glados_es_gs__activity__bao_endpoint__label__mini'

      bao_format : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__bao_format__label'
        label_mini_id : 'glados_es_gs__activity__bao_format__label__mini'

      bao_label : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__bao_label__label'
        label_mini_id : 'glados_es_gs__activity__bao_label__label__mini'

      canonical_smiles : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__canonical_smiles__label'
        label_mini_id : 'glados_es_gs__activity__canonical_smiles__label__mini'

      data_validity_comment : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__data_validity_comment__label'
        label_mini_id : 'glados_es_gs__activity__data_validity_comment__label__mini'

      data_validity_description : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__data_validity_description__label'
        label_mini_id : 'glados_es_gs__activity__data_validity_description__label__mini'

      document_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__document_chembl_id__label'
        label_mini_id : 'glados_es_gs__activity__document_chembl_id__label__mini'

      document_journal : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__document_journal__label'
        label_mini_id : 'glados_es_gs__activity__document_journal__label__mini'

      document_year : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__activity__document_year__label'
        label_mini_id : 'glados_es_gs__activity__document_year__label__mini'

      'ligand_efficiency.bei' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__ligand_efficiency___bei__label'
        label_mini_id : 'glados_es_gs__activity__ligand_efficiency___bei__label__mini'

      'ligand_efficiency.le' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__ligand_efficiency___le__label'
        label_mini_id : 'glados_es_gs__activity__ligand_efficiency___le__label__mini'

      'ligand_efficiency.lle' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__ligand_efficiency___lle__label'
        label_mini_id : 'glados_es_gs__activity__ligand_efficiency___lle__label__mini'

      'ligand_efficiency.sei' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__ligand_efficiency___sei__label'
        label_mini_id : 'glados_es_gs__activity__ligand_efficiency___sei__label__mini'

      ligand_efficiency : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__activity__ligand_efficiency__label'
        label_mini_id : 'glados_es_gs__activity__ligand_efficiency__label__mini'

      molecule_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__activity__molecule_chembl_id__label__mini'

      molecule_pref_name : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__molecule_pref_name__label'
        label_mini_id : 'glados_es_gs__activity__molecule_pref_name__label__mini'

      parent_molecule_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__parent_molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__activity__parent_molecule_chembl_id__label__mini'

      pchembl_value : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__pchembl_value__label'
        label_mini_id : 'glados_es_gs__activity__pchembl_value__label__mini'

      potential_duplicate : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__activity__potential_duplicate__label'
        label_mini_id : 'glados_es_gs__activity__potential_duplicate__label__mini'

      qudt_units : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__qudt_units__label'
        label_mini_id : 'glados_es_gs__activity__qudt_units__label__mini'

      record_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__record_id__label'
        label_mini_id : 'glados_es_gs__activity__record_id__label__mini'

      relation : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__relation__label'
        label_mini_id : 'glados_es_gs__activity__relation__label__mini'

      src_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__src_id__label'
        label_mini_id : 'glados_es_gs__activity__src_id__label__mini'

      standard_flag : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__activity__standard_flag__label'
        label_mini_id : 'glados_es_gs__activity__standard_flag__label__mini'

      standard_relation : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__standard_relation__label'
        label_mini_id : 'glados_es_gs__activity__standard_relation__label__mini'

      standard_text_value : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__standard_text_value__label'
        label_mini_id : 'glados_es_gs__activity__standard_text_value__label__mini'

      standard_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__standard_type__label'
        label_mini_id : 'glados_es_gs__activity__standard_type__label__mini'

      standard_units : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__standard_units__label'
        label_mini_id : 'glados_es_gs__activity__standard_units__label__mini'

      standard_value : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__standard_value__label'
        label_mini_id : 'glados_es_gs__activity__standard_value__label__mini'

      target_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__target_chembl_id__label'
        label_mini_id : 'glados_es_gs__activity__target_chembl_id__label__mini'

      target_organism : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__target_organism__label'
        label_mini_id : 'glados_es_gs__activity__target_organism__label__mini'

      target_pref_name : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__target_pref_name__label'
        label_mini_id : 'glados_es_gs__activity__target_pref_name__label__mini'

      target_tax_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__target_tax_id__label'
        label_mini_id : 'glados_es_gs__activity__target_tax_id__label__mini'

      text_value : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__text_value__label'
        label_mini_id : 'glados_es_gs__activity__text_value__label__mini'

      toid : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__toid__label'
        label_mini_id : 'glados_es_gs__activity__toid__label__mini'

      type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__type__label'
        label_mini_id : 'glados_es_gs__activity__type__label__mini'

      units : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__units__label'
        label_mini_id : 'glados_es_gs__activity__units__label__mini'

      uo_units : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__uo_units__label'
        label_mini_id : 'glados_es_gs__activity__uo_units__label__mini'

      upper_value : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__upper_value__label'
        label_mini_id : 'glados_es_gs__activity__upper_value__label__mini'

      value : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__value__label'
        label_mini_id : 'glados_es_gs__activity__value__label__mini'

    chembl_26_assay:
      '_metadata.assay_generated.confidence_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_generated___confidence_label__label'
        label_mini_id : 'glados_es_gs__assay__assay_generated___confidence_label__label__mini'

      '_metadata.assay_generated.relationship_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_generated___relationship_label__label'
        label_mini_id : 'glados_es_gs__assay__assay_generated___relationship_label__label__mini'

      '_metadata.assay_generated.type_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_generated___type_label__label'
        label_mini_id : 'glados_es_gs__assay__assay_generated___type_label__label__mini'

      '_metadata.assay_generated' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__assay_generated__label'
        label_mini_id : 'glados_es_gs__assay__assay_generated__label__mini'

      '_metadata.document_data.doi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_data___doi__label'
        label_mini_id : 'glados_es_gs__assay__document_data___doi__label__mini'

      '_metadata.document_data.first_page' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_data___first_page__label'
        label_mini_id : 'glados_es_gs__assay__document_data___first_page__label__mini'

      '_metadata.document_data.journal' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_data___journal__label'
        label_mini_id : 'glados_es_gs__assay__document_data___journal__label__mini'

      '_metadata.document_data.last_page' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_data___last_page__label'
        label_mini_id : 'glados_es_gs__assay__document_data___last_page__label__mini'

      '_metadata.document_data.pubmed_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_data___pubmed_id__label'
        label_mini_id : 'glados_es_gs__assay__document_data___pubmed_id__label__mini'

      '_metadata.document_data.title' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_data___title__label'
        label_mini_id : 'glados_es_gs__assay__document_data___title__label__mini'

      '_metadata.document_data.volume' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_data___volume__label'
        label_mini_id : 'glados_es_gs__assay__document_data___volume__label__mini'

      '_metadata.document_data.year' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_data___year__label'
        label_mini_id : 'glados_es_gs__assay__document_data___year__label__mini'

      '_metadata.document_data' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__document_data__label'
        label_mini_id : 'glados_es_gs__assay__document_data__label__mini'

      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__assay__es_completion__label'
        label_mini_id : 'glados_es_gs__assay__es_completion__label__mini'

      '_metadata.organism_taxonomy.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__organism_taxonomy___l1__label'
        label_mini_id : 'glados_es_gs__assay__organism_taxonomy___l1__label__mini'

      '_metadata.organism_taxonomy.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__organism_taxonomy___l2__label'
        label_mini_id : 'glados_es_gs__assay__organism_taxonomy___l2__label__mini'

      '_metadata.organism_taxonomy.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__organism_taxonomy___l3__label'
        label_mini_id : 'glados_es_gs__assay__organism_taxonomy___l3__label__mini'

      '_metadata.organism_taxonomy.oc_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__organism_taxonomy___oc_id__label'
        label_mini_id : 'glados_es_gs__assay__organism_taxonomy___oc_id__label__mini'

      '_metadata.organism_taxonomy.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__organism_taxonomy___tax_id__label'
        label_mini_id : 'glados_es_gs__assay__organism_taxonomy___tax_id__label__mini'

      '_metadata.organism_taxonomy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__organism_taxonomy__label'
        label_mini_id : 'glados_es_gs__assay__organism_taxonomy__label__mini'

      '_metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__assay__related_activities___count__label'
        label_mini_id : 'glados_es_gs__assay__related_activities___count__label__mini'

      '_metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__related_activities__label'
        label_mini_id : 'glados_es_gs__assay__related_activities__label__mini'

      '_metadata.related_compounds.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__assay__related_compounds___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__assay__related_compounds___all_chembl_ids__label__mini'

      '_metadata.related_compounds.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__assay__related_compounds___count__label'
        label_mini_id : 'glados_es_gs__assay__related_compounds___count__label__mini'

      '_metadata.related_compounds' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__related_compounds__label'
        label_mini_id : 'glados_es_gs__assay__related_compounds__label__mini'

      '_metadata.related_documents.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__assay__related_documents___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__assay__related_documents___all_chembl_ids__label__mini'

      '_metadata.related_documents.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__assay__related_documents___count__label'
        label_mini_id : 'glados_es_gs__assay__related_documents___count__label__mini'

      '_metadata.related_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__related_documents__label'
        label_mini_id : 'glados_es_gs__assay__related_documents__label__mini'

      '_metadata.related_targets.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__assay__related_targets___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__assay__related_targets___all_chembl_ids__label__mini'

      '_metadata.related_targets.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__assay__related_targets___count__label'
        label_mini_id : 'glados_es_gs__assay__related_targets___count__label__mini'

      '_metadata.related_targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__related_targets__label'
        label_mini_id : 'glados_es_gs__assay__related_targets__label__mini'

      '_metadata.source.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__source___src_description__label'
        label_mini_id : 'glados_es_gs__assay__source___src_description__label__mini'

      '_metadata.source.src_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__source___src_id__label'
        label_mini_id : 'glados_es_gs__assay__source___src_id__label__mini'

      '_metadata.source.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__source___src_short_name__label'
        label_mini_id : 'glados_es_gs__assay__source___src_short_name__label__mini'

      '_metadata.source' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__source__label'
        label_mini_id : 'glados_es_gs__assay__source__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay___metadata__label'
        label_mini_id : 'glados_es_gs__assay___metadata__label__mini'

      assay_category : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_category__label'
        label_mini_id : 'glados_es_gs__assay__assay_category__label__mini'

      assay_cell_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_cell_type__label'
        label_mini_id : 'glados_es_gs__assay__assay_cell_type__label__mini'

      assay_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_chembl_id__label'
        label_mini_id : 'glados_es_gs__assay__assay_chembl_id__label__mini'

      'assay_classifications.assay_class_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_classifications___assay_class_id__label'
        label_mini_id : 'glados_es_gs__assay__assay_classifications___assay_class_id__label__mini'

      'assay_classifications.class_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_classifications___class_type__label'
        label_mini_id : 'glados_es_gs__assay__assay_classifications___class_type__label__mini'

      'assay_classifications.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_classifications___l1__label'
        label_mini_id : 'glados_es_gs__assay__assay_classifications___l1__label__mini'

      'assay_classifications.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_classifications___l2__label'
        label_mini_id : 'glados_es_gs__assay__assay_classifications___l2__label__mini'

      'assay_classifications.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_classifications___l3__label'
        label_mini_id : 'glados_es_gs__assay__assay_classifications___l3__label__mini'

      'assay_classifications.source' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_classifications___source__label'
        label_mini_id : 'glados_es_gs__assay__assay_classifications___source__label__mini'

      assay_classifications : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__assay_classifications__label'
        label_mini_id : 'glados_es_gs__assay__assay_classifications__label__mini'

      assay_organism : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_organism__label'
        label_mini_id : 'glados_es_gs__assay__assay_organism__label__mini'

      'assay_parameters.active' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___active__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___active__label__mini'

      'assay_parameters.comments' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___comments__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___comments__label__mini'

      'assay_parameters.relation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___relation__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___relation__label__mini'

      'assay_parameters.standard_relation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___standard_relation__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___standard_relation__label__mini'

      'assay_parameters.standard_text_value' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___standard_text_value__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___standard_text_value__label__mini'

      'assay_parameters.standard_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___standard_type__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___standard_type__label__mini'

      'assay_parameters.standard_type_fixed' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___standard_type_fixed__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___standard_type_fixed__label__mini'

      'assay_parameters.standard_units' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___standard_units__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___standard_units__label__mini'

      'assay_parameters.standard_value' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___standard_value__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___standard_value__label__mini'

      'assay_parameters.text_value' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___text_value__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___text_value__label__mini'

      'assay_parameters.type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___type__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___type__label__mini'

      'assay_parameters.units' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___units__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___units__label__mini'

      'assay_parameters.value' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_parameters___value__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters___value__label__mini'

      assay_parameters : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__assay__assay_parameters__label'
        label_mini_id : 'glados_es_gs__assay__assay_parameters__label__mini'

      assay_strain : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_strain__label'
        label_mini_id : 'glados_es_gs__assay__assay_strain__label__mini'

      assay_subcellular_fraction : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_subcellular_fraction__label'
        label_mini_id : 'glados_es_gs__assay__assay_subcellular_fraction__label__mini'

      assay_tax_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_tax_id__label'
        label_mini_id : 'glados_es_gs__assay__assay_tax_id__label__mini'

      assay_test_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_test_type__label'
        label_mini_id : 'glados_es_gs__assay__assay_test_type__label__mini'

      assay_tissue : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_tissue__label'
        label_mini_id : 'glados_es_gs__assay__assay_tissue__label__mini'

      assay_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_type__label'
        label_mini_id : 'glados_es_gs__assay__assay_type__label__mini'

      assay_type_description : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_type_description__label'
        label_mini_id : 'glados_es_gs__assay__assay_type_description__label__mini'

      bao_format : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__bao_format__label'
        label_mini_id : 'glados_es_gs__assay__bao_format__label__mini'

      bao_label : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__bao_label__label'
        label_mini_id : 'glados_es_gs__assay__bao_label__label__mini'

      cell_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__cell_chembl_id__label'
        label_mini_id : 'glados_es_gs__assay__cell_chembl_id__label__mini'

      confidence_description : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__confidence_description__label'
        label_mini_id : 'glados_es_gs__assay__confidence_description__label__mini'

      confidence_score : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__assay__confidence_score__label'
        label_mini_id : 'glados_es_gs__assay__confidence_score__label__mini'

      description : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__description__label'
        label_mini_id : 'glados_es_gs__assay__description__label__mini'

      document_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__document_chembl_id__label'
        label_mini_id : 'glados_es_gs__assay__document_chembl_id__label__mini'

      relationship_description : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__relationship_description__label'
        label_mini_id : 'glados_es_gs__assay__relationship_description__label__mini'

      relationship_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__relationship_type__label'
        label_mini_id : 'glados_es_gs__assay__relationship_type__label__mini'

      src_assay_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__src_assay_id__label'
        label_mini_id : 'glados_es_gs__assay__src_assay_id__label__mini'

      src_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__src_id__label'
        label_mini_id : 'glados_es_gs__assay__src_id__label__mini'

      target_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__target_chembl_id__label'
        label_mini_id : 'glados_es_gs__assay__target_chembl_id__label__mini'

      tissue_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__tissue_chembl_id__label'
        label_mini_id : 'glados_es_gs__assay__tissue_chembl_id__label__mini'

    chembl_26_cell_line:
      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__es_completion__label'
        label_mini_id : 'glados_es_gs__cell_line__es_completion__label__mini'

      '_metadata.organism_taxonomy.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__organism_taxonomy___l1__label'
        label_mini_id : 'glados_es_gs__cell_line__organism_taxonomy___l1__label__mini'

      '_metadata.organism_taxonomy.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__organism_taxonomy___l2__label'
        label_mini_id : 'glados_es_gs__cell_line__organism_taxonomy___l2__label__mini'

      '_metadata.organism_taxonomy.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__organism_taxonomy___l3__label'
        label_mini_id : 'glados_es_gs__cell_line__organism_taxonomy___l3__label__mini'

      '_metadata.organism_taxonomy.oc_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__organism_taxonomy___oc_id__label'
        label_mini_id : 'glados_es_gs__cell_line__organism_taxonomy___oc_id__label__mini'

      '_metadata.organism_taxonomy.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__organism_taxonomy___tax_id__label'
        label_mini_id : 'glados_es_gs__cell_line__organism_taxonomy___tax_id__label__mini'

      '_metadata.organism_taxonomy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__organism_taxonomy__label'
        label_mini_id : 'glados_es_gs__cell_line__organism_taxonomy__label__mini'

      '_metadata.related_activities.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_activities___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__cell_line__related_activities___all_chembl_ids__label__mini'

      '_metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__related_activities___count__label'
        label_mini_id : 'glados_es_gs__cell_line__related_activities___count__label__mini'

      '_metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_activities__label'
        label_mini_id : 'glados_es_gs__cell_line__related_activities__label__mini'

      '_metadata.related_assays.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_assays___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__cell_line__related_assays___all_chembl_ids__label__mini'

      '_metadata.related_assays.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__related_assays___count__label'
        label_mini_id : 'glados_es_gs__cell_line__related_assays___count__label__mini'

      '_metadata.related_assays' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_assays__label'
        label_mini_id : 'glados_es_gs__cell_line__related_assays__label__mini'

      '_metadata.related_compounds.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_compounds___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__cell_line__related_compounds___all_chembl_ids__label__mini'

      '_metadata.related_compounds.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__related_compounds___count__label'
        label_mini_id : 'glados_es_gs__cell_line__related_compounds___count__label__mini'

      '_metadata.related_compounds' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_compounds__label'
        label_mini_id : 'glados_es_gs__cell_line__related_compounds__label__mini'

      '_metadata.related_documents.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_documents___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__cell_line__related_documents___all_chembl_ids__label__mini'

      '_metadata.related_documents.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__related_documents___count__label'
        label_mini_id : 'glados_es_gs__cell_line__related_documents___count__label__mini'

      '_metadata.related_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_documents__label'
        label_mini_id : 'glados_es_gs__cell_line__related_documents__label__mini'

      '_metadata.related_targets.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_targets___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__cell_line__related_targets___all_chembl_ids__label__mini'

      '_metadata.related_targets.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__related_targets___count__label'
        label_mini_id : 'glados_es_gs__cell_line__related_targets___count__label__mini'

      '_metadata.related_targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_targets__label'
        label_mini_id : 'glados_es_gs__cell_line__related_targets__label__mini'

      '_metadata.related_tissues.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_tissues___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__cell_line__related_tissues___all_chembl_ids__label__mini'

      '_metadata.related_tissues.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__related_tissues___count__label'
        label_mini_id : 'glados_es_gs__cell_line__related_tissues___count__label__mini'

      '_metadata.related_tissues' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__related_tissues__label'
        label_mini_id : 'glados_es_gs__cell_line__related_tissues__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line___metadata__label'
        label_mini_id : 'glados_es_gs__cell_line___metadata__label__mini'

      cell_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cell_chembl_id__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_chembl_id__label__mini'

      cell_description : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cell_description__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_description__label__mini'

      cell_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cell_id__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_id__label__mini'

      cell_name : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cell_name__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_name__label__mini'

      cell_source_organism : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cell_source_organism__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_source_organism__label__mini'

      cell_source_tax_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cell_source_tax_id__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_source_tax_id__label__mini'

      cell_source_tissue : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cell_source_tissue__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_source_tissue__label__mini'

      cellosaurus_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cellosaurus_id__label'
        label_mini_id : 'glados_es_gs__cell_line__cellosaurus_id__label__mini'

      cl_lincs_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cl_lincs_id__label'
        label_mini_id : 'glados_es_gs__cell_line__cl_lincs_id__label__mini'

      clo_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__clo_id__label'
        label_mini_id : 'glados_es_gs__cell_line__clo_id__label__mini'

      efo_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__efo_id__label'
        label_mini_id : 'glados_es_gs__cell_line__efo_id__label__mini'

    chembl_26_document:
      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__es_completion__label'
        label_mini_id : 'glados_es_gs__document__es_completion__label__mini'

      '_metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__related_activities___count__label'
        label_mini_id : 'glados_es_gs__document__related_activities___count__label__mini'

      '_metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document__related_activities__label'
        label_mini_id : 'glados_es_gs__document__related_activities__label__mini'

      '_metadata.related_assays.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__related_assays___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__document__related_assays___all_chembl_ids__label__mini'

      '_metadata.related_assays.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__related_assays___count__label'
        label_mini_id : 'glados_es_gs__document__related_assays___count__label__mini'

      '_metadata.related_assays' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document__related_assays__label'
        label_mini_id : 'glados_es_gs__document__related_assays__label__mini'

      '_metadata.related_cell_lines.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__related_cell_lines___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__document__related_cell_lines___all_chembl_ids__label__mini'

      '_metadata.related_cell_lines.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__related_cell_lines___count__label'
        label_mini_id : 'glados_es_gs__document__related_cell_lines___count__label__mini'

      '_metadata.related_cell_lines' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document__related_cell_lines__label'
        label_mini_id : 'glados_es_gs__document__related_cell_lines__label__mini'

      '_metadata.related_compounds.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__related_compounds___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__document__related_compounds___all_chembl_ids__label__mini'

      '_metadata.related_compounds.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__related_compounds___count__label'
        label_mini_id : 'glados_es_gs__document__related_compounds___count__label__mini'

      '_metadata.related_compounds' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document__related_compounds__label'
        label_mini_id : 'glados_es_gs__document__related_compounds__label__mini'

      '_metadata.related_targets.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__related_targets___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__document__related_targets___all_chembl_ids__label__mini'

      '_metadata.related_targets.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__related_targets___count__label'
        label_mini_id : 'glados_es_gs__document__related_targets___count__label__mini'

      '_metadata.related_targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document__related_targets__label'
        label_mini_id : 'glados_es_gs__document__related_targets__label__mini'

      '_metadata.related_tissues.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__related_tissues___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__document__related_tissues___all_chembl_ids__label__mini'

      '_metadata.related_tissues.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__related_tissues___count__label'
        label_mini_id : 'glados_es_gs__document__related_tissues___count__label__mini'

      '_metadata.related_tissues' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document__related_tissues__label'
        label_mini_id : 'glados_es_gs__document__related_tissues__label__mini'

      '_metadata.similar_documents.document_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___document_chembl_id__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___document_chembl_id__label__mini'

      '_metadata.similar_documents.doi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___doi__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___doi__label__mini'

      '_metadata.similar_documents.first_page' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___first_page__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___first_page__label__mini'

      '_metadata.similar_documents.journal' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___journal__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___journal__label__mini'

      '_metadata.similar_documents.last_page' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___last_page__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___last_page__label__mini'

      '_metadata.similar_documents.mol_tani' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___mol_tani__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___mol_tani__label__mini'

      '_metadata.similar_documents.pubmed_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___pubmed_id__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___pubmed_id__label__mini'

      '_metadata.similar_documents.tid_tani' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___tid_tani__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___tid_tani__label__mini'

      '_metadata.similar_documents.title' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___title__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___title__label__mini'

      '_metadata.similar_documents.volume' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___volume__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___volume__label__mini'

      '_metadata.similar_documents.year' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__similar_documents___year__label'
        label_mini_id : 'glados_es_gs__document__similar_documents___year__label__mini'

      '_metadata.similar_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document__similar_documents__label'
        label_mini_id : 'glados_es_gs__document__similar_documents__label__mini'

      '_metadata.source.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__source___src_description__label'
        label_mini_id : 'glados_es_gs__document__source___src_description__label__mini'

      '_metadata.source.src_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__source___src_id__label'
        label_mini_id : 'glados_es_gs__document__source___src_id__label__mini'

      '_metadata.source.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__source___src_short_name__label'
        label_mini_id : 'glados_es_gs__document__source___src_short_name__label__mini'

      '_metadata.source' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document__source__label'
        label_mini_id : 'glados_es_gs__document__source__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document___metadata__label'
        label_mini_id : 'glados_es_gs__document___metadata__label__mini'

      abstract : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__abstract__label'
        label_mini_id : 'glados_es_gs__document__abstract__label__mini'

      authors : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__authors__label'
        label_mini_id : 'glados_es_gs__document__authors__label__mini'

      doc_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__doc_type__label'
        label_mini_id : 'glados_es_gs__document__doc_type__label__mini'

      document_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__document_chembl_id__label'
        label_mini_id : 'glados_es_gs__document__document_chembl_id__label__mini'

      doi : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__doi__label'
        label_mini_id : 'glados_es_gs__document__doi__label__mini'

      first_page : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__first_page__label'
        label_mini_id : 'glados_es_gs__document__first_page__label__mini'

      issue : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__issue__label'
        label_mini_id : 'glados_es_gs__document__issue__label__mini'

      journal : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__journal__label'
        label_mini_id : 'glados_es_gs__document__journal__label__mini'

      journal_full_title : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__journal_full_title__label'
        label_mini_id : 'glados_es_gs__document__journal_full_title__label__mini'

      last_page : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__last_page__label'
        label_mini_id : 'glados_es_gs__document__last_page__label__mini'

      patent_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__patent_id__label'
        label_mini_id : 'glados_es_gs__document__patent_id__label__mini'

      pubmed_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__pubmed_id__label'
        label_mini_id : 'glados_es_gs__document__pubmed_id__label__mini'

      src_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__src_id__label'
        label_mini_id : 'glados_es_gs__document__src_id__label__mini'

      title : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__title__label'
        label_mini_id : 'glados_es_gs__document__title__label__mini'

      volume : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__document__volume__label'
        label_mini_id : 'glados_es_gs__document__volume__label__mini'

      year : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__document__year__label'
        label_mini_id : 'glados_es_gs__document__year__label__mini'

    chembl_26_drug_indication_by_parent:
      'drug_indication._metadata.all_molecule_chembl_ids' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__all_molecule_chembl_ids__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__all_molecule_chembl_ids__label__mini'

      'drug_indication._metadata' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication____metadata__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication____metadata__label__mini'

      'drug_indication.drugind_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___drugind_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___drugind_id__label__mini'

      'drug_indication.efo.id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__efo___id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__efo___id__label__mini'

      'drug_indication.efo.term' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__efo___term__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__efo___term__label__mini'

      'drug_indication.efo' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___efo__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___efo__label__mini'

      'drug_indication.indication_refs.ref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_id__label__mini'

      'drug_indication.indication_refs.ref_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_type__label__mini'

      'drug_indication.indication_refs.ref_url' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_url__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_url__label__mini'

      'drug_indication.indication_refs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___indication_refs__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___indication_refs__label__mini'

      'drug_indication.max_phase' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___max_phase__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___max_phase__label__mini'

      'drug_indication.max_phase_for_ind' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___max_phase_for_ind__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___max_phase_for_ind__label__mini'

      'drug_indication.mesh_heading' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___mesh_heading__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___mesh_heading__label__mini'

      'drug_indication.mesh_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___mesh_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___mesh_id__label__mini'

      'drug_indication.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___molecule_chembl_id__label__mini'

      'drug_indication.parent_molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___parent_molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication___parent_molecule_chembl_id__label__mini'

      drug_indication : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indication__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indication__label__mini'

      'parent_molecule._metadata.activity_count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__activity_count__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__activity_count__label__mini'

      'parent_molecule._metadata.atc_classifications.level1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level1__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level1__label__mini'

      'parent_molecule._metadata.atc_classifications.level1_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level1_description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level1_description__label__mini'

      'parent_molecule._metadata.atc_classifications.level2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level2__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level2__label__mini'

      'parent_molecule._metadata.atc_classifications.level2_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level2_description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level2_description__label__mini'

      'parent_molecule._metadata.atc_classifications.level3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level3__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level3__label__mini'

      'parent_molecule._metadata.atc_classifications.level3_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level3_description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level3_description__label__mini'

      'parent_molecule._metadata.atc_classifications.level4' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level4__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level4__label__mini'

      'parent_molecule._metadata.atc_classifications.level4_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level4_description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level4_description__label__mini'

      'parent_molecule._metadata.atc_classifications.level5' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level5__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___level5__label__mini'

      'parent_molecule._metadata.atc_classifications.who_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___who_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications___who_name__label__mini'

      'parent_molecule._metadata.atc_classifications' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classifications__label__mini'

      'parent_molecule._metadata.compound_generated.availability_type_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_generated___availability_type_label__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_generated___availability_type_label__label__mini'

      'parent_molecule._metadata.compound_generated.chirality_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_generated___chirality_label__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_generated___chirality_label__label__mini'

      'parent_molecule._metadata.compound_generated.image_file' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_generated___image_file__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_generated___image_file__label__mini'

      'parent_molecule._metadata.compound_generated' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_generated__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_generated__label__mini'

      'parent_molecule._metadata.compound_records.compound_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_records___compound_key__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_records___compound_key__label__mini'

      'parent_molecule._metadata.compound_records.compound_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_records___compound_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_records___compound_name__label__mini'

      'parent_molecule._metadata.compound_records.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_records___src_description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_records___src_description__label__mini'

      'parent_molecule._metadata.compound_records.src_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_records___src_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_records___src_id__label__mini'

      'parent_molecule._metadata.compound_records.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_records___src_short_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_records___src_short_name__label__mini'

      'parent_molecule._metadata.compound_records' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__compound_records__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__compound_records__label__mini'

      'parent_molecule._metadata.disease_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__disease_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__disease_name__label__mini'

      'parent_molecule._metadata.drug.drug_data.applicants' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__applicants__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__applicants__label__mini'

      'parent_molecule._metadata.drug.drug_data.atc_classification.code' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classification___code__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classification___code__label__mini'

      'parent_molecule._metadata.drug.drug_data.atc_classification.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classification___description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classification___description__label__mini'

      'parent_molecule._metadata.drug.drug_data.atc_classification' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__atc_classification__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__atc_classification__label__mini'

      'parent_molecule._metadata.drug.drug_data.availability_type' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__availability_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__availability_type__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___component_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___component_id__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___component_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___component_type__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___description__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___organism__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___organism__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.sequence' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___sequence__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___sequence__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___tax_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___tax_id__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___biocomponents__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___biocomponents__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___description__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___helm_notation__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___helm_notation__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___molecule_chembl_id__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic__label__mini'

      'parent_molecule._metadata.drug.drug_data.black_box' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__black_box__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__black_box__label__mini'

      'parent_molecule._metadata.drug.drug_data.chirality' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__chirality__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__chirality__label__mini'

      'parent_molecule._metadata.drug.drug_data.development_phase' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__development_phase__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__development_phase__label__mini'

      'parent_molecule._metadata.drug.drug_data.drug_type' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_type__label__mini'

      'parent_molecule._metadata.drug.drug_data.first_approval' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__first_approval__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__first_approval__label__mini'

      'parent_molecule._metadata.drug.drug_data.first_in_class' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__first_in_class__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__first_in_class__label__mini'

      'parent_molecule._metadata.drug.drug_data.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__helm_notation__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__helm_notation__label__mini'

      'parent_molecule._metadata.drug.drug_data.indication_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__indication_class__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__indication_class__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_chembl_id__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.alogp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___alogp__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___alogp__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.aromatic_rings' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___aromatic_rings__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___aromatic_rings__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.cx_logd' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_logd__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_logd__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.cx_logp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_logp__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_logp__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.cx_most_apka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_most_apka__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_most_apka__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.cx_most_bpka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_most_bpka__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_most_bpka__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.full_molformula' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___full_molformula__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___full_molformula__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.full_mwt' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___full_mwt__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___full_mwt__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.hba' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hba__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hba__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.hba_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hba_lipinski__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hba_lipinski__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.hbd' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hbd__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hbd__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.hbd_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hbd_lipinski__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hbd_lipinski__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.heavy_atoms' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___heavy_atoms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___heavy_atoms__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.molecular_species' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___molecular_species__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___molecular_species__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.mw_freebase' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___mw_freebase__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___mw_freebase__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.mw_monoisotopic' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___mw_monoisotopic__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___mw_monoisotopic__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.num_lipinski_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___num_lipinski_ro5_violations__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___num_lipinski_ro5_violations__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.num_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___num_ro5_violations__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.psa' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___psa__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___psa__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.qed_weighted' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___qed_weighted__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___qed_weighted__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.ro3_pass' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___ro3_pass__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___ro3_pass__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.rtb' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___rtb__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___rtb__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures.canonical_smiles' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___canonical_smiles__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___canonical_smiles__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures.molfile' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___molfile__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___molfile__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures.standard_inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___standard_inchi__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___standard_inchi__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures.standard_inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___standard_inchi_key__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___standard_inchi_key__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___molecule_synonym__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___syn_type__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___synonyms__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms__label__mini'

      'parent_molecule._metadata.drug.drug_data.ob_patent' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__ob_patent__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__ob_patent__label__mini'

      'parent_molecule._metadata.drug.drug_data.oral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__oral__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__oral__label__mini'

      'parent_molecule._metadata.drug.drug_data.parenteral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parenteral__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parenteral__label__mini'

      'parent_molecule._metadata.drug.drug_data.prodrug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__prodrug__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__prodrug__label__mini'

      'parent_molecule._metadata.drug.drug_data.research_codes' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__research_codes__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__research_codes__label__mini'

      'parent_molecule._metadata.drug.drug_data.rule_of_five' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__rule_of_five__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__rule_of_five__label__mini'

      'parent_molecule._metadata.drug.drug_data.sc_patent' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__sc_patent__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__sc_patent__label__mini'

      'parent_molecule._metadata.drug.drug_data.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__synonyms__label__mini'

      'parent_molecule._metadata.drug.drug_data.topical' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__topical__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__topical__label__mini'

      'parent_molecule._metadata.drug.drug_data.usan_stem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__usan_stem__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__usan_stem__label__mini'

      'parent_molecule._metadata.drug.drug_data.usan_stem_definition' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__usan_stem_definition__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__usan_stem_definition__label__mini'

      'parent_molecule._metadata.drug.drug_data.usan_stem_substem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__usan_stem_substem__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__usan_stem_substem__label__mini'

      'parent_molecule._metadata.drug.drug_data.usan_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__usan_year__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__usan_year__label__mini'

      'parent_molecule._metadata.drug.drug_data.withdrawn_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__withdrawn_class__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__withdrawn_class__label__mini'

      'parent_molecule._metadata.drug.drug_data.withdrawn_country' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__withdrawn_country__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__withdrawn_country__label__mini'

      'parent_molecule._metadata.drug.drug_data.withdrawn_reason' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__withdrawn_reason__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__withdrawn_reason__label__mini'

      'parent_molecule._metadata.drug.drug_data.withdrawn_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__withdrawn_year__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__withdrawn_year__label__mini'

      'parent_molecule._metadata.drug.drug_data' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug___drug_data__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug___drug_data__label__mini'

      'parent_molecule._metadata.drug.is_drug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug___is_drug__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug___is_drug__label__mini'

      'parent_molecule._metadata.drug' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug__label__mini'

      'parent_molecule._metadata.drug_indications._metadata.all_molecule_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__all_molecule_chembl_ids__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__all_molecule_chembl_ids__label__mini'

      'parent_molecule._metadata.drug_indications._metadata' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications____metadata__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications____metadata__label__mini'

      'parent_molecule._metadata.drug_indications.drugind_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___drugind_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___drugind_id__label__mini'

      'parent_molecule._metadata.drug_indications.efo_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___efo_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___efo_id__label__mini'

      'parent_molecule._metadata.drug_indications.efo_term' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___efo_term__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___efo_term__label__mini'

      'parent_molecule._metadata.drug_indications.indication_refs.ref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_id__label__mini'

      'parent_molecule._metadata.drug_indications.indication_refs.ref_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_type__label__mini'

      'parent_molecule._metadata.drug_indications.indication_refs.ref_url' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_url__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__indication_refs___ref_url__label__mini'

      'parent_molecule._metadata.drug_indications.indication_refs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___indication_refs__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___indication_refs__label__mini'

      'parent_molecule._metadata.drug_indications.max_phase_for_ind' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___max_phase_for_ind__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___max_phase_for_ind__label__mini'

      'parent_molecule._metadata.drug_indications.mesh_heading' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___mesh_heading__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___mesh_heading__label__mini'

      'parent_molecule._metadata.drug_indications.mesh_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___mesh_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___mesh_id__label__mini'

      'parent_molecule._metadata.drug_indications.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___molecule_chembl_id__label__mini'

      'parent_molecule._metadata.drug_indications.parent_molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___parent_molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications___parent_molecule_chembl_id__label__mini'

      'parent_molecule._metadata.drug_indications' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__drug_indications__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__drug_indications__label__mini'

      'parent_molecule._metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__es_completion__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__es_completion__label__mini'

      'parent_molecule._metadata.hierarchy.all_family.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__all_family___chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__all_family___chembl_id__label__mini'

      'parent_molecule._metadata.hierarchy.all_family.inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__all_family___inchi__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__all_family___inchi__label__mini'

      'parent_molecule._metadata.hierarchy.all_family.inchi_connectivity_layer' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__all_family___inchi_connectivity_layer__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__all_family___inchi_connectivity_layer__label__mini'

      'parent_molecule._metadata.hierarchy.all_family.inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__all_family___inchi_key__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__all_family___inchi_key__label__mini'

      'parent_molecule._metadata.hierarchy.all_family' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___all_family__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___all_family__label__mini'

      'parent_molecule._metadata.hierarchy.children.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__children___chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__children___chembl_id__label__mini'

      'parent_molecule._metadata.hierarchy.children.sources.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__sources___src_description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__sources___src_description__label__mini'

      'parent_molecule._metadata.hierarchy.children.sources.src_id' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__sources___src_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__sources___src_id__label__mini'

      'parent_molecule._metadata.hierarchy.children.sources.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__sources___src_short_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__sources___src_short_name__label__mini'

      'parent_molecule._metadata.hierarchy.children.sources' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__children___sources__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__children___sources__label__mini'

      'parent_molecule._metadata.hierarchy.children.synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__synonyms___molecule_synonym__label__mini'

      'parent_molecule._metadata.hierarchy.children.synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__synonyms___syn_type__label__mini'

      'parent_molecule._metadata.hierarchy.children.synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__synonyms___synonyms__label__mini'

      'parent_molecule._metadata.hierarchy.children.synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__children___synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__children___synonyms__label__mini'

      'parent_molecule._metadata.hierarchy.children' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___children__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___children__label__mini'

      'parent_molecule._metadata.hierarchy.family_inchi_connectivity_layer' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___family_inchi_connectivity_layer__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___family_inchi_connectivity_layer__label__mini'

      'parent_molecule._metadata.hierarchy.is_approved_drug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___is_approved_drug__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___is_approved_drug__label__mini'

      'parent_molecule._metadata.hierarchy.is_usan' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___is_usan__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___is_usan__label__mini'

      'parent_molecule._metadata.hierarchy.parent.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent___chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent___chembl_id__label__mini'

      'parent_molecule._metadata.hierarchy.parent.sources.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__sources___src_description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__sources___src_description__label__mini'

      'parent_molecule._metadata.hierarchy.parent.sources.src_id' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__sources___src_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__sources___src_id__label__mini'

      'parent_molecule._metadata.hierarchy.parent.sources.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__sources___src_short_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__sources___src_short_name__label__mini'

      'parent_molecule._metadata.hierarchy.parent.sources' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent___sources__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent___sources__label__mini'

      'parent_molecule._metadata.hierarchy.parent.synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__synonyms___molecule_synonym__label__mini'

      'parent_molecule._metadata.hierarchy.parent.synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__synonyms___syn_type__label__mini'

      'parent_molecule._metadata.hierarchy.parent.synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__synonyms___synonyms__label__mini'

      'parent_molecule._metadata.hierarchy.parent.synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent___synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent___synonyms__label__mini'

      'parent_molecule._metadata.hierarchy.parent' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___parent__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__hierarchy___parent__label__mini'

      'parent_molecule._metadata.hierarchy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__hierarchy__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__hierarchy__label__mini'

      'parent_molecule._metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__related_activities___count__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_activities___count__label__mini'

      'parent_molecule._metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_activities__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_activities__label__mini'

      'parent_molecule._metadata.related_assays.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_assays___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_assays___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_assays.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__related_assays___count__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_assays___count__label__mini'

      'parent_molecule._metadata.related_assays' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_assays__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_assays__label__mini'

      'parent_molecule._metadata.related_cell_lines.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_cell_lines___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_cell_lines___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_cell_lines.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__related_cell_lines___count__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_cell_lines___count__label__mini'

      'parent_molecule._metadata.related_cell_lines' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_cell_lines__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_cell_lines__label__mini'

      'parent_molecule._metadata.related_documents.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_documents___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_documents___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_documents.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__related_documents___count__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_documents___count__label__mini'

      'parent_molecule._metadata.related_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_documents__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_documents__label__mini'

      'parent_molecule._metadata.related_targets.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_targets___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_targets___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_targets.chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_targets___chembl_ids__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_targets___chembl_ids__label__mini'

      'parent_molecule._metadata.related_targets.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__related_targets___count__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_targets___count__label__mini'

      'parent_molecule._metadata.related_targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_targets__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_targets__label__mini'

      'parent_molecule._metadata.related_tissues.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_tissues___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_tissues___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_tissues.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__related_tissues___count__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_tissues___count__label__mini'

      'parent_molecule._metadata.related_tissues' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__related_tissues__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__related_tissues__label__mini'

      'parent_molecule._metadata.tags' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__tags__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__tags__label__mini'

      'parent_molecule._metadata.unichem.id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__unichem___id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__unichem___id__label__mini'

      'parent_molecule._metadata.unichem.link' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__unichem___link__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__unichem___link__label__mini'

      'parent_molecule._metadata.unichem.src_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__unichem___src_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__unichem___src_name__label__mini'

      'parent_molecule._metadata.unichem.src_url' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__unichem___src_url__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__unichem___src_url__label__mini'

      'parent_molecule._metadata.unichem' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__unichem__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__unichem__label__mini'

      'parent_molecule._metadata' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule____metadata__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule____metadata__label__mini'

      'parent_molecule.atc_classifications' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___atc_classifications__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___atc_classifications__label__mini'

      'parent_molecule.availability_type' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___availability_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___availability_type__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___component_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___component_id__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___component_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___component_type__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___description__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___organism__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___organism__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.sequence' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___sequence__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___sequence__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___tax_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biocomponents___tax_id__label__mini'

      'parent_molecule.biotherapeutic.biocomponents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___biocomponents__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___biocomponents__label__mini'

      'parent_molecule.biotherapeutic.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___description__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___description__label__mini'

      'parent_molecule.biotherapeutic.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___helm_notation__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___helm_notation__label__mini'

      'parent_molecule.biotherapeutic.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__biotherapeutic___molecule_chembl_id__label__mini'

      'parent_molecule.biotherapeutic' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___biotherapeutic__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___biotherapeutic__label__mini'

      'parent_molecule.black_box_warning' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___black_box_warning__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___black_box_warning__label__mini'

      'parent_molecule.chebi_par_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___chebi_par_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___chebi_par_id__label__mini'

      'parent_molecule.chirality' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___chirality__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___chirality__label__mini'

      'parent_molecule.cross_references.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_id__label__mini'

      'parent_molecule.cross_references.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_name__label__mini'

      'parent_molecule.cross_references.xref_src' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_src__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_src__label__mini'

      'parent_molecule.cross_references.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_src_url__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_src_url__label__mini'

      'parent_molecule.cross_references.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_url__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__cross_references___xref_url__label__mini'

      'parent_molecule.cross_references' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___cross_references__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___cross_references__label__mini'

      'parent_molecule.dosed_ingredient' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___dosed_ingredient__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___dosed_ingredient__label__mini'

      'parent_molecule.first_approval' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___first_approval__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___first_approval__label__mini'

      'parent_molecule.first_in_class' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___first_in_class__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___first_in_class__label__mini'

      'parent_molecule.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___helm_notation__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___helm_notation__label__mini'

      'parent_molecule.indication_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___indication_class__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___indication_class__label__mini'

      'parent_molecule.inorganic_flag' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___inorganic_flag__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___inorganic_flag__label__mini'

      'parent_molecule.max_phase' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___max_phase__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___max_phase__label__mini'

      'parent_molecule.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_chembl_id__label__mini'

      'parent_molecule.molecule_hierarchy.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_hierarchy___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_hierarchy___molecule_chembl_id__label__mini'

      'parent_molecule.molecule_hierarchy.parent_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_hierarchy___parent_chembl_id__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_hierarchy___parent_chembl_id__label__mini'

      'parent_molecule.molecule_hierarchy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_hierarchy__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_hierarchy__label__mini'

      'parent_molecule.molecule_properties.alogp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___alogp__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___alogp__label__mini'

      'parent_molecule.molecule_properties.aromatic_rings' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___aromatic_rings__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___aromatic_rings__label__mini'

      'parent_molecule.molecule_properties.cx_logd' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_logd__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_logd__label__mini'

      'parent_molecule.molecule_properties.cx_logp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_logp__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_logp__label__mini'

      'parent_molecule.molecule_properties.cx_most_apka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_most_apka__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_most_apka__label__mini'

      'parent_molecule.molecule_properties.cx_most_bpka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_most_bpka__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___cx_most_bpka__label__mini'

      'parent_molecule.molecule_properties.full_molformula' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___full_molformula__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___full_molformula__label__mini'

      'parent_molecule.molecule_properties.full_mwt' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___full_mwt__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___full_mwt__label__mini'

      'parent_molecule.molecule_properties.hba' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hba__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hba__label__mini'

      'parent_molecule.molecule_properties.hba_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hba_lipinski__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hba_lipinski__label__mini'

      'parent_molecule.molecule_properties.hbd' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hbd__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hbd__label__mini'

      'parent_molecule.molecule_properties.hbd_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hbd_lipinski__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___hbd_lipinski__label__mini'

      'parent_molecule.molecule_properties.heavy_atoms' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___heavy_atoms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___heavy_atoms__label__mini'

      'parent_molecule.molecule_properties.molecular_species' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___molecular_species__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___molecular_species__label__mini'

      'parent_molecule.molecule_properties.mw_freebase' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___mw_freebase__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___mw_freebase__label__mini'

      'parent_molecule.molecule_properties.mw_monoisotopic' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___mw_monoisotopic__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___mw_monoisotopic__label__mini'

      'parent_molecule.molecule_properties.num_lipinski_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___num_lipinski_ro5_violations__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___num_lipinski_ro5_violations__label__mini'

      'parent_molecule.molecule_properties.num_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___num_ro5_violations__label__mini'

      'parent_molecule.molecule_properties.psa' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___psa__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___psa__label__mini'

      'parent_molecule.molecule_properties.qed_weighted' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___qed_weighted__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___qed_weighted__label__mini'

      'parent_molecule.molecule_properties.ro3_pass' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___ro3_pass__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___ro3_pass__label__mini'

      'parent_molecule.molecule_properties.rtb' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___rtb__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_properties___rtb__label__mini'

      'parent_molecule.molecule_properties' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_properties__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_properties__label__mini'

      'parent_molecule.molecule_structures.canonical_smiles' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___canonical_smiles__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___canonical_smiles__label__mini'

      'parent_molecule.molecule_structures.molfile' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___molfile__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___molfile__label__mini'

      'parent_molecule.molecule_structures.standard_inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___standard_inchi__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___standard_inchi__label__mini'

      'parent_molecule.molecule_structures.standard_inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___standard_inchi_key__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_structures___standard_inchi_key__label__mini'

      'parent_molecule.molecule_structures' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_structures__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_structures__label__mini'

      'parent_molecule.molecule_synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___molecule_synonym__label__mini'

      'parent_molecule.molecule_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___syn_type__label__mini'

      'parent_molecule.molecule_synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__molecule_synonyms___synonyms__label__mini'

      'parent_molecule.molecule_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_synonyms__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_synonyms__label__mini'

      'parent_molecule.molecule_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___molecule_type__label__mini'

      'parent_molecule.natural_product' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___natural_product__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___natural_product__label__mini'

      'parent_molecule.oral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___oral__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___oral__label__mini'

      'parent_molecule.parenteral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___parenteral__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___parenteral__label__mini'

      'parent_molecule.polymer_flag' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___polymer_flag__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___polymer_flag__label__mini'

      'parent_molecule.pref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___pref_name__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___pref_name__label__mini'

      'parent_molecule.prodrug' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___prodrug__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___prodrug__label__mini'

      'parent_molecule.structure_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___structure_type__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___structure_type__label__mini'

      'parent_molecule.therapeutic_flag' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___therapeutic_flag__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___therapeutic_flag__label__mini'

      'parent_molecule.topical' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___topical__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___topical__label__mini'

      'parent_molecule.usan_stem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___usan_stem__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___usan_stem__label__mini'

      'parent_molecule.usan_stem_definition' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___usan_stem_definition__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___usan_stem_definition__label__mini'

      'parent_molecule.usan_substem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___usan_substem__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___usan_substem__label__mini'

      'parent_molecule.usan_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___usan_year__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___usan_year__label__mini'

      'parent_molecule.withdrawn_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_class__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_class__label__mini'

      'parent_molecule.withdrawn_country' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_country__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_country__label__mini'

      'parent_molecule.withdrawn_flag' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_flag__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_flag__label__mini'

      'parent_molecule.withdrawn_reason' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_reason__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_reason__label__mini'

      'parent_molecule.withdrawn_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_year__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule___withdrawn_year__label__mini'

      parent_molecule : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule__label'
        label_mini_id : 'glados_es_gs__drug_indication_by_parent__parent_molecule__label__mini'

    chembl_26_mechanism_by_parent_target:
      'binding_site.site_components.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__site_components___component_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__site_components___component_id__label__mini'

      'binding_site.site_components.domain.domain_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__domain___domain_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__domain___domain_id__label__mini'

      'binding_site.site_components.domain.domain_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__domain___domain_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__domain___domain_name__label__mini'

      'binding_site.site_components.domain.domain_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__domain___domain_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__domain___domain_type__label__mini'

      'binding_site.site_components.domain.source_domain_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__domain___source_domain_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__domain___source_domain_id__label__mini'

      'binding_site.site_components.domain' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__site_components___domain__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__site_components___domain__label__mini'

      'binding_site.site_components.sitecomp_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__site_components___sitecomp_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__site_components___sitecomp_id__label__mini'

      'binding_site.site_components' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__binding_site___site_components__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__binding_site___site_components__label__mini'

      'binding_site.site_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__binding_site___site_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__binding_site___site_id__label__mini'

      'binding_site.site_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__binding_site___site_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__binding_site___site_name__label__mini'

      binding_site : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__binding_site__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__binding_site__label__mini'

      'mechanism_of_action._metadata.all_molecule_chembl_ids' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__all_molecule_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__all_molecule_chembl_ids__label__mini'

      'mechanism_of_action._metadata.parent_molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule_chembl_id__label__mini'

      'mechanism_of_action._metadata.should_appear_in_browser' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__should_appear_in_browser__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__should_appear_in_browser__label__mini'

      'mechanism_of_action._metadata' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action____metadata__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action____metadata__label__mini'

      'mechanism_of_action.action_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___action_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___action_type__label__mini'

      'mechanism_of_action.binding_site_comment' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___binding_site_comment__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___binding_site_comment__label__mini'

      'mechanism_of_action.direct_interaction' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___direct_interaction__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___direct_interaction__label__mini'

      'mechanism_of_action.disease_efficacy' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___disease_efficacy__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___disease_efficacy__label__mini'

      'mechanism_of_action.max_phase' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___max_phase__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___max_phase__label__mini'

      'mechanism_of_action.mec_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___mec_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___mec_id__label__mini'

      'mechanism_of_action.mechanism_comment' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___mechanism_comment__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___mechanism_comment__label__mini'

      'mechanism_of_action.mechanism_of_action' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___mechanism_of_action__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___mechanism_of_action__label__mini'

      'mechanism_of_action.mechanism_refs.ref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_refs___ref_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_refs___ref_id__label__mini'

      'mechanism_of_action.mechanism_refs.ref_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_refs___ref_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_refs___ref_type__label__mini'

      'mechanism_of_action.mechanism_refs.ref_url' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_refs___ref_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_refs___ref_url__label__mini'

      'mechanism_of_action.mechanism_refs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___mechanism_refs__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___mechanism_refs__label__mini'

      'mechanism_of_action.molecular_mechanism' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___molecular_mechanism__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___molecular_mechanism__label__mini'

      'mechanism_of_action.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___molecule_chembl_id__label__mini'

      'mechanism_of_action.parent_molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___parent_molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___parent_molecule_chembl_id__label__mini'

      'mechanism_of_action.record_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___record_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___record_id__label__mini'

      'mechanism_of_action.selectivity_comment' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___selectivity_comment__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___selectivity_comment__label__mini'

      'mechanism_of_action.site_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___site_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___site_id__label__mini'

      'mechanism_of_action.target_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___target_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action___target_chembl_id__label__mini'

      mechanism_of_action : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__mechanism_of_action__label__mini'

      'parent_molecule._metadata.activity_count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__activity_count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__activity_count__label__mini'

      'parent_molecule._metadata.atc_classifications.level1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level1__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level1__label__mini'

      'parent_molecule._metadata.atc_classifications.level1_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level1_description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level1_description__label__mini'

      'parent_molecule._metadata.atc_classifications.level2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level2__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level2__label__mini'

      'parent_molecule._metadata.atc_classifications.level2_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level2_description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level2_description__label__mini'

      'parent_molecule._metadata.atc_classifications.level3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level3__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level3__label__mini'

      'parent_molecule._metadata.atc_classifications.level3_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level3_description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level3_description__label__mini'

      'parent_molecule._metadata.atc_classifications.level4' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level4__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level4__label__mini'

      'parent_molecule._metadata.atc_classifications.level4_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level4_description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level4_description__label__mini'

      'parent_molecule._metadata.atc_classifications.level5' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level5__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___level5__label__mini'

      'parent_molecule._metadata.atc_classifications.who_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___who_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications___who_name__label__mini'

      'parent_molecule._metadata.atc_classifications' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classifications__label__mini'

      'parent_molecule._metadata.compound_generated.availability_type_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_generated___availability_type_label__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_generated___availability_type_label__label__mini'

      'parent_molecule._metadata.compound_generated.chirality_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_generated___chirality_label__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_generated___chirality_label__label__mini'

      'parent_molecule._metadata.compound_generated.image_file' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_generated___image_file__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_generated___image_file__label__mini'

      'parent_molecule._metadata.compound_generated' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_generated__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_generated__label__mini'

      'parent_molecule._metadata.compound_records.compound_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___compound_key__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___compound_key__label__mini'

      'parent_molecule._metadata.compound_records.compound_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___compound_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___compound_name__label__mini'

      'parent_molecule._metadata.compound_records.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___src_description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___src_description__label__mini'

      'parent_molecule._metadata.compound_records.src_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___src_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___src_id__label__mini'

      'parent_molecule._metadata.compound_records.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___src_short_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_records___src_short_name__label__mini'

      'parent_molecule._metadata.compound_records' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__compound_records__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__compound_records__label__mini'

      'parent_molecule._metadata.disease_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__disease_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__disease_name__label__mini'

      'parent_molecule._metadata.drug.drug_data.applicants' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__applicants__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__applicants__label__mini'

      'parent_molecule._metadata.drug.drug_data.atc_classification.code' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classification___code__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classification___code__label__mini'

      'parent_molecule._metadata.drug.drug_data.atc_classification.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classification___description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classification___description__label__mini'

      'parent_molecule._metadata.drug.drug_data.atc_classification' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__atc_classification__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__atc_classification__label__mini'

      'parent_molecule._metadata.drug.drug_data.availability_type' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__availability_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__availability_type__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___component_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___component_id__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___component_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___component_type__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___description__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___organism__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___organism__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.sequence' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___sequence__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___sequence__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___tax_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___tax_id__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.biocomponents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___biocomponents__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___biocomponents__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___description__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___helm_notation__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___helm_notation__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___molecule_chembl_id__label__mini'

      'parent_molecule._metadata.drug.drug_data.biotherapeutic' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic__label__mini'

      'parent_molecule._metadata.drug.drug_data.black_box' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__black_box__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__black_box__label__mini'

      'parent_molecule._metadata.drug.drug_data.chirality' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__chirality__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__chirality__label__mini'

      'parent_molecule._metadata.drug.drug_data.development_phase' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__development_phase__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__development_phase__label__mini'

      'parent_molecule._metadata.drug.drug_data.drug_type' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_type__label__mini'

      'parent_molecule._metadata.drug.drug_data.first_approval' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__first_approval__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__first_approval__label__mini'

      'parent_molecule._metadata.drug.drug_data.first_in_class' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__first_in_class__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__first_in_class__label__mini'

      'parent_molecule._metadata.drug.drug_data.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__helm_notation__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__helm_notation__label__mini'

      'parent_molecule._metadata.drug.drug_data.indication_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__indication_class__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__indication_class__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_chembl_id__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.alogp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___alogp__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___alogp__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.aromatic_rings' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___aromatic_rings__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___aromatic_rings__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.cx_logd' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_logd__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_logd__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.cx_logp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_logp__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_logp__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.cx_most_apka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_most_apka__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_most_apka__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.cx_most_bpka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_most_bpka__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_most_bpka__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.full_molformula' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___full_molformula__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___full_molformula__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.full_mwt' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___full_mwt__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___full_mwt__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.hba' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hba__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hba__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.hba_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hba_lipinski__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hba_lipinski__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.hbd' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hbd__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hbd__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.hbd_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hbd_lipinski__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hbd_lipinski__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.heavy_atoms' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___heavy_atoms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___heavy_atoms__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.molecular_species' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___molecular_species__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___molecular_species__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.mw_freebase' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___mw_freebase__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___mw_freebase__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.mw_monoisotopic' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___mw_monoisotopic__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___mw_monoisotopic__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.num_lipinski_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___num_lipinski_ro5_violations__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___num_lipinski_ro5_violations__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.num_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___num_ro5_violations__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.psa' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___psa__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___psa__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.qed_weighted' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___qed_weighted__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___qed_weighted__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.ro3_pass' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___ro3_pass__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___ro3_pass__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties.rtb' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___rtb__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___rtb__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_properties' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures.canonical_smiles' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___canonical_smiles__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___canonical_smiles__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures.molfile' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___molfile__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___molfile__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures.standard_inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___standard_inchi__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___standard_inchi__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures.standard_inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___standard_inchi_key__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___standard_inchi_key__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_structures' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___molecule_synonym__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___syn_type__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___synonyms__label__mini'

      'parent_molecule._metadata.drug.drug_data.molecule_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms__label__mini'

      'parent_molecule._metadata.drug.drug_data.ob_patent' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__ob_patent__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__ob_patent__label__mini'

      'parent_molecule._metadata.drug.drug_data.oral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__oral__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__oral__label__mini'

      'parent_molecule._metadata.drug.drug_data.parenteral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parenteral__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parenteral__label__mini'

      'parent_molecule._metadata.drug.drug_data.prodrug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__prodrug__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__prodrug__label__mini'

      'parent_molecule._metadata.drug.drug_data.research_codes' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__research_codes__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__research_codes__label__mini'

      'parent_molecule._metadata.drug.drug_data.rule_of_five' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__rule_of_five__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__rule_of_five__label__mini'

      'parent_molecule._metadata.drug.drug_data.sc_patent' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__sc_patent__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__sc_patent__label__mini'

      'parent_molecule._metadata.drug.drug_data.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__synonyms__label__mini'

      'parent_molecule._metadata.drug.drug_data.topical' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__topical__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__topical__label__mini'

      'parent_molecule._metadata.drug.drug_data.usan_stem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__usan_stem__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__usan_stem__label__mini'

      'parent_molecule._metadata.drug.drug_data.usan_stem_definition' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__usan_stem_definition__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__usan_stem_definition__label__mini'

      'parent_molecule._metadata.drug.drug_data.usan_stem_substem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__usan_stem_substem__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__usan_stem_substem__label__mini'

      'parent_molecule._metadata.drug.drug_data.usan_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__usan_year__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__usan_year__label__mini'

      'parent_molecule._metadata.drug.drug_data.withdrawn_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__withdrawn_class__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__withdrawn_class__label__mini'

      'parent_molecule._metadata.drug.drug_data.withdrawn_country' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__withdrawn_country__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__withdrawn_country__label__mini'

      'parent_molecule._metadata.drug.drug_data.withdrawn_reason' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__withdrawn_reason__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__withdrawn_reason__label__mini'

      'parent_molecule._metadata.drug.drug_data.withdrawn_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__withdrawn_year__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__withdrawn_year__label__mini'

      'parent_molecule._metadata.drug.drug_data' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug___drug_data__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug___drug_data__label__mini'

      'parent_molecule._metadata.drug.is_drug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug___is_drug__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug___is_drug__label__mini'

      'parent_molecule._metadata.drug' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug__label__mini'

      'parent_molecule._metadata.drug_indications.drugind_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___drugind_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___drugind_id__label__mini'

      'parent_molecule._metadata.drug_indications.efo_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___efo_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___efo_id__label__mini'

      'parent_molecule._metadata.drug_indications.efo_term' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___efo_term__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___efo_term__label__mini'

      'parent_molecule._metadata.drug_indications.indication_refs.ref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__indication_refs___ref_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__indication_refs___ref_id__label__mini'

      'parent_molecule._metadata.drug_indications.indication_refs.ref_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__indication_refs___ref_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__indication_refs___ref_type__label__mini'

      'parent_molecule._metadata.drug_indications.indication_refs.ref_url' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__indication_refs___ref_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__indication_refs___ref_url__label__mini'

      'parent_molecule._metadata.drug_indications.indication_refs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___indication_refs__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___indication_refs__label__mini'

      'parent_molecule._metadata.drug_indications.max_phase_for_ind' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___max_phase_for_ind__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___max_phase_for_ind__label__mini'

      'parent_molecule._metadata.drug_indications.mesh_heading' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___mesh_heading__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___mesh_heading__label__mini'

      'parent_molecule._metadata.drug_indications.mesh_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___mesh_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___mesh_id__label__mini'

      'parent_molecule._metadata.drug_indications.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___molecule_chembl_id__label__mini'

      'parent_molecule._metadata.drug_indications.parent_molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___parent_molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications___parent_molecule_chembl_id__label__mini'

      'parent_molecule._metadata.drug_indications' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__drug_indications__label__mini'

      'parent_molecule._metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__es_completion__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__es_completion__label__mini'

      'parent_molecule._metadata.hierarchy.all_family.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__all_family___chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__all_family___chembl_id__label__mini'

      'parent_molecule._metadata.hierarchy.all_family.inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__all_family___inchi__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__all_family___inchi__label__mini'

      'parent_molecule._metadata.hierarchy.all_family.inchi_connectivity_layer' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__all_family___inchi_connectivity_layer__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__all_family___inchi_connectivity_layer__label__mini'

      'parent_molecule._metadata.hierarchy.all_family.inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__all_family___inchi_key__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__all_family___inchi_key__label__mini'

      'parent_molecule._metadata.hierarchy.all_family' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___all_family__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___all_family__label__mini'

      'parent_molecule._metadata.hierarchy.children.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__children___chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__children___chembl_id__label__mini'

      'parent_molecule._metadata.hierarchy.children.sources.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_description__label__mini'

      'parent_molecule._metadata.hierarchy.children.sources.src_id' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_id__label__mini'

      'parent_molecule._metadata.hierarchy.children.sources.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_short_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_short_name__label__mini'

      'parent_molecule._metadata.hierarchy.children.sources' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__children___sources__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__children___sources__label__mini'

      'parent_molecule._metadata.hierarchy.children.synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___molecule_synonym__label__mini'

      'parent_molecule._metadata.hierarchy.children.synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___syn_type__label__mini'

      'parent_molecule._metadata.hierarchy.children.synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___synonyms__label__mini'

      'parent_molecule._metadata.hierarchy.children.synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__children___synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__children___synonyms__label__mini'

      'parent_molecule._metadata.hierarchy.children' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___children__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___children__label__mini'

      'parent_molecule._metadata.hierarchy.family_inchi_connectivity_layer' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___family_inchi_connectivity_layer__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___family_inchi_connectivity_layer__label__mini'

      'parent_molecule._metadata.hierarchy.is_approved_drug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___is_approved_drug__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___is_approved_drug__label__mini'

      'parent_molecule._metadata.hierarchy.is_usan' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___is_usan__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___is_usan__label__mini'

      'parent_molecule._metadata.hierarchy.parent.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent___chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent___chembl_id__label__mini'

      'parent_molecule._metadata.hierarchy.parent.sources.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_description__label__mini'

      'parent_molecule._metadata.hierarchy.parent.sources.src_id' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_id__label__mini'

      'parent_molecule._metadata.hierarchy.parent.sources.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_short_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__sources___src_short_name__label__mini'

      'parent_molecule._metadata.hierarchy.parent.sources' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent___sources__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent___sources__label__mini'

      'parent_molecule._metadata.hierarchy.parent.synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___molecule_synonym__label__mini'

      'parent_molecule._metadata.hierarchy.parent.synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___syn_type__label__mini'

      'parent_molecule._metadata.hierarchy.parent.synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__synonyms___synonyms__label__mini'

      'parent_molecule._metadata.hierarchy.parent.synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent___synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent___synonyms__label__mini'

      'parent_molecule._metadata.hierarchy.parent' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___parent__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy___parent__label__mini'

      'parent_molecule._metadata.hierarchy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__hierarchy__label__mini'

      'parent_molecule._metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_activities___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_activities___count__label__mini'

      'parent_molecule._metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_activities__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_activities__label__mini'

      'parent_molecule._metadata.related_assays.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_assays___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_assays___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_assays.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_assays___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_assays___count__label__mini'

      'parent_molecule._metadata.related_assays' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_assays__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_assays__label__mini'

      'parent_molecule._metadata.related_cell_lines.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_cell_lines.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines___count__label__mini'

      'parent_molecule._metadata.related_cell_lines' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines__label__mini'

      'parent_molecule._metadata.related_documents.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_documents___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_documents___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_documents.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_documents___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_documents___count__label__mini'

      'parent_molecule._metadata.related_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_documents__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_documents__label__mini'

      'parent_molecule._metadata.related_targets.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_targets___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_targets___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_targets.chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_targets___chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_targets___chembl_ids__label__mini'

      'parent_molecule._metadata.related_targets.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_targets___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_targets___count__label__mini'

      'parent_molecule._metadata.related_targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_targets__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_targets__label__mini'

      'parent_molecule._metadata.related_tissues.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues___all_chembl_ids__label__mini'

      'parent_molecule._metadata.related_tissues.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues___count__label__mini'

      'parent_molecule._metadata.related_tissues' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues__label__mini'

      'parent_molecule._metadata.tags' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__tags__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__tags__label__mini'

      'parent_molecule._metadata.unichem.id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__unichem___id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__unichem___id__label__mini'

      'parent_molecule._metadata.unichem.link' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__unichem___link__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__unichem___link__label__mini'

      'parent_molecule._metadata.unichem.src_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__unichem___src_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__unichem___src_name__label__mini'

      'parent_molecule._metadata.unichem.src_url' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__unichem___src_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__unichem___src_url__label__mini'

      'parent_molecule._metadata.unichem' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__unichem__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__unichem__label__mini'

      'parent_molecule._metadata' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule____metadata__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule____metadata__label__mini'

      'parent_molecule.atc_classifications' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___atc_classifications__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___atc_classifications__label__mini'

      'parent_molecule.availability_type' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___availability_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___availability_type__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___component_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___component_id__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___component_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___component_type__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___description__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___organism__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___organism__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.sequence' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___sequence__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___sequence__label__mini'

      'parent_molecule.biotherapeutic.biocomponents.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___tax_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biocomponents___tax_id__label__mini'

      'parent_molecule.biotherapeutic.biocomponents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___biocomponents__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___biocomponents__label__mini'

      'parent_molecule.biotherapeutic.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___description__label__mini'

      'parent_molecule.biotherapeutic.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___helm_notation__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___helm_notation__label__mini'

      'parent_molecule.biotherapeutic.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__biotherapeutic___molecule_chembl_id__label__mini'

      'parent_molecule.biotherapeutic' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___biotherapeutic__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___biotherapeutic__label__mini'

      'parent_molecule.black_box_warning' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___black_box_warning__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___black_box_warning__label__mini'

      'parent_molecule.chebi_par_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___chebi_par_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___chebi_par_id__label__mini'

      'parent_molecule.chirality' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___chirality__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___chirality__label__mini'

      'parent_molecule.cross_references.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_id__label__mini'

      'parent_molecule.cross_references.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_name__label__mini'

      'parent_molecule.cross_references.xref_src' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_src__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_src__label__mini'

      'parent_molecule.cross_references.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_src_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_src_url__label__mini'

      'parent_molecule.cross_references.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_url__label__mini'

      'parent_molecule.cross_references' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___cross_references__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___cross_references__label__mini'

      'parent_molecule.dosed_ingredient' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___dosed_ingredient__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___dosed_ingredient__label__mini'

      'parent_molecule.first_approval' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___first_approval__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___first_approval__label__mini'

      'parent_molecule.first_in_class' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___first_in_class__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___first_in_class__label__mini'

      'parent_molecule.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___helm_notation__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___helm_notation__label__mini'

      'parent_molecule.indication_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___indication_class__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___indication_class__label__mini'

      'parent_molecule.inorganic_flag' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___inorganic_flag__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___inorganic_flag__label__mini'

      'parent_molecule.max_phase' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___max_phase__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___max_phase__label__mini'

      'parent_molecule.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_chembl_id__label__mini'

      'parent_molecule.molecule_hierarchy.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_hierarchy___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_hierarchy___molecule_chembl_id__label__mini'

      'parent_molecule.molecule_hierarchy.parent_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_hierarchy___parent_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_hierarchy___parent_chembl_id__label__mini'

      'parent_molecule.molecule_hierarchy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_hierarchy__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_hierarchy__label__mini'

      'parent_molecule.molecule_properties.alogp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___alogp__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___alogp__label__mini'

      'parent_molecule.molecule_properties.aromatic_rings' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___aromatic_rings__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___aromatic_rings__label__mini'

      'parent_molecule.molecule_properties.cx_logd' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_logd__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_logd__label__mini'

      'parent_molecule.molecule_properties.cx_logp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_logp__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_logp__label__mini'

      'parent_molecule.molecule_properties.cx_most_apka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_most_apka__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_most_apka__label__mini'

      'parent_molecule.molecule_properties.cx_most_bpka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_most_bpka__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___cx_most_bpka__label__mini'

      'parent_molecule.molecule_properties.full_molformula' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___full_molformula__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___full_molformula__label__mini'

      'parent_molecule.molecule_properties.full_mwt' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___full_mwt__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___full_mwt__label__mini'

      'parent_molecule.molecule_properties.hba' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hba__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hba__label__mini'

      'parent_molecule.molecule_properties.hba_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hba_lipinski__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hba_lipinski__label__mini'

      'parent_molecule.molecule_properties.hbd' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hbd__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hbd__label__mini'

      'parent_molecule.molecule_properties.hbd_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hbd_lipinski__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___hbd_lipinski__label__mini'

      'parent_molecule.molecule_properties.heavy_atoms' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___heavy_atoms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___heavy_atoms__label__mini'

      'parent_molecule.molecule_properties.molecular_species' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___molecular_species__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___molecular_species__label__mini'

      'parent_molecule.molecule_properties.mw_freebase' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___mw_freebase__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___mw_freebase__label__mini'

      'parent_molecule.molecule_properties.mw_monoisotopic' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___mw_monoisotopic__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___mw_monoisotopic__label__mini'

      'parent_molecule.molecule_properties.num_lipinski_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___num_lipinski_ro5_violations__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___num_lipinski_ro5_violations__label__mini'

      'parent_molecule.molecule_properties.num_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___num_ro5_violations__label__mini'

      'parent_molecule.molecule_properties.psa' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___psa__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___psa__label__mini'

      'parent_molecule.molecule_properties.qed_weighted' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___qed_weighted__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___qed_weighted__label__mini'

      'parent_molecule.molecule_properties.ro3_pass' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___ro3_pass__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___ro3_pass__label__mini'

      'parent_molecule.molecule_properties.rtb' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___rtb__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_properties___rtb__label__mini'

      'parent_molecule.molecule_properties' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_properties__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_properties__label__mini'

      'parent_molecule.molecule_structures.canonical_smiles' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___canonical_smiles__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___canonical_smiles__label__mini'

      'parent_molecule.molecule_structures.molfile' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___molfile__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___molfile__label__mini'

      'parent_molecule.molecule_structures.standard_inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___standard_inchi__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___standard_inchi__label__mini'

      'parent_molecule.molecule_structures.standard_inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___standard_inchi_key__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_structures___standard_inchi_key__label__mini'

      'parent_molecule.molecule_structures' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_structures__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_structures__label__mini'

      'parent_molecule.molecule_synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___molecule_synonym__label__mini'

      'parent_molecule.molecule_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___syn_type__label__mini'

      'parent_molecule.molecule_synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__molecule_synonyms___synonyms__label__mini'

      'parent_molecule.molecule_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_synonyms__label__mini'

      'parent_molecule.molecule_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___molecule_type__label__mini'

      'parent_molecule.natural_product' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___natural_product__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___natural_product__label__mini'

      'parent_molecule.oral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___oral__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___oral__label__mini'

      'parent_molecule.parenteral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___parenteral__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___parenteral__label__mini'

      'parent_molecule.polymer_flag' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___polymer_flag__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___polymer_flag__label__mini'

      'parent_molecule.pref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___pref_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___pref_name__label__mini'

      'parent_molecule.prodrug' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___prodrug__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___prodrug__label__mini'

      'parent_molecule.structure_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___structure_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___structure_type__label__mini'

      'parent_molecule.therapeutic_flag' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___therapeutic_flag__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___therapeutic_flag__label__mini'

      'parent_molecule.topical' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___topical__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___topical__label__mini'

      'parent_molecule.usan_stem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___usan_stem__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___usan_stem__label__mini'

      'parent_molecule.usan_stem_definition' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___usan_stem_definition__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___usan_stem_definition__label__mini'

      'parent_molecule.usan_substem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___usan_substem__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___usan_substem__label__mini'

      'parent_molecule.usan_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___usan_year__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___usan_year__label__mini'

      'parent_molecule.withdrawn_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_class__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_class__label__mini'

      'parent_molecule.withdrawn_country' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_country__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_country__label__mini'

      'parent_molecule.withdrawn_flag' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_flag__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_flag__label__mini'

      'parent_molecule.withdrawn_reason' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_reason__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_reason__label__mini'

      'parent_molecule.withdrawn_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_year__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule___withdrawn_year__label__mini'

      parent_molecule : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__parent_molecule__label__mini'

      'target._metadata.activity_count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__activity_count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__activity_count__label__mini'

      'target._metadata.disease_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__disease_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__disease_name__label__mini'

      'target._metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__es_completion__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__es_completion__label__mini'

      'target._metadata.organism_taxonomy.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___l1__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___l1__label__mini'

      'target._metadata.organism_taxonomy.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___l2__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___l2__label__mini'

      'target._metadata.organism_taxonomy.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___l3__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___l3__label__mini'

      'target._metadata.organism_taxonomy.oc_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___oc_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___oc_id__label__mini'

      'target._metadata.organism_taxonomy.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___tax_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy___tax_id__label__mini'

      'target._metadata.organism_taxonomy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__organism_taxonomy__label__mini'

      'target._metadata.protein_classification.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l1__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l1__label__mini'

      'target._metadata.protein_classification.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l2__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l2__label__mini'

      'target._metadata.protein_classification.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l3__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l3__label__mini'

      'target._metadata.protein_classification.l4' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l4__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l4__label__mini'

      'target._metadata.protein_classification.l5' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l5__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l5__label__mini'

      'target._metadata.protein_classification.l6' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l6__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___l6__label__mini'

      'target._metadata.protein_classification.protein_class_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___protein_class_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification___protein_class_id__label__mini'

      'target._metadata.protein_classification' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classification__label__mini'

      'target._metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_activities___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_activities___count__label__mini'

      'target._metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_activities__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_activities__label__mini'

      'target._metadata.related_assays.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_assays___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_assays___all_chembl_ids__label__mini'

      'target._metadata.related_assays.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_assays___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_assays___count__label__mini'

      'target._metadata.related_assays' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_assays__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_assays__label__mini'

      'target._metadata.related_cell_lines.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines___all_chembl_ids__label__mini'

      'target._metadata.related_cell_lines.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines___count__label__mini'

      'target._metadata.related_cell_lines' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_cell_lines__label__mini'

      'target._metadata.related_compounds.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_compounds___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_compounds___all_chembl_ids__label__mini'

      'target._metadata.related_compounds.chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_compounds___chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_compounds___chembl_ids__label__mini'

      'target._metadata.related_compounds.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_compounds___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_compounds___count__label__mini'

      'target._metadata.related_compounds' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_compounds__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_compounds__label__mini'

      'target._metadata.related_documents.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_documents___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_documents___all_chembl_ids__label__mini'

      'target._metadata.related_documents.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_documents___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_documents___count__label__mini'

      'target._metadata.related_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_documents__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_documents__label__mini'

      'target._metadata.related_tissues.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues___all_chembl_ids__label__mini'

      'target._metadata.related_tissues.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues___count__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues___count__label__mini'

      'target._metadata.related_tissues' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__related_tissues__label__mini'

      'target._metadata.tags' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__tags__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__tags__label__mini'

      'target._metadata.target_component.accession' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___accession__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___accession__label__mini'

      'target._metadata.target_component.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___component_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___component_id__label__mini'

      'target._metadata.target_component.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___component_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___component_type__label__mini'

      'target._metadata.target_component.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___description__label__mini'

      'target._metadata.target_component.go_slims.go_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__go_slims___go_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__go_slims___go_id__label__mini'

      'target._metadata.target_component.go_slims' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___go_slims__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___go_slims__label__mini'

      'target._metadata.target_component.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___organism__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___organism__label__mini'

      'target._metadata.target_component.protein_classifications.protein_classification_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__protein_classifications___protein_classification_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__protein_classifications___protein_classification_id__label__mini'

      'target._metadata.target_component.protein_classifications' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___protein_classifications__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___protein_classifications__label__mini'

      'target._metadata.target_component.sequence' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___sequence__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___sequence__label__mini'

      'target._metadata.target_component.target_component_synonyms.component_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_synonyms___component_synonym__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_synonyms___component_synonym__label__mini'

      'target._metadata.target_component.target_component_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_synonyms___syn_type__label__mini'

      'target._metadata.target_component.target_component_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___target_component_synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___target_component_synonyms__label__mini'

      'target._metadata.target_component.target_component_xrefs.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_id__label__mini'

      'target._metadata.target_component.target_component_xrefs.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_name__label__mini'

      'target._metadata.target_component.target_component_xrefs.xref_src_db' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_src_db__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_src_db__label__mini'

      'target._metadata.target_component.target_component_xrefs.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_src_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_src_url__label__mini'

      'target._metadata.target_component.target_component_xrefs.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_url__label__mini'

      'target._metadata.target_component.target_component_xrefs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___target_component_xrefs__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___target_component_xrefs__label__mini'

      'target._metadata.target_component.targets.target_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__targets___target_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__targets___target_chembl_id__label__mini'

      'target._metadata.target_component.targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___targets__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___targets__label__mini'

      'target._metadata.target_component.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component___tax_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component___tax_id__label__mini'

      'target._metadata.target_component' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component__label__mini'

      'target._metadata' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target____metadata__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target____metadata__label__mini'

      'target.cross_references.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_id__label__mini'

      'target.cross_references.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_name__label__mini'

      'target.cross_references.xref_src' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_src__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_src__label__mini'

      'target.cross_references.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_src_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_src_url__label__mini'

      'target.cross_references.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__cross_references___xref_url__label__mini'

      'target.cross_references' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target___cross_references__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target___cross_references__label__mini'

      'target.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target___organism__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target___organism__label__mini'

      'target.pref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target___pref_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target___pref_name__label__mini'

      'target.species_group_flag' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target___species_group_flag__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target___species_group_flag__label__mini'

      'target.target_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target___target_chembl_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target___target_chembl_id__label__mini'

      'target.target_components.accession' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_components___accession__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_components___accession__label__mini'

      'target.target_components.component_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_components___component_description__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_components___component_description__label__mini'

      'target.target_components.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_components___component_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_components___component_id__label__mini'

      'target.target_components.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_components___component_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_components___component_type__label__mini'

      'target.target_components.relationship' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_components___relationship__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_components___relationship__label__mini'

      'target.target_components.target_component_synonyms.component_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_synonyms___component_synonym__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_synonyms___component_synonym__label__mini'

      'target.target_components.target_component_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_synonyms___syn_type__label__mini'

      'target.target_components.target_component_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_components___target_component_synonyms__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_components___target_component_synonyms__label__mini'

      'target.target_components.target_component_xrefs.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_id__label__mini'

      'target.target_components.target_component_xrefs.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_name__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_name__label__mini'

      'target.target_components.target_component_xrefs.xref_src_db' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_src_db__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_src_db__label__mini'

      'target.target_components.target_component_xrefs.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_src_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_src_url__label__mini'

      'target.target_components.target_component_xrefs.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_url__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_component_xrefs___xref_url__label__mini'

      'target.target_components.target_component_xrefs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target_components___target_component_xrefs__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target_components___target_component_xrefs__label__mini'

      'target.target_components' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target___target_components__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target___target_components__label__mini'

      'target.target_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target___target_type__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target___target_type__label__mini'

      'target.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__mechanism_by_parent_target__target___tax_id__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target___tax_id__label__mini'

      target : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__mechanism_by_parent_target__target__label'
        label_mini_id : 'glados_es_gs__mechanism_by_parent_target__target__label__mini'

    chembl_26_molecule:
      '_metadata.activity_count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__activity_count__label'
        label_mini_id : 'glados_es_gs__molecule__activity_count__label__mini'

      '_metadata.atc_classifications.level1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level1__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level1__label__mini'

      '_metadata.atc_classifications.level1_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level1_description__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level1_description__label__mini'

      '_metadata.atc_classifications.level2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level2__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level2__label__mini'

      '_metadata.atc_classifications.level2_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level2_description__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level2_description__label__mini'

      '_metadata.atc_classifications.level3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level3__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level3__label__mini'

      '_metadata.atc_classifications.level3_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level3_description__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level3_description__label__mini'

      '_metadata.atc_classifications.level4' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level4__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level4__label__mini'

      '_metadata.atc_classifications.level4_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level4_description__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level4_description__label__mini'

      '_metadata.atc_classifications.level5' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___level5__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___level5__label__mini'

      '_metadata.atc_classifications.who_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications___who_name__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications___who_name__label__mini'

      '_metadata.atc_classifications' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__atc_classifications__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications__label__mini'

      '_metadata.compound_generated.availability_type_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__compound_generated___availability_type_label__label'
        label_mini_id : 'glados_es_gs__molecule__compound_generated___availability_type_label__label__mini'

      '_metadata.compound_generated.chirality_label' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__compound_generated___chirality_label__label'
        label_mini_id : 'glados_es_gs__molecule__compound_generated___chirality_label__label__mini'

      '_metadata.compound_generated.image_file' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__compound_generated___image_file__label'
        label_mini_id : 'glados_es_gs__molecule__compound_generated___image_file__label__mini'

      '_metadata.compound_generated' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__compound_generated__label'
        label_mini_id : 'glados_es_gs__molecule__compound_generated__label__mini'

      '_metadata.compound_records.compound_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__compound_records___compound_key__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records___compound_key__label__mini'

      '_metadata.compound_records.compound_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__compound_records___compound_name__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records___compound_name__label__mini'

      '_metadata.compound_records.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__compound_records___src_description__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records___src_description__label__mini'

      '_metadata.compound_records.src_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__compound_records___src_id__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records___src_id__label__mini'

      '_metadata.compound_records.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__compound_records___src_short_name__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records___src_short_name__label__mini'

      '_metadata.compound_records' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__compound_records__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records__label__mini'

      '_metadata.disease_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__disease_name__label'
        label_mini_id : 'glados_es_gs__molecule__disease_name__label__mini'

      '_metadata.drug.drug_data.applicants' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__applicants__label'
        label_mini_id : 'glados_es_gs__molecule__applicants__label__mini'

      '_metadata.drug.drug_data.atc_classification.code' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classification___code__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classification___code__label__mini'

      '_metadata.drug.drug_data.atc_classification.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classification___description__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classification___description__label__mini'

      '_metadata.drug.drug_data.atc_classification' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__atc_classification__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classification__label__mini'

      '_metadata.drug.drug_data.availability_type' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__availability_type__label'
        label_mini_id : 'glados_es_gs__molecule__availability_type__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.biocomponents.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___component_id__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___component_id__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.biocomponents.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___component_type__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___component_type__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.biocomponents.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___description__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___description__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.biocomponents.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___organism__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___organism__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.biocomponents.sequence' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___sequence__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___sequence__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.biocomponents.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___tax_id__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___tax_id__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.biocomponents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__biotherapeutic___biocomponents__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic___biocomponents__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biotherapeutic___description__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic___description__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biotherapeutic___helm_notation__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic___helm_notation__label__mini'

      '_metadata.drug.drug_data.biotherapeutic.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biotherapeutic___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic___molecule_chembl_id__label__mini'

      '_metadata.drug.drug_data.biotherapeutic' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__biotherapeutic__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic__label__mini'

      '_metadata.drug.drug_data.black_box' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__black_box__label'
        label_mini_id : 'glados_es_gs__molecule__black_box__label__mini'

      '_metadata.drug.drug_data.chirality' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__chirality__label'
        label_mini_id : 'glados_es_gs__molecule__chirality__label__mini'

      '_metadata.drug.drug_data.development_phase' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__development_phase__label'
        label_mini_id : 'glados_es_gs__molecule__development_phase__label__mini'

      '_metadata.drug.drug_data.drug_type' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_type__label'
        label_mini_id : 'glados_es_gs__molecule__drug_type__label__mini'

      '_metadata.drug.drug_data.first_approval' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__first_approval__label'
        label_mini_id : 'glados_es_gs__molecule__first_approval__label__mini'

      '_metadata.drug.drug_data.first_in_class' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__first_in_class__label'
        label_mini_id : 'glados_es_gs__molecule__first_in_class__label__mini'

      '_metadata.drug.drug_data.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__helm_notation__label'
        label_mini_id : 'glados_es_gs__molecule__helm_notation__label__mini'

      '_metadata.drug.drug_data.indication_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__indication_class__label'
        label_mini_id : 'glados_es_gs__molecule__indication_class__label__mini'

      '_metadata.drug.drug_data.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_chembl_id__label__mini'

      '_metadata.drug.drug_data.molecule_properties.alogp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___alogp__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___alogp__label__mini'

      '_metadata.drug.drug_data.molecule_properties.aromatic_rings' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___aromatic_rings__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___aromatic_rings__label__mini'

      '_metadata.drug.drug_data.molecule_properties.cx_logd' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___cx_logd__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___cx_logd__label__mini'

      '_metadata.drug.drug_data.molecule_properties.cx_logp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___cx_logp__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___cx_logp__label__mini'

      '_metadata.drug.drug_data.molecule_properties.cx_most_apka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___cx_most_apka__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___cx_most_apka__label__mini'

      '_metadata.drug.drug_data.molecule_properties.cx_most_bpka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___cx_most_bpka__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___cx_most_bpka__label__mini'

      '_metadata.drug.drug_data.molecule_properties.full_molformula' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___full_molformula__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___full_molformula__label__mini'

      '_metadata.drug.drug_data.molecule_properties.full_mwt' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___full_mwt__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___full_mwt__label__mini'

      '_metadata.drug.drug_data.molecule_properties.hba' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hba__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hba__label__mini'

      '_metadata.drug.drug_data.molecule_properties.hba_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hba_lipinski__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hba_lipinski__label__mini'

      '_metadata.drug.drug_data.molecule_properties.hbd' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hbd__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hbd__label__mini'

      '_metadata.drug.drug_data.molecule_properties.hbd_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hbd_lipinski__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hbd_lipinski__label__mini'

      '_metadata.drug.drug_data.molecule_properties.heavy_atoms' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___heavy_atoms__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___heavy_atoms__label__mini'

      '_metadata.drug.drug_data.molecule_properties.molecular_species' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___molecular_species__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___molecular_species__label__mini'

      '_metadata.drug.drug_data.molecule_properties.mw_freebase' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___mw_freebase__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___mw_freebase__label__mini'

      '_metadata.drug.drug_data.molecule_properties.mw_monoisotopic' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___mw_monoisotopic__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___mw_monoisotopic__label__mini'

      '_metadata.drug.drug_data.molecule_properties.num_lipinski_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_lipinski_ro5_violations__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_lipinski_ro5_violations__label__mini'

      '_metadata.drug.drug_data.molecule_properties.num_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_ro5_violations__label__mini'

      '_metadata.drug.drug_data.molecule_properties.psa' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___psa__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___psa__label__mini'

      '_metadata.drug.drug_data.molecule_properties.qed_weighted' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___qed_weighted__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___qed_weighted__label__mini'

      '_metadata.drug.drug_data.molecule_properties.ro3_pass' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___ro3_pass__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___ro3_pass__label__mini'

      '_metadata.drug.drug_data.molecule_properties.rtb' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___rtb__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___rtb__label__mini'

      '_metadata.drug.drug_data.molecule_properties' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_properties__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties__label__mini'

      '_metadata.drug.drug_data.molecule_structures.canonical_smiles' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_structures___canonical_smiles__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___canonical_smiles__label__mini'

      '_metadata.drug.drug_data.molecule_structures.molfile' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures___molfile__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___molfile__label__mini'

      '_metadata.drug.drug_data.molecule_structures.standard_inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi__label__mini'

      '_metadata.drug.drug_data.molecule_structures.standard_inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi_key__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi_key__label__mini'

      '_metadata.drug.drug_data.molecule_structures' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures__label__mini'

      '_metadata.drug.drug_data.molecule_synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___molecule_synonym__label__mini'

      '_metadata.drug.drug_data.molecule_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___syn_type__label__mini'

      '_metadata.drug.drug_data.molecule_synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___synonyms__label__mini'

      '_metadata.drug.drug_data.molecule_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms__label__mini'

      '_metadata.drug.drug_data.ob_patent' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__ob_patent__label'
        label_mini_id : 'glados_es_gs__molecule__ob_patent__label__mini'

      '_metadata.drug.drug_data.oral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__oral__label'
        label_mini_id : 'glados_es_gs__molecule__oral__label__mini'

      '_metadata.drug.drug_data.parenteral' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__parenteral__label'
        label_mini_id : 'glados_es_gs__molecule__parenteral__label__mini'

      '_metadata.drug.drug_data.prodrug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__prodrug__label'
        label_mini_id : 'glados_es_gs__molecule__prodrug__label__mini'

      '_metadata.drug.drug_data.research_codes' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__research_codes__label'
        label_mini_id : 'glados_es_gs__molecule__research_codes__label__mini'

      '_metadata.drug.drug_data.rule_of_five' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__rule_of_five__label'
        label_mini_id : 'glados_es_gs__molecule__rule_of_five__label__mini'

      '_metadata.drug.drug_data.sc_patent' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__sc_patent__label'
        label_mini_id : 'glados_es_gs__molecule__sc_patent__label__mini'

      '_metadata.drug.drug_data.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__synonyms__label__mini'

      '_metadata.drug.drug_data.topical' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__topical__label'
        label_mini_id : 'glados_es_gs__molecule__topical__label__mini'

      '_metadata.drug.drug_data.usan_stem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_stem__label'
        label_mini_id : 'glados_es_gs__molecule__usan_stem__label__mini'

      '_metadata.drug.drug_data.usan_stem_definition' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_stem_definition__label'
        label_mini_id : 'glados_es_gs__molecule__usan_stem_definition__label__mini'

      '_metadata.drug.drug_data.usan_stem_substem' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_stem_substem__label'
        label_mini_id : 'glados_es_gs__molecule__usan_stem_substem__label__mini'

      '_metadata.drug.drug_data.usan_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_year__label'
        label_mini_id : 'glados_es_gs__molecule__usan_year__label__mini'

      '_metadata.drug.drug_data.withdrawn_class' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_class__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_class__label__mini'

      '_metadata.drug.drug_data.withdrawn_country' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_country__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_country__label__mini'

      '_metadata.drug.drug_data.withdrawn_reason' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_reason__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_reason__label__mini'

      '_metadata.drug.drug_data.withdrawn_year' : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_year__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_year__label__mini'

      '_metadata.drug.drug_data' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__drug___drug_data__label'
        label_mini_id : 'glados_es_gs__molecule__drug___drug_data__label__mini'

      '_metadata.drug.is_drug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug___is_drug__label'
        label_mini_id : 'glados_es_gs__molecule__drug___is_drug__label__mini'

      '_metadata.drug' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__drug__label'
        label_mini_id : 'glados_es_gs__molecule__drug__label__mini'

      '_metadata.drug_indications._metadata.all_molecule_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__all_molecule_chembl_ids__label'
        label_mini_id : 'glados_es_gs__molecule__all_molecule_chembl_ids__label__mini'

      '_metadata.drug_indications._metadata' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__drug_indications____metadata__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications____metadata__label__mini'

      '_metadata.drug_indications.drugind_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_indications___drugind_id__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___drugind_id__label__mini'

      '_metadata.drug_indications.efo_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_indications___efo_id__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___efo_id__label__mini'

      '_metadata.drug_indications.efo_term' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_indications___efo_term__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___efo_term__label__mini'

      '_metadata.drug_indications.indication_refs.ref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__indication_refs___ref_id__label'
        label_mini_id : 'glados_es_gs__molecule__indication_refs___ref_id__label__mini'

      '_metadata.drug_indications.indication_refs.ref_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__indication_refs___ref_type__label'
        label_mini_id : 'glados_es_gs__molecule__indication_refs___ref_type__label__mini'

      '_metadata.drug_indications.indication_refs.ref_url' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__indication_refs___ref_url__label'
        label_mini_id : 'glados_es_gs__molecule__indication_refs___ref_url__label__mini'

      '_metadata.drug_indications.indication_refs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__drug_indications___indication_refs__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___indication_refs__label__mini'

      '_metadata.drug_indications.max_phase_for_ind' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_indications___max_phase_for_ind__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___max_phase_for_ind__label__mini'

      '_metadata.drug_indications.mesh_heading' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_indications___mesh_heading__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___mesh_heading__label__mini'

      '_metadata.drug_indications.mesh_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_indications___mesh_id__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___mesh_id__label__mini'

      '_metadata.drug_indications.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_indications___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___molecule_chembl_id__label__mini'

      '_metadata.drug_indications.parent_molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_indications___parent_molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications___parent_molecule_chembl_id__label__mini'

      '_metadata.drug_indications' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__drug_indications__label'
        label_mini_id : 'glados_es_gs__molecule__drug_indications__label__mini'

      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__es_completion__label'
        label_mini_id : 'glados_es_gs__molecule__es_completion__label__mini'

      '_metadata.hierarchy.all_family.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__all_family___chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__all_family___chembl_id__label__mini'

      '_metadata.hierarchy.all_family.inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__all_family___inchi__label'
        label_mini_id : 'glados_es_gs__molecule__all_family___inchi__label__mini'

      '_metadata.hierarchy.all_family.inchi_connectivity_layer' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__all_family___inchi_connectivity_layer__label'
        label_mini_id : 'glados_es_gs__molecule__all_family___inchi_connectivity_layer__label__mini'

      '_metadata.hierarchy.all_family.inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__all_family___inchi_key__label'
        label_mini_id : 'glados_es_gs__molecule__all_family___inchi_key__label__mini'

      '_metadata.hierarchy.all_family' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__hierarchy___all_family__label'
        label_mini_id : 'glados_es_gs__molecule__hierarchy___all_family__label__mini'

      '_metadata.hierarchy.children.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__children___chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__children___chembl_id__label__mini'

      '_metadata.hierarchy.children.sources.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__sources___src_description__label'
        label_mini_id : 'glados_es_gs__molecule__sources___src_description__label__mini'

      '_metadata.hierarchy.children.sources.src_id' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__sources___src_id__label'
        label_mini_id : 'glados_es_gs__molecule__sources___src_id__label__mini'

      '_metadata.hierarchy.children.sources.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__sources___src_short_name__label'
        label_mini_id : 'glados_es_gs__molecule__sources___src_short_name__label__mini'

      '_metadata.hierarchy.children.sources' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__children___sources__label'
        label_mini_id : 'glados_es_gs__molecule__children___sources__label__mini'

      '_metadata.hierarchy.children.synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__molecule__synonyms___molecule_synonym__label__mini'

      '_metadata.hierarchy.children.synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__molecule__synonyms___syn_type__label__mini'

      '_metadata.hierarchy.children.synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__synonyms___synonyms__label__mini'

      '_metadata.hierarchy.children.synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__children___synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__children___synonyms__label__mini'

      '_metadata.hierarchy.children' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__hierarchy___children__label'
        label_mini_id : 'glados_es_gs__molecule__hierarchy___children__label__mini'

      '_metadata.hierarchy.family_inchi_connectivity_layer' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__hierarchy___family_inchi_connectivity_layer__label'
        label_mini_id : 'glados_es_gs__molecule__hierarchy___family_inchi_connectivity_layer__label__mini'

      '_metadata.hierarchy.is_approved_drug' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__hierarchy___is_approved_drug__label'
        label_mini_id : 'glados_es_gs__molecule__hierarchy___is_approved_drug__label__mini'

      '_metadata.hierarchy.is_usan' : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__hierarchy___is_usan__label'
        label_mini_id : 'glados_es_gs__molecule__hierarchy___is_usan__label__mini'

      '_metadata.hierarchy.parent.chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__parent___chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__parent___chembl_id__label__mini'

      '_metadata.hierarchy.parent.sources.src_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__sources___src_description__label'
        label_mini_id : 'glados_es_gs__molecule__sources___src_description__label__mini'

      '_metadata.hierarchy.parent.sources.src_id' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__sources___src_id__label'
        label_mini_id : 'glados_es_gs__molecule__sources___src_id__label__mini'

      '_metadata.hierarchy.parent.sources.src_short_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__sources___src_short_name__label'
        label_mini_id : 'glados_es_gs__molecule__sources___src_short_name__label__mini'

      '_metadata.hierarchy.parent.sources' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__parent___sources__label'
        label_mini_id : 'glados_es_gs__molecule__parent___sources__label__mini'

      '_metadata.hierarchy.parent.synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__molecule__synonyms___molecule_synonym__label__mini'

      '_metadata.hierarchy.parent.synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__molecule__synonyms___syn_type__label__mini'

      '_metadata.hierarchy.parent.synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__synonyms___synonyms__label__mini'

      '_metadata.hierarchy.parent.synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__parent___synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__parent___synonyms__label__mini'

      '_metadata.hierarchy.parent' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__hierarchy___parent__label'
        label_mini_id : 'glados_es_gs__molecule__hierarchy___parent__label__mini'

      '_metadata.hierarchy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__hierarchy__label'
        label_mini_id : 'glados_es_gs__molecule__hierarchy__label__mini'

      '_metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__related_activities___count__label'
        label_mini_id : 'glados_es_gs__molecule__related_activities___count__label__mini'

      '_metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_activities__label'
        label_mini_id : 'glados_es_gs__molecule__related_activities__label__mini'

      '_metadata.related_assays.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_assays___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__molecule__related_assays___all_chembl_ids__label__mini'

      '_metadata.related_assays.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__related_assays___count__label'
        label_mini_id : 'glados_es_gs__molecule__related_assays___count__label__mini'

      '_metadata.related_assays' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_assays__label'
        label_mini_id : 'glados_es_gs__molecule__related_assays__label__mini'

      '_metadata.related_cell_lines.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_cell_lines___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__molecule__related_cell_lines___all_chembl_ids__label__mini'

      '_metadata.related_cell_lines.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__related_cell_lines___count__label'
        label_mini_id : 'glados_es_gs__molecule__related_cell_lines___count__label__mini'

      '_metadata.related_cell_lines' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_cell_lines__label'
        label_mini_id : 'glados_es_gs__molecule__related_cell_lines__label__mini'

      '_metadata.related_documents.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_documents___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__molecule__related_documents___all_chembl_ids__label__mini'

      '_metadata.related_documents.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__related_documents___count__label'
        label_mini_id : 'glados_es_gs__molecule__related_documents___count__label__mini'

      '_metadata.related_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_documents__label'
        label_mini_id : 'glados_es_gs__molecule__related_documents__label__mini'

      '_metadata.related_targets.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_targets___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__molecule__related_targets___all_chembl_ids__label__mini'

      '_metadata.related_targets.chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_targets___chembl_ids__label'
        label_mini_id : 'glados_es_gs__molecule__related_targets___chembl_ids__label__mini'

      '_metadata.related_targets.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__related_targets___count__label'
        label_mini_id : 'glados_es_gs__molecule__related_targets___count__label__mini'

      '_metadata.related_targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_targets__label'
        label_mini_id : 'glados_es_gs__molecule__related_targets__label__mini'

      '_metadata.related_tissues.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_tissues___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__molecule__related_tissues___all_chembl_ids__label__mini'

      '_metadata.related_tissues.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__related_tissues___count__label'
        label_mini_id : 'glados_es_gs__molecule__related_tissues___count__label__mini'

      '_metadata.related_tissues' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_tissues__label'
        label_mini_id : 'glados_es_gs__molecule__related_tissues__label__mini'

      '_metadata.tags' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__tags__label'
        label_mini_id : 'glados_es_gs__molecule__tags__label__mini'

      '_metadata.unichem.id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__unichem___id__label'
        label_mini_id : 'glados_es_gs__molecule__unichem___id__label__mini'

      '_metadata.unichem.link' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__unichem___link__label'
        label_mini_id : 'glados_es_gs__molecule__unichem___link__label__mini'

      '_metadata.unichem.src_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__unichem___src_name__label'
        label_mini_id : 'glados_es_gs__molecule__unichem___src_name__label__mini'

      '_metadata.unichem.src_url' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__unichem___src_url__label'
        label_mini_id : 'glados_es_gs__molecule__unichem___src_url__label__mini'

      '_metadata.unichem' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__unichem__label'
        label_mini_id : 'glados_es_gs__molecule__unichem__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule___metadata__label'
        label_mini_id : 'glados_es_gs__molecule___metadata__label__mini'

      atc_classifications : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classifications__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classifications__label__mini'

      availability_type : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__availability_type__label'
        label_mini_id : 'glados_es_gs__molecule__availability_type__label__mini'

      'biotherapeutic.biocomponents.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___component_id__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___component_id__label__mini'

      'biotherapeutic.biocomponents.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___component_type__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___component_type__label__mini'

      'biotherapeutic.biocomponents.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___description__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___description__label__mini'

      'biotherapeutic.biocomponents.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___organism__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___organism__label__mini'

      'biotherapeutic.biocomponents.sequence' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___sequence__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___sequence__label__mini'

      'biotherapeutic.biocomponents.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biocomponents___tax_id__label'
        label_mini_id : 'glados_es_gs__molecule__biocomponents___tax_id__label__mini'

      'biotherapeutic.biocomponents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__biotherapeutic___biocomponents__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic___biocomponents__label__mini'

      'biotherapeutic.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biotherapeutic___description__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic___description__label__mini'

      'biotherapeutic.helm_notation' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biotherapeutic___helm_notation__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic___helm_notation__label__mini'

      'biotherapeutic.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__biotherapeutic___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic___molecule_chembl_id__label__mini'

      biotherapeutic : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__biotherapeutic__label'
        label_mini_id : 'glados_es_gs__molecule__biotherapeutic__label__mini'

      black_box_warning : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__black_box_warning__label'
        label_mini_id : 'glados_es_gs__molecule__black_box_warning__label__mini'

      chebi_par_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__chebi_par_id__label'
        label_mini_id : 'glados_es_gs__molecule__chebi_par_id__label__mini'

      chirality : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__chirality__label'
        label_mini_id : 'glados_es_gs__molecule__chirality__label__mini'

      'cross_references.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__cross_references___xref_id__label'
        label_mini_id : 'glados_es_gs__molecule__cross_references___xref_id__label__mini'

      'cross_references.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__cross_references___xref_name__label'
        label_mini_id : 'glados_es_gs__molecule__cross_references___xref_name__label__mini'

      'cross_references.xref_src' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__cross_references___xref_src__label'
        label_mini_id : 'glados_es_gs__molecule__cross_references___xref_src__label__mini'

      'cross_references.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__cross_references___xref_src_url__label'
        label_mini_id : 'glados_es_gs__molecule__cross_references___xref_src_url__label__mini'

      'cross_references.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__cross_references___xref_url__label'
        label_mini_id : 'glados_es_gs__molecule__cross_references___xref_url__label__mini'

      cross_references : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__cross_references__label'
        label_mini_id : 'glados_es_gs__molecule__cross_references__label__mini'

      dosed_ingredient : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__dosed_ingredient__label'
        label_mini_id : 'glados_es_gs__molecule__dosed_ingredient__label__mini'

      first_approval : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__first_approval__label'
        label_mini_id : 'glados_es_gs__molecule__first_approval__label__mini'

      first_in_class : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__first_in_class__label'
        label_mini_id : 'glados_es_gs__molecule__first_in_class__label__mini'

      helm_notation : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__helm_notation__label'
        label_mini_id : 'glados_es_gs__molecule__helm_notation__label__mini'

      indication_class : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__indication_class__label'
        label_mini_id : 'glados_es_gs__molecule__indication_class__label__mini'

      inorganic_flag : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__inorganic_flag__label'
        label_mini_id : 'glados_es_gs__molecule__inorganic_flag__label__mini'

      max_phase : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__max_phase__label'
        label_mini_id : 'glados_es_gs__molecule__max_phase__label__mini'

      molecule_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_chembl_id__label__mini'

      'molecule_hierarchy.molecule_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_hierarchy___molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_hierarchy___molecule_chembl_id__label__mini'

      'molecule_hierarchy.parent_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_hierarchy___parent_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_hierarchy___parent_chembl_id__label__mini'

      molecule_hierarchy : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_hierarchy__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_hierarchy__label__mini'

      'molecule_properties.alogp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___alogp__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___alogp__label__mini'

      'molecule_properties.aromatic_rings' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___aromatic_rings__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___aromatic_rings__label__mini'

      'molecule_properties.cx_logd' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___cx_logd__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___cx_logd__label__mini'

      'molecule_properties.cx_logp' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___cx_logp__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___cx_logp__label__mini'

      'molecule_properties.cx_most_apka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___cx_most_apka__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___cx_most_apka__label__mini'

      'molecule_properties.cx_most_bpka' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___cx_most_bpka__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___cx_most_bpka__label__mini'

      'molecule_properties.full_molformula' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___full_molformula__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___full_molformula__label__mini'

      'molecule_properties.full_mwt' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___full_mwt__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___full_mwt__label__mini'

      'molecule_properties.hba' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hba__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hba__label__mini'

      'molecule_properties.hba_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hba_lipinski__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hba_lipinski__label__mini'

      'molecule_properties.hbd' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hbd__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hbd__label__mini'

      'molecule_properties.hbd_lipinski' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hbd_lipinski__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hbd_lipinski__label__mini'

      'molecule_properties.heavy_atoms' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___heavy_atoms__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___heavy_atoms__label__mini'

      'molecule_properties.molecular_species' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___molecular_species__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___molecular_species__label__mini'

      'molecule_properties.mw_freebase' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___mw_freebase__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___mw_freebase__label__mini'

      'molecule_properties.mw_monoisotopic' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___mw_monoisotopic__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___mw_monoisotopic__label__mini'

      'molecule_properties.num_lipinski_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_lipinski_ro5_violations__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_lipinski_ro5_violations__label__mini'

      'molecule_properties.num_ro5_violations' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_ro5_violations__label__mini'

      'molecule_properties.psa' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___psa__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___psa__label__mini'

      'molecule_properties.qed_weighted' : 
        type : Number
        integer : false
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___qed_weighted__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___qed_weighted__label__mini'

      'molecule_properties.ro3_pass' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___ro3_pass__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___ro3_pass__label__mini'

      'molecule_properties.rtb' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___rtb__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___rtb__label__mini'

      molecule_properties : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_properties__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties__label__mini'

      'molecule_structures.canonical_smiles' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_structures___canonical_smiles__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___canonical_smiles__label__mini'

      'molecule_structures.molfile' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures___molfile__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___molfile__label__mini'

      'molecule_structures.standard_inchi' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi__label__mini'

      'molecule_structures.standard_inchi_key' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi_key__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi_key__label__mini'

      molecule_structures : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures__label__mini'

      'molecule_synonyms.molecule_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___molecule_synonym__label__mini'

      'molecule_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___syn_type__label__mini'

      'molecule_synonyms.synonyms' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_synonyms___synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___synonyms__label__mini'

      molecule_synonyms : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_synonyms__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms__label__mini'

      molecule_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_type__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_type__label__mini'

      natural_product : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__natural_product__label'
        label_mini_id : 'glados_es_gs__molecule__natural_product__label__mini'

      oral : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__oral__label'
        label_mini_id : 'glados_es_gs__molecule__oral__label__mini'

      parenteral : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__parenteral__label'
        label_mini_id : 'glados_es_gs__molecule__parenteral__label__mini'

      polymer_flag : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__polymer_flag__label'
        label_mini_id : 'glados_es_gs__molecule__polymer_flag__label__mini'

      pref_name : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__pref_name__label'
        label_mini_id : 'glados_es_gs__molecule__pref_name__label__mini'

      prodrug : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__prodrug__label'
        label_mini_id : 'glados_es_gs__molecule__prodrug__label__mini'

      structure_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__structure_type__label'
        label_mini_id : 'glados_es_gs__molecule__structure_type__label__mini'

      therapeutic_flag : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__therapeutic_flag__label'
        label_mini_id : 'glados_es_gs__molecule__therapeutic_flag__label__mini'

      topical : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__topical__label'
        label_mini_id : 'glados_es_gs__molecule__topical__label__mini'

      usan_stem : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_stem__label'
        label_mini_id : 'glados_es_gs__molecule__usan_stem__label__mini'

      usan_stem_definition : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_stem_definition__label'
        label_mini_id : 'glados_es_gs__molecule__usan_stem_definition__label__mini'

      usan_substem : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_substem__label'
        label_mini_id : 'glados_es_gs__molecule__usan_substem__label__mini'

      usan_year : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_year__label'
        label_mini_id : 'glados_es_gs__molecule__usan_year__label__mini'

      withdrawn_class : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_class__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_class__label__mini'

      withdrawn_country : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_country__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_country__label__mini'

      withdrawn_flag : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_flag__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_flag__label__mini'

      withdrawn_reason : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_reason__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_reason__label__mini'

      withdrawn_year : 
        type : Number
        integer : true
        year : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_year__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_year__label__mini'

    chembl_26_target:
      '_metadata.activity_count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__target__activity_count__label'
        label_mini_id : 'glados_es_gs__target__activity_count__label__mini'

      '_metadata.disease_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__disease_name__label'
        label_mini_id : 'glados_es_gs__target__disease_name__label__mini'

      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__es_completion__label'
        label_mini_id : 'glados_es_gs__target__es_completion__label__mini'

      '_metadata.organism_taxonomy.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__organism_taxonomy___l1__label'
        label_mini_id : 'glados_es_gs__target__organism_taxonomy___l1__label__mini'

      '_metadata.organism_taxonomy.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__organism_taxonomy___l2__label'
        label_mini_id : 'glados_es_gs__target__organism_taxonomy___l2__label__mini'

      '_metadata.organism_taxonomy.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__organism_taxonomy___l3__label'
        label_mini_id : 'glados_es_gs__target__organism_taxonomy___l3__label__mini'

      '_metadata.organism_taxonomy.oc_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__organism_taxonomy___oc_id__label'
        label_mini_id : 'glados_es_gs__target__organism_taxonomy___oc_id__label__mini'

      '_metadata.organism_taxonomy.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__organism_taxonomy___tax_id__label'
        label_mini_id : 'glados_es_gs__target__organism_taxonomy___tax_id__label__mini'

      '_metadata.organism_taxonomy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__organism_taxonomy__label'
        label_mini_id : 'glados_es_gs__target__organism_taxonomy__label__mini'

      '_metadata.protein_classification.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__protein_classification___l1__label'
        label_mini_id : 'glados_es_gs__target__protein_classification___l1__label__mini'

      '_metadata.protein_classification.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__protein_classification___l2__label'
        label_mini_id : 'glados_es_gs__target__protein_classification___l2__label__mini'

      '_metadata.protein_classification.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__protein_classification___l3__label'
        label_mini_id : 'glados_es_gs__target__protein_classification___l3__label__mini'

      '_metadata.protein_classification.l4' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__protein_classification___l4__label'
        label_mini_id : 'glados_es_gs__target__protein_classification___l4__label__mini'

      '_metadata.protein_classification.l5' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__protein_classification___l5__label'
        label_mini_id : 'glados_es_gs__target__protein_classification___l5__label__mini'

      '_metadata.protein_classification.l6' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__protein_classification___l6__label'
        label_mini_id : 'glados_es_gs__target__protein_classification___l6__label__mini'

      '_metadata.protein_classification.protein_class_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__protein_classification___protein_class_id__label'
        label_mini_id : 'glados_es_gs__target__protein_classification___protein_class_id__label__mini'

      '_metadata.protein_classification' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__protein_classification__label'
        label_mini_id : 'glados_es_gs__target__protein_classification__label__mini'

      '_metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__target__related_activities___count__label'
        label_mini_id : 'glados_es_gs__target__related_activities___count__label__mini'

      '_metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__related_activities__label'
        label_mini_id : 'glados_es_gs__target__related_activities__label__mini'

      '_metadata.related_assays.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__related_assays___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__target__related_assays___all_chembl_ids__label__mini'

      '_metadata.related_assays.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__target__related_assays___count__label'
        label_mini_id : 'glados_es_gs__target__related_assays___count__label__mini'

      '_metadata.related_assays' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__related_assays__label'
        label_mini_id : 'glados_es_gs__target__related_assays__label__mini'

      '_metadata.related_cell_lines.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__related_cell_lines___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__target__related_cell_lines___all_chembl_ids__label__mini'

      '_metadata.related_cell_lines.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__target__related_cell_lines___count__label'
        label_mini_id : 'glados_es_gs__target__related_cell_lines___count__label__mini'

      '_metadata.related_cell_lines' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__related_cell_lines__label'
        label_mini_id : 'glados_es_gs__target__related_cell_lines__label__mini'

      '_metadata.related_compounds.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__related_compounds___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__target__related_compounds___all_chembl_ids__label__mini'

      '_metadata.related_compounds.chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__related_compounds___chembl_ids__label'
        label_mini_id : 'glados_es_gs__target__related_compounds___chembl_ids__label__mini'

      '_metadata.related_compounds.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__target__related_compounds___count__label'
        label_mini_id : 'glados_es_gs__target__related_compounds___count__label__mini'

      '_metadata.related_compounds' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__related_compounds__label'
        label_mini_id : 'glados_es_gs__target__related_compounds__label__mini'

      '_metadata.related_documents.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__related_documents___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__target__related_documents___all_chembl_ids__label__mini'

      '_metadata.related_documents.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__target__related_documents___count__label'
        label_mini_id : 'glados_es_gs__target__related_documents___count__label__mini'

      '_metadata.related_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__related_documents__label'
        label_mini_id : 'glados_es_gs__target__related_documents__label__mini'

      '_metadata.related_tissues.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__related_tissues___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__target__related_tissues___all_chembl_ids__label__mini'

      '_metadata.related_tissues.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__target__related_tissues___count__label'
        label_mini_id : 'glados_es_gs__target__related_tissues___count__label__mini'

      '_metadata.related_tissues' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__related_tissues__label'
        label_mini_id : 'glados_es_gs__target__related_tissues__label__mini'

      '_metadata.tags' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__tags__label'
        label_mini_id : 'glados_es_gs__target__tags__label__mini'

      '_metadata.target_component.accession' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component___accession__label'
        label_mini_id : 'glados_es_gs__target__target_component___accession__label__mini'

      '_metadata.target_component.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component___component_id__label'
        label_mini_id : 'glados_es_gs__target__target_component___component_id__label__mini'

      '_metadata.target_component.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component___component_type__label'
        label_mini_id : 'glados_es_gs__target__target_component___component_type__label__mini'

      '_metadata.target_component.description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component___description__label'
        label_mini_id : 'glados_es_gs__target__target_component___description__label__mini'

      '_metadata.target_component.go_slims.go_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__go_slims___go_id__label'
        label_mini_id : 'glados_es_gs__target__go_slims___go_id__label__mini'

      '_metadata.target_component.go_slims' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component___go_slims__label'
        label_mini_id : 'glados_es_gs__target__target_component___go_slims__label__mini'

      '_metadata.target_component.organism' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component___organism__label'
        label_mini_id : 'glados_es_gs__target__target_component___organism__label__mini'

      '_metadata.target_component.protein_classifications.protein_classification_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__protein_classifications___protein_classification_id__label'
        label_mini_id : 'glados_es_gs__target__protein_classifications___protein_classification_id__label__mini'

      '_metadata.target_component.protein_classifications' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component___protein_classifications__label'
        label_mini_id : 'glados_es_gs__target__target_component___protein_classifications__label__mini'

      '_metadata.target_component.sequence' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component___sequence__label'
        label_mini_id : 'glados_es_gs__target__target_component___sequence__label__mini'

      '_metadata.target_component.target_component_synonyms.component_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_synonyms___component_synonym__label'
        label_mini_id : 'glados_es_gs__target__target_component_synonyms___component_synonym__label__mini'

      '_metadata.target_component.target_component_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__target__target_component_synonyms___syn_type__label__mini'

      '_metadata.target_component.target_component_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component___target_component_synonyms__label'
        label_mini_id : 'glados_es_gs__target__target_component___target_component_synonyms__label__mini'

      '_metadata.target_component.target_component_xrefs.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_id__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_id__label__mini'

      '_metadata.target_component.target_component_xrefs.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_name__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_name__label__mini'

      '_metadata.target_component.target_component_xrefs.xref_src_db' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_src_db__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_src_db__label__mini'

      '_metadata.target_component.target_component_xrefs.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_src_url__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_src_url__label__mini'

      '_metadata.target_component.target_component_xrefs.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_url__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_url__label__mini'

      '_metadata.target_component.target_component_xrefs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component___target_component_xrefs__label'
        label_mini_id : 'glados_es_gs__target__target_component___target_component_xrefs__label__mini'

      '_metadata.target_component.targets.target_chembl_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__targets___target_chembl_id__label'
        label_mini_id : 'glados_es_gs__target__targets___target_chembl_id__label__mini'

      '_metadata.target_component.targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component___targets__label'
        label_mini_id : 'glados_es_gs__target__target_component___targets__label__mini'

      '_metadata.target_component.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component___tax_id__label'
        label_mini_id : 'glados_es_gs__target__target_component___tax_id__label__mini'

      '_metadata.target_component' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component__label'
        label_mini_id : 'glados_es_gs__target__target_component__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target___metadata__label'
        label_mini_id : 'glados_es_gs__target___metadata__label__mini'

      'cross_references.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__cross_references___xref_id__label'
        label_mini_id : 'glados_es_gs__target__cross_references___xref_id__label__mini'

      'cross_references.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__cross_references___xref_name__label'
        label_mini_id : 'glados_es_gs__target__cross_references___xref_name__label__mini'

      'cross_references.xref_src' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__cross_references___xref_src__label'
        label_mini_id : 'glados_es_gs__target__cross_references___xref_src__label__mini'

      'cross_references.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__cross_references___xref_src_url__label'
        label_mini_id : 'glados_es_gs__target__cross_references___xref_src_url__label__mini'

      'cross_references.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__cross_references___xref_url__label'
        label_mini_id : 'glados_es_gs__target__cross_references___xref_url__label__mini'

      cross_references : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__cross_references__label'
        label_mini_id : 'glados_es_gs__target__cross_references__label__mini'

      organism : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__organism__label'
        label_mini_id : 'glados_es_gs__target__organism__label__mini'

      pref_name : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__pref_name__label'
        label_mini_id : 'glados_es_gs__target__pref_name__label__mini'

      species_group_flag : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__target__species_group_flag__label'
        label_mini_id : 'glados_es_gs__target__species_group_flag__label__mini'

      target_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_chembl_id__label'
        label_mini_id : 'glados_es_gs__target__target_chembl_id__label__mini'

      'target_components.accession' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_components___accession__label'
        label_mini_id : 'glados_es_gs__target__target_components___accession__label__mini'

      'target_components.component_description' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_components___component_description__label'
        label_mini_id : 'glados_es_gs__target__target_components___component_description__label__mini'

      'target_components.component_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_components___component_id__label'
        label_mini_id : 'glados_es_gs__target__target_components___component_id__label__mini'

      'target_components.component_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_components___component_type__label'
        label_mini_id : 'glados_es_gs__target__target_components___component_type__label__mini'

      'target_components.relationship' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_components___relationship__label'
        label_mini_id : 'glados_es_gs__target__target_components___relationship__label__mini'

      'target_components.target_component_synonyms.component_synonym' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_synonyms___component_synonym__label'
        label_mini_id : 'glados_es_gs__target__target_component_synonyms___component_synonym__label__mini'

      'target_components.target_component_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__target__target_component_synonyms___syn_type__label__mini'

      'target_components.target_component_synonyms' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_components___target_component_synonyms__label'
        label_mini_id : 'glados_es_gs__target__target_components___target_component_synonyms__label__mini'

      'target_components.target_component_xrefs.xref_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_id__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_id__label__mini'

      'target_components.target_component_xrefs.xref_name' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_name__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_name__label__mini'

      'target_components.target_component_xrefs.xref_src_db' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_src_db__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_src_db__label__mini'

      'target_components.target_component_xrefs.xref_src_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_src_url__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_src_url__label__mini'

      'target_components.target_component_xrefs.xref_url' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__target_component_xrefs___xref_url__label'
        label_mini_id : 'glados_es_gs__target__target_component_xrefs___xref_url__label__mini'

      'target_components.target_component_xrefs' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_components___target_component_xrefs__label'
        label_mini_id : 'glados_es_gs__target__target_components___target_component_xrefs__label__mini'

      target_components : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__target_components__label'
        label_mini_id : 'glados_es_gs__target__target_components__label__mini'

      target_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__target_type__label'
        label_mini_id : 'glados_es_gs__target__target_type__label__mini'

      tax_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__tax_id__label'
        label_mini_id : 'glados_es_gs__target__tax_id__label__mini'

    chembl_26_tissue:
      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__es_completion__label'
        label_mini_id : 'glados_es_gs__tissue__es_completion__label__mini'

      '_metadata.organism_taxonomy.l1' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__organism_taxonomy___l1__label'
        label_mini_id : 'glados_es_gs__tissue__organism_taxonomy___l1__label__mini'

      '_metadata.organism_taxonomy.l2' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__organism_taxonomy___l2__label'
        label_mini_id : 'glados_es_gs__tissue__organism_taxonomy___l2__label__mini'

      '_metadata.organism_taxonomy.l3' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__organism_taxonomy___l3__label'
        label_mini_id : 'glados_es_gs__tissue__organism_taxonomy___l3__label__mini'

      '_metadata.organism_taxonomy.oc_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__organism_taxonomy___oc_id__label'
        label_mini_id : 'glados_es_gs__tissue__organism_taxonomy___oc_id__label__mini'

      '_metadata.organism_taxonomy.tax_id' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__organism_taxonomy___tax_id__label'
        label_mini_id : 'glados_es_gs__tissue__organism_taxonomy___tax_id__label__mini'

      '_metadata.organism_taxonomy' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__tissue__organism_taxonomy__label'
        label_mini_id : 'glados_es_gs__tissue__organism_taxonomy__label__mini'

      '_metadata.related_activities.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_activities___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__tissue__related_activities___all_chembl_ids__label__mini'

      '_metadata.related_activities.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__tissue__related_activities___count__label'
        label_mini_id : 'glados_es_gs__tissue__related_activities___count__label__mini'

      '_metadata.related_activities' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_activities__label'
        label_mini_id : 'glados_es_gs__tissue__related_activities__label__mini'

      '_metadata.related_assays.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_assays___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__tissue__related_assays___all_chembl_ids__label__mini'

      '_metadata.related_assays.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__tissue__related_assays___count__label'
        label_mini_id : 'glados_es_gs__tissue__related_assays___count__label__mini'

      '_metadata.related_assays' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_assays__label'
        label_mini_id : 'glados_es_gs__tissue__related_assays__label__mini'

      '_metadata.related_cell_lines.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_cell_lines___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__tissue__related_cell_lines___all_chembl_ids__label__mini'

      '_metadata.related_cell_lines.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__tissue__related_cell_lines___count__label'
        label_mini_id : 'glados_es_gs__tissue__related_cell_lines___count__label__mini'

      '_metadata.related_cell_lines' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_cell_lines__label'
        label_mini_id : 'glados_es_gs__tissue__related_cell_lines__label__mini'

      '_metadata.related_compounds.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_compounds___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__tissue__related_compounds___all_chembl_ids__label__mini'

      '_metadata.related_compounds.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__tissue__related_compounds___count__label'
        label_mini_id : 'glados_es_gs__tissue__related_compounds___count__label__mini'

      '_metadata.related_compounds' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_compounds__label'
        label_mini_id : 'glados_es_gs__tissue__related_compounds__label__mini'

      '_metadata.related_documents.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_documents___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__tissue__related_documents___all_chembl_ids__label__mini'

      '_metadata.related_documents.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__tissue__related_documents___count__label'
        label_mini_id : 'glados_es_gs__tissue__related_documents___count__label__mini'

      '_metadata.related_documents' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_documents__label'
        label_mini_id : 'glados_es_gs__tissue__related_documents__label__mini'

      '_metadata.related_targets.all_chembl_ids' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_targets___all_chembl_ids__label'
        label_mini_id : 'glados_es_gs__tissue__related_targets___all_chembl_ids__label__mini'

      '_metadata.related_targets.count' : 
        type : Number
        integer : true
        year : false
        aggregatable : true
        label_id : 'glados_es_gs__tissue__related_targets___count__label'
        label_mini_id : 'glados_es_gs__tissue__related_targets___count__label__mini'

      '_metadata.related_targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__tissue__related_targets__label'
        label_mini_id : 'glados_es_gs__tissue__related_targets__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__tissue___metadata__label'
        label_mini_id : 'glados_es_gs__tissue___metadata__label__mini'

      bto_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__bto_id__label'
        label_mini_id : 'glados_es_gs__tissue__bto_id__label__mini'

      caloha_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__caloha_id__label'
        label_mini_id : 'glados_es_gs__tissue__caloha_id__label__mini'

      efo_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__efo_id__label'
        label_mini_id : 'glados_es_gs__tissue__efo_id__label__mini'

      pref_name : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__pref_name__label'
        label_mini_id : 'glados_es_gs__tissue__pref_name__label__mini'

      tissue_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__tissue_chembl_id__label'
        label_mini_id : 'glados_es_gs__tissue__tissue_chembl_id__label__mini'

      uberon_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__uberon_id__label'
        label_mini_id : 'glados_es_gs__tissue__uberon_id__label__mini'

