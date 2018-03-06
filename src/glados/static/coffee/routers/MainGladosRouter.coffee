glados.useNameSpace 'glados.routers',
  MainGladosRouter: Backbone.Router.extend
    routes:
      '': 'initMainPage'
      'search_results(/:search_term)': 'initSearchResults'
      'substructure_search_results/:search_term': 'initSubstructureSearchResults'
      'similarity_search_results/:search_term/:threshold': 'initSimilaritySearchResults'
      'flexmatch_search_results/:search_term': 'initFlexmatchSearchResults'
      'browse/:entity_name(/filter/:filter)(/state/:state)': 'initBrowser'
      'report_card/:entity_name/:chembl_id': 'initReportCard'

    initMainPage: -> glados.apps.Main.MainGladosApp.initMainPage()

    initSearchResults: (searchTerm) -> glados.apps.Main.MainGladosApp.initSearchResults(searchTerm)
    initSubstructureSearchResults: (searchTerm) ->
      glados.apps.Main.MainGladosApp.initSubstructureSearchResults(searchTerm)
    initSimilaritySearchResults: (searchTerm, threshold) ->
      glados.apps.Main.MainGladosApp.initSimilaritySearchResults(searchTerm, threshold)
    initFlexmatchSearchResults: (searchTerm) ->
      glados.apps.Main.MainGladosApp.initFlexmatchSearchResults(searchTerm)

    initBrowser: (entityName, filter, state) ->
      glados.apps.Main.MainGladosApp.initBrowserForEntity(entityName, filter, state)

    initReportCard: (entityName, chemblID) ->
      glados.apps.Main.MainGladosApp.initReportCard(entityName, chemblID)

