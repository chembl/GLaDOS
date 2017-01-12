CellLine = Backbone.Model.extend

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'cell_line/' + @get('cell_chembl_id') + '.json'

  parse: (data) ->
    parsed = data
    parsed.report_card_url = CellLine.get_report_card_url(parsed.cell_chembl_id)
    return parsed;

CellLine.get_report_card_url = (chembl_id)->
  return glados.Settings.GLADOS_BASE_PATH_REL+'cell_line_report_card/'+chembl_id

CellLine.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [
    {
      'name_to_show': 'CHEMBL_ID'
      'comparator': 'cell_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
    }
    {
      'name_to_show': 'Name'
      'comparator': 'cell_name'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'custom_field_template': '<i>{{val}}</i>'
    }
    {
      'name_to_show': 'Description'
      'comparator': 'cell_description'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Type'
      'comparator': 'cell_description'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Organism'
      'comparator': 'cell_source_organism'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  ]
}