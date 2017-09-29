class SearchResultsApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->
    @eSQueryExplainView = glados.views.SearchResults.ESQueryExplainView.getInstance()

    $searchResultsContainer = $('.BCK-SearchResultsContainer')
    new glados.views.SearchResults.SearchResultsView
      el: $searchResultsContainer
      model: SearchModel.getInstance()

  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  @initSubstructureSearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getSubstructureSearchQueryString()
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
    @initBrowserFromWSResults(resultsList, $browserContainer, $progressElement, undefined,
      glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SUBSTRUCTURE_HIGHLIGHTING,
      GlobalVariables.SEARCH_TERM)

  @initSimilaritySearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getSimilaritySearchQueryString()
    GlobalVariables.SIMILARITY_PERCENTAGE = URLProcessor.getSimilaritySearchPercentage()
    console.log 'initSimilaritySearchResults'
    queryParams =
      search_term: GlobalVariables.SEARCH_TERM
      similarity_percentage: GlobalVariables.SIMILARITY_PERCENTAGE

    $queryContainer = $('.BCK-query-Container')
    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      query_params: queryParams

    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsList()
    resultsList.initURL GlobalVariables.SEARCH_TERM, GlobalVariables.SIMILARITY_PERCENTAGE

    $progressElement = $('#BCK-loading-messages-container')
    $browserContainer = $('.BCK-BrowserContainer')
    @initBrowserFromWSResults(resultsList, $browserContainer, $progressElement, [Compound.COLUMNS.SIMILARITY_ELASTIC],
      glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SIMILARITY_MAPS,
      GlobalVariables.SEARCH_TERM)

  @initFlexmatchSearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getUrlPartInReversePosition(0)

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
    @initBrowserFromWSResults(resultsList, $browserContainer, $progressElement)

  @initBrowserFromWSResults = (resultsList, $browserContainer, $progressElement, contextualColumns, customSettings,
    searchTerm) ->

    deferreds = resultsList.getAllResults($progressElement, askingForOnlySelected=false, onlyFirstThousand=true,
    customBaseProgressText='Searching...')

    # for now, we need to jump from web services to elastic
    $.when.apply($, deferreds).done(->


      esCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(undefined,
        resultsList.allResults, contextualColumns, customSettings, searchTerm)

      new glados.views.Browsers.BrowserMenuView
        collection: esCompoundsList
        el: $browserContainer

      esCompoundsList.fetch()

    ).fail((msg) ->

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

