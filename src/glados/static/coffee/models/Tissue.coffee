glados.useNameSpace 'glados.models',
  Tissue: Backbone.Model.extend(DownloadModelOrCollectionExt).extend

    initialize: ->
      @url = glados.Settings.WS_BASE_URL + 'tissue/' + @get('tissue_chembl_id') + '.json'

    parse: (response) ->


      response.report_card_url = glados.models.Tissue.get_report_card_url(response.tissue_chembl_id )

      return response;

# Constant definition for ReportCardEntity model functionalities
_.extend(glados.models.Tissue, glados.models.base.ReportCardEntity)
glados.models.Tissue.color = 'deep-orange'
glados.models.Tissue.reportCardPath = 'tissue_report_card/'

glados.models.Tissue.INDEX_NAME = 'chembl_tissue'
glados.models.Tissue.COLUMNS = {
  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Tissue.INDEX_NAME,
    comparator: 'tissue_chembl_id'
    link_base: 'report_card_url'
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
    glados.models.Tissue.COLUMNS.CHEMBL_ID,
    glados.models.Tissue.COLUMNS.PREF_NAME,
    glados.models.Tissue.COLUMNS.UBERON_ID,
    glados.models.Tissue.COLUMNS.EFO_ID,
  ]
  RESULTS_LIST_ADDITIONAL:[
    glados.models.Tissue.COLUMNS.BTO_ID
    glados.models.Tissue.COLUMNS.CALOHA_ID
  ]
}