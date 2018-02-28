glados.useNameSpace 'glados.apps.Main',
  MainGladosApp: class ActivitiesBrowserApp

    @hideMainSplashScreen = -> $('#GladosMainSplashScreen').hide()
    @showMainGladosContent = -> $('#GladosMainContent').show()

    @baseTemplates:
      main_page: 'Handlebars-MainPageLayout'
      search_results: 'Handlebars-SearchResultsLayout'

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

    @initMainPage = ->

      @prepareContentFor('main_page')
      MainPageApp.init()

    @initSearchResults = (searchTerm) ->

      @prepareContentFor('search_results')
      SearchResultsApp.init()







