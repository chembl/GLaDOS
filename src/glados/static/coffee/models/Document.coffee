Document = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  idAttribute:'document_chembl_id'

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'document/' + @get('document_chembl_id') + '.json'

  parse: (data) ->
    parsed = data
    parsed.report_card_url = Document.get_report_card_url(parsed.document_chembl_id)

    filterForActivities = 'document_chembl_id:' + parsed.document_chembl_id
    parsed.activities_url = Activity.getActivitiesListURL(filterForActivities)

    filterForCompounds = '_metadata.related_documents.chembl_ids.\\*:' + parsed.document_chembl_id
    parsed.compounds_url = Compound.getCompoundsListURL(filterForCompounds)

    return parsed;

# Constant definition for ReportCardEntity model functionalities
_.extend(Document, glados.models.base.ReportCardEntity)
Document.color = 'red'
Document.reportCardPath = 'document_report_card/'

Document.INDEX_NAME = 'chembl_document'
Document.COLUMNS = {
  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'document_chembl_id'
    link_base: 'report_card_url'
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
  PUBMED_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'pubmed_id'
    link_function: (id) -> 'http://europepmc.org/abstract/MED/' + encodeURIComponent(id)
  DOI: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: 'doi'
    link_function: (id) -> 'http://dx.doi.org/'+ encodeURIComponent(id)
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
    secondary_link: true
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
    secondary_link: true
  NUM_TARGETS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Document.INDEX_NAME,
    comparator: '_metadata.related_targets.count'
    format_as_number: true
    link_base: 'targets_url'
    secondary_link: true
    on_click: DocumentReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['document_chembl_id']
    function_constant_parameters: ['targets']
    function_key: 'document_targets'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
}

Document.ID_COLUMN = Document.COLUMNS.CHEMBL_ID

Document.COLUMNS_SETTINGS = {

  ALL_COLUMNS: (->
    colsList = []
    for key, value of Document.COLUMNS
      colsList.push value
    return colsList
  )()

  RESULTS_LIST_TABLE: [
    Document.COLUMNS.CHEMBL_ID
    Document.COLUMNS.JOURNAL
    Document.COLUMNS.TITLE
    Document.COLUMNS.PUBMED_ID
    Document.COLUMNS.DOI
    Document.COLUMNS.BIOACTIVITIES_NUMBER
    Document.COLUMNS.PATENT_ID
    Document.COLUMNS.SOURCE
    Document.COLUMNS.JOURNAL
    Document.COLUMNS.AUTHORS
    Document.COLUMNS.YEAR
  ]
  RESULTS_LIST_ADDITIONAL: [
    Document.COLUMNS.TYPE
    Document.COLUMNS.ABSTRACT
    Document.COLUMNS.NUM_COMPOUNDS_HISTOGRAM
    Document.COLUMNS.NUM_TARGETS
  ]
  RESULTS_LIST_CARD: [
    Document.COLUMNS.CHEMBL_ID
    Document.COLUMNS.JOURNAL
    Document.COLUMNS.TITLE
    Document.COLUMNS.AUTHORS
    Document.COLUMNS.YEAR
  ]
  SEARCH_BY_TERM_RESULTS: [
    Document.COLUMNS.CHEMBL_ID
    Document.COLUMNS.SCORE
    Document.COLUMNS.TITLE
    Document.COLUMNS.AUTHORS
    Document.COLUMNS.YEAR
  ]
}

Document.COLUMNS_SETTINGS.DEFAULT_DOWNLOAD_COLUMNS = _.union(Document.COLUMNS_SETTINGS.RESULTS_LIST_TABLE,
  Document.COLUMNS_SETTINGS.RESULTS_LIST_ADDITIONAL)

Document.getDocumentsListURL = (filter) ->

  if filter
    return glados.Settings.GLADOS_BASE_PATH_REL + 'documents/filter/' + encodeURIComponent(filter)
  else
    return glados.Settings.GLADOS_BASE_PATH_REL + 'documents'