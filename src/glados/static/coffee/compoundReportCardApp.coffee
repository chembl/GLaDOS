# This takes care of handling the compound report card.
class CompoundReportCardApp extends glados.ReportCardApp

  #This initializes all views and models necessary for the compound report card
  @init = ->

    super

    compound = CompoundReportCardApp.getCurrentCompound()

    CompoundReportCardApp.initNameAndClassification()
    CompoundReportCardApp.initRepresentations()
    CompoundReportCardApp.initSources()
    CompoundReportCardApp.initAlternateForms()
    CompoundReportCardApp.initSimilarCompounds()
    CompoundReportCardApp.initMoleculeFeatures()
    CompoundReportCardApp.initWithdrawnInfo()
    CompoundReportCardApp.initMechanismOfAction()
    CompoundReportCardApp.initIndications()
    CompoundReportCardApp.initClinicalData()
    CompoundReportCardApp.initMetabolism()
    CompoundReportCardApp.initHELMNotation()
    CompoundReportCardApp.initBioSeq()
    CompoundReportCardApp.initActivitySummary()
    CompoundReportCardApp.initAssaySummary()
    CompoundReportCardApp.initTargetSummary()
    CompoundReportCardApp.initTargetPredictions()
    CompoundReportCardApp.initCalculatedCompoundParentProperties()
    CompoundReportCardApp.initStructuralAlerts()
    CompoundReportCardApp.initCrossReferences()
    CompoundReportCardApp.initUniChemCrossReferences()

    compound.fetch()

    ButtonsHelper.initCroppedContainers()
    ButtonsHelper.initExpendableMenus()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentCompound = ->

    if not @currentCompound?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()
      @currentCompound = new Compound
        molecule_chembl_id: chemblID
      return @currentCompound

    else return @currentCompound

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initNameAndClassification = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new CompoundNameClassificationView
      model: compound,
      el: $('#CNCCard')
      section_id: 'CompoundNameAndClassification'
      section_label: 'Name And Classification'
      report_card_app: @

    new CompoundImageView
      model: compound,
      el: ('#CNCImageCard')

    if GlobalVariables['EMBEDED']
      compound.fetch()

      ButtonsHelper.initCroppedContainers()
      ButtonsHelper.initExpendableMenus()


  @initRepresentations = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new CompoundRepresentationsView
      model: compound
      el: $('#CompRepsCard')
      section_id: 'CompoundRepresentations'
      section_label: 'Representations'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

      ButtonsHelper.initCroppedContainers()
      ButtonsHelper.initExpendableMenus()

  @initSources = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'sources'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if_has_property: '_metadata.compound_records'
      show_if: (model) ->
        compoundRecords = glados.Utils.getNestedValue(model.attributes, '_metadata.compound_records',
          forceAsNumber=false, customNullValueLabel=undefined, returnUndefined=true)

        if not compoundRecords?
          return false
        else if compoundRecords.length == 0
          return false
        else
          return true
      properties_to_show: Compound.COLUMNS_SETTINGS.COMPOUND_SOURCES_SECTION

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#CSourcesCard')
      config: viewConfig
      section_id: 'CompoundSources'
      section_label: 'Sources'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initCalculatedCompoundParentProperties = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new CompoundCalculatedParentPropertiesView
      model: compound
      el: $('#CalculatedParentPropertiesCard')
      section_id: 'CalculatedCompoundParentProperties'
      section_label: 'Calculated Parent Properties'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initMechanismOfAction = ->

    mechanismOfActionList = new MechanismOfActionList()
    mechanismOfActionList.url = glados.Settings.WS_BASE_URL + 'mechanism.json?molecule_chembl_id=' + glados.Utils.URLS.getCurrentModelChemblID()
    new CompoundMechanismsOfActionView
      collection: mechanismOfActionList
      el: $('#MechOfActCard')
      molecule_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()
      section_id: 'MechanismOfAction'
      section_label: 'Mechanism Of Action'
      report_card_app: @

    console.log 'URL: ', mechanismOfActionList.url
    mechanismOfActionList.fetch({reset: true})

  @initIndications = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    drugIndicationsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugIndicationsList()
    drugIndicationsList.initURL(chemblID)

    viewConfig =
      embed_section_name: 'drug_indications'
      embed_identifier: chemblID

    new glados.views.ReportCards.PaginatedTableInCardView
      collection: drugIndicationsList
      el: $('#CDrugIndicationsCard')
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'Indications'
      section_label: 'Indications'
      config: viewConfig
      report_card_app: @

    drugIndicationsList.fetch({reset: true})

  @initMoleculeFeatures = ->

    compound = CompoundReportCardApp.getCurrentCompound()
    new CompoundFeaturesView
      model: compound
      el: $('#MoleculeFeaturesCard')
      section_id: 'MoleculeFeatures'
      section_label: 'Molecule Features'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initWithdrawnInfo = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'withdrawal_info'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if: (model) -> model.attributes.withdrawn_flag == true
      properties_to_show: Compound.COLUMNS_SETTINGS.WITHDRAWN_INFO_SECTION

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#CWithdrawnInfoCard')
      config: viewConfig
      section_id: 'WithdrawnInfo'
      section_label: 'Withdrawal Information'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initClinicalData = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'clinical_data'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if: (model) -> model.attributes.pref_name?
      properties_to_show: Compound.COLUMNS_SETTINGS.CLINICAL_DATA_SECTION

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#ClinDataCard')
      config: viewConfig
      section_id: 'ClinicalData'
      section_label: 'Clinical Data'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initStructuralAlerts = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    structuralAlertsSets = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewStructuralAlertsSetsList()
    structuralAlertsSets.initURL(chemblID)

    viewConfig =
      embed_section_name: 'structural_alerts'
      embed_identifier: chemblID

    new glados.views.ReportCards.PaginatedTableInCardView
      collection: structuralAlertsSets
      el: $('#CStructuralAlertsCard')
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'StructuralAlerts'
      section_label: 'Structural Alerts'
      config: viewConfig
      report_card_app: @

    structuralAlertsSets.fetch()

  @initAlternateForms = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    moleculeFormsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewAlternateFormsListForCarousel()
    moleculeFormsList.initURL chemblID

    viewConfig =
      embed_section_name: 'alternate_forms'
      embed_identifier: chemblID
      title: "Alternate forms of compound #{chemblID}:"

    new glados.views.ReportCards.CarouselInCardView
      collection: moleculeFormsList
      el: $('#AlternateFormsCard')
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'AlternateFormsOfCompoundInChEMBL'
      section_label: 'Alternate Forms'
      config: viewConfig
      report_card_app: @

    moleculeFormsList.fetch({reset: true})

  @initActivitySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedActivities = CompoundReportCardApp.getRelatedActivitiesAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_compound__associated_activities_pie_title_base') + chemblID
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_compound_name')
      embed_section_name: 'related_activities'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all activities related to ' + chemblID + ' used in this visualisation.'
        url: Activity.getActivitiesListURL('molecule_chembl_id:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: relatedActivities
      el: $('#CAssociatedActivitiesCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      report_card_app: @

    relatedActivities.fetch()

  @initAssaySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedAssays = CompoundReportCardApp.getRelatedAssaysAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_compound__associated_assays_pie_title_base') + chemblID
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_compound_name')
      embed_section_name: 'related_assays'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all assays related to ' + chemblID + ' used in this visualisation.'
        url: Assay.getAssaysListURL('_metadata.related_compounds.chembl_ids.\\*:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: relatedAssays
      el: $('#CAssociatedAssaysCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      report_card_app: @

    relatedAssays.fetch()

  @initTargetSummary = ->
    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedTargets = CompoundReportCardApp.getRelatedTargetsAggByClass(chemblID)

    pieConfig =
      x_axis_prop_name: 'classes'
      title: gettext('glados_compound__associated_targets_by_class_pie_title_base') + chemblID
      custom_empty_message: "No target classification data available for compound #{chemblID} (all may be non-protein targets)"
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_compound_name')
      embed_section_name: 'related_targets'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all targets related to ' + chemblID + ' used in this visualisation.'
        url: Target.getTargetsListURL('_metadata.related_compounds.chembl_ids.\\*:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: relatedTargets
      el: $('#CAssociatedTargetsCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      report_card_app: @

    relatedTargets.fetch()

  @initTargetPredictions = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new glados.views.Compound.TargetPredictionsView
      model: compound
      el: $('#CTargetPredictionsCard')
      section_id: 'TargetPredictions'
      section_label: 'Target Predictions'
      report_card_app: @
      embed_section_name: 'target_predictions'
      embed_identifier: glados.Utils.URLS.getCurrentModelChemblID()

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initCrossReferences = ->

    compound = CompoundReportCardApp.getCurrentCompound()
    refsConfig =
      is_unichem: false

    new glados.views.ReportCards.ReferencesInCardView
      model: CompoundReportCardApp.getCurrentCompound()
      el: $('#CrossReferencesCard')
      embed_section_name: 'cross_refs'
      embed_identifier: glados.Utils.URLS.getCurrentModelChemblID()
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'CompoundCrossReferences'
      section_label: 'Cross References'
      report_card_app: @
      config:
        refs_config: refsConfig

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initUniChemCrossReferences = ->

    compound = CompoundReportCardApp.getCurrentCompound()
    refsConfig =
      is_unichem: true

    new glados.views.ReportCards.ReferencesInCardView
      model: CompoundReportCardApp.getCurrentCompound()
      el: $('#UniChemCrossReferencesCard')
      embed_section_name: 'unichem_cross_refs'
      embed_identifier: glados.Utils.URLS.getCurrentModelChemblID()
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'UniChemCrossReferences'
      section_label: 'UniChem Cross References'
      report_card_app: @
      config:
        refs_config: refsConfig

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initSimilarCompounds = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    similarCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsListForCarousel()
    similarCompoundsList.initURL glados.Utils.URLS.getCurrentModelChemblID(), glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    viewConfig =
      embed_section_name: 'similar'
      embed_identifier: chemblID
      title: "Compounds similar to #{chemblID} with at least 70% similarity:"
      full_list_url: "/similarity_search_results/#{chemblID}/70"
      hide_on_error: true

    new glados.views.ReportCards.CarouselInCardView
      collection: similarCompoundsList
      el: $('#SimilarCompoundsCard')
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'SimilarCompounds'
      section_label: 'Similar Compounds'
      config: viewConfig
      report_card_app: @

    similarCompoundsList.fetch({reset: true})

  @initMetabolismFullScreen = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getUrlPartInReversePosition 0
    compoundMetabolism = new glados.models.Compound.Metabolism
      molecule_chembl_id: GlobalVariables.CHEMBL_ID

    new CompoundMetabolismFSView
      model: compoundMetabolism
      el: $('#CompoundMetabolismMain')

    compoundMetabolism.fetch()

  @initMetabolism = ->

    compoundMetabolism = new glados.models.Compound.Metabolism
      molecule_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new glados.views.ReportCards.MetabolismInCardView
      model: compoundMetabolism
      el: $('#MetabolismCard')
      molecule_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()
      section_id: 'Metabolism'
      section_label: 'Metabolism'
      report_card_app: @

    compoundMetabolism.fetch()

  @initHELMNotation = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'helm_notation'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if: (model) ->
        HELMNotation = glados.Utils.getNestedValue(model.attributes, Compound.COLUMNS.HELM_NOTATION.comparator,
          forceAsNumber=false, customNullValueLabel=undefined, returnUndefined=true)

        if not HELMNotation?
          return false
        else
          return true
      properties_to_show: Compound.COLUMNS_SETTINGS.HELM_NOTATION_SECTION
      after_render: (thisView) ->
        ButtonsHelper.initCroppedTextFields()
        $copyBtn = $(thisView.el).find('.BCK-Copy-btn')
        ButtonsHelper.initCopyButton($copyBtn, 'Copy to Clipboard', thisView.model.get('helm_notation'))

        $downloadBtn = $(thisView.el).find('.BCK-Dwnld-btn')
        ButtonsHelper.initDownloadBtn($downloadBtn, "#{thisView.model.get('molecule_chembl_id')}-HELM.txt",
          'Download', thisView.model.get('helm_notation'))

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#CHELMNotationCard')
      config: viewConfig
      section_id: 'CompoundHELMNotation'
      section_label: 'HELM Notation'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initBioSeq = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'biocomponents'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if: (model) ->
        biocomponents = glados.Utils.getNestedValue(model.attributes, Compound.COLUMNS.BIOCOMPONENTS.comparator,
          forceAsNumber=false, customNullValueLabel=undefined, returnUndefined=true)

        if not biocomponents?
          return false
        else
          return true
      properties_to_show: Compound.COLUMNS_SETTINGS.BIOCOMPONENTS_SECTION
      after_render: (thisView) ->
        ButtonsHelper.initCroppedTextFields()

        $buttonsContainers = $(thisView.el).find('.BCK-ButtonsContainer')

        $buttonsContainers.each (i, div) ->

          $div = $(div)
          $copyBtn = $div.find('.BCK-Copy-btn')

          ButtonsHelper.initCopyButton($copyBtn, 'Copy to Clipboard',
            $div.attr('data-value'))

          $downloadBtn = $div.find('.BCK-Dwnld-btn')
          ButtonsHelper.initDownloadBtn($downloadBtn,
            "#{thisView.model.get('molecule_chembl_id')}-Biocomp-#{$div.attr('data-description')}.txt",
            'Download', $div.attr('data-value'))

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#CBioseqCard')
      config: viewConfig
      section_id: 'CompoundBIOLSeq'
      section_label: 'Biocomponents'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()



  # -------------------------------------------------------------
  # Function Cells
  # -------------------------------------------------------------
  @initMiniBioactivitiesHistogram = ($containerElem, chemblID) ->

    bioactivities = CompoundReportCardApp.getRelatedActivitiesAgg(chemblID)

    stdTypeProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'STANDARD_TYPE',
      withColourScale=true)

    barsColourScale = stdTypeProp.colourScale

    config =
      max_categories: 8
      bars_colour_scale: barsColourScale
      fixed_bar_width: true
      hide_title: false
      x_axis_prop_name: 'types'
      properties:
        std_type: stdTypeProp
      initial_property_x: 'std_type'

    new glados.views.Visualisation.HistogramView
      model: bioactivities
      el: $containerElem
      config: config

    bioactivities.fetch()

  @initMiniTargetsByClassHistogram = ($containerElem, chemblID) ->

    targetClases = CompoundReportCardApp.getRelatedTargetsAggByClass(chemblID)

    stdClassProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target', 'TARGET_CLASS',
    withColourScale=true)

    barsColourScale = stdClassProp.colourScale

    config =
      max_categories: 8
      bars_colour_scale: barsColourScale
      fixed_bar_width: true
      hide_title: false
      x_axis_prop_name: 'classes'
      properties:
        target_class: stdTypeProp
      initial_property_x: 'target_class'

    new glados.views.Visualisation.HistogramView
      model: targetTypes
      el: $containerElem
      config: config

    targetTypes.fetch()


  @initMiniTargetsHistogram = ($containerElem, chemblID) ->

    targetTypes = CompoundReportCardApp.getRelatedTargetsAgg(chemblID)

    stdTypeProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target', 'TARGET_TYPE',
    withColourScale=true)

    barsColourScale = stdTypeProp.colourScale

    config =
      max_categories: 8
      bars_colour_scale: barsColourScale
      fixed_bar_width: true
      hide_title: false
      x_axis_prop_name: 'types'
      properties:
        std_type: stdTypeProp
      initial_property_x: 'std_type'

    new glados.views.Visualisation.HistogramView
      model: targetTypes
      el: $containerElem
      config: config

    targetTypes.fetch()

  @initMiniHistogramFromFunctionLink = ->
    $clickedLink = $(@)

    [paramsList, constantParamsList, $containerElem] = \
    glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell($clickedLink)

    histogramType = constantParamsList[0]
    compoundChemblID = paramsList[0]

    if histogramType == 'activities'
      CompoundReportCardApp.initMiniBioactivitiesHistogram($containerElem, compoundChemblID)
    else if histogramType == 'targets'
      CompoundReportCardApp.initMiniTargetsHistogram($containerElem, compoundChemblID)
    else if histogramType == 'targets_by_class'
      CompoundReportCardApp.initMiniTargetsByClassHistogram($containerElem, compoundChemblID)

  # --------------------------------------------------------------------------------------------------------------------
  # Cells Functions
  # --------------------------------------------------------------------------------------------------------------------
  @initStructuralAlertsCarouselFromFunctionLink = ->

    $clickedLink = $(@)
    [paramsList, constantParamsList, $containerElem, objectParam] = \
    glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell($clickedLink, isDataVis=false)


    structAlerts = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewStructuralAlertList()

    $carouselContainer = $("<div>#{glados.Utils.getContentFromTemplate('Handlebars-Common-DefaultCarouselContent')}</div>")
    $containerElem.append($carouselContainer)
    glados.views.PaginatedViews.PaginatedViewFactory.getNewCardsCarouselView(structAlerts, $containerElem)

    parsedAlerts = JSON.parse(objectParam)
    structAlerts.setMeta('data_loaded', true)
    structAlerts.reset(_.map(parsedAlerts, glados.models.Compound.StructuralAlert.prototype.parse))

  @initDrugIconGridFromFunctionLink = ->

    $clickedLink = $(@)
    [paramsList, constantParamsList, $containerElem] = \
    glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell($clickedLink, isDataVis=false)

    $gridContainer = $('<div class="BCK-FeaturesGrid" data-hb-template="Handlebars-Compound-MoleculeFeaturesGrid">')
    $containerElem.append($gridContainer)

    chemblID = paramsList[0]
    # in the future this should be taken form the collection instead of creating a new instance
    compound = new Compound
      molecule_chembl_id: chemblID
    new CompoundFeaturesView
      model: compound
      el: $containerElem
      table_cell_mode: true
    compound.fetch()

  # --------------------------------------------------------------------------------------------------------------------
  # Aggregations
  # --------------------------------------------------------------------------------------------------------------------
  @getRelatedTargetsAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'molecule_chembl_id'
      fields: ['_metadata.related_compounds.chembl_ids.*']

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'target_type'
          size: 20
          bucket_links:

            bucket_filter_template: '_metadata.related_compounds.chembl_ids.\\*:{{molecule_chembl_id}} ' +
                                    'AND target_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              molecule_chembl_id: 'molecule_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Target.getTargetsListURL

    targetTypes = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
      query_config: queryConfig
      molecule_chembl_id: chemblID
      aggs_config: aggsConfig

    return targetTypes

  @getRelatedTargetsAggByClass = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'molecule_chembl_id'
      fields: ['_metadata.related_compounds.chembl_ids.*']

    aggsConfig =
      aggs:
        classes:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.protein_classification.l1'
          size: 20
          bucket_links:

            bucket_filter_template: '_metadata.related_compounds.chembl_ids.\\*:{{molecule_chembl_id}} ' +
                                    'AND _metadata.protein_classification.l1:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              molecule_chembl_id: 'molecule_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Target.getTargetsListURL

    targetTypes = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
      query_config: queryConfig
      molecule_chembl_id: chemblID
      aggs_config: aggsConfig

    return targetTypes

  @getRelatedAssaysAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'molecule_chembl_id'
      fields: ['_metadata.related_compounds.chembl_ids.*']

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.assay_generated.type_label'
          size: 20
          bucket_links:

            bucket_filter_template: '_metadata.related_compounds.chembl_ids.\\*:{{molecule_chembl_id}} ' +
                                    'AND _metadata.assay_generated.type_label:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              molecule_chembl_id: 'molecule_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Assay.getAssaysListURL

    assays = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ASSAY_INDEX_URL
      query_config: queryConfig
      molecule_chembl_id: chemblID
      aggs_config: aggsConfig

    return assays

  @getRelatedActivitiesAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'molecule_chembl_id:{{molecule_chembl_id}}'
      template_data:
        molecule_chembl_id: 'molecule_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'standard_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'molecule_chembl_id:{{molecule_chembl_id}} ' +
                                    'AND standard_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              molecule_chembl_id: 'molecule_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Activity.getActivitiesListURL

    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      molecule_chembl_id: chemblID
      aggs_config: aggsConfig

    return bioactivities