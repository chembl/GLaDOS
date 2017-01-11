Document = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  idAttribute:'document_chembl_id'

  initialize: ->

    @url = glados.Settings.WS_BASE_URL + 'document/' + @get('document_chembl_id') + '.json'

Document.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [
    {
      'name_to_show': 'CHEMBL_ID'
      'comparator': 'document_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': '/document_report_card/$$$'
    }
    {
      'name_to_show': 'Title'
      'comparator': 'title'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'custom_field_template': '<i>{{val}}</i>'
    }
    {
      'name_to_show': 'Authors'
      'comparator': 'authors'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Year'
      'comparator': 'year'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  ]
}