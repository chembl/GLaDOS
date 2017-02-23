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

    subResView = new WSInfinityView
      collection: resultsList
      el: $('#BCK-SubstructureSearchResults')

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

    fmResView = new WSInfinityView
      collection: resultsList
      el: $('#BCK-SubstructureSearchResults')

    resultsList.fetch()

  # --------------------------------------------------------------------------------------------------------------------
  # Graph Views
  # --------------------------------------------------------------------------------------------------------------------

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

  @initCompoundTargetMatrix = ->

    ctm = new CompoundTargetMatrix
    new CompoundTargetMatrixView
      model: ctm
      el: $('.BCK-CompTargetMatrix')

    ctm.fetch()
