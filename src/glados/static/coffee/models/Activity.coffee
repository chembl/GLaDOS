Activity = Backbone.Model.extend

  entityName: 'Activity'

  initialize: ->

  parse: (response) ->

    imageFile = glados.Utils.getNestedValue(response, '_metadata.parent_molecule_data.image_file')

    if imageFile != glados.Settings.DEFAULT_NULL_VALUE_LABEL
      response.image_url = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/#{imageFile}"
    else
      response.image_url = "#{glados.Settings.WS_BASE_URL}image/#{response.molecule_chembl_id}.svg?engine=indigo"

    response.molecule_link = Compound.get_report_card_url(response.molecule_chembl_id )
    response.target_link = Target.get_report_card_url(response.target_chembl_id)
    response.assay_link = Assay.get_report_card_url(response.assay_chembl_id )
    response.document_link = Document.get_report_card_url(response.document_chembl_id)
    if response._metadata?
      response.tissue_link = glados.models.Tissue.get_report_card_url(response._metadata.assay_data.tissue_chembl_id)
    return response

Activity.indexName = 'chembl_activity'
Activity.COLUMNS = {
  ACTIVITY_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'activity_id'
  ASSAY_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'assay_chembl_id'
    link_base:'assay_link'
    use_in_summary: true
  ASSAY_DESCRIPTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    'comparator': 'assay_description'
  ASSAY_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'assay_type'
  ASSAY_ORGANISM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.assay_data.assay_organism'
  ASSAY_TISSUE_NAME: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.assay_data.assay_tissue'
  ASSAY_TISSUE_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.assay_data.tissue_chembl_id'
    link_base: 'tissue_link'
  ASSAY_CELL_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.assay_data.assay_cell_type'
  ASSAY_SUBCELLULAR_FRACTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.assay_data.assay_subcellular_fraction'
  BAO_FORMAT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'bao_format'
  BAO_LABEL: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'bao_label'
  CANONICAL_SMILES: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'canonical_smiles'
  DATA_VALIDITY_COMMENT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'data_validity_comment'
  DOCUMENT_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'document_chembl_id'
    link_base: 'document_link'
  DOCUMENT_JOURNAL: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    'comparator': 'document_journal'
  DOCUMENT_YEAR: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    'comparator': 'document_year'
  MOLECULE_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'molecule_chembl_id'
    image_base_url: 'image_url'
    link_base:'molecule_link'
  ALOGP: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.parent_molecule_data.alogp'
  MAX_PHASE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.parent_molecule_data.max_phase'
  NUM_RO5_VIOLATIONS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.parent_molecule_data.num_ro5_violations'
  MOLECULAR_WEIGHT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.parent_molecule_data.full_mwt'
  COMPOUND_KEY: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.parent_molecule_data.compound_key'
  LIGAND_EFFICIENCIES_BEI: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'ligand_efficiency.bei'
  LIGAND_EFFICIENCIES_LE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'ligand_efficiency.le'
  LIGAND_EFFICIENCIES_LLE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'ligand_efficiency.lle'
  LIGAND_EFFICIENCIES_SEI: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'ligand_efficiency.sei'
  STANDARD_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_type'
  PCHEMBL_VALUE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'pchembl_value'
  ACTIVITY_COMMENT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'activity_comment'
  POTENTIAL_DUPLICATE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'potential_duplicate'
  PUBLISHED_RELATION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'published_relation'
  PUBLISHED_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'published_type'
  PUBLISHED_UNITS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    name_to_show: 'Published Units'
    comparator: 'published_units'
  PUBLISHED_VALUE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'published_value'
  QUDT_UNITS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'qudt_units'
  RECORD_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'record_id'
  SRC_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'src_id'
  SRC_DESCRIPTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.source.src_description'
  STANDARD_FLAG: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_flag'
  STANDARD_RELATION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_relation'
  STANDARD_UNITS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_units'
  STANDARD_VALUE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_value'
  TARGET_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_chembl_id'
    link_base:'target_link'
  TARGET_ORGANISM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_organism'
  TARGET_PREF_NAME: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_pref_name'
  UO_UNITS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'uo_units'
  DOC_COUNT: {
    'name_to_show': 'Count'
    'comparator': 'doc_count'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  IS_AGGREGATION: {
    'name_to_show': 'Is aggregation'
    'comparator': 'is_aggregation'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  TARGET_TAX_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_tax_id'
}

Activity.ID_COLUMN = Activity.COLUMNS.ACTIVITY_ID
Activity = Activity.extend({idAttribute: Activity.ID_COLUMN.comparator})

Activity.COLUMNS_SETTINGS = {
  ALL_COLUMNS: (->
    colsList = []
    for key, value of Activity.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_REPORT_TABLE: [
    Activity.COLUMNS.MOLECULE_CHEMBL_ID
    Activity.COLUMNS.STANDARD_TYPE
    Activity.COLUMNS.STANDARD_RELATION
    Activity.COLUMNS.STANDARD_VALUE
    Activity.COLUMNS.STANDARD_UNITS
    Activity.COLUMNS.PCHEMBL_VALUE
    Activity.COLUMNS.ACTIVITY_COMMENT
    Activity.COLUMNS.COMPOUND_KEY
    Activity.COLUMNS.ASSAY_CHEMBL_ID
    Activity.COLUMNS.ASSAY_DESCRIPTION
    Activity.COLUMNS.BAO_LABEL
    Activity.COLUMNS.TARGET_CHEMBL_ID
    Activity.COLUMNS.TARGET_PREF_NAME
    Activity.COLUMNS.TARGET_ORGANISM
    Activity.COLUMNS.DOCUMENT_CHEMBL_ID
    Activity.COLUMNS.SRC_DESCRIPTION
  ]
  RESULTS_LIST_REPORT_CARD: [
    Activity.COLUMNS.MOLECULE_CHEMBL_ID
    Activity.COLUMNS.STANDARD_TYPE
    Activity.COLUMNS.STANDARD_RELATION
    Activity.COLUMNS.STANDARD_VALUE
    Activity.COLUMNS.STANDARD_UNITS
    Activity.COLUMNS.PCHEMBL_VALUE
    Activity.COLUMNS.ASSAY_TYPE
    Activity.COLUMNS.ASSAY_DESCRIPTION
    Activity.COLUMNS.TARGET_PREF_NAME
    Activity.COLUMNS.TARGET_CHEMBL_ID
    Activity.COLUMNS.TARGET_ORGANISM
    Activity.COLUMNS.DOCUMENT_CHEMBL_ID
  ]
  RESULTS_LIST_TABLE_ADDITIONAL: [
    Activity.COLUMNS.MAX_PHASE
    Activity.COLUMNS.NUM_RO5_VIOLATIONS
    Activity.COLUMNS.MOLECULAR_WEIGHT
    Activity.COLUMNS.LIGAND_EFFICIENCIES_BEI
    Activity.COLUMNS.LIGAND_EFFICIENCIES_LE
    Activity.COLUMNS.LIGAND_EFFICIENCIES_LLE
    Activity.COLUMNS.LIGAND_EFFICIENCIES_SEI
    Activity.COLUMNS.ALOGP
    Activity.COLUMNS.ASSAY_ORGANISM
    Activity.COLUMNS.ASSAY_TISSUE_CHEMBL_ID
    Activity.COLUMNS.ASSAY_TISSUE_NAME
    Activity.COLUMNS.ASSAY_CELL_TYPE
    Activity.COLUMNS.ASSAY_SUBCELLULAR_FRACTION
    Activity.COLUMNS.TARGET_TAX_ID
    Activity.COLUMNS.BAO_FORMAT
    Activity.COLUMNS.PUBLISHED_TYPE
    Activity.COLUMNS.PUBLISHED_RELATION
    Activity.COLUMNS.PUBLISHED_VALUE
    Activity.COLUMNS.PUBLISHED_UNITS
    Activity.COLUMNS.CANONICAL_SMILES
    Activity.COLUMNS.DATA_VALIDITY_COMMENT
    Activity.COLUMNS.DOCUMENT_JOURNAL
    Activity.COLUMNS.DOCUMENT_YEAR
    Activity.COLUMNS.SRC_ID
    Activity.COLUMNS.UO_UNITS
    Activity.COLUMNS.POTENTIAL_DUPLICATE
  ]
}

Activity.COLUMNS_SETTINGS.DEFAULT_DOWNLOAD_COLUMNS = _.union(Activity.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_TABLE,
  Activity.COLUMNS_SETTINGS.RESULTS_LIST_TABLE_ADDITIONAL)

Activity.getActivitiesListURL = (filter) ->

  glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    entity: 'activities'
    filter: encodeURIComponent(filter) unless not filter?