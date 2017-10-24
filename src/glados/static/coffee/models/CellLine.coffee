CellLine = Backbone.Model.extend

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'cell_line/' + @get('cell_chembl_id') + '.json'

  parse: (data) ->
    parsed = data
    parsed.report_card_url = CellLine.get_report_card_url(parsed.cell_chembl_id)
    return parsed;

# Constant definition for ReportCardEntity model functionalities
_.extend(CellLine, glados.models.base.ReportCardEntity)
CellLine.color = 'deep-purple'
CellLine.reportCardPath = 'cell_line_report_card/'

CellLine.INDEX_NAME = 'chembl_cell_line'
CellLine.COLUMNS = {
  CHEMBL_ID:{
      'name_to_show': 'CHEMBL_ID'
      'comparator': 'cell_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
    }
  SOURCE_TISSUE: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cell_source_tissue'
  CLO_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'clo_id'
  EFO_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'efo_id'
  CELLOSAURUS_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cellosaurus_id'
  LINCS_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn CellLine.INDEX_NAME,
    comparator: 'cl_lincs_id'
}

CellLine.ID_COLUMN = CellLine.COLUMNS.CHEMBL_ID

CellLine.COLUMNS_SETTINGS = {
  RESULTS_LIST_TABLE: [
    CellLine.COLUMNS.CHEMBL_ID
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
      'name_to_show': 'Organism'
      'comparator': 'cell_source_organism'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    CellLine.COLUMNS.SOURCE_TISSUE

  ]
  RESULTS_LIST_ADDITIONAL: [
    CellLine.COLUMNS.CLO_ID
    CellLine.COLUMNS.EFO_ID
    CellLine.COLUMNS.CELLOSAURUS_ID
    CellLine.COLUMNS.LINCS_ID
  ]
}