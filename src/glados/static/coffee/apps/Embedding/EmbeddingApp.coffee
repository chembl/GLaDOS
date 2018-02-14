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
        sources:
          template: "#{@compoundReportCardBaseTemplate} #CSourcesCard"
          initFunction: CompoundReportCardApp.initSources
        alternate_forms:
          template: "#{@compoundReportCardBaseTemplate} #AlternateFormsCard"
          initFunction: CompoundReportCardApp.initAlternateForms
        similar:
          template: "#{@compoundReportCardBaseTemplate} #SimilarCompoundsCard"
          initFunction: CompoundReportCardApp.initSimilarCompounds
        molecule_features:
          template: "#{@compoundReportCardBaseTemplate} #MoleculeFeaturesCard"
          initFunction: CompoundReportCardApp.initMoleculeFeatures
        withdrawal_info:
          template: "#{@compoundReportCardBaseTemplate} #CWithdrawnInfoCard"
          initFunction: CompoundReportCardApp.initWithdrawnInfo
        mechanism_of_action:
          template: "#{@compoundReportCardBaseTemplate} #MechOfActCard"
          initFunction: CompoundReportCardApp.initMechanismOfAction
        drug_indications:
          template: "#{@compoundReportCardBaseTemplate} #CDrugIndicationsCard"
          initFunction: CompoundReportCardApp.initIndications
        clinical_data:
          template: "#{@compoundReportCardBaseTemplate} #ClinDataCard"
          initFunction: CompoundReportCardApp.initClinicalData
        metabolism:
          template: "#{@compoundReportCardBaseTemplate} #MetabolismCard"
          initFunction: CompoundReportCardApp.initMetabolism
        helm_notation:
          template: "#{@compoundReportCardBaseTemplate} #CHELMNotationCard"
          initFunction: CompoundReportCardApp.initHELMNotation
        biocomponents:
          template: "#{@compoundReportCardBaseTemplate} #CBioseqCard"
          initFunction: CompoundReportCardApp.initBioSeq
        related_activities:
          template: "#{@compoundReportCardBaseTemplate} #CAssociatedActivitiesCard"
          initFunction: CompoundReportCardApp.initActivitySummary
        related_assays:
          template: "#{@compoundReportCardBaseTemplate} #CAssociatedAssaysCard"
          initFunction: CompoundReportCardApp.initAssaySummary
        related_targets:
          template: "#{@compoundReportCardBaseTemplate} #CAssociatedTargetsCard"
          initFunction: CompoundReportCardApp.initTargetSummary
        target_predictions:
          template: "#{@compoundReportCardBaseTemplate} #CTargetPredictionsCard"
          initFunction: CompoundReportCardApp.initTargetPredictions
        calculated_properties:
          template: "#{@compoundReportCardBaseTemplate} #CalculatedParentPropertiesCard"
          initFunction: CompoundReportCardApp.initCalculatedCompoundParentProperties

    @initReportCardSection: (reportCardPath, chemblID, sectionName) ->

      requiredHTMLURLTempl = @requiredHTMLTemplatesURLS["#{reportCardPath}/"][sectionName].template
      requiredHTMLURL = Handlebars.compile(requiredHTMLURLTempl)
        chembl_id: chemblID
      initFunction = @requiredHTMLTemplatesURLS["#{reportCardPath}/"][sectionName].initFunction
      GlobalVariables['CURRENT_MODEL_CHEMBL_ID'] = chemblID

      console.log 'reportCardPath: ', reportCardPath
      console.log 'chemblID: ', chemblID
      console.log 'sectionName: ', sectionName
      @loadHTMLSection(requiredHTMLURL, initFunction)
