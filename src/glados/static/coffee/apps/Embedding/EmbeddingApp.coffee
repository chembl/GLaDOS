glados.useNameSpace 'glados.apps.Embedding',
  EmbeddingApp: class EmbeddingApp

    @init = ->

      embedRouter = new glados.apps.Embedding.EmbeddingRouter

      #check if there are shortened params
      shortenedURL = $('#GladosShortenedParamsContainer').attr('data-shortened-params')
      if shortenedURL != ''

        Backbone.history.start({silent: true})
        window.history.pushState({}, '', "#{glados.Settings.GLADOS_BASE_PATH_REL}embed/")
        embedRouter.navigate(shortenedURL, {trigger: true})
      else
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

    @loadHTMLSectionInScript: (inScriptConfig, initFunction, initFunctionParams) ->

      templateToLoad = inScriptConfig.script_id
      $contentFromScriptsContainer = $('#BCK-content-from-scripts')
      glados.Utils.fillContentForElement $contentFromScriptsContainer, {}, templateToLoad
      itemFromTemplateID = inScriptConfig.elem_id
      if not itemFromTemplateID?
        $baseElement = $($contentFromScriptsContainer.html())
      else
        $baseElement = $contentFromScriptsContainer.find("##{itemFromTemplateID}")

      $embedContentContainer = $('#BCK-embedded-content')
      $embedContentContainer.append($baseElement)

      initFunction(initFunctionParams)
      return

    @compoundReportCardBaseTemplate = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{Compound.reportCardPath}{{chembl_id}}"
    @targetReportCardBaseTemplate = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{Target.reportCardPath}{{chembl_id}}"
    @assayReportCardBaseTemplate = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{Assay.reportCardPath}{{chembl_id}}"
    @documentReportCardBaseTemplate = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{Document.reportCardPath}{{chembl_id}}"
    @documentReportCardBaseTemplate = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{Document.reportCardPath}{{chembl_id}}"
    @cellLineReportCardBaseTemplate = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{CellLine.reportCardPath}{{chembl_id}}"
    @tissueReportCardBaseTemplate = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{glados.models.Tissue.reportCardPath}{{chembl_id}}"
    @requiredHTMLTemplatesURLSReportCards:
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
        papers_per_year:
          template: "#{@compoundReportCardBaseTemplate} #PapersAboutCompoundPerYear"
          initFunction: CompoundReportCardApp.initPapersAboutCompound
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
        structural_alerts:
          template: "#{@compoundReportCardBaseTemplate} #CStructuralAlertsCard"
          initFunction: CompoundReportCardApp.initStructuralAlerts
        cross_refs:
          template: "#{@compoundReportCardBaseTemplate} #CrossReferencesCard"
          initFunction: CompoundReportCardApp.initCrossReferences
        unichem_cross_refs:
          template: "#{@compoundReportCardBaseTemplate} #UniChemCrossReferencesCard"
          initFunction: CompoundReportCardApp.initUniChemCrossReferences
        unichem_connectivity_matches:
          template: "#{@compoundReportCardBaseTemplate} #CUnichemConnectivityMatchesCard"
          initFunction: CompoundReportCardApp.initUnichemConnectivityMatches
      "#{Target.reportCardPath}":
        name_and_classification:
          template: "#{@targetReportCardBaseTemplate} #TNameClassificationCard"
          initFunction: TargetReportCardApp.initTargetNameAndClassification
        components:
          template: "#{@targetReportCardBaseTemplate} #TComponentsCard"
          initFunction: TargetReportCardApp.initTargetComponents
        relations:
          template: "#{@targetReportCardBaseTemplate} #TRelationsCard"
          initFunction: TargetReportCardApp.initTargetRelations
        approved_drugs_clinical_candidates:
          template: "#{@targetReportCardBaseTemplate} #ApprovedDrugsAndClinicalCandidatesCard"
          initFunction: TargetReportCardApp.initApprovedDrugsClinicalCandidates
        bioactivities:
          template: "#{@targetReportCardBaseTemplate} #TAssociatedBioactivitiesCard"
          initFunction: TargetReportCardApp.initBioactivities
        associated_assays:
          template: "#{@targetReportCardBaseTemplate} #TAssociatedAssaysCard"
          initFunction: TargetReportCardApp.initAssociatedAssays
        ligand_efficiencies:
          template: "#{@targetReportCardBaseTemplate} #TLigandEfficienciesCard"
          initFunction: TargetReportCardApp.initLigandEfficiencies
        associated_compounds:
          template: "#{@targetReportCardBaseTemplate} #TAssociatedCompoundProperties"
          initFunction: TargetReportCardApp.initAssociatedCompounds
        gene_cross_refs:
          template: "#{@targetReportCardBaseTemplate} #TGeneCrossReferencesCard"
          initFunction: TargetReportCardApp.initGeneCrossReferences
        protein_cross_refs:
          template: "#{@targetReportCardBaseTemplate} #TProteinCrossReferencesCard"
          initFunction: TargetReportCardApp.initProteinCrossReferences
        domain_cross_refs:
          template: "#{@targetReportCardBaseTemplate} #TDomainCrossReferencesCard"
          initFunction: TargetReportCardApp.initDomainCrossReferences
        structure_cross_refs:
          template: "#{@targetReportCardBaseTemplate} #TStructureCrossReferencesCard"
          initFunction: TargetReportCardApp.initStructureCrossReferences
      "#{Assay.reportCardPath}":
        basic_information:
          template: "#{@assayReportCardBaseTemplate} #ABasicInformation"
          initFunction: AssayReportCardApp.initAssayBasicInformation
        curation_summary:
          template: "#{@assayReportCardBaseTemplate} #ACurationSummaryCard"
          initFunction: AssayReportCardApp.initCurationSummary
        bioactivities:
          template: "#{@assayReportCardBaseTemplate} #AAssociatedBioactivitiesCard"
          initFunction: AssayReportCardApp.initActivitySummary
        associated_compounds:
          template: "#{@assayReportCardBaseTemplate} #AAssociatedCompoundProperties"
          initFunction: AssayReportCardApp.initAssociatedCompounds
      "#{Document.reportCardPath}":
        basic_information:
          template: "#{@documentReportCardBaseTemplate} #DBasicInformation"
          initFunction: DocumentReportCardApp.initBasicInformation
        assay_network:
          template: "#{@documentReportCardBaseTemplate} #DAssayNetworkCard"
          initFunction: DocumentReportCardApp.initAssayNetwork
        word_cloud:
          template: "#{@documentReportCardBaseTemplate} #DWordCloudCard"
          initFunction: DocumentReportCardApp.initWordCloud
        related_targets:
          template: "#{@documentReportCardBaseTemplate} #DAssociatedTargetsCard"
          initFunction: DocumentReportCardApp.initTargetSummary
        related_assays:
          template: "#{@documentReportCardBaseTemplate} #DAssociatedAssaysCard"
          initFunction: DocumentReportCardApp.initAssaySummary
        related_activities:
          template: "#{@documentReportCardBaseTemplate} #DAssociatedActivitiesCard"
          initFunction: DocumentReportCardApp.initActivitySummary
        related_documents:
          template: "#{@documentReportCardBaseTemplate} #CRelatedDocumentsCard"
          initFunction: DocumentReportCardApp.initRelatedDocuments

      "#{CellLine.reportCardPath}":
        basic_information:
          template: "#{@cellLineReportCardBaseTemplate} #CBasicInformation"
          initFunction: CellLineReportCardApp.initBasicInformation
        related_assays:
          template: "#{@cellLineReportCardBaseTemplate} #CAssociatedAssaysCard"
          initFunction: CellLineReportCardApp.initAssaySummary
        bioactivities:
          template: "#{@cellLineReportCardBaseTemplate} #CLAssociatedActivitiesCard"
          initFunction: CellLineReportCardApp.initActivitySummary
        related_compounds:
          template: "#{@cellLineReportCardBaseTemplate} #CLAssociatedCompoundProperties"
          initFunction: CellLineReportCardApp.initAssociatedCompounds
      "#{glados.models.Tissue.reportCardPath}":
        basic_information:
          template: "#{@tissueReportCardBaseTemplate} #TiBasicInformation"
          initFunction: TissueReportCardApp.initBasicInformation
        related_assays:
          template: "#{@tissueReportCardBaseTemplate} #TiAssociatedAssaysCard"
          initFunction: TissueReportCardApp.initAssaySummary
        bioactivities:
          template: "#{@tissueReportCardBaseTemplate} #TiAssociatedActivitiesCard"
          initFunction: TissueReportCardApp.initActivitySummary
        related_compounds:
          template: "#{@tissueReportCardBaseTemplate} #TiAssociatedCompoundsCard"
          initFunction: TissueReportCardApp.initAssociatedCompounds




    @initReportCardSection: (reportCardPath, chemblID, sectionName) ->

      requiredHTMLURLTempl = @requiredHTMLTemplatesURLSReportCards["#{reportCardPath}/"][sectionName].template
      requiredHTMLURL = Handlebars.compile(requiredHTMLURLTempl)
        chembl_id: chemblID
      initFunction = @requiredHTMLTemplatesURLSReportCards["#{reportCardPath}/"][sectionName].initFunction
      GlobalVariables['CURRENT_MODEL_CHEMBL_ID'] = chemblID

      @loadHTMLSection(requiredHTMLURL, initFunction)

    @summonMe: ->

      $embedContentContainer = $('#BCK-embedded-content')
      mySong = '<iframe width="560" height="315" src="https://www.youtube.com/embed/nfRlrV8awo0?showinfo=0" ' +
      'frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>'
      $embedContentContainer.html(mySong)

    @requiredHTMLTemplatesURLSVisualisations:
      documents_by_year_histogram:
        initFunction: MainPageApp.initDrugsPerUsanYear
        in_script:
          script_id: 'Handlebars-MainPageLayout'
          elem_id: 'PapersPerYearHistogram'
      targets_by_protein_class:
        initFunction: MainPageApp.initTargetsVisualisation
        in_script:
          script_id: 'Handlebars-MainPageLayout'
          elem_id: 'BCK-TargetBrowserAsCircles'
      max_phase_for_disease:
        initFunction: MainPageApp.initMaxPhaseForDisease
        in_script:
          script_id: 'Handlebars-MainPageLayout'
          elem_id: 'MaxPhaseForDisease'

    @initVisualisation: (visualisationPath) ->

      #I will use a template, just in case we need something more complex in the future
      embedConfig = @requiredHTMLTemplatesURLSVisualisations[visualisationPath]
      initFunction = embedConfig.initFunction
      inScriptConfig = embedConfig.in_script

      if not inScriptConfig?
        requiredHTMLURLTempl = embedConfig.template
        requiredHTMLURL = Handlebars.compile(requiredHTMLURLTempl)()
        @loadHTMLSection(requiredHTMLURL, initFunction)
      else
        @loadHTMLSectionInScript(inScriptConfig, initFunction)

    @requiredHTMLTemplatesURLSVisualisationsForCollection:
      heatmap:
        initFunction: glados.views.SearchResults.ESResultsBioactivitySummaryView.initEmbedded
        in_script:
          script_id: 'Handlebars-Common-ESResultsListHeatmapView'
      plot:
        initFunction: glados.views.SearchResults.ESResultsGraphView.initEmbedded
        in_script:
          script_id: 'Handlebars-Common-ESResultsListGraphView'
      cards:
        initFunction: glados.views.PaginatedViews.PaginatedViewFactory.initPaginatedCardsEmbedded
        in_script:
          script_id: 'Handlebars-Common-ESResultsListCardsView'
      infinite:
        initFunction: glados.views.PaginatedViews.PaginatedViewFactory.initInfiniteCardsEmbedded
        in_script:
          script_id: 'Handlebars-Common-ESResultsListInfiniteView'
      table:
        initFunction: glados.views.PaginatedViews.PaginatedViewFactory.initInfiniteTableEmbedded
        in_script:
          script_id: 'Handlebars-Common-ESResultsListTableView'

    @initVIewForCollection: (viewType, state) ->

      embedConfig = @requiredHTMLTemplatesURLSVisualisationsForCollection[viewType]
      initFunction = embedConfig.initFunction
      inScriptConfig = embedConfig.in_script
      initFunctionParams =
        state: state

      @loadHTMLSectionInScript(inScriptConfig, initFunction, initFunctionParams)


    @initMiniReportCard: (entityType, chemblID) ->

      Entity = undefined
      AvailableEntities = [Compound, Target, Assay, Document, CellLine, glados.models.Tissue]
      for CurrentEntity in AvailableEntities
        if entityType == CurrentEntity.prototype.entityName
          Entity = CurrentEntity

      $embedContentContainer = $('#BCK-embedded-content')
      glados.ReportCardApp.initMiniReportCard(Entity, $embedContentContainer, chemblID)

