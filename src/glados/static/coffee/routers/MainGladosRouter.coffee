glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'
      'search_results(/:search_term)': 'initSearchResults'
      'browse/:entity_name(/filter/:filter)(/state/:state)': 'initBrowser'

    initMainPage: -> glados.apps.Main.MainGladosApp.initMainPage()
    initSearchResults: (searchTerm) -> glados.apps.Main.MainGladosApp.initSearchResults(searchTerm)
    initBrowser: (entityName, filter, state) ->
      glados.apps.Main.MainGladosApp.initBrowserForEntity(entityName, filter, state)

