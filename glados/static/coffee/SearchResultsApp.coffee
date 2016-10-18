class SearchResultsApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = () ->
    SearchResultsApp.searchModel = null
    @initCompResultsListView($('#BCK-CompoundSearchResults'))
    @initDocsResultsListView($('#BCK-DocSearchResults'))
    @search()

  # --------------------------------------------------------------------------------------------------------------------
  # Models
  # --------------------------------------------------------------------------------------------------------------------

  # Lazily initialized searchModel
  @getSearchModel = ->
    if not SearchResultsApp.searchModel
      SearchResultsApp.searchModel = new SearchModel
    return SearchResultsApp.searchModel

  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  # this initialises the view that shows the compounds section of the results
  @initCompResultsListView = (top_level_elem) ->

    compResView = new CompoundResultsListView
      collection: @getSearchModel().getCompoundResultsList()
      el: top_level_elem

    return compResView

  # this initialises the view that shows the documents section of the results
  @initDocsResultsListView = (top_level_elem) ->

    docResView = new DocumentResultsListView
      collection: @getSearchModel().getDocumentResultsList()
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

  # --------------------------------------------------------------------------------------------------------------------
  # Functions
  # --------------------------------------------------------------------------------------------------------------------

  @search = () ->
    # TODO: load query parameters from html to model
    @getSearchModel().search()