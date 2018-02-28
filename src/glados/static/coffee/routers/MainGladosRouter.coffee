glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'
      'search_results(/:search_term)': 'initSearchResults'

    initMainPage: -> glados.apps.Main.MainGladosApp.initMainPage()
    initSearchResults: (searchTerm) -> glados.apps.Main.MainGladosApp.initSearchResults(searchTerm)

