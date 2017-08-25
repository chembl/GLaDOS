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


glados.models.Tissue.COLUMNS = {
  CHEMBL_ID: {
      'name_to_show': 'ChEMBL ID'
      'comparator': 'tissue_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
    }
  PREF_NAME: {
      'name_to_show': 'Name'
      'comparator': 'pref_name'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  UBERON_ID: {
      'name_to_show': 'UBERON ID'
      'comparator': 'uberon_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  EFO_ID: {
      'name_to_show': 'EFO ID'
      'comparator': 'efo_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
}

glados.models.Tissue.ID_COLUMN = glados.models.Tissue.COLUMNS.CHEMBL_ID

glados.models.Tissue.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [
    glados.models.Tissue.COLUMNS.CHEMBL_ID,
    glados.models.Tissue.COLUMNS.PREF_NAME,
    glados.models.Tissue.COLUMNS.UBERON_ID,
    glados.models.Tissue.COLUMNS.EFO_ID,
  ]
}