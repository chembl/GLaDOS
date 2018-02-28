glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'
      'search_results(/:search_term)': 'initSearchResults'
      'substructure_search_results(/:search_term)': 'initSubstructureSearchResults'
      'browse/:entity_name(/filter/:filter)(/state/:state)': 'initBrowser'

    initMainPage: -> glados.apps.Main.MainGladosApp.initMainPage()
    initSearchResults: (searchTerm) -> glados.apps.Main.MainGladosApp.initSearchResults(searchTerm)
    initSubstructureSearchResults: (searchTerm) ->
      glados.apps.Main.MainGladosApp.initSubstructureSearchResults(searchTerm)
    initBrowser: (entityName, filter, state) ->
      glados.apps.Main.MainGladosApp.initBrowserForEntity(entityName, filter, state)

