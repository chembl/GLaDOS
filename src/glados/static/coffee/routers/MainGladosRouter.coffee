glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'
    initMainPage: ->

      console.log 'THIS CAME FROM THE ROUTER!!!'
