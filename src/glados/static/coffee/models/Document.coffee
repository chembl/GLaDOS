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

Document.COLUMNS = {
  CHEMBL_ID: {
      'name_to_show': 'CHEMBL_ID'
      'comparator': 'document_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
  }
  TITLE: {
      'name_to_show': 'Title'
      'comparator': 'title'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'custom_field_template': '<i>{{val}}</i>'
  }
  AUTHORS: {
      'name_to_show': 'Authors'
      'comparator': 'authors'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
  }
  YEAR:{
      'name_to_show': 'Year'
      'comparator': 'year'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  # this is shown when searching documents by terms.
  SCORE: {
      'name_to_show': 'Score'
      'comparator': 'score'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'custom_field_template': '<b>Score: </b>{{val}}'
  }
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