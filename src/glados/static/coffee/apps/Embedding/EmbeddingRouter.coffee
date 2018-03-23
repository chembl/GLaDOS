glados.useNameSpace 'glados.apps.Embedding',
  EmbeddingRouter: Backbone.Router.extend
    routes:
      ":report_card_path/:chembl_id/:section_name(/)": 'initReportCardSection'
      "GLaDOS": 'summonMe'
      ':visualisation_path': 'initVisualisation'
      'view_for_collection/:view_type/state/:state': 'initVIewForCollection'

    initReportCardSection: (reportCardPath, chemblID, sectionName) ->
      glados.apps.Embedding.EmbeddingApp.initReportCardSection(reportCardPath, chemblID, sectionName)
    summonMe: ->
      glados.apps.Embedding.EmbeddingApp.summonMe()
    initVisualisation: (visualisationPath) ->
      glados.apps.Embedding.EmbeddingApp.initVisualisation(visualisationPath)
    initVIewForCollection: (viewType, state) ->
      glados.apps.Embedding.EmbeddingApp.initVIewForCollection(viewType, state)
