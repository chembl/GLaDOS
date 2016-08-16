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
  @initBrowserAsTable = (col, top_level_elem) ->

    asTableView = new DrugBrowserTableView
      collection: col
      el: top_level_elem

    return asTableView

  # This initialises the infinity view of the browser
  @initInfinityBrowserView = (top_level_elem) ->

    infView = new DrugBrowserInfinityView
      el: top_level_elem

    return infView


