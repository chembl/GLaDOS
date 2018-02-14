glados.useNameSpace 'glados.apps.Embedding',
  EmbeddingRouter: Backbone.Router.extend
    routes:
      ":report_card_path/:chembl_id/:section_name/": 'initReportCardSection'

    initReportCardSection: (reportCardPath, chemblID, sectionName) ->

      console.log 'init report card section!'
      console.log 'reportCardPath: ', reportCardPath
      console.log 'chemblID: ', chemblID
      console.log 'sectionName: ', sectionName