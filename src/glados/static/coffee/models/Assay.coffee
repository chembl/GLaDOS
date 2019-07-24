Assay = Backbone.Model.extend

  entityName: 'Assay'
  entityNamePlural: 'Assays'
  idAttribute: 'assay_chembl_id'
  defaults:
    fetch_from_elastic: true
  initialize: ->

    id = @get('id')
    id ?= @get('assay_chembl_id')
    @set('id', id)
    @set('assay_chembl_id', id)

    if @get('fetch_from_elastic')
      @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_assay/_doc/' + id
    else
      @url = glados.Settings.WS_BASE_URL + 'assay/' + id + '.json'

  parse: (response) ->

    # get data when it comes from elastic
    if response._source?
      objData = response._source
    else
      objData = response

    objData.target = response.assay_chembl_id

    objData.report_card_url = Assay.get_report_card_url(objData.assay_chembl_id )
    objData.document_link = Document.get_report_card_url(objData.document_chembl_id)
    objData.tissue_link = glados.models.Tissue.get_report_card_url(objData.tissue_chembl_id)

    filterForCompounds = '_metadata.related_assays.all_chembl_ids:' + objData.assay_chembl_id
    objData.compounds_url = Compound.getCompoundsListURL(filterForCompounds)

    filterForActivities = 'assay_chembl_id:' + objData.assay_chembl_id
    objData.activities_url = Activity.getActivitiesListURL(filterForActivities)

    objData.target_link = Target.get_report_card_url(objData.target_chembl_id)
    objData.cell_link = CellLine.get_report_card_url(objData.cell_chembl_id)

    #check if it is bindingdb and add corresponding link
    isFromBindingDB = objData.src_id == 37
    if isFromBindingDB
      assayIDParts = objData.src_assay_id.split('_')
      byAssayID = assayIDParts[1]
      entryID = assayIDParts[0]

      bindingDBLink = "https://www.bindingdb.org/jsp/dbsearch/assay.jsp?assayid=#{byAssayID}&entryid=#{entryID}"
      objData.binding_db_link = bindingDBLink
      objData.binding_db_link_text = entryID

    if objData._metadata.document_data.doi?
      objData.reference_link = 'http://dx.doi.org/' + encodeURIComponent(objData._metadata.document_data.doi)

    if objData._metadata.document_data.pubmed_id?
      objData.pubmed_link = 'https://www.ncbi.nlm.nih.gov/pubmed/' + \
        encodeURIComponent(objData._metadata.document_data.pubmed_id)

    return objData;

# Constant definition for ReportCardEntity model functionalities
_.extend(Assay, glados.models.base.ReportCardEntity)
Assay.color = 'amber'
Assay.reportCardPath = 'assay_report_card/'

Assay.getAssaysListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'assays'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState

Assay.INDEX_NAME = 'chembl_assay'
Assay.PROPERTIES_VISUAL_CONFIG = {
  'assay_chembl_id': {
    link_base: 'report_card_url'
  }
  '_metadata.related_compounds.count': {
    link_base: 'compounds_url'
    on_click: AssayReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['assay_chembl_id']
    function_key: 'assay_num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
  '_metadata.related_activities.count': {
    link_base: 'activities_url'
    on_click: AssayReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['assay_chembl_id']
    function_constant_parameters: ['activities']
    function_key: 'assay_bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
  'document_chembl_id': {
    link_base: 'document_link'
  }
  'tissue_chembl_id': {
    link_base: 'tissue_link'
  }
  '_metadata.document_data.pubmed_id': {
    link_base: 'pubmed_link'
  }
  '_metadata.document_data.doi': {
    link_base: 'reference_link'
  }
  'assay_parameters': {
    parse_function: (raw_parameters) ->

      param_groups = []

      for param in raw_parameters

        useful_params = []

        for key in ['standard_type', 'standard_relation', 'standard_value', 'standard_units', 'comments']

          useful_params.push("#{key}:#{param[key]}")

        param_groups.push(useful_params.join(' '))

      return param_groups.join(' | ')
  }
}
Assay.COLUMNS = {

  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'assay_chembl_id'
    link_base: 'report_card_url'
    hide_label: true
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
  BAO_LABEL: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'bao_label'
  SRC_DESCRIPTION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: '_metadata.source.src_description'
  TISSUE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Assay.INDEX_NAME,
    comparator: 'tissue_chembl_id'
    link_base: 'tissue_link'
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
}

Assay.COLUMNS.CHEMBL_ID = {
  aggregatable: true
  comparator: "assay_chembl_id"
  hide_label: true
  id: "assay_chembl_id"
  is_sorting: 0
  link_base: "report_card_url"
  name_to_show: "ChEMBL ID"
  name_to_show_short: "ChEMBL ID"
  show: true
  sort_class: "fa-sort"
  sort_disabled: false
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
  COLUMNS: Assay.COLUMNS_SETTINGS.RESULTS_LIST_TABLE