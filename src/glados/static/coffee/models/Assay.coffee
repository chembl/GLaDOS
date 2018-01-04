Assay = Backbone.Model.extend

  entityName: 'Assay'
  idAttribute: 'assay_chembl_id'

  initialize: ->

    id = @get('id')
    id ?= @get('assay_chembl_id')
    @set('id', id)
    @set('assay_chembl_id', id)

    @url = glados.Settings.WS_BASE_URL + 'assay/' + @get('assay_chembl_id') + '.json'

  parse: (data) ->
    parsed = data
    parsed.target = data.assay_chembl_id

    parsed.report_card_url = Assay.get_report_card_url(parsed.assay_chembl_id )
    parsed.document_link = Document.get_report_card_url(parsed.document_chembl_id)
    parsed.tissue_link = glados.models.Tissue.get_report_card_url(parsed.tissue_chembl_id)

    filterForCompounds = '_metadata.related_assays.chembl_ids.\\*:' + parsed.assay_chembl_id
    parsed.compounds_url = Compound.getCompoundsListURL(filterForCompounds)

    filterForActivities = 'assay_chembl_id:' + parsed.assay_chembl_id
    parsed.activities_url = Activity.getActivitiesListURL(filterForActivities)

    parsed.target_link = Target.get_report_card_url(parsed.target_chembl_id)
    parsed.cell_link = CellLine.get_report_card_url(parsed.cell_chembl_id)

    return parsed;

# Constant definition for ReportCardEntity model functionalities
_.extend(Assay, glados.models.base.ReportCardEntity)
Assay.color = 'amber'
Assay.reportCardPath = 'assay_report_card/'

Assay.getAssaysListURL = (filter) ->

  if filter
    return glados.Settings.GLADOS_BASE_PATH_REL + 'assays/filter/' + encodeURIComponent(filter)
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
  BAO_LABEL: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'bao_label'
  SRC_DESCRIPTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: '_metadata.source.src_description'
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
  NUM_COMPOUNDS_HISTOGRAM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: '_metadata.related_compounds.count'
    link_base: 'compounds_url'
    on_click: AssayReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['assay_chembl_id']
    function_key: 'assay_num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
    secondary_link: true
  BIOACTIVITIES_NUMBER: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: '_metadata.related_activities.count'
    link_base: 'activities_url'
    on_click: AssayReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['assay_chembl_id']
    function_constant_parameters: ['activities']
    function_key: 'assay_bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
    secondary_link: true
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
    Assay.COLUMNS.NUM_COMPOUNDS_HISTOGRAM
    Assay.COLUMNS.DOCUMENT
    Assay.COLUMNS.BAO_LABEL
    Assay.COLUMNS.SRC_DESCRIPTION
  ]
  RESULTS_LIST_ADDITIONAL:[
    Assay.COLUMNS.TAX_ID
    Assay.COLUMNS.STRAIN
    Assay.COLUMNS.ASSAY_TYPE
    Assay.COLUMNS.TISSUE
    Assay.COLUMNS.CELL_TYPE
    Assay.COLUMNS.SUBCELLULAR_FRACTION
    Assay.COLUMNS.BIOACTIVITIES_NUMBER
  ]
  RESULTS_LIST_CARD: [
    Assay.COLUMNS.CHEMBL_ID
    Assay.COLUMNS.DESCRIPTION
    Assay.COLUMNS.ORGANISM
    Assay.COLUMNS.ASSAY_TYPE
  ]
}

Assay.COLUMNS_SETTINGS.DEFAULT_DOWNLOAD_COLUMNS = _.union(Assay.COLUMNS_SETTINGS.RESULTS_LIST_TABLE,
  Assay.COLUMNS_SETTINGS.RESULTS_LIST_ADDITIONAL)

Assay.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'
  COLUMNS: Assay.COLUMNS_SETTINGS.RESULTS_LIST_CARD