# This takes care of handling the compound report card.
class CompoundReportCardApp extends glados.ReportCardApp

  #This initializes all views and models necessary for the compound report card
  @init = ->

    super

    compound = CompoundReportCardApp.getCurrentCompound()

    breadcrumbLinks = [
        {
          label: compound.get('id')
          link: Compound.get_report_card_url(compound.get('id'))
        }
      ]
    glados.apps.BreadcrumbApp.setBreadCrumb(breadcrumbLinks)

    CompoundReportCardApp.initNameAndClassification()
    CompoundReportCardApp.initRepresentations()
    CompoundReportCardApp.initSources()
    CompoundReportCardApp.initAlternateForms()
    CompoundReportCardApp.initMoleculeFeatures()
    CompoundReportCardApp.initWithdrawnInfo()
    CompoundReportCardApp.initMechanismOfAction()
    CompoundReportCardApp.initIndications()
    CompoundReportCardApp.initClinicalData()
    CompoundReportCardApp.initSimilarCompounds()
    CompoundReportCardApp.initMetabolism()
    CompoundReportCardApp.initBioSeq()
    CompoundReportCardApp.initHELMNotation()
    CompoundReportCardApp.initActivityChartsEmbedder()
    CompoundReportCardApp.initActivitySummary()
    CompoundReportCardApp.initAssaySummary()
    CompoundReportCardApp.initTargetSummary()
    CompoundReportCardApp.initPapersAboutCompound()
    CompoundReportCardApp.initTargetPredictions()
    CompoundReportCardApp.initCalculatedCompoundParentProperties()
    CompoundReportCardApp.initStructuralAlerts()
    CompoundReportCardApp.initCrossReferences()
    CompoundReportCardApp.initUniChemCrossReferences()
    CompoundReportCardApp.initUnichemConnectivityMatches()

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
      entity_name: Compound.prototype.entityName
      report_card_app: @

    new CompoundImageView
      model: compound,
      el: ('#CNCImageCard')

    if GlobalVariables['EMBEDED']
      compound.fetch()

      ButtonsHelper.initExpendableMenus()

  @initRepresentations = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new CompoundRepresentationsView
      model: compound
      el: $('#CompRepsCard')
      section_id: 'CompoundRepresentations'
      section_label: 'Representations'
      entity_name: Compound.prototype.entityName
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
      properties_group: 'compound_sources'
      sort_alpha: true
      property_id_to_sort: 'compound_sources_list'

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#CSourcesCard')
      config: viewConfig
      section_id: 'CompoundSources'
      section_label: 'Sources'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initCalculatedCompoundParentProperties = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new CompoundCalculatedParentPropertiesView
      model: compound
      el: $('#CalculatedParentPropertiesCard')
      section_id: 'CalculatedCompoundParentProperties'
      section_label: 'Calculated Properties'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initMechanismOfAction = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESMechanismsOfActionList(
      "*",
      listConfig=glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.MECHANISMS_OF_ACTION_COMPOUND_REPORT_CARD
    )

    viewConfig =
      embed_section_name: 'mechanism_of_action'
      embed_identifier: chemblID
      table_config:
        full_list_url: ''

    tableView = new glados.views.ReportCards.PaginatedTableInCardView
      collection: list
      el: $('#MechOfActCard')
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'MechanismOfAction'
      section_label: 'Drug Mechanisms'
      entity_name: Compound.prototype.entityName
      config: viewConfig
      report_card_app: @

    compound = CompoundReportCardApp.getCurrentCompound()

    fetchList = ->
      chemblID = compound.get('id')

      if compound.isParent()
        query = "parent_molecule.molecule_chembl_id:#{chemblID}"
      else
        query = "mechanism_of_action.molecule_chembl_id:#{chemblID}"

      viewConfig.table_config.full_list_url = glados.models.Compound.MechanismOfAction.getListURL(query)
      list.setMeta('custom_query', query)
      list.fetch({reset: true})

    compound.on 'change', fetchList, @
    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initIndications = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    list = glados.models.paginatedCollections.PaginatedCollectionFactory\
      .getNewESDrugIndicationsList(
        "drug_indication._metadata.all_molecule_chembl_ids:#{chemblID}",
        config=glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.DRUG_INDICATIONS_COMPOUND_REPORT_CARD
    )

    viewConfig =
      embed_section_name: 'drug_indications'
      embed_identifier: chemblID
      table_config:
        full_list_url: ''

    tableView = new glados.views.ReportCards.PaginatedTableInCardView
      collection: list
      el: $('#CDrugIndicationsCard')
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'Indications'
      section_label: 'Drug Indications'
      entity_name: Compound.prototype.entityName
      config: viewConfig
      report_card_app: @

    compound = CompoundReportCardApp.getCurrentCompound()

    fetchList = ->
      chemblID = compound.get('id')

      if compound.isParent()
        query = "drug_indication.parent_molecule_chembl_id:#{chemblID}"
      else
        query = "drug_indication.molecule_chembl_id:#{chemblID}"

      viewConfig.table_config.full_list_url = glados.models.Compound.DrugIndication.getListURL(query)
      list.setMeta('custom_query', query)
      list.fetch({reset: true})

    compound.on 'change', fetchList, @
    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initMoleculeFeatures = ->

    compound = CompoundReportCardApp.getCurrentCompound()
    new CompoundFeaturesView
      model: compound
      el: $('#MoleculeFeaturesCard')
      section_id: 'MoleculeFeatures'
      section_label: 'Molecule Features'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initWithdrawnInfo = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'withdrawal_info'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if: (model) -> model.attributes.withdrawn_flag == true
      properties_group: 'withdrawal_info'

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#CWithdrawnInfoCard')
      config: viewConfig
      section_id: 'WithdrawnInfo'
      section_label: 'Withdrawal Information'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initClinicalData = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'clinical_data'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if: (model) -> model.attributes.pref_name?
      properties_group: 'clinical_data'

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#ClinDataCard')
      config: viewConfig
      section_id: 'ClinicalData'
      section_label: 'Clinical Data'
      entity_name: Compound.prototype.entityName
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
      entity_name: Compound.prototype.entityName
      config: viewConfig
      report_card_app: @

    structuralAlertsSets.fetch()

  @initAlternateForms = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()

    initAlternateFormsList = ->

      parentID = compound.getParentID()
      filter = "molecule_hierarchy.parent_chembl_id:(\"#{parentID}\") OR molecule_chembl_id:(\"#{parentID}\")^100"
      alternateFormsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(filter,
      itemsList=undefined,
      settings=settings=glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_ES_RESULTS_LIST_CAROUSEL)

      if compound.isParent()
        parentText = '(Parent)'
      else
        parentText = "(Parent is #{parentID})"

      viewConfig =
        embed_section_name: 'alternate_forms'
        embed_identifier: chemblID
        title: "Alternative forms of compound #{chemblID} #{parentText}:"

      new glados.views.ReportCards.CarouselInCardView
        collection: alternateFormsList
        el: $('#AlternateFormsCard')
        resource_type: gettext('glados_entities_compound_name')
        section_id: 'AlternateFormsOfCompoundInChEMBL'
        section_label: 'Alternative Forms'
        entity_name: Compound.prototype.entityName
        position_in_scroll_spy: 2
        config: viewConfig
        report_card_app: @

      alternateFormsList.fetch()

    compound.on 'change', initAlternateFormsList, @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initActivityChartsEmbedder = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      resource_type: gettext('glados_entities_compound_name')
      embed_identifier: compound.get('molecule_chembl_id')

    new glados.views.ReportCards.FullSectionEmbedderView
      model: compound
      el: $('#ActivityChartsEmbedder')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Compound.prototype.entityName
      report_card_app: @

  @initAllActivityChartsWhenEmbedded = ->

    CompoundReportCardApp.initActivitySummary()
    CompoundReportCardApp.initAssaySummary()
    CompoundReportCardApp.initTargetSummary()

  @initActivitySummary = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    configGenerator = new glados.configs.ReportCards.Compound.ActivityPieSummaryConfig(compound)
    viewConfig = configGenerator.getViewConfig()

    new glados.views.ReportCards.PieInCardView
      el: $('#CAssociatedActivitiesCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initPapersAboutCompound = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    allDocumentsByYear = CompoundReportCardApp.getPapersPerYearAgg(chemblID)

    yearProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('DocumentAggregation',
      'YEAR')
    journalNameProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('DocumentAggregation',
      'JOURNAL_NAME')
    barsColourScale = journalNameProp.colourScale

    histogramConfig =
      bars_colour_scale: barsColourScale
      stacked_histogram: true
      sort_by_key: true
      y_scale_mode: 'normal'
      rotate_x_axis_if_needed: false
      legend_vertical: true
      big_size: true
      paint_axes_selectors: true
      properties:
        year: yearProp
        journal: journalNameProp
      initial_property_x: 'year'
      initial_property_z: 'journal'
      x_axis_options: ['count']
      x_axis_min_columns: 1
      x_axis_max_columns: 40
      x_axis_initial_num_columns: 40
      x_axis_prop_name: 'documentsPerYear'
      title: 'Documents by Year'
      title_link_url: Document.getDocumentsListURL('_metadata.related_compounds.all_chembl_ids:' +
        chemblID)
      external_title: true
      max_z_categories: 7
      max_height: 320

    config =
      histogram_config: histogramConfig
      resource_type: gettext('glados_entities_compound_name')
      embed_section_name: 'papers_per_year'
      embed_identifier: chemblID

    new glados.views.ReportCards.HistogramInCardView
      el: $('#PapersAboutCompoundPerYear')
      model: allDocumentsByYear
      config: config
      compound_chembl_id: chemblID
      section_id: 'PapersAboutCompound'
      section_label: 'Literature'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    allDocumentsByYear.fetch()


  @initAssaySummary = ->

    compound = CompoundReportCardApp.getCurrentCompound()
    configGenerator = new glados.configs.ReportCards.Compound.AssaySummaryPieConfig(compound)
    viewConfig = configGenerator.getViewConfig()

    new glados.views.ReportCards.PieInCardView
      el: $('#CAssociatedAssaysCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initTargetSummary = ->

    compound = CompoundReportCardApp.getCurrentCompound()
    configGenerator = new glados.configs.ReportCards.Compound.TargetSummaryPieConfig(compound)
    viewConfig = configGenerator.getViewConfig()

    new glados.views.ReportCards.PieInCardView
      el: $('#CAssociatedTargetsCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initTargetPredictions = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new glados.views.Compound.TargetPredictionsView
      model: compound
      el: $('#CTargetPredictionsCard')
      section_id: 'TargetPredictions'
      section_label: 'Target Predictions'
      entity_name: Compound.prototype.entityName
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
      entity_name: Compound.prototype.entityName
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
      entity_name: Compound.prototype.entityName
      report_card_app: @
      config:
        refs_config: refsConfig

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initUnichemConnectivityMatches = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new glados.views.Compound.UnichemConnectivityMatchesView
      model: compound
      el: $('#CUnichemConnectivityMatchesCard')
      section_id: 'UniChemConnectivityMatches'
      section_label: 'UniChem Connectivity Layer Cross References'
      entity_name: Compound.prototype.entityName
      report_card_app: @
      embed_section_name: 'unichem_connectivity_matches'
      embed_identifier: glados.Utils.URLS.getCurrentModelChemblID()

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initSimilarCompounds = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()

    carouselConfig =
      custom_available_page_sizes:
        'SMALL_SCREEN': 1
        'MEDIUM_SCREEN': 3
        'LARGE_SCREEN': 6
      custom_card_sizes:
        small: 12
        medium: 4
        large: 2

    similarCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory\
    .getNewSimilaritySearchResultsListForCarousel(customConfig=carouselConfig)
    similarCompoundsList.initURL glados.Utils.URLS.getCurrentModelChemblID(), glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    viewConfig =
      embed_section_name: 'similar'
      embed_identifier: chemblID
      title: "Compounds similar to #{chemblID} with at least 85% similarity, "
      full_list_url: CompoundReportCardApp.getCurrentCompound().getSimilaritySearchURL()
      hide_on_error: true
      carousel_config: carouselConfig

    new glados.views.ReportCards.CarouselInCardView
      collection: similarCompoundsList
      el: $('#SimilarCompoundsCard')
      resource_type: gettext('glados_entities_compound_name')
      section_id: 'SimilarCompounds'
      section_label: 'Similar Compounds'
      entity_name: Compound.prototype.entityName
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
      entity_name: Compound.prototype.entityName
      report_card_app: @

    compoundMetabolism.fetch()

  #https://chembl-glados.herokuapp.com/compound_report_card/CHEMBL1201585/
  @initHELMNotation = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'helm_notation'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if: (model) ->
        HELMNotation = glados.Utils.getNestedValue(model.attributes, 'helm_notation',
          forceAsNumber=false, customNullValueLabel=undefined, returnUndefined=true)

        if not HELMNotation?
          return false
        else
          return true
      properties_group: 'helm_notation'
      after_render: (thisView) ->

        $container = $(thisView.el).find('.BCK-HELMNotationContainer')

        config =
            value: $container.attr('data-value')
            download:
              filename: "#{thisView.model.get('molecule_chembl_id')}-HELMNotation.helm"
              value: $container.attr('data-value')
              tooltip: 'Download'

        ButtonsHelper.initCroppedContainer($container, config)

        return

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#CHELMNotationCard')
      config: viewConfig
      section_id: 'CompoundHELMNotation'
      section_label: 'HELM Notation'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  # https://chembl-glados.herokuapp.com/compound_report_card/CHEMBL1201585
  @initBioSeq = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    viewConfig =
      embed_section_name: 'biocomponents'
      embed_identifier: compound.get('molecule_chembl_id')
      show_if: (model) ->
        biocomponents = glados.Utils.getNestedValue(model.attributes, 'biotherapeutic.biocomponents',
          forceAsNumber=false, customNullValueLabel=undefined, returnUndefined=true)

        if not biocomponents?
          return false

        if biocomponents.length == 0
          return false

        return true
      properties_group: 'biocomponents'
      after_render: (thisView) ->

        $buttonsContainers = $(thisView.el).find('.BCK-BioCompCroppedContainer')
        $buttonsContainers.each (i, div) ->

          $container = $(div)

          config =
            value: $container.attr('data-value')
            download:
              filename: "#{thisView.model.get('molecule_chembl_id')}-Biocomp-#{$container.attr('data-description')}.txt"
              value: $container.attr('data-value')
              tooltip: 'Download'

          ButtonsHelper.initCroppedContainer($container, config)
          return

    new glados.views.ReportCards.EntityDetailsInCardView
      model: compound
      el: $('#CBioseqCard')
      config: viewConfig
      section_id: 'CompoundBIOLSeq'
      section_label: 'Biocomponents'
      entity_name: Compound.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      compound.fetch()

  # -------------------------------------------------------------
  # Function Cells
  # -------------------------------------------------------------
  @initMiniBioactivitiesHistogram = ($containerElem, chemblID) ->

    bioactivities = CompoundReportCardApp.getRelatedActivitiesAgg([chemblID])

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

    viewConfig =
      is_outside_an_entity_report_card: true

    new CompoundFeaturesView
      model: compound
      el: $containerElem
      table_cell_mode: true
      config: viewConfig
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

            bucket_filter_template: '_metadata.related_compounds.all_chembl_ids:{{molecule_chembl_id}} ' +
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

  @getRelatedTargetsAggByClass = (chemblIDs) ->

    queryConfig = glados.configs.ReportCards.Compound.TargetSummaryPieConfig.getQueryConfig()
    aggsConfig = glados.configs.ReportCards.Compound.TargetSummaryPieConfig.getAggConfig()

    targetTypes = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
      query_config: queryConfig
      molecule_chembl_ids: chemblIDs
      aggs_config: aggsConfig

    return targetTypes

  @getRelatedAssaysAgg = (chemblIDs) ->

    queryConfig = glados.configs.ReportCards.Compound.AssaySummaryPieConfig.getQueryConfig()
    aggsConfig = glados.configs.ReportCards.Compound.AssaySummaryPieConfig.getAggConfig()

    assays = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ASSAY_INDEX_URL
      query_config: queryConfig
      molecule_chembl_ids: chemblIDs
      aggs_config: aggsConfig

    return assays

  @getRelatedActivitiesAgg = (chemblIDs) ->

    queryConfig = glados.configs.ReportCards.Compound.ActivityPieSummaryConfig.getQueryConfig()
    aggsConfig = glados.configs.ReportCards.Compound.ActivityPieSummaryConfig.getAggConfig()

    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      molecule_chembl_ids: chemblIDs
      aggs_config: aggsConfig

    return bioactivities

  @getPapersPerYearAgg = (chemblID, defaultInterval=1)  ->
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'molecule_chembl_id'
      fields: ['_metadata.related_compounds.chembl_ids.*']

    aggsConfig =
      aggs:
        documentsPerYear:
          type: glados.models.Aggregations.Aggregation.AggTypes.HISTOGRAM
          field: 'year'
          default_interval_size: defaultInterval
          min_interval_size: 1
          max_interval_size: 10
          bucket_key_parse_function: (key) -> key.replace(/\.0/i, '')
          bucket_sort_compare_function: (bucketA, bucketB) ->
            yearA = parseFloat(bucketA.key)
            yearB = parseFloat(bucketB.key)
            if yearA < yearB
              return -1
            else if yearA > yearB
              return 1
            return 0
          aggs:
            journal:
              type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
              field: 'journal'
              size: 10
              bucket_links:

                bucket_filter_template: '_metadata.related_compounds.all_chembl_ids:({{molecule_chembl_id}})' +
                                        ' AND year:({{year}}) AND journal:("{{bucket_key}}"' +
                                        '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
                template_data:
                  year: 'BUCKET.parsed_parent_key'
                  bucket_key: 'BUCKET.key'
                  extra_buckets: 'EXTRA_BUCKETS.key'
                  molecule_chembl_id: 'molecule_chembl_id'

                link_generator: Document.getDocumentsListURL

    allDocumentsByYear = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.DOCUMENT_INDEX_URL
      query_config: queryConfig
      aggs_config: aggsConfig
      molecule_chembl_id: chemblID

    return allDocumentsByYear

