class SearchResultsApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = (selectedESEntity, searchTerm, currentState) ->

    $searchResultsContainer = $('.BCK-SearchResultsContainer')
    new glados.views.SearchResults.SearchResultsView
      el: $searchResultsContainer
      model: SearchModel.getInstance()
      attributes:
        selectedESEntity: selectedESEntity
        state: currentState

    stateObject = if currentState? then JSON.parse(atob(currentState)) else undefined
    SearchModel.getInstance().search(searchTerm, selectedESEntity, stateObject)

  @initSSSearchResults = (searchParams, searchType) ->

    GlobalVariables.SEARCH_TERM = searchParams.search_term

    ssSearchModel = new glados.models.Search.StructureSearchModel
      query_params: searchParams
      search_type: searchType

    $queryContainer = $('.BCK-query-Container')
    if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.SEQUENCE.BLAST
      @initSequenceQueryView($queryContainer, ssSearchModel)
    else
      @initStructureQueryView($queryContainer, ssSearchModel)


    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')

    listConfig = @getListConfig(searchType)

    thisApp = @
    ssSearchModel.once glados.models.Search.StructureSearchModel.EVENTS.RESULTS_READY, ->

      $browserContainer.show()
      thisApp.initBrowserFromSSResults($browserContainer, $noResultsDiv, listConfig, ssSearchModel)

    ssSearchModel.submitSearch()

  @initSequenceQueryView = ($queryContainer, ssSearchModel) ->

    new glados.views.SearchResults.SequenceQueryView
      el: $queryContainer
      model: ssSearchModel

  @initStructureQueryView = ($queryContainer, ssSearchModel) ->

    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      model: ssSearchModel

  # --------------------------------------------------------------------------------------------------------------------
  # List Config
  # --------------------------------------------------------------------------------------------------------------------
  @getListConfig = (searchType) ->

    if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.SIMILARITY

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SIMILARITY_MAPS

    else if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.SUBSTRUCTURE

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SUBSTRUCTURE_HIGHLIGHTING

    else if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.CONNECTIVITY

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.SUBSTRUCTURE_RESULTS_LIST

    else if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.SEQUENCE.BLAST

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.TARGET_BLAST_RESULTS

    return listConfig

  # --------------------------------------------------------------------------------------------------------------------
  # Router functions
  # --------------------------------------------------------------------------------------------------------------------
  @initSubstructureSearchResults = (searchTerm) ->

    searchParams =
      search_term: searchTerm

    @initSSSearchResults(searchParams, glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.SUBSTRUCTURE)


  @initSimilaritySearchResults = (searchTerm, threshold) ->

    searchParams =
      search_term: searchTerm
      threshold: threshold

    @initSSSearchResults(searchParams, glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.SIMILARITY)


  @initFlexmatchSearchResults = (searchTerm) ->

    searchParams =
      search_term: searchTerm

    @initSSSearchResults(searchParams, glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.CONNECTIVITY)

  @initBLASTSearchResults = (base64Params) ->

    searchParams = JSON.parse(atob(base64Params))

    @initSSSearchResults(searchParams, glados.models.Search.StructureSearchModel.SEARCH_TYPES.SEQUENCE.BLAST)

  @initBrowserFromSSResults = ($browserContainer, $noResultsDiv, customSettings, ssSearchModel) ->

    esCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(
      customQuery=undefined, itemsList=undefined, settings=customSettings, ssSearchModel)

    new glados.views.Browsers.BrowserMenuView
      collection: esCompoundsList
      el: $browserContainer

    esCompoundsList.fetch()