class DrugBrowserApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initDrugList = () ->
    drugList = new DrugList

    drugList.url = 'https://www.ebi.ac.uk/chembl/api/data/molecule.json?max_phase=4'
    return drugList

