class SearchResultsApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initCompoundsResultsList = () ->
    compsList = new CompoundResultsList

    return compsList

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  # this initialises the view that shows the compounds section of the results
  @initCompResultsListView = (col, top_level_elem) ->

    compResView = new CompoundResultsListView
      collection: col
      el: top_level_elem

    return compResView

