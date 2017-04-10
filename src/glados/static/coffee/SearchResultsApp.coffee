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

  @initCompoundTargetMatrix = ->
    ctm = new CompoundTargetMatrix
      'molecule_chembl_ids': ['CHEMBL554', 'CHEMBL212250', 'CHEMBL212201', 'CHEMBL212251', 'CHEMBL384407',
      'CHEMBL387207', 'CHEMBL215814', 'CHEMBL383965', 'CHEMBL214487']

    new MatrixView
      model: ctm
      el: $('.BCK-CompTargetMatrix')

    ctm.fetch()
