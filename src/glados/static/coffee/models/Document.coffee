Document = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  idAttribute:'document_chembl_id'

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'document/' + @get('document_chembl_id') + '.json'

  parse: (data) ->
    parsed = data
    parsed.report_card_url = Document.get_report_card_url(parsed.document_chembl_id)
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
    Document.COLUMNS.PATENT_ID
    Document.COLUMNS.AUTHORS
    Document.COLUMNS.YEAR
  ]
  RESULTS_LIST_ADDITIONAL: [
    Document.COLUMNS.TYPE
    Document.COLUMNS.ABSTRACT
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