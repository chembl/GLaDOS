Assay = Backbone.Model.extend

  idAttribute: 'assay_chembl_id'

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'assay/' + @get('assay_chembl_id') + '.json'

  parse: (data) ->
    parsed = data
    parsed.target = data.target_chembl_id

    parsed.report_card_url = Assay.get_report_card_url(parsed.assay_chembl_id )
    parsed.document_link = Document.get_report_card_url(parsed.document_chembl_id)
    parsed.tissue_link = glados.models.Tissue.get_report_card_url(parsed.tissue_chembl_id)
    return parsed;

# Constant definition for ReportCardEntity model functionalities
_.extend(Assay, glados.models.base.ReportCardEntity)
Assay.color = 'amber'
Assay.reportCardPath = 'assay_report_card/'

Assay.getAssaysListURL = (filter) ->

  if filter
    return glados.Settings.GLADOS_BASE_PATH_REL + 'assays/filter/' + filter
  else
    return glados.Settings.GLADOS_BASE_PATH_REL + 'assays'

Assay.INDEX_NAME = 'chembl_assay'
Assay.COLUMNS = {

  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'assay_chembl_id'
    link_base: 'report_card_url'
  STRAIN: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'assay_strain'
    custom_field_template: '<i>{{val}}</i>'
  DESCRIPTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'description'
  ORGANISM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'assay_organism'
  ASSAY_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'assay_type'
  DOCUMENT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'document_chembl_id'
    link_base: 'document_link'
    secondary_link: true
  TISSUE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'tissue_chembl_id'
    link_base: 'tissue_link'
    secondary_link: true
  CELL_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'assay_cell_type'
  SUBCELLULAR_FRACTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'assay_subcellular_fraction'
  TAX_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'assay_tax_id'
}

Assay.ID_COLUMN = Assay.COLUMNS.CHEMBL_ID

Assay.COLUMNS_SETTINGS = {
  ALL_COLUMNS: (->
    colsList = []
    for key, value of Assay.COLUMNS
      colsList.push value
    return colsList
  )()

  RESULTS_LIST_TABLE: [
    Assay.COLUMNS.CHEMBL_ID
    Assay.COLUMNS.DESCRIPTION
    Assay.COLUMNS.ORGANISM
    Assay.COLUMNS.DOCUMENT
  ]
  RESULTS_LIST_ADDITIONAL:[
    Assay.COLUMNS.STRAIN
    Assay.COLUMNS.ASSAY_TYPE
    Assay.COLUMNS.TISSUE
    Assay.COLUMNS.CELL_TYPE
    Assay.COLUMNS.SUBCELLULAR_FRACTION
  ]
  RESULTS_LIST_CARD: [
    Assay.COLUMNS.CHEMBL_ID
    Assay.COLUMNS.DESCRIPTION
    Assay.COLUMNS.ORGANISM
    Assay.COLUMNS.ASSAY_TYPE
  ]
}

Assay.COLUMNS_SETTINGS.DEFAULT_DOWNLOAD_COLUMNS = _.union(Assay.COLUMNS_SETTINGS.RESULTS_LIST_TABLE,
  Assay.COLUMNS_SETTINGS.RESULTS_LIST_ADDITIONAL, [Assay.COLUMNS.TAX_ID])