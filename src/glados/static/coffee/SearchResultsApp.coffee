class SearchResultsApp

  SEARCH_TYPES =
    STRUCTURE:
      SIMILARITY: 'SIMILARITY'
      SUBSTRUCTURE: 'SUBSTRUCTURE'
      CONNECTIVITY: 'CONNECTIVITY'
    SEQUENCE:
      BLAST: 'BLAST'

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

  @initSSSearchResults = (searchParams, search_type) ->

    GlobalVariables.SEARCH_TERM = searchParams.search_term

    ssSearchModel = new glados.models.Search.StructureSearchModel
      query_params: searchParams
      search_type: search_type

    console.log 'ssSearchModel: ', ssSearchModel

    $queryContainer = $('.BCK-query-Container')
    if search_type == SEARCH_TYPES.SEQUENCE.BLAST
      @initSequenceQueryView($queryContainer, ssSearchModel)
    else
      @initStructureQueryView($queryContainer, ssSearchModel)

#    ssSearchModel.submitSearch()
#    return

    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')

    if search_type == SEARCH_TYPES.STRUCTURE.SIMILARITY

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SIMILARITY_MAPS

    else if search_type == SEARCH_TYPES.STRUCTURE.SUBSTRUCTURE or search_type == SEARCH_TYPES.CONNECTIVITY

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.SUBSTRUCTURE_RESULTS_LIST

    thisApp = @
    ssSearchModel.once glados.models.Search.StructureSearchModel.EVENTS.RESULTS_READY, ->

      $browserContainer.show()
      thisApp.initBrowserFromSSResults($browserContainer, $noResultsDiv, listConfig, ssSearchModel)

    ssSearchModel.submitSearch()

  @initSequenceQueryView = ($queryContainer, ssSearchModel) ->

    console.log 'init sequence query view'

  @initStructureQueryView = ($queryContainer, ssSearchModel) ->

    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      model: ssSearchModel

  # --------------------------------------------------------------------------------------------------------------------
  # Router functions
  # --------------------------------------------------------------------------------------------------------------------
  @initSubstructureSearchResults = (searchTerm) ->

    searchParams =
      search_term: searchTerm

    @initSSSearchResults(searchParams, SEARCH_TYPES.STRUCTURE.SUBSTRUCTURE)


  @initSimilaritySearchResults = (searchTerm, threshold) ->

    searchParams =
      search_term: searchTerm
      threshold: threshold

    @initSSSearchResults(searchParams, SEARCH_TYPES.STRUCTURE.SIMILARITY)


  @initFlexmatchSearchResults = (searchTerm) ->

    searchParams =
      search_term: searchTerm

    @initSSSearchResults(searchParams, SEARCH_TYPES.STRUCTURE.CONNECTIVITY)

  @initBLASTSearchResults = (base64Params) ->

    searchParams =
      query_sequence: 'ABCDE'

    @initSSSearchResults(searchParams, SEARCH_TYPES.SEQUENCE.BLAST)


  @initBrowserFromSSResults = ($browserContainer, $noResultsDiv, customSettings, ssSearchModel) ->

    resultIds = ssSearchModel.get('result_ids')
    esCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(
      customQuery=undefined, itemsList=resultIds, settings=customSettings, ssSearchModel)

    new glados.views.Browsers.BrowserMenuView
      collection: esCompoundsList
      el: $browserContainer

    esCompoundsList.fetch()