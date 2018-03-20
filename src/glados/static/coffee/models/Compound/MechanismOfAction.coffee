glados.useNameSpace 'glados.models.Compound',
  MechanismOfAction: Backbone.Model.extend {}

glados.models.Compound.MechanismOfAction.COLUMNS =
  MECH_ID:
    name_to_show: 'ID'
    comparator: 'mec_id'
  MECHANISM_OF_ACTION:
    name_to_show: 'Mechanism Of Action'
    comparator: 'mechanism_of_action'

glados.models.Compound.MechanismOfAction.ID_COLUMN = glados.models.Compound.MechanismOfAction.COLUMNS.MECH_ID

glados.models.Compound.MechanismOfAction.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.MechanismOfAction.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.MechanismOfAction.COLUMNS.MECHANISM_OF_ACTION
  ]