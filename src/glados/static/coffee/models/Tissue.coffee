glados.useNameSpace 'glados.models',
  Tissue: Backbone.Model.extend(DownloadModelOrCollectionExt).extend

    entityName: 'Tissue'
    entityNamePlural: 'Tissues'
    idAttribute:'tissue_chembl_id'
    defaults:
      fetch_from_elastic: true
    initialize: ->

      id = @get('id')
      id ?= @get('tissue_chembl_id')
      @set('id', id)
      @set('tissue_chembl_id', id)

      if @get('fetch_from_elastic')
        @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_tissue/_doc/' + id
      else
        @url = glados.Settings.WS_BASE_URL + 'tissue/' + id + '.json'

    parse: (response) ->

      if response._source?
        objData = response._source
      else
        objData = response

      objData.report_card_url = glados.models.Tissue.get_report_card_url(objData.tissue_chembl_id )

      filterForActivities = '_metadata.assay_data.tissue_chembl_id:' + objData.tissue_chembl_id
      objData.activities_url = Activity.getActivitiesListURL(filterForActivities)

      filterForCompounds = '_metadata.related_tissues.all_chembl_ids:' + objData.tissue_chembl_id
      objData.compounds_url = Compound.getCompoundsListURL(filterForCompounds)

      return objData;

# Constant definition for ReportCardEntity model functionalities
_.extend(glados.models.Tissue, glados.models.base.ReportCardEntity)
glados.models.Tissue.color = 'deep-orange'
glados.models.Tissue.reportCardPath = 'tissue_report_card/'

glados.models.Tissue.INDEX_NAME = 'chembl_tissue'
glados.models.Tissue.COLUMNS = {
  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: 'tissue_chembl_id'
    link_base: 'report_card_url'
    hide_label: true
  PREF_NAME: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: 'pref_name'
  UBERON_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: 'uberon_id'
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/search?q=' + encodeURIComponent(id)
  EFO_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: 'efo_id'
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/search?q=' + encodeURIComponent(id)
  BTO_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: 'bto_id'
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/search?q=' + encodeURIComponent(id)
  CALOHA_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: 'caloha_id'
    link_function: (id) -> 'https://www.nextprot.org/term/' + encodeURIComponent(id)
  BIOACTIVITIES_NUMBER: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: '_metadata.related_activities.count'
    link_base: 'activities_url'
    on_click: TissueReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['tissue_chembl_id']
    function_constant_parameters: ['activities']
    function_key: 'tissue_bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  NUM_COMPOUNDS_HISTOGRAM: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: '_metadata.related_compounds.count'
    link_base: 'compounds_url'
    on_click: TissueReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['tissue_chembl_id']
    function_key: 'tissue_num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
}

glados.models.Tissue.ID_COLUMN = glados.models.Tissue.COLUMNS.CHEMBL_ID

glados.models.Tissue.COLUMNS_SETTINGS = {
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Tissue.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_REPORT_CARD: [
    glados.models.Tissue.COLUMNS.CHEMBL_ID
    glados.models.Tissue.COLUMNS.PREF_NAME
    glados.models.Tissue.COLUMNS.UBERON_ID
    glados.models.Tissue.COLUMNS.EFO_ID
    glados.models.Tissue.COLUMNS.BIOACTIVITIES_NUMBER
  ]
  RESULTS_LIST_ADDITIONAL:[
    glados.models.Tissue.COLUMNS.BTO_ID
    glados.models.Tissue.COLUMNS.CALOHA_ID
    glados.models.Tissue.COLUMNS.NUM_COMPOUNDS_HISTOGRAM
  ]
}

glados.models.Tissue.COLUMNS_SETTINGS.DEFAULT_DOWNLOAD_COLUMNS = _.union(
  glados.models.Tissue.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD,
  glados.models.Tissue.COLUMNS_SETTINGS.RESULTS_LIST_ADDITIONAL)

glados.models.Tissue.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'
  COLUMNS: glados.models.Tissue.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD

glados.models.Tissue.getTissuesListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'tissues'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState