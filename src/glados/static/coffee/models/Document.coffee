Document = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  entityName: 'Document'
  entityNamePlural: 'Documents'
  idAttribute: 'document_chembl_id'

  initialize: ->
    id = @get('id')
    id ?= @get('document_chembl_id')
    @set('id', id)
    @set('document_chembl_id', id)

    if @get('fetch_from_elastic')
      @url = "#{glados.Settings.ES_PROXY_API_BASE_URL}/es_data/get_es_document/#{Document.ES_INDEX}/#{id}"
    else
      @url = glados.Settings.WS_BASE_URL + 'document/' + id + '.json'

  parse: (response) ->
    if response._source?
      objData = response._source
    else
      objData = response

    objData.report_card_url = Document.get_report_card_url(objData.document_chembl_id)

    filterForActivities = 'document_chembl_id:' + objData.document_chembl_id
    objData.activities_url = Activity.getActivitiesListURL(filterForActivities)

    filterForCompounds = '_metadata.related_documents.all_chembl_ids:' + objData.document_chembl_id
    objData.compounds_url = Compound.getCompoundsListURL(filterForCompounds)

    return objData;

# Constant definition for ReportCardEntity model functionalities
_.extend(Document, glados.models.base.ReportCardEntity)
Document.color = 'red'
Document.reportCardPath = 'document_report_card/'

Document.ES_INDEX = 'chembl_document'
Document.INDEX_NAME = glados.Settings.CHEMBL_ES_INDEX_PREFIX+'document'
Document.PROPERTIES_VISUAL_CONFIG = {
  'document_chembl_id': {
    link_base: 'report_card_url'
  }
  '_metadata.source': {
    parse_function: (values) -> (v.src_description for v in values).join(', ')
  }
  'pubmed_id': {
    link_function: (id) -> 'http://europepmc.org/abstract/MED/' + encodeURIComponent(id)
  }
  'doi': {
    link_function: (id) -> 'http://dx.doi.org/' + encodeURIComponent(id)
  }
  'patent_id': {
    link_function: (patent_id) -> "https://www.surechembl.org/document/#gi{patent_id}"
  }
  '_metadata.related_activities.count': {
    link_base: 'activities_url'
    on_click: DocumentReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['document_chembl_id']
    function_constant_parameters: ['activities']
    function_key: 'document_bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
  '_metadata.related_compounds.count': {
    link_base: 'compounds_url'
    on_click: DocumentReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['document_chembl_id']
    function_key: 'document_num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
  '_metadata.related_targets.count': {
    format_as_number: true
    link_base: 'targets_url'
    on_click: DocumentReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['document_chembl_id']
    function_constant_parameters: ['targets']
    function_key: 'document_targets'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
}

Document.COLUMNS = {
  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'document_chembl_id'
    link_base: 'report_card_url'
    hide_label: true
  TITLE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'title'
    custom_field_template: '<i>{{val}}</i>'
  AUTHORS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'authors'
  YEAR: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'year'
  SOURCE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: '_metadata.source'
    parse_function: (values) -> (v.src_description for v in values).join(', ')
# this is shown when searching documents by terms.
  SCORE: {
    'name_to_show': 'Score'
    'comparator': 'score'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'custom_field_template': '<b>Score: </b>{{val}}'
  }
# this is shown when showing related documents in a report card
  TARGET_TANIMOTO: {
    name_to_show: 'Target Similarity'
    comparator: 'tid_tani'
    parse_function: (value) -> "#{parseFloat(value) * 100}%"
  }
  COMPOUND_TANIMOTO: {
    name_to_show: 'Compound Similarity'
    comparator: 'mol_tani'
    parse_function: (value) -> "#{parseFloat(value) * 100}%"
  }
  REFERENCE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: '_metadata.similar_documents'
    name_to_show: 'Reference'
    parse_function: (model) -> Document.getFormattedReference model.attributes
    parse_from_model: true
    link_function: (model) -> 'http://dx.doi.org/' + encodeURIComponent(model.attributes.doi)
    get_link_from_model: true
  PUBMED_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'pubmed_id'
    link_function: (id) -> 'http://europepmc.org/abstract/MED/' + encodeURIComponent(id)
  DOI: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'doi'
    link_function: (id) -> 'http://dx.doi.org/' + encodeURIComponent(id)
  PATENT_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'patent_id'
  JOURNAL: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'journal'
  TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'doc_type'
  ABSTRACT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'abstract'
  BIOACTIVITIES_NUMBER: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: '_metadata.related_activities.count'
    link_base: 'activities_url'
    on_click: DocumentReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['document_chembl_id']
    function_constant_parameters: ['activities']
    function_key: 'document_bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  NUM_COMPOUNDS_HISTOGRAM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: '_metadata.related_compounds.count'
    link_base: 'compounds_url'
    on_click: DocumentReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['document_chembl_id']
    function_key: 'document_num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  NUM_TARGETS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: '_metadata.related_targets.count'
    format_as_number: true
    link_base: 'targets_url'
    on_click: DocumentReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['document_chembl_id']
    function_constant_parameters: ['targets']
    function_key: 'document_targets'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
}

Document.COLUMNS.CHEMBL_ID = {
  aggregatable: true
  comparator: "document_chembl_id"
  hide_label: true
  id: "document_chembl_id"
  is_sorting: 0
  link_base: "report_card_url"
  name_to_show: "ChEMBL ID"
  name_to_show_short: "ChEMBL ID"
  show: true
  sort_class: "fa-sort"
  sort_disabled: false
}

Document.ID_COLUMN = Document.COLUMNS.CHEMBL_ID

Document.COLUMNS_SETTINGS = {

  ALL_COLUMNS: (->
    colsList = []
    for key, value of Document.COLUMNS
      colsList.push value
    return colsList
  )()
  SIMILAR_TERMS_IN_REPORT_CARDS: [
    Document.COLUMNS.CHEMBL_ID
    Document.COLUMNS.TARGET_TANIMOTO
    Document.COLUMNS.COMPOUND_TANIMOTO
    Document.COLUMNS.REFERENCE
    Document.COLUMNS.TITLE
    Document.COLUMNS.PUBMED_ID
    Document.COLUMNS.DOI
  ]
}

console.log('SIMILAR_TERMS_IN_REPORT_CARDS: ', Document.COLUMNS_SETTINGS.SIMILAR_TERMS_IN_REPORT_CARDS)

Document.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'

Document.getDocumentsListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'documents'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState

Document.DEPOSITED_DATASETS_FILTER = 'doc_type:"DATASET" AND NOT(_metadata.source.src_id:(
"1" OR "7" OR "8" OR "9" OR "11" OR "12" OR "13" OR "15" OR "18" OR "25" OR "26" OR "28" OR "31" OR "35" OR "37" OR "38"
 OR "39" OR "41" OR  "42")) AND _metadata.related_activities.count:>0'

Document.getFormattedReference = (docAttributes) ->

  journal = if docAttributes.journal? then docAttributes.journal else ""
  year = if docAttributes.year? then "(#{docAttributes.year})" else ""
  volume = if docAttributes.volume? then "#{docAttributes.volume}:" else ""
  firstPage = if docAttributes.first_page? then docAttributes.first_page else ""
  lastPage = if docAttributes.last_page? then docAttributes.last_page else ""
  return "#{journal} #{year} #{volume}#{firstPage}-#{lastPage}"