glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'

    initMainPage: -> glados.apps.Main.MainGladosApp.initMainPage()

