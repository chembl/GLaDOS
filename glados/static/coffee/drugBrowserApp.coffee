class DrugBrowserApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initDrugList = () ->
    drugList = new DrugList

    return drugList

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  # This initialises the view of the broswer as a table. No cards involved.
  @initBrowserAsTable = (col, top_level_elem) ->

    asTableView = new DrugBrowserTableView
      collection: col
      el: top_level_elem

    return asTableView

  # This initialises the infinity view of the browser
  @initInfinityBrowserView = (col, top_level_elem) ->

    col.setMeta('page_size', 50)
    infView = new DrugBrowserInfinityView
      collection: col
      el: top_level_elem

    return infView

  # This initialises the view of the broswer as a table inside a card that is embeddable,
  # and has all the characteristics of a card view.
  @initBrowserAsTableCard = (col, top_level_elem) ->

    asTableCardView = new DrugBrowserTableAsCardView
      collection: col
      el: top_level_elem

    return asTableCardView




