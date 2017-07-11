class SearchResultsApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->
    @searchBarView = glados.views.SearchResults.SearchBarView.getInstance()

  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  @initSubstructureSearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getSubstructureSearchQueryString()
    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSubstructureSearchResultsList()
    resultsList.initURL GlobalVariables.SEARCH_TERM

    glados.views.PaginatedViews.PaginatedView\
    .getNewInfinitePaginatedView(resultsList, $('#BCK-SubstructureSearchResults'))

    resultsList.fetch()

  @initSimilaritySearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getSimilaritySearchQueryString()
    GlobalVariables.SIMILARITY_PERCENTAGE = URLProcessor.getSimilaritySearchPercentage()

    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsList()

    resultsList.initURL GlobalVariables.SEARCH_TERM, GlobalVariables.SIMILARITY_PERCENTAGE

    subResView = new SimilaritySearchResultsView
      collection: resultsList
      el: $('#BCK-SimilaritySearchResults')

    resultsList.fetch()

  @initFlexmatchSearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getUrlPartInReversePosition(0)

    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewFlexmatchSearchResultsList()
    resultsList.initURL GlobalVariables.SEARCH_TERM

    glados.views.PaginatedViews.PaginatedView\
    .getNewInfinitePaginatedView(resultsList, $('#BCK-SubstructureSearchResults'))

    resultsList.fetch()

  # --------------------------------------------------------------------------------------------------------------------
  # Graph Views
  # --------------------------------------------------------------------------------------------------------------------

  # this initialises the view that shows the compound results graph view
  @initCompResultsGraphView = (topLevelElem) ->
    compResGraphView = new PlotView
      el: topLevelElem

    return compResGraphView

