ApprovedDrugClinicalCandidate = Compound.extend
  idAttribute: "molecule_chembl_id"

ApprovedDrugClinicalCandidate.COLUMNS = {
  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'molecule_chembl_id'
    link_function: Compound.get_report_card_url.bind(Compound)
  PREF_NAME:{
    'name_to_show': 'Name'
    'comparator': 'pref_name'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  MECH_OF_ACT:{
    'name_to_show': 'Mechanism of Action'
    'comparator': 'mechanism_of_action'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  REFERENCES:{
    'name_to_show': 'References'
    'comparator': 'references'
    'sort_disabled': true
    'is_sorting': 0
  }
}

ApprovedDrugClinicalCandidate.ID_COLUMN = Compound.COLUMNS.CHEMBL_ID

ApprovedDrugClinicalCandidate.COLUMNS_SETTINGS = {
  ALL_COLUMNS: (->
    colsList = []
    for key, value of ApprovedDrugClinicalCandidate.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE:[
    ApprovedDrugClinicalCandidate.COLUMNS.CHEMBL_ID
    ApprovedDrugClinicalCandidate.COLUMNS.PREF_NAME
    ApprovedDrugClinicalCandidate.COLUMNS.MECH_OF_ACT
    Compound.COLUMNS.MAX_PHASE
    ApprovedDrugClinicalCandidate.COLUMNS.REFERENCES
  ]
}