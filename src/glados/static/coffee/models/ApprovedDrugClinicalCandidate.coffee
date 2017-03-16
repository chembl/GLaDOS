ApprovedDrugClinicalCandidate = Compound.extend
  idAttribute: "molecule_chembl_id"

ApprovedDrugClinicalCandidate.COLUMNS = {
  CHEMBL_ID:{
    'name_to_show': 'ChEMBL ID'
    'comparator': 'molecule_chembl_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base': 'report_card_url'
  }
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
  MAX_PHASE:{
    'name_to_show': 'Max Phase'
    'comparator': 'max_phase'
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

ApprovedDrugClinicalCandidate.ID_COLUMN = ApprovedDrugClinicalCandidate.COLUMNS.CHEMBL_ID

ApprovedDrugClinicalCandidate.COLUMNS_SETTINGS = {
  RESULTS_LIST_TABLE:[
    ApprovedDrugClinicalCandidate.COLUMNS.CHEMBL_ID
    ApprovedDrugClinicalCandidate.COLUMNS.PREF_NAME
    ApprovedDrugClinicalCandidate.COLUMNS.MECH_OF_ACT
    ApprovedDrugClinicalCandidate.COLUMNS.MAX_PHASE
    ApprovedDrugClinicalCandidate.COLUMNS.REFERENCES
  ]
}

