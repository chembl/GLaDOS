glados.useNameSpace 'glados.apps.Main',
  MainGladosApp: class ActivitiesBrowserApp

    @hideMainSplashScreen = -> $('#GladosMainSplashScreen').hide()
    @showMainGladosContent = -> $('#GladosMainContent').show()

    
    @init = ->

      console.log 'INIT MAIN APP!!'

      new glados.routers.MainGladosRouter
      Backbone.history.start()

      @hideMainSplashScreen()
      @showMainGladosContent()
      console.log 'everything is shown!!'



