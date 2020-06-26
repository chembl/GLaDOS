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
      @url = "#{glados.Settings.ES_PROXY_API_BASE_URL}/es_data/get_es_document/#{CellLine.ES_INDEX}/#{id}"
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

CellLine.ES_INDEX = 'chembl_cell_line'
CellLine.INDEX_NAME = glados.Settings.CHEMBL_ES_INDEX_PREFIX+'cell_line'
CellLine.PROPERTIES_VISUAL_CONFIG = {
  'cell_chembl_id': {
    link_base: 'report_card_url'
  }
  'cell_name': {
    custom_field_template: '<i>{{val}}</i>'
  }
  'clo_id': {
    link_function: (id) -> 'http://purl.obolibrary.org/obo/' + id
  }
  'efo_id': {
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/ontologies/efo/terms?short_form=' + id
  }
  'cellosaurus_id': {
    link_function: (id) -> 'http://web.expasy.org/cellosaurus/' + id
  }
  'efo_id': {
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/ontologies/efo/terms?short_form=' + id
  }
  'cl_lincs_id': {
    link_function: (id) -> 'http://life.ccs.miami.edu/life/summary?mode=CellLine&source=LINCS&input=' + id
  }
  '_metadata.related_compounds.count': {
    link_base: 'compounds_url'
    on_click: CellLineReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['cell_chembl_id']
    function_key: 'cell_num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
  '_metadata.related_activities.count': {
    link_base: 'activities_url'
    on_click: CellLineReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['cell_chembl_id']
    function_constant_parameters: ['activities']
    function_key: 'cell_bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
}

CellLine.COLUMNS = {
  CHEMBL_ID:

    aggregatable: true
    comparator: "cell_chembl_id"
    hide_label: true
    id: "cell_chembl_id"
    is_sorting: 0
    link_base: "report_card_url"
    name_to_show: "ChEMBL ID"
    name_to_show_short: "ChEMBL ID"
    show: true
    sort_class: "fa-sort"
    sort_disabled: false

}

CellLine.ID_COLUMN = CellLine.COLUMNS.CHEMBL_ID

CellLine.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'

CellLine.getCellsListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'cells'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState