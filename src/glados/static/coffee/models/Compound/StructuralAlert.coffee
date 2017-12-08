glados.useNameSpace 'glados.models.Compound',
  StructuralAlert: Backbone.Model.extend {}

glados.models.Compound.StructuralAlert.COLUMNS =
  ALERT_ID:
    name_to_show: 'Alert ID'
    comparator: 'alert_id'
  ALERT_NAME:
    name_to_show: 'Alert Name'
    comparator: 'alert_name'

glados.models.Compound.StructuralAlert.ID_COLUMN = glados.models.Compound.StructuralAlert.COLUMNS.ALERT_ID

glados.models.Compound.StructuralAlert.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.StructuralAlert.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_REPORT_CARD_CAROUSEL: [
    glados.models.Compound.StructuralAlert.COLUMNS.ALERT_NAME
  ]
