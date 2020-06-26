Activity = Backbone.Model.extend

  entityName: 'Activity'
  entityNamePlural: 'Activities'
  initialize: ->

  parse: (response) ->

    if response._source?
      objData = response._source
    else
      objData = response

    imageFile = glados.Utils.getNestedValue(objData, '_metadata.parent_molecule_data.image_file')

    if imageFile != glados.Settings.DEFAULT_NULL_VALUE_LABEL
      objData.image_url = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/#{imageFile}"
    else
      objData.image_url = "#{glados.Settings.WS_BASE_URL}image/#{objData.molecule_chembl_id}.svg"

    objData.molecule_link = Compound.get_report_card_url(objData.molecule_chembl_id )
    objData.target_link = Target.get_report_card_url(objData.target_chembl_id)
    objData.assay_link = Assay.get_report_card_url(objData.assay_chembl_id )
    objData.document_link = Document.get_report_card_url(objData.document_chembl_id)
    if objData._metadata?
      objData.tissue_link = glados.models.Tissue.get_report_card_url(objData._metadata.assay_data.tissue_chembl_id)
      objData.cell_link = CellLine.get_report_card_url(objData._metadata.assay_data.cell_chembl_id)

    return objData

Activity.indexName = glados.Settings.CHEMBL_ES_INDEX_PREFIX+'activity'
Activity.PROPERTIES_VISUAL_CONFIG = {
  'molecule_chembl_id': {
    image_base_url: 'image_url'
    link_base:'molecule_link'
  }
  'assay_chembl_id': {
    link_base:'assay_link'
    use_in_summary: true
  }
  'target_chembl_id': {
    link_base:'target_link'
  }
  '_metadata.assay_data.cell_chembl_id': {
    link_base:'cell_link'
  }
  'document_chembl_id': {
    link_base: 'document_link'
  }
}
Activity.COLUMNS = {
  ACTIVITY_ID:

    aggregatable: true
    comparator: "activity_id"
    id: "activity_id"
    is_sorting: 0
    name_to_show: "ID"
    name_to_show_short: "ID"
    show: true
    sort_class: "fa-sort"
    sort_disabled: false

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
  QUDT_UNITS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'qudt_units' # not used???
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
  TARGET_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: '_metadata.target_data.target_type'
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

Activity.getActivitiesListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'activities'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState