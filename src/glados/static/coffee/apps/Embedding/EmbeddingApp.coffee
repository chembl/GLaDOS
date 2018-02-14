glados.useNameSpace 'glados.apps.Embedding',
  EmbeddingApp: class EmbeddingApp

    @init = ->

      new glados.apps.Embedding.EmbeddingRouter
      Backbone.history.start()

    @loadHTMLSection: (sectionLoadURL, successCallBack) ->

      $embedContentContainer = $('#BCK-embedded-content')

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

    @compoundReportCardBaseTemplate = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{Compound.reportCardPath}{{chembl_id}}"
    @requiredHTMLTemplatesURLS:
      "#{Compound.reportCardPath}":
        name_and_classification:
          template: "#{@compoundReportCardBaseTemplate} #CNCCard"
          initFunction: CompoundReportCardApp.initNameAndClassification
        representations:
          template: "#{@compoundReportCardBaseTemplate} #CompRepsCard"
          initFunction: CompoundReportCardApp.initRepresentations

    @initReportCardSection: (reportCardPath, chemblID, sectionName) ->

      requiredHTMLURLTempl = @requiredHTMLTemplatesURLS["#{reportCardPath}/"][sectionName].template
      requiredHTMLURL = Handlebars.compile(requiredHTMLURLTempl)
        chembl_id: chemblID
      initFunction = @requiredHTMLTemplatesURLS["#{reportCardPath}/"][sectionName].initFunction
      GlobalVariables['CURRENT_MODEL_CHEMBL_ID'] = chemblID

      @loadHTMLSection(requiredHTMLURL, initFunction)
