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