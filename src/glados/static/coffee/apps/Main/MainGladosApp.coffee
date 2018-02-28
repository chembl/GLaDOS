glados.useNameSpace 'glados.apps.Main',
  MainGladosApp: class ActivitiesBrowserApp

    @hideMainSplashScreen = -> $('#GladosMainSplashScreen').hide()
    @showMainGladosContent = -> $('#GladosMainContent').show()

    @baseTemplates:
      main_page: 'Handlebars-MainPageLayout'
      search_results: 'Handlebars-SearchResultsLayout'
      browser: 'Handlebars-MainBrowserContent'

    @init = ->

      new glados.routers.MainGladosRouter
      Backbone.history.start()

    @prepareContentFor = (pageName) ->

      alert('perpare content for: ' + pageName)
      templateName = @baseTemplates[pageName]
      $gladosMainContent = $('#GladosMainContent')

      glados.Utils.fillContentForElement($gladosMainContent, {}, templateName)
      @hideMainSplashScreen()
      @showMainGladosContent()

    # ------------------------------------------------------------------------------------------------------------------
    # Main page
    # ------------------------------------------------------------------------------------------------------------------
    @initMainPage = ->

      @prepareContentFor('main_page')
      MainPageApp.init()

    # ------------------------------------------------------------------------------------------------------------------
    # Search Results
    # ------------------------------------------------------------------------------------------------------------------
    @initSearchResults = (searchTerm) ->

      @prepareContentFor('search_results')
      SearchResultsApp.init()

    # ------------------------------------------------------------------------------------------------------------------
    # Entity Browsers
    # ------------------------------------------------------------------------------------------------------------------
    @initBrowserForEntity = (entityName, filter, state) ->

      @prepareContentFor('browser')
      glados.apps.Browsers.BrowserApp.initBrowserForEntity(entityName, filter, state)







