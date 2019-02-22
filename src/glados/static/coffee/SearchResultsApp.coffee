class SearchResultsApp

  SEARCH_TYPES =
    STRUCTURE:
      SIMILARITY: 'SIMILARITY'
      SUBSTRUCTURE: 'SUBSTRUCTURE'
      CONNECTIVITY: 'CONNECTIVITY'

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = (selectedESEntity, searchTerm, currentState) ->
    @eSQueryExplainView = new glados.views.SearchResults.ESQueryExplainView
      el: $('#es-query-explain-wrapper')

    $searchResultsContainer = $('.BCK-SearchResultsContainer')
    new glados.views.SearchResults.SearchResultsView
      el: $searchResultsContainer
      model: SearchModel.getInstance()
      attributes:
        selectedESEntity: selectedESEntity
        state: currentState

    stateObject = if currentState? then JSON.parse(atob(currentState)) else undefined
    SearchModel.getInstance().search(searchTerm, selectedESEntity, stateObject)

  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  @initSubstructureSearchResults = (searchTerm) ->

    GlobalVariables.SEARCH_TERM = searchTerm

    paramsDict =
      search_term: searchTerm

    console.log 'paramsDict: ', paramsDict
    ssSearchModel = new glados.models.Search.StructureSearchModel
      query_params: paramsDict
      search_type: SEARCH_TYPES.STRUCTURE.SUBSTRUCTURE

    $queryContainer = $('.BCK-query-Container')
    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      model: ssSearchModel

    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')

    thisApp = @
    ssSearchModel.once glados.models.Search.StructureSearchModel.EVENTS.RESULTS_READY, ->

      $browserContainer.show()
      thisApp.initBrowserFromSSResults($browserContainer, $noResultsDiv,
        glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.SUBSTRUCTURE_RESULTS_LIST,
        ssSearchModel)

    ssSearchModel.submitSearch()

  @initSimilaritySearchResults = (searchTerm, threshold) ->

    GlobalVariables.SEARCH_TERM = searchTerm
    GlobalVariables.SIMILARITY_PERCENTAGE = threshold

    paramsDict =
      search_term: searchTerm
      threshold: threshold

    ssSearchModel = new glados.models.Search.StructureSearchModel
      query_params: paramsDict
      search_type: SEARCH_TYPES.STRUCTURE.SIMILARITY

    $queryContainer = $('.BCK-query-Container')
    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      model: ssSearchModel

    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')

    thisApp = @
    ssSearchModel.once glados.models.Search.StructureSearchModel.EVENTS.RESULTS_READY, ->

      $browserContainer.show()
      thisApp.initBrowserFromSSResults($browserContainer, $noResultsDiv,
        glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SIMILARITY_MAPS,
        ssSearchModel)

    ssSearchModel.submitSearch()

  @initFlexmatchSearchResults = (searchTerm) ->

    glados.views.base.TrackView.registerSearchUsage(glados.views.base.TrackView.searchTypes.CONNECTIVITY)
    GlobalVariables.SEARCH_TERM = searchTerm

    queryParams =
      search_term: GlobalVariables.SEARCH_TERM

    $queryContainer = $('.BCK-query-Container')
    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      query_params: queryParams

    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewFlexmatchSearchResultsList()
    resultsList.initURL GlobalVariables.SEARCH_TERM

    $progressElement = $('#BCK-loading-messages-container')
    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')
    @initBrowserFromSSResults(resultsList, $browserContainer, $progressElement, $noResultsDiv)

  @initBrowserFromSSResults = ($browserContainer, $noResultsDiv, customSettings, ssSearchModel) ->

    resultIds = ssSearchModel.get('result_ids')
    esCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(
      customQuery=undefined, itemsList=resultIds, settings=customSettings, ssSearchModel)

    new glados.views.Browsers.BrowserMenuView
      collection: esCompoundsList
      el: $browserContainer

    esCompoundsList.fetch()