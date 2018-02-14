glados.useNameSpace 'glados.apps.Embedding',
  EmbeddingApp: class EmbeddingApp

    @init = ->

      new glados.apps.Embedding.EmbeddingRouter
      Backbone.history.start()

    @loadHTMLSection: (sectionLoadURL, successCallBack) ->

      $embedContentContainer = $('#BCK-embedded-content')
      console.log '$embedContentContainer: ', $embedContentContainer

      glados.Utils.fillContentForElement($embedContentContainer, {
        msg: 'Loading section html...'
      }, 'Handlebars-Common-Preloader')

      $embedContentContainer.load sectionLoadURL, ( response, status, xhr ) ->
        if ( status == "error" )
          glados.Utils.fillContentForElement($embedContentContainer, {
            msg: 'There was an error loading the html content'
          }, 'Handlebars-Common-CardError')
        else
          successCallBack()

    @requiredHTMLTemplatesURLS:
      "#{Compound.reportCardPath}":
        'name_and_classification':
          template: "#{glados.Settings.GLADOS_BASE_PATH_REL}#{Compound.reportCardPath}{{chembl_id}} #CNCCard"
          initFunction: CompoundReportCardApp.initNameAndClassification

    @initReportCardSection: (reportCardPath, chemblID, sectionName) ->

      requiredHTMLURLTempl = @requiredHTMLTemplatesURLS["#{reportCardPath}/"][sectionName].template
      requiredHTMLURL = Handlebars.compile(requiredHTMLURLTempl)
        chembl_id: chemblID
      initFunction = @requiredHTMLTemplatesURLS["#{reportCardPath}/"][sectionName].initFunction
      GlobalVariables['CURRENT_MODEL_CHEMBL_ID'] = chemblID

      @loadHTMLSection(requiredHTMLURL, initFunction)

      console.log 'init report card section!'
      console.log 'reportCardPath: ', reportCardPath
      console.log 'chemblID: ', chemblID
      console.log 'sectionName: ', sectionName
      console.log '@requiredHTMLTemplatesURLS: ', requiredHTMLURL

