glados.useNameSpace 'glados.apps.Main',
  MainGladosApp: class ActivitiesBrowserApp

    @showMainSplashScreen = -> $('#GladosMainSplashScreen').show()
    @hideMainSplashScreen = -> #$('#GladosMainSplashScreen').hide()
    @showMainGladosContent = -> $('#GladosMainContent').show()

    @baseTemplates:
      main_page: 'Handlebars-MainPageLayout'
      search_results: 'Handlebars-SearchResultsLayout'
      structure_search_results: 'Handlebars-SubstructureSearchResultsLayout'
      browser: 'Handlebars-MainBrowserContent'

    @init = ->

      mainRouter = new glados.routers.MainGladosRouter

      #now if there are shortened params
      shortenedURL = $('#GladosShortenedParamsContainer').attr('data-shortened-params')
      if shortenedURL != ''

        Backbone.history.start({silent: true})
        window.history.pushState({}, '', glados.Settings.GLADOS_BASE_PATH_REL+glados.Settings.NO_SIDE_NAV_PLACEHOLDER)
        mainRouter.navigate(shortenedURL, {trigger: true})
      else
        Backbone.history.start()

    @setUpLinkShortenerListener = (containerElem) ->

      mutationCallback = (mutationsList) ->

        for mutation in mutationsList
          addedNodes = mutation.addedNodes
          for node in addedNodes
            $node = $(node)
            # check for the current added node
            isAnchor = node.nodeName == 'A'
            if isAnchor
              glados.Utils.URLS.shortenHTMLLinkIfNecessary($node)

            # and also check for check for the added node's descendants
            $node.find('a').each (index) -> glados.Utils.URLS.shortenHTMLLinkIfNecessary($(@))

      mutObserver = new MutationObserver(mutationCallback)
      observationConfig =
        childList: true
        subtree: true

      mutObserver.observe(containerElem, observationConfig)

    @prepareContentFor = (pageName, templateParams={}) ->

      #make sure splash screen is shown, specially useful when it changes urls without using the server
      @showMainSplashScreen()
      templateName = @baseTemplates[pageName]
      $gladosMainContent = $('#GladosMainContent')
      $gladosMainContent.empty()
      @setUpLinkShortenerListener($gladosMainContent[0])

      glados.Utils.fillContentForElement($gladosMainContent, templateParams, templateName)
#      @hideMainSplashScreen()
      @showMainGladosContent()

    # ------------------------------------------------------------------------------------------------------------------
    # Main page
    # ------------------------------------------------------------------------------------------------------------------
    @initMainPage = ->

      glados.apps.BreadcrumbApp.setBreadCrumb()
      @prepareContentFor('main_page')
      MainPageApp.init()

    # ------------------------------------------------------------------------------------------------------------------
    # Search Results
    # ------------------------------------------------------------------------------------------------------------------
    @initSearchResults = (searchTerm) ->

      @prepareContentFor('search_results')
      SearchResultsApp.init(searchTerm)

    @initSubstructureSearchResults = (searchTerm) ->

      templateParams =
        type: 'Substructure'
      @prepareContentFor('structure_search_results', templateParams)
      SearchResultsApp.initSubstructureSearchResults(searchTerm)

    @initSimilaritySearchResults = (searchTerm, threshold) ->

      templateParams =
        type: 'Similarity'
      @prepareContentFor('structure_search_results', templateParams)
      SearchResultsApp.initSimilaritySearchResults(searchTerm, threshold)

    @initFlexmatchSearchResults = (searchTerm) ->

      templateParams =
        type: ''
      @prepareContentFor('structure_search_results', templateParams)
      SearchResultsApp.initFlexmatchSearchResults(searchTerm)

    # ------------------------------------------------------------------------------------------------------------------
    # Entity Browsers
    # ------------------------------------------------------------------------------------------------------------------
    @initBrowserForEntity = (entityName, filter, state) ->

      reverseDict = {}
      for key, val of glados.Settings.ES_KEY_2_SEARCH_PATH
        reverseDict[val] = key

      reverseDict.activities = 'ACTIVITY'
      # use dict created by jf
      dictKey = reverseDict[entityName]

      if entityName != 'activities'
        listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES[dictKey]
      else
        listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH[dictKey]

      breadcrumbLinks = [
        {
          label: listConfig.LABEL
          link: listConfig.BROWSE_LIST_URL()
        }
        {
          label: filter
          link: listConfig.BROWSE_LIST_URL(filter)
          is_filter_link: true
          truncate: true
        }
      ]

      glados.apps.BreadcrumbApp.setBreadCrumb(breadcrumbLinks)
      @prepareContentFor('browser')
      glados.apps.Browsers.BrowserApp.initBrowserForEntity(entityName, filter, state)

    # ------------------------------------------------------------------------------------------------------------------
    # Report Cards
    # ------------------------------------------------------------------------------------------------------------------
    @initReportCard = (entityName, chemblID) ->

      console.log 'INIT REPORT CARD'







