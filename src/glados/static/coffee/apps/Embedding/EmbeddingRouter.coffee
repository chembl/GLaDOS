glados.useNameSpace 'glados.apps.Embedding',
  EmbeddingRouter: Backbone.Router.extend
    routes:
      "GLaDOS": 'summonMe'
      ':visualisation_path': 'initVisualisation'
      'view_for_collection/:view_type/state/:state': 'initViewForCollection'
      'mini_report_card/:entity_type/:chembl_id': 'initMiniReportCard'

    initReportCardSection: (reportCardPath, chemblID, sectionName) ->
      glados.apps.Embedding.EmbeddingApp.initReportCardSection(reportCardPath, chemblID, sectionName)
    summonMe: ->
      glados.apps.Embedding.EmbeddingApp.summonMe()
    initVisualisation: (visualisationPath) ->
      glados.apps.Embedding.EmbeddingApp.initVisualisation(visualisationPath)
    initViewForCollection: (viewType, state) ->
      glados.apps.Embedding.EmbeddingApp.initVIewForCollection(viewType, decodeURIComponent(state))
    initMiniReportCard: (entityType, chemblID) ->
      glados.apps.Embedding.EmbeddingApp.initMiniReportCard(entityType, chemblID)
