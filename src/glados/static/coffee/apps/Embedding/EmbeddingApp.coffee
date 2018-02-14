glados.useNameSpace 'glados.apps.Embedding',
  EmbeddingApp: class EmbeddingApp

    @init = ->

      new glados.apps.Embedding.EmbeddingRouter
      Backbone.history.start()

    @loadHTMLSection: (successCallBack) ->

      $embedContentContainer = $('#BCK-embedded-content')
      console.log '$embedContentContainer: ', $embedContentContainer

      glados.Utils.fillContentForElement($embedContentContainer, {
        msg: 'Loading section html...'
      }, 'Handlebars-Common-Preloader')

    @requiredHTMLTemplatesURLS:
      "#{Compound.reportCardPath}":
        'name_and_classification':
          template: "#{glados.Settings.GLADOS_BASE_PATH_REL}#{Compound.reportCardPath}{{chembl_id}}"

    @initReportCardSection: (reportCardPath, chemblID, sectionName) ->

      requiredHTMLURLTempl = @requiredHTMLTemplatesURLS["#{reportCardPath}/"][sectionName].template
      requiredHTMLURL = Handlebars.compile(requiredHTMLURLTempl)
        chembl_id: chemblID

      @loadHTMLSection()
      console.log 'init report card section!'
      console.log 'reportCardPath: ', reportCardPath
      console.log 'chemblID: ', chemblID
      console.log 'sectionName: ', sectionName
      console.log '@requiredHTMLTemplatesURLS: ', requiredHTMLURL

