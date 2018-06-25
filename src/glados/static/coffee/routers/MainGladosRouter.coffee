glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'
      'search_results(/:current_tab)(/query=:search_term)(/state=:search_term)': 'initSearchResults'
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

    #-------------------------------------------------------------------------------------------------------------------
    # Report Cards
    #-------------------------------------------------------------------------------------------------------------------
    initReportCard: (entityName, chemblID) ->
      glados.apps.Main.MainGladosApp.initReportCard(entityName, chemblID)
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
      url += "#search_results/#{tab}"
      if searchTerm? and _.isString(searchTerm) and searchTerm.trim().length > 0
       url += "/query=" + encodeURIComponent(searchTerm)
      if currentState?
       url += "/state=#{currentState}"
      return url

    updateSearchURL: (esEntityKey, searchTerm, currentState, trigger=false) ->

      tabLabelPrefix = ''
      if glados.models.paginatedCollections.Settings.ES_INDEXES[esEntityKey]?
        tabLabelPrefix = glados.models.paginatedCollections.Settings.ES_INDEXES[esEntityKey].LABEL
      breadcrumbLinks = [
        {
          label: (tabLabelPrefix+' Search Results').trim()
          link: @getSearchURL(esEntityKey, null, null)
          truncate: true
        }
      ]
      if searchTerm?
        breadcrumbLinks.push(
          {
            label: searchTerm
            link: @getSearchURL(esEntityKey, searchTerm, null)
            truncate: true
          }
        )

      # This makes sure that the url and the breadcrumbs are correct. It is the job of the SearchResultsView to
      # to show the correct tab.
      newSearchURL = @getSearchURL(esEntityKey, searchTerm, currentState, true)
      window.history.pushState({}, 'Search Results', newSearchURL)
      glados.apps.BreadcrumbApp.setBreadCrumb(breadcrumbLinks, longFilter=undefined,
          hideShareButton=false, askBeforeShortening=true)

    triggerSearchURL: (esEntityKey, searchTerm, currentState) ->
      #this puts the search url in the bar and navigates to it
      newSearchURL = @getSearchURL(esEntityKey, searchTerm, currentState)
      window.history.pushState({}, 'Search Results', newSearchURL)

      isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent)
      if not isSafari
        window.history.go()
      else
        location.reload(true)

    validateAndParseSearchURL: (tab, searchTerm, state)->
      selectedESEntity = null
      if _.has(glados.Settings.SEARCH_PATH_2_ES_KEY, tab)
        selectedESEntity = glados.Settings.SEARCH_PATH_2_ES_KEY[tab]
      if tab != 'all' and not _.has(glados.Settings.SEARCH_PATH_2_ES_KEY, tab)
        if not searchTerm?
          searchTerm = tab
      return [selectedESEntity, searchTerm, state]


