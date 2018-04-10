glados.useNameSpace 'glados.models.Compound',
  UnichemConnectivityMatch: Backbone.Model.extend {}

glados.models.Compound.UnichemConnectivityMatch.COLUMNS =
  SOURCE:
    name_to_show: 'Source'
    comparator: 'src_name'
    link_base: 'scr_url'

glados.models.Compound.UnichemConnectivityMatch.ID_COLUMN = glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SOURCE

glados.models.Compound.UnichemConnectivityMatch.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.UnichemConnectivityMatch.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SOURCE
  ]