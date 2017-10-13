glados.useNameSpace 'glados.models.Compound',
  Drug: Compound.extend {}

glados.models.Compound.Drug.COLUMNS =
  CHEMBL_ID: _.extend({}, Compound.COLUMNS.CHEMBL_ID,
    'name_to_show': 'Parent Molecule')
  SYNONYMS: Compound.COLUMNS.SYNONYMS
  PHASE: _.extend({}, Compound.COLUMNS.MAX_PHASE,
    'name_to_show': 'Phase')

glados.models.Compound.Drug.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of Drug.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    Drug.COLUMNS.CHEMBL_ID
    Drug.COLUMNS.SYNONYMS
    Drug.COLUMNS.PHASE
  ]
  RESULTS_LIST_REPORT_CARD_ADDITIONAL: []
  RESULTS_LIST_REPORT_CARD: [
    Drug.COLUMNS.CHEMBL_ID
    Drug.COLUMNS.SYNONYMS
    Drug.COLUMNS.PHASE
  ]