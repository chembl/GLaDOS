class DrugBrowserApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initDrugList = () ->
    drugList = new DrugList

    drugList.url = 'https://www.ebi.ac.uk/chembl/api/data/molecule.json?max_phase=4'
    return drugList

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  # This initialises the view of the broswer as a table. 
  @initBrowserAsTable = (model, top_level_elem) ->

    asTableView = new DrugBrowserTableView
      model: model
      el: top_level_elem

    return asTableView

