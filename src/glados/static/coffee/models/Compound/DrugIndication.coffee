glados.useNameSpace 'glados.models.Compound',
  DrugIndication: Backbone.Model.extend {}

glados.models.Compound.DrugIndication.COLUMNS =
  DRUG_IND_ID:
    name_to_show: 'ID'
    comparator: 'mesh_heading'
  MESH_HEADING:
    name_to_show: 'MESH Heading'
    comparator: 'mesh_heading'

glados.models.Compound.DrugIndication.ID_COLUMN = glados.models.Compound.DrugIndication.COLUMNS.DRUG_IND_ID

glados.models.Compound.DrugIndication.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.DrugIndication.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.DrugIndication.COLUMNS.DRUG_IND_ID
  ]

