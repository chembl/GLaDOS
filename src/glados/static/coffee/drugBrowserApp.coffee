class DrugBrowserApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  # This initialises the view of the broswer as a table. No cards involved.
  # the colection must be a drug list
  @initBrowserAsTable = (col, top_level_elem) ->

    asTableView = glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(col, top_level_elem)

    return asTableView

  # This initialises the infinity view of the browser
  @initInfinityBrowserView = (col, top_level_elem) ->

    col.setMeta('page_size', 50)
    infView = glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView(col, top_level_elem)

    return infView




