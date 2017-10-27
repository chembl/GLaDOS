Activity = Backbone.Model.extend

  initialize: ->

  parse: (response) ->
    response.image_url = glados.Settings.WS_BASE_URL + 'image/' + response.molecule_chembl_id + '.svg?engine=indigo'
    response.molecule_link = Compound.get_report_card_url(response.molecule_chembl_id )
    response.target_link = Target.get_report_card_url(response.target_chembl_id)
    response.assay_link = Assay.get_report_card_url(response.assay_chembl_id )
    response.document_link = Document.get_report_card_url(response.document_chembl_id)
    return response

Activity.indexName = 'chembl_activity'
Activity.COLUMNS = {
  ACTIVITY_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'activity_id'
  ASSAY_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'assay_chembl_id'
    link_base:'assay_link'
    secondary_link: true
    use_in_summary: true
  ASSAY_DESCRIPTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    'comparator': 'assay_description'
  ASSAY_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'assay_type'
  BAO_FORMAT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'bao_format'
  CANONICAL_SMILES: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'canonical_smiles'
  DATA_VALIDITY_COMMENT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'data_validity_comment'
  DOCUMENT_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'document_chembl_id'
    link_base: 'document_link'
    secondary_link: true
  DOCUMENT_JOURNAL: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    'comparator': 'document_journal'
  DOCUMENT_YEAR: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    'comparator': 'document_year'
  MOLECULE_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'molecule_chembl_id'
    image_base_url: 'image_url'
    link_base:'molecule_link'
    secondary_link: true
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
  STANDARD_FLAG: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_flag'
  STANDARD_RELATION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_relation'
  STANDARD_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_type'
  STANDARD_UNITS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_units'
  STANDARD_VALUE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'standard_value'
  TARGET_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_chembl_id'
    link_base:'target_link'
    secondary_link: true
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
    Activity.COLUMNS.ASSAY_CHEMBL_ID
    Activity.COLUMNS.ASSAY_DESCRIPTION
    Activity.COLUMNS.TARGET_CHEMBL_ID
    Activity.COLUMNS.TARGET_PREF_NAME
    Activity.COLUMNS.TARGET_ORGANISM
    Activity.COLUMNS.DOCUMENT_CHEMBL_ID
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


  if filter
    return glados.Settings.GLADOS_BASE_PATH_REL + 'activities/filter/' + encodeURIComponent(filter)
  else
    return glados.Settings.GLADOS_BASE_PATH_REL + 'activities'