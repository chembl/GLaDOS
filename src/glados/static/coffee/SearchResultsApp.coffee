class SearchResultsApp

  SEARCH_TYPES =
    STRUCTURE:
      SIMILARITY: 'SIMILARITY'
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

    glados.views.base.TrackView.registerSearchUsage(glados.views.base.TrackView.searchTypes.SUBSTRUCTURE)
    GlobalVariables.SEARCH_TERM = searchTerm
    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSubstructureSearchResultsList()
    resultsList.initURL GlobalVariables.SEARCH_TERM

    queryParams =
      search_term: GlobalVariables.SEARCH_TERM

    $queryContainer = $('.BCK-query-Container')
    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      query_params: queryParams

    $progressElement = $('#BCK-loading-messages-container')
    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')
    @initBrowserFromSSResults(resultsList, $browserContainer, $progressElement, $noResultsDiv, undefined,
      glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SUBSTRUCTURE_HIGHLIGHTING,
      GlobalVariables.SEARCH_TERM)

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

    $progressElement = $('#BCK-loading-messages-container')
    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')

    thisApp = @
    ssSearchModel.once glados.models.Search.StructureSearchModel.EVENTS.RESULTS_READY, ->

      $browserContainer.show()
      thisApp.initBrowserFromSSResults($browserContainer, $progressElement, $noResultsDiv,
        [Compound.COLUMNS.SIMILARITY_ELASTIC],
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

  @initBrowserFromSSResults = ($browserContainer, $progressElement, $noResultsDiv, contextualColumns, customSettings,
    ssSearchModel) ->

    console.log 'INIT BROWSER FROM SEARCH RESULTS'
    console.log 'ssSearchModel: ', ssSearchModel

    resultIds = ssSearchModel.get('result_ids')

    esCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(
      customQuery=undefined, itemsList=resultIds, settings=customSettings)

    new glados.views.Browsers.BrowserMenuView
      collection: esCompoundsList
      el: $browserContainer

    console.log 'esCompoundsList: ', esCompoundsList
    esCompoundsList.fetch()
    return
    esCompoundsList = undefined
    browserView = undefined
    query_first_n = 10000
    doneCallback = (firstCall=false, finalCall=false)->

      if resultsList.allResults.length == 0
        $progressElement.hide()
        $browserContainer.hide()
        $noResultsDiv.show()
        return
      $browserContainer.show()
      if not esCompoundsList?
        esCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(undefined,
          resultsList.allResults, contextualColumns, customSettings, searchTerm)
        esCompoundsList.enableStreamingMode()
        if resultsList.getMeta('total_all_results') > query_first_n
          esCompoundsList.setMeta('out_of_n', resultsList.getMeta('total_all_results'))
        browserView = new glados.views.Browsers.BrowserMenuView
          collection: esCompoundsList
          el: $browserContainer
      else
        esCompoundsList.setMeta('generator_items_list', resultsList.allResults)

      fetchDeferred = esCompoundsList.fetch()
      if finalCall
        fetchDeferred.then _.defer( ->
          esCompoundsList.disableStreamingMode()
        )

    debouncedDoneCallback = _.debounce(doneCallback, 500, true)
    deferreds = resultsList.getAllResults($progressElement, askingForOnlySelected=false, onlyFirstN=query_first_n,
    customBaseProgressText='Searching . . . ', customProgressCallback=debouncedDoneCallback)

    # for now, we need to jump from web services to elastic
    $.when.apply($, deferreds).done(doneCallback.bind(@, false, true)).fail((msg) ->

      customExplanation = 'Error while performing the search.'
      $browserContainer.hide()
      if $progressElement?
        # it can be a jqxr
        if msg.status?
          $progressElement.html glados.Utils.ErrorMessages.getCollectionErrorContent(msg, customExplanation)
        else
          $progressElement.html Handlebars.compile($('#Handlebars-Common-CollectionErrorMsg').html())
            msg: msg
            custom_explanation: customExplanation
    )