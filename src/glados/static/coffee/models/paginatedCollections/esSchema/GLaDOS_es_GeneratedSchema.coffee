glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
# The contents of this file were generated from the GLaDOS-es project

  GLaDOS_es_GeneratedSchema:
    chembl_activity:
      activity_comment : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__activity_comment__label'
        label_mini_id : 'glados_es_gs__activity__activity_comment__label__mini'

      activity_id : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__activity__activity_id__label'
        label_mini_id : 'glados_es_gs__activity__activity_id__label__mini'

      assay_chembl_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__assay_chembl_id__label'
        label_mini_id : 'glados_es_gs__activity__assay_chembl_id__label__mini'

      assay_description : 
        type : String
        aggregatable : false
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

      canonical_smiles : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__activity__canonical_smiles__label'
        label_mini_id : 'glados_es_gs__activity__canonical_smiles__label__mini'

      data_validity_comment : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__activity__data_validity_comment__label'
        label_mini_id : 'glados_es_gs__activity__data_validity_comment__label__mini'

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
        aggregatable : true
        label_id : 'glados_es_gs__activity__document_year__label'
        label_mini_id : 'glados_es_gs__activity__document_year__label__mini'

      'ligand_efficiency.bei' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__ligand_efficiency___bei__label'
        label_mini_id : 'glados_es_gs__activity__ligand_efficiency___bei__label__mini'

      'ligand_efficiency.le' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__ligand_efficiency___le__label'
        label_mini_id : 'glados_es_gs__activity__ligand_efficiency___le__label__mini'

      'ligand_efficiency.lle' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__ligand_efficiency___lle__label'
        label_mini_id : 'glados_es_gs__activity__ligand_efficiency___lle__label__mini'

      'ligand_efficiency.sei' : 
        type : Number
        integer : false
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

      pchembl_value : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__pchembl_value__label'
        label_mini_id : 'glados_es_gs__activity__pchembl_value__label__mini'

      potential_duplicate : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__activity__potential_duplicate__label'
        label_mini_id : 'glados_es_gs__activity__potential_duplicate__label__mini'

      published_relation : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__published_relation__label'
        label_mini_id : 'glados_es_gs__activity__published_relation__label__mini'

      published_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__published_type__label'
        label_mini_id : 'glados_es_gs__activity__published_type__label__mini'

      published_units : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__published_units__label'
        label_mini_id : 'glados_es_gs__activity__published_units__label__mini'

      published_value : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__activity__published_value__label'
        label_mini_id : 'glados_es_gs__activity__published_value__label__mini'

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
        aggregatable : false
        label_id : 'glados_es_gs__activity__target_pref_name__label'
        label_mini_id : 'glados_es_gs__activity__target_pref_name__label__mini'

      target_tax_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__target_tax_id__label'
        label_mini_id : 'glados_es_gs__activity__target_tax_id__label__mini'

      uo_units : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__activity__uo_units__label'
        label_mini_id : 'glados_es_gs__activity__uo_units__label__mini'

    chembl_assay:
      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__assay__es_completion__label'
        label_mini_id : 'glados_es_gs__assay__es_completion__label__mini'

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
        aggregatable : false
        label_id : 'glados_es_gs__assay__assay_chembl_id__label'
        label_mini_id : 'glados_es_gs__assay__assay_chembl_id__label__mini'

      assay_organism : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__assay__assay_organism__label'
        label_mini_id : 'glados_es_gs__assay__assay_organism__label__mini'

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
        aggregatable : true
        label_id : 'glados_es_gs__assay__confidence_score__label'
        label_mini_id : 'glados_es_gs__assay__confidence_score__label__mini'

      description : 
        type : String
        aggregatable : false
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

    chembl_cell_line:
      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__es_completion__label'
        label_mini_id : 'glados_es_gs__cell_line__es_completion__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__cell_line___metadata__label'
        label_mini_id : 'glados_es_gs__cell_line___metadata__label__mini'

      cell_chembl_id : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__cell_chembl_id__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_chembl_id__label__mini'

      cell_description : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__cell_line__cell_description__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_description__label__mini'

      cell_id : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__cell_line__cell_id__label'
        label_mini_id : 'glados_es_gs__cell_line__cell_id__label__mini'

      cell_name : 
        type : String
        aggregatable : false
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

    chembl_document:
      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__es_completion__label'
        label_mini_id : 'glados_es_gs__document__es_completion__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__document___metadata__label'
        label_mini_id : 'glados_es_gs__document___metadata__label__mini'

      abstract : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__abstract__label'
        label_mini_id : 'glados_es_gs__document__abstract__label__mini'

      authors : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__authors__label'
        label_mini_id : 'glados_es_gs__document__authors__label__mini'

      doc_type : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__document__doc_type__label'
        label_mini_id : 'glados_es_gs__document__doc_type__label__mini'

      document_chembl_id : 
        type : String
        aggregatable : false
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

      title : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__document__title__label'
        label_mini_id : 'glados_es_gs__document__title__label__mini'

      volume : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__document__volume__label'
        label_mini_id : 'glados_es_gs__document__volume__label__mini'

      year : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__document__year__label'
        label_mini_id : 'glados_es_gs__document__year__label__mini'

    chembl_molecule:
      '_metadata.activity_count' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__activity_count__label'
        label_mini_id : 'glados_es_gs__molecule__activity_count__label__mini'

      '_metadata.compound_records.compound_key' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__compound_records___compound_key__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records___compound_key__label__mini'

      '_metadata.compound_records.compound_name' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__compound_records___compound_name__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records___compound_name__label__mini'

      '_metadata.compound_records' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__compound_records__label'
        label_mini_id : 'glados_es_gs__molecule__compound_records__label__mini'

      '_metadata.disease_name' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__disease_name__label'
        label_mini_id : 'glados_es_gs__molecule__disease_name__label__mini'

      '_metadata.drug.drug_data.applicants' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__applicants__label'
        label_mini_id : 'glados_es_gs__molecule__applicants__label__mini'

      '_metadata.drug.drug_data.atc_classification.code' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__atc_classification___code__label'
        label_mini_id : 'glados_es_gs__molecule__atc_classification___code__label__mini'

      '_metadata.drug.drug_data.atc_classification.description' : 
        type : String
        aggregatable : false
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
        aggregatable : false
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
        aggregatable : false
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
        aggregatable : true
        label_id : 'glados_es_gs__molecule__chirality__label'
        label_mini_id : 'glados_es_gs__molecule__chirality__label__mini'

      '_metadata.drug.drug_data.development_phase' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__development_phase__label'
        label_mini_id : 'glados_es_gs__molecule__development_phase__label__mini'

      '_metadata.drug.drug_data.drug_type' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__drug_type__label'
        label_mini_id : 'glados_es_gs__molecule__drug_type__label__mini'

      '_metadata.drug.drug_data.first_approval' : 
        type : Number
        integer : true
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
        aggregatable : false
        label_id : 'glados_es_gs__molecule__indication_class__label'
        label_mini_id : 'glados_es_gs__molecule__indication_class__label__mini'

      '_metadata.drug.drug_data.molecule_chembl_id' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_chembl_id__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_chembl_id__label__mini'

      '_metadata.drug.drug_data.molecule_properties.acd_logd' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___acd_logd__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___acd_logd__label__mini'

      '_metadata.drug.drug_data.molecule_properties.acd_logp' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___acd_logp__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___acd_logp__label__mini'

      '_metadata.drug.drug_data.molecule_properties.acd_most_apka' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___acd_most_apka__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___acd_most_apka__label__mini'

      '_metadata.drug.drug_data.molecule_properties.acd_most_bpka' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___acd_most_bpka__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___acd_most_bpka__label__mini'

      '_metadata.drug.drug_data.molecule_properties.alogp' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___alogp__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___alogp__label__mini'

      '_metadata.drug.drug_data.molecule_properties.aromatic_rings' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___aromatic_rings__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___aromatic_rings__label__mini'

      '_metadata.drug.drug_data.molecule_properties.full_molformula' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___full_molformula__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___full_molformula__label__mini'

      '_metadata.drug.drug_data.molecule_properties.full_mwt' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___full_mwt__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___full_mwt__label__mini'

      '_metadata.drug.drug_data.molecule_properties.hba' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hba__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hba__label__mini'

      '_metadata.drug.drug_data.molecule_properties.hba_lipinski' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hba_lipinski__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hba_lipinski__label__mini'

      '_metadata.drug.drug_data.molecule_properties.hbd' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hbd__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hbd__label__mini'

      '_metadata.drug.drug_data.molecule_properties.hbd_lipinski' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hbd_lipinski__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hbd_lipinski__label__mini'

      '_metadata.drug.drug_data.molecule_properties.heavy_atoms' : 
        type : Number
        integer : true
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
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___mw_freebase__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___mw_freebase__label__mini'

      '_metadata.drug.drug_data.molecule_properties.mw_monoisotopic' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___mw_monoisotopic__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___mw_monoisotopic__label__mini'

      '_metadata.drug.drug_data.molecule_properties.num_alerts' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_alerts__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_alerts__label__mini'

      '_metadata.drug.drug_data.molecule_properties.num_lipinski_ro5_violations' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_lipinski_ro5_violations__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_lipinski_ro5_violations__label__mini'

      '_metadata.drug.drug_data.molecule_properties.num_ro5_violations' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_ro5_violations__label__mini'

      '_metadata.drug.drug_data.molecule_properties.psa' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___psa__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___psa__label__mini'

      '_metadata.drug.drug_data.molecule_properties.qed_weighted' : 
        type : Number
        integer : false
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
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures___canonical_smiles__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___canonical_smiles__label__mini'

      '_metadata.drug.drug_data.molecule_structures.standard_inchi' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi__label__mini'

      '_metadata.drug.drug_data.molecule_structures.standard_inchi_key' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi_key__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi_key__label__mini'

      '_metadata.drug.drug_data.molecule_structures' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures__label__mini'

      '_metadata.drug.drug_data.molecule_synonyms.molecule_synonym' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___molecule_synonym__label__mini'

      '_metadata.drug.drug_data.molecule_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___syn_type__label__mini'

      '_metadata.drug.drug_data.molecule_synonyms.synonyms' : 
        type : String
        aggregatable : false
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
        aggregatable : false
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
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_year__label'
        label_mini_id : 'glados_es_gs__molecule__usan_year__label__mini'

      '_metadata.drug.drug_data.withdrawn_country' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_country__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_country__label__mini'

      '_metadata.drug.drug_data.withdrawn_reason' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__withdrawn_reason__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_reason__label__mini'

      '_metadata.drug.drug_data.withdrawn_year' : 
        type : Number
        integer : true
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

      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__es_completion__label'
        label_mini_id : 'glados_es_gs__molecule__es_completion__label__mini'

      '_metadata.related_targets.chembl_ids' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_targets___chembl_ids__label'
        label_mini_id : 'glados_es_gs__molecule__related_targets___chembl_ids__label__mini'

      '_metadata.related_targets.count' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__related_targets___count__label'
        label_mini_id : 'glados_es_gs__molecule__related_targets___count__label__mini'

      '_metadata.related_targets' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__related_targets__label'
        label_mini_id : 'glados_es_gs__molecule__related_targets__label__mini'

      '_metadata.tags' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__tags__label'
        label_mini_id : 'glados_es_gs__molecule__tags__label__mini'

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
        aggregatable : false
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
        aggregatable : false
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
        aggregatable : true
        label_id : 'glados_es_gs__molecule__chirality__label'
        label_mini_id : 'glados_es_gs__molecule__chirality__label__mini'

      dosed_ingredient : 
        type : Boolean
        aggregatable : true
        label_id : 'glados_es_gs__molecule__dosed_ingredient__label'
        label_mini_id : 'glados_es_gs__molecule__dosed_ingredient__label__mini'

      first_approval : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__first_approval__label'
        label_mini_id : 'glados_es_gs__molecule__first_approval__label__mini'

      first_in_class : 
        type : Number
        integer : true
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
        aggregatable : true
        label_id : 'glados_es_gs__molecule__inorganic_flag__label'
        label_mini_id : 'glados_es_gs__molecule__inorganic_flag__label__mini'

      max_phase : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__max_phase__label'
        label_mini_id : 'glados_es_gs__molecule__max_phase__label__mini'

      molecule_chembl_id : 
        type : String
        aggregatable : false
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

      'molecule_properties.acd_logd' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___acd_logd__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___acd_logd__label__mini'

      'molecule_properties.acd_logp' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___acd_logp__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___acd_logp__label__mini'

      'molecule_properties.acd_most_apka' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___acd_most_apka__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___acd_most_apka__label__mini'

      'molecule_properties.acd_most_bpka' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___acd_most_bpka__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___acd_most_bpka__label__mini'

      'molecule_properties.alogp' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___alogp__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___alogp__label__mini'

      'molecule_properties.aromatic_rings' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___aromatic_rings__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___aromatic_rings__label__mini'

      'molecule_properties.full_molformula' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___full_molformula__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___full_molformula__label__mini'

      'molecule_properties.full_mwt' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___full_mwt__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___full_mwt__label__mini'

      'molecule_properties.hba' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hba__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hba__label__mini'

      'molecule_properties.hba_lipinski' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hba_lipinski__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hba_lipinski__label__mini'

      'molecule_properties.hbd' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hbd__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hbd__label__mini'

      'molecule_properties.hbd_lipinski' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___hbd_lipinski__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___hbd_lipinski__label__mini'

      'molecule_properties.heavy_atoms' : 
        type : Number
        integer : true
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
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___mw_freebase__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___mw_freebase__label__mini'

      'molecule_properties.mw_monoisotopic' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___mw_monoisotopic__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___mw_monoisotopic__label__mini'

      'molecule_properties.num_alerts' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_alerts__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_alerts__label__mini'

      'molecule_properties.num_lipinski_ro5_violations' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_lipinski_ro5_violations__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_lipinski_ro5_violations__label__mini'

      'molecule_properties.num_ro5_violations' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___num_ro5_violations__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___num_ro5_violations__label__mini'

      'molecule_properties.psa' : 
        type : Number
        integer : false
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_properties___psa__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_properties___psa__label__mini'

      'molecule_properties.qed_weighted' : 
        type : Number
        integer : false
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
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures___canonical_smiles__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___canonical_smiles__label__mini'

      'molecule_structures.standard_inchi' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi__label__mini'

      'molecule_structures.standard_inchi_key' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi_key__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures___standard_inchi_key__label__mini'

      molecule_structures : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_structures__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_structures__label__mini'

      'molecule_synonyms.molecule_synonym' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__molecule__molecule_synonyms___molecule_synonym__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___molecule_synonym__label__mini'

      'molecule_synonyms.syn_type' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__molecule__molecule_synonyms___syn_type__label'
        label_mini_id : 'glados_es_gs__molecule__molecule_synonyms___syn_type__label__mini'

      'molecule_synonyms.synonyms' : 
        type : String
        aggregatable : false
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
        aggregatable : false
        label_id : 'glados_es_gs__molecule__pref_name__label'
        label_mini_id : 'glados_es_gs__molecule__pref_name__label__mini'

      prodrug : 
        type : Number
        integer : true
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
        aggregatable : false
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
        aggregatable : true
        label_id : 'glados_es_gs__molecule__usan_year__label'
        label_mini_id : 'glados_es_gs__molecule__usan_year__label__mini'

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
        aggregatable : false
        label_id : 'glados_es_gs__molecule__withdrawn_reason__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_reason__label__mini'

      withdrawn_year : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__molecule__withdrawn_year__label'
        label_mini_id : 'glados_es_gs__molecule__withdrawn_year__label__mini'

    chembl_target:
      '_metadata.activity_count' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__target__activity_count__label'
        label_mini_id : 'glados_es_gs__target__activity_count__label__mini'

      '_metadata.disease_name' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__disease_name__label'
        label_mini_id : 'glados_es_gs__target__disease_name__label__mini'

      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__target__es_completion__label'
        label_mini_id : 'glados_es_gs__target__es_completion__label__mini'

      '_metadata.related_compounds.chembl_ids' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__related_compounds___chembl_ids__label'
        label_mini_id : 'glados_es_gs__target__related_compounds___chembl_ids__label__mini'

      '_metadata.related_compounds.count' : 
        type : Number
        integer : true
        aggregatable : true
        label_id : 'glados_es_gs__target__related_compounds___count__label'
        label_mini_id : 'glados_es_gs__target__related_compounds___count__label__mini'

      '_metadata.related_compounds' : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target__related_compounds__label'
        label_mini_id : 'glados_es_gs__target__related_compounds__label__mini'

      '_metadata.tags' : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__tags__label'
        label_mini_id : 'glados_es_gs__target__tags__label__mini'

      _metadata : 
        type : Object
        aggregatable : false
        label_id : 'glados_es_gs__target___metadata__label'
        label_mini_id : 'glados_es_gs__target___metadata__label__mini'

      organism : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__target__organism__label'
        label_mini_id : 'glados_es_gs__target__organism__label__mini'

      pref_name : 
        type : String
        aggregatable : false
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
        aggregatable : false
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
        aggregatable : false
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

    chembl_tissue:
      '_metadata.es_completion' : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__es_completion__label'
        label_mini_id : 'glados_es_gs__tissue__es_completion__label__mini'

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
        aggregatable : false
        label_id : 'glados_es_gs__tissue__pref_name__label'
        label_mini_id : 'glados_es_gs__tissue__pref_name__label__mini'

      tissue_chembl_id : 
        type : String
        aggregatable : false
        label_id : 'glados_es_gs__tissue__tissue_chembl_id__label'
        label_mini_id : 'glados_es_gs__tissue__tissue_chembl_id__label__mini'

      uberon_id : 
        type : String
        aggregatable : true
        label_id : 'glados_es_gs__tissue__uberon_id__label'
        label_mini_id : 'glados_es_gs__tissue__uberon_id__label__mini'

