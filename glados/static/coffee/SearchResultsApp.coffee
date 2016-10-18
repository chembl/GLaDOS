class SearchResultsApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initCompoundsResultsList = ->
    compsList = new CompoundResultsList

    return compsList

  @initDocsResultsList = ->
    docsList = new DocumentResultsList

    return docsList

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  # this initialises the view that shows the compounds section of the results
  @initCompResultsListView = (col, top_level_elem) ->

    compResView = new CompoundResultsListView
      collection: col
      el: top_level_elem

    return compResView

  # this initialises the view that shows the compounds section of the results, embedded as card
  @initCompResultsListAsCardView = (col, top_level_elem) ->

    compResAsCardView = new CompoundResultsListAsCardView
      collection: col
      el: top_level_elem

    return compResAsCardView

  # this initialises the view that shows the documents section of the results
  @initDocsResultsListView = (col, top_level_elem) ->

    docResView = new DocumentResultsListView
      collection: col
      el: top_level_elem

    return docResView

  # this initalises the view that shows the compound vs target matrix view
  @initCompTargMatrixView = (topLevelElem) ->

    compTargMatrixView = new CompoundTargetMatrixView
      el: topLevelElem

    return compTargMatrixView

  # this initalises the view that shows the compound results graph view
  @initCompResultsGraphView = (topLevelElem) ->

    compResGraphView = new CompoundResultsGraphView
      el: topLevelElem

    return compResGraphView
