glados.useNameSpace 'glados.apps.Main',
  MainGladosApp: class ActivitiesBrowserApp

    @hideMainSplashScreen = -> $('#GladosMainSplashScreen').hide()
    @showMainGladosContent = -> $('#GladosMainContent').show()

    @baseTemplates:
      main_page: 'Handlebars-MainPageLayout'

    @init = ->

      new glados.routers.MainGladosRouter
      Backbone.history.start()

    @prepareContentFor = (pageName) ->

      templateName = @baseTemplates[pageName]
      $gladosMainContent = $('#GladosMainContent')

      glados.Utils.fillContentForElement($gladosMainContent, {}, templateName)
      @hideMainSplashScreen()
      @showMainGladosContent()

    @initMainPage = ->

      @prepareContentFor('main_page')
      MainPageApp.init()





