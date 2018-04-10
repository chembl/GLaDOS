glados.useNameSpace 'glados.models.Compound',
  UnichemConnectivityMatch: Backbone.Model.extend {}

glados.models.Compound.UnichemConnectivityMatch.COLUMNS =
  SOURCE:
    name_to_show: 'Source'
    comparator: 'src_name'
    link_base: 'scr_url'
  IDENTICAL_COMPONENT_MATCHES:
    name_to_show: 'Identical Component'
    comparator: ''
  S:
    name_to_show: 'S'
    comparator: ''
  I:
    name_to_show: 'I'
    comparator: ''
  P:
    name_to_show: 'P'
    comparator: ''
  SI:
    name_to_show: 'SI'
    comparator: ''
  IP:
    name_to_show: 'IP'
    comparator: ''
  SP:
    name_to_show: 'SP'
    comparator: ''
  SIP:
    name_to_show: 'SIP'
    comparator: ''


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
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.IDENTICAL_COMPONENT_MATCHES
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.S
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.I
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.P
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SI
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.IP
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SP
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SIP
  ]