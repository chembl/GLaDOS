glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'
      'search_results(/:current_tab)(/query/:search_term)(/state/:search_term)': 'initSearchResults'
      'substructure_search_results/:search_term': 'initSubstructureSearchResults'
      'similarity_search_results/:search_term/:threshold': 'initSimilaritySearchResults'
      'flexmatch_search_results/:search_term': 'initFlexmatchSearchResults'
      'browse/:entity_name(/filter/:filter)(/state/:state)': 'initBrowser'
      'report_card/:entity_name/:chembl_id': 'initReportCard'

    execute: (callback, args, name) ->
      # Always reset the value of this variable on navigation
      GlobalVariables.atSearchResultsPage = false
      if callback?
        callback.apply(@, args)

    initMainPage: -> glados.apps.Main.MainGladosApp.initMainPage()

    initSearchResults: (currentTab, searchTerm, currentState) ->
      [selectedESEntity, searchTerm, currentState] = \
        glados.routers.MainGladosRouter.validateAndParseSearchURL(currentTab, searchTerm, currentState)
      glados.routers.MainGladosRouter.updateSearchURL(selectedESEntity, searchTerm, currentState)
      GlobalVariables.atSearchResultsPage = true
      glados.apps.Main.MainGladosApp.initSearchResults(selectedESEntity, searchTerm, currentState)

    initSubstructureSearchResults: (searchTerm) ->
      glados.apps.Main.MainGladosApp.initSubstructureSearchResults(searchTerm)

    initSimilaritySearchResults: (searchTerm, threshold) ->
      glados.apps.Main.MainGladosApp.initSimilaritySearchResults(searchTerm, threshold)

    initFlexmatchSearchResults: (searchTerm) ->
      glados.apps.Main.MainGladosApp.initFlexmatchSearchResults(searchTerm)

    initBrowser: (entityName, filter, state) ->
      glados.apps.Main.MainGladosApp.initBrowserForEntity(entityName, filter, state)
  ,
    #-------------------------------------------------------------------------------------------------------------------
    # STATIC CONTEXT
    #-------------------------------------------------------------------------------------------------------------------

    getInstance: ()->
      if not glados.routers.MainGladosRouter._instance?
        glados.routers.MainGladosRouter._instance = new glados.routers.MainGladosRouter
      return glados.routers.MainGladosRouter._instance

    #-------------------------------------------------------------------------------------------------------------------
    # SEARCH HELPERS
    #-------------------------------------------------------------------------------------------------------------------

    getSearchURL: (esEntityKey, searchTerm, currentState, fragmentOnly=false)->
      tab = 'all'
      if esEntityKey? and _.has(glados.Settings.ES_KEY_2_SEARCH_PATH, esEntityKey)
        tab = glados.Settings.ES_KEY_2_SEARCH_PATH[esEntityKey]
      url = ''
      if not fragmentOnly
        url += glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL
      url += "/search_results/#{tab}"
      if searchTerm?
       url += "/query/" + encodeURIComponent(searchTerm)
      if currentState?
       url += "/state/#{currentState}"
      return url

    updateSearchURL: (esEntityKey, searchTerm, currentState, trigger=false)->
      glados.routers.MainGladosRouter.getInstance().navigate(
        @getSearchURL(esEntityKey, searchTerm, currentState, true),
        {
          'trigger': trigger
        }
      )

    validateAndParseSearchURL: (tab, searchTerm, state)->
      selectedESEntity = null
      if _.has(glados.Settings.SEARCH_PATH_2_ES_KEY, tab)
        selectedESEntity = glados.Settings.SEARCH_PATH_2_ES_KEY[tab]
      if tab != 'all' and not _.has(glados.Settings.SEARCH_PATH_2_ES_KEY, tab)
        if not searchTerm?
          searchTerm = tab
      return [selectedESEntity, searchTerm, state]

    initReportCard: (entityName, chemblID) ->
      glados.apps.Main.MainGladosApp.initReportCard(entityName, chemblID)

