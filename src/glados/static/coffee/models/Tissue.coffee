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
        @url = "#{glados.Settings.ES_PROXY_API_BASE_URL}/es_data/get_es_document/#{glados.models.Tissue.ES_INDEX}/#{id}"
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

glados.models.Tissue.PROPERTIES_VISUAL_CONFIG = {
  'tissue_chembl_id': {
    link_base: 'report_card_url'
  }
  'uberon_id': {
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/search?q=' + encodeURIComponent(id)
  }
  'efo_id': {
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/search?q=' + encodeURIComponent(id)
  }
  'bto_id': {
    link_function: (id) -> 'https://www.ebi.ac.uk/ols/search?q=' + encodeURIComponent(id)
  }
  'caloha_id': {
    link_function: (id) -> 'https://www.nextprot.org/term/' + encodeURIComponent(id)
  }
  '_metadata.related_compounds.count': {
    on_click: TissueReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['tissue_chembl_id']
    function_key: 'tissue_num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
  '_metadata.related_activities.count': {
    link_base: 'activities_url'
    on_click: TissueReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['tissue_chembl_id']
    function_constant_parameters: ['activities']
    function_key: 'tissue_bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
}
glados.models.Tissue.ES_INDEX = 'chembl_tissue'
glados.models.Tissue.INDEX_NAME = glados.models.Tissue.ES_INDEX

glados.models.Tissue.COLUMNS = {
  CHEMBL_ID: {
    aggregatable: true
    comparator: "tissue_chembl_id"
    hide_label: true
    id: "tissue_chembl_id"
    is_sorting: 0
    link_base: "report_card_url"
    name_to_show: "ChEMBL ID"
    name_to_show_short: "ChEMBL ID"
    show: true
    sort_class: "fa-sort"
    sort_disabled: false
  }
}

glados.models.Tissue.ID_COLUMN = glados.models.Tissue.COLUMNS.CHEMBL_ID

glados.models.Tissue.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'

glados.models.Tissue.getTissuesListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'tissues'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState