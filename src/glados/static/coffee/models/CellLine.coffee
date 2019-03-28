CellLine = Backbone.Model.extend

  entityName: 'Cell Line'
  entityNamePlural: 'Cell Lines'
  idAttribute:'cell_chembl_id'
  defaults:
    fetch_from_elastic: true
  initialize: ->

    id = @get('id')
    id ?= @get('cell_chembl_id')
    @set('id', id)
    @set('cell_chembl_id', id)

    if @get('fetch_from_elastic')
      @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_cell_line/_doc/' + id
    else
      @url = glados.Settings.WS_BASE_URL + 'cell_line/' + id + '.json'


  parse: (response) ->

    if response._source?
      objData = response._source
    else
      objData = response

    objData.report_card_url = CellLine.get_report_card_url(objData.cell_chembl_id)

    filterForActivities = '_metadata.assay_data.cell_chembl_id:' + objData.cell_chembl_id
    objData.activities_url = Activity.getActivitiesListURL(filterForActivities)

    filterForCompounds = '_metadata.related_cell_lines.all_chembl_ids:' + objData.cell_chembl_id
    objData.compounds_url = Compound.getCompoundsListURL(filterForCompounds)

    return objData;

# Constant definition for ReportCardEntity model functionalities
_.extend(CellLine, glados.models.base.ReportCardEntity)
CellLine.color = 'deep-purple'
CellLine.reportCardPath = 'cell_line_report_card/'

CellLine.INDEX_NAME = 'chembl_cell_line'
CellLine.COLUMNS = {
  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    link_base: 'report_card_url'
    comparator: 'cell_chembl_id'
    hide_label: true
  SOURCE_TISSUE: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cell_source_tissue'
  CLO_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'clo_id'
    link_function: (id) -> 'http://purl.obolibrary.org/obo/' + id
  EFO_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'efo_id'
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/ontologies/efo/terms?short_form=' + id
  CELLOSAURUS_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cellosaurus_id'
    link_function: (id) -> 'http://web.expasy.org/cellosaurus/' + id
  LINCS_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cl_lincs_id'
    link_function: (id) -> 'http://life.ccs.miami.edu/life/summary?mode=CellLine&source=LINCS&input=' + id
  NAME: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cell_name'
    custom_field_template: '<i>{{val}}</i>'
  DESCRIPTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cell_description'
  ORGANISM: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cell_source_organism'
  TAX_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cell_source_tax_id'
  BIOACTIVITIES_NUMBER: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: '_metadata.related_activities.count'
    link_base: 'activities_url'
    on_click: CellLineReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['cell_chembl_id']
    function_constant_parameters: ['activities']
    function_key: 'cell_bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  NUM_COMPOUNDS_HISTOGRAM: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: '_metadata.related_compounds.count'
    link_base: 'compounds_url'
    on_click: CellLineReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['cell_chembl_id']
    function_key: 'cell_num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
}

CellLine.ID_COLUMN = CellLine.COLUMNS.CHEMBL_ID

CellLine.COLUMNS_SETTINGS = {
  ALL_COLUMNS: (->
    colsList = []
    for key, value of CellLine.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    CellLine.COLUMNS.CHEMBL_ID
    CellLine.COLUMNS.NAME
    CellLine.COLUMNS.DESCRIPTION
    CellLine.COLUMNS.BIOACTIVITIES_NUMBER
    CellLine.COLUMNS.ORGANISM
    CellLine.COLUMNS.SOURCE_TISSUE

  ]
  RESULTS_LIST_ADDITIONAL: [
    CellLine.COLUMNS.TAX_ID
    CellLine.COLUMNS.CLO_ID
    CellLine.COLUMNS.EFO_ID
    CellLine.COLUMNS.CELLOSAURUS_ID
    CellLine.COLUMNS.LINCS_ID
    CellLine.COLUMNS.NUM_COMPOUNDS_HISTOGRAM
  ]
}

CellLine.COLUMNS_SETTINGS.DEFAULT_DOWNLOAD_COLUMNS = _.union(CellLine.COLUMNS_SETTINGS.RESULTS_LIST_TABLE,
  CellLine.COLUMNS_SETTINGS.RESULTS_LIST_ADDITIONAL)

CellLine.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'
  COLUMNS: CellLine.COLUMNS_SETTINGS.RESULTS_LIST_TABLE

CellLine.getCellsListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'cells'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState