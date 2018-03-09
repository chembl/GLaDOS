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


      console.log 'glados.Settings.ES_KEY_2_SEARCH_PATH: ', glados.Settings.ES_KEY_2_SEARCH_PATH
      #use the reverse of glados.Settings.ES_KEY_2_SEARCH_PATH defined by JF in settings
      reverseDict = {}
      for key, val of glados.Settings.ES_KEY_2_SEARCH_PATH
        reverseDict[val] = key

      console.log 'reverseDict: ', reverseDict

      seeAllLabel = glados.models.paginatedCollections.Settings.ES_INDEXES[reverseDict[entityName]].LABEL
      breadcrumbLinks = [
        {
          label: seeAllLabel
          link: Compound.getCompoundsListURL()
        }
      ]
      console.log 'breadcrumbLinks: ', breadcrumbLinks
      glados.apps.BreadcrumbApp.setBreadCrumb()
      @prepareContentFor('browser')
      glados.apps.Browsers.BrowserApp.initBrowserForEntity(entityName, filter, state)

    # ------------------------------------------------------------------------------------------------------------------
    # Report Cards
    # ------------------------------------------------------------------------------------------------------------------
    @initReportCard = (entityName, chemblID) ->

      console.log 'INIT REPORT CARD'







