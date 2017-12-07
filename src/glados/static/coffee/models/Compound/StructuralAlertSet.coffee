glados.useNameSpace 'glados.models.Compound',
  StructuralAlertSet: Backbone.Model.extend {}

glados.models.Compound.StructuralAlertSet.COLUMNS =
  SET_NAME:
    name_to_show: 'Alert Set'
    comparator: 'set_name'

glados.models.Compound.StructuralAlertSet.ID_COLUMN = glados.models.Compound.StructuralAlertSet.COLUMNS.SET_NAME

glados.models.Compound.StructuralAlertSet.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.StructuralAlertSet.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.StructuralAlertSet.COLUMNS.SET_NAME
  ]