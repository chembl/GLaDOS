glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'
      'search_results(/:current_tab)(/query/:search_term)(/state/:search_term)': 'initSearchResults'
      'substructure_search_results/:search_term': 'initSubstructureSearchResults'
      'similarity_search_results/:search_term/:threshold': 'initSimilaritySearchResults'
      'flexmatch_search_results/:search_term': 'initFlexmatchSearchResults'
      'browse/:entity_name(/filter/:filter)(/state/:state)': 'initBrowser'

    execute: (callback, args, name) ->
      # Always reset the value of this variable on navigation
      GlobalVariables.atSearchResultsPage = false
      if callback?
        callback.apply(@, args)

    initMainPage: -> glados.apps.Main.MainGladosApp.initMainPage()

    initSearchResults: (currentTab, searchTerm, currentState) ->
      [currentTab, searchTerm, currentState] = \
        glados.routers.MainGladosRouter.updateAndCorrectSearchURL(currentTab, searchTerm, currentState)
      GlobalVariables.atSearchResultsPage = true
      glados.apps.Main.MainGladosApp.initSearchResults(searchTerm)

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

    getSearchURL: (esEntity, searchTerm, currentState)->
      tab = 'all'
      if esEntity? and _.has(glados.Settings.ES_KEY_2_SEARCH_PATH, esEntity)
        tab = glados.Settings.ES_KEY_2_SEARCH_PATH[esEntity]
      url = "#{glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL}/search_results/#{tab}"
      if searchTerm?
       url += "/query/#{searchTerm}"
      if currentState?
       url += "/state/#{currentState}"
      return url

    updateAndCorrectSearchURL: (tab, searchTerm, state)->
      if tab != 'all' and not _.has(glados.Settings.SEARCH_PATH_2_ES_KEY, tab)
        if not searchTerm?
          searchTerm = tab
        tab = 'all'
      fragment = "search_results/#{tab}"
      if searchTerm?
       fragment += "/query/#{searchTerm}"
      if state?
       fragment += "/state/#{state}"
      glados.routers.MainGladosRouter.getInstance().navigate(fragment)
      return [tab, searchTerm, state]

