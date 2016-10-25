class SearchResultsApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->
    @searchModel = SearchModel.getInstance()
    @initCompResultsListView($('#BCK-CompoundSearchResults'))
    @initDocsResultsListView($('#BCK-DocSearchResults'))
    @search()

  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  # this initialises the view that shows the compounds section of the results
  @initCompResultsListView = (top_level_elem) ->

    compResView = new CompoundResultsListView
      collection: @searchModel.getCompoundResultsList()
      el: top_level_elem

    return compResView

  # this initialises the view that shows the documents section of the results
  @initDocsResultsListView = (top_level_elem) ->

    docResView = new DocumentResultsListView
      collection: @searchModel.getDocumentResultsList()
      el: top_level_elem

    return docResView

  # this initialises the view that shows the compound vs target matrix view
  @initCompTargMatrixView = (topLevelElem) ->

    compTargMatrixView = new CompoundTargetMatrixView
      el: topLevelElem

    return compTargMatrixView

  # this initialises the view that shows the compound results graph view
  @initCompResultsGraphView = (topLevelElem) ->

    compResGraphView = new CompoundResultsGraphView
      el: topLevelElem

    return compResGraphView
