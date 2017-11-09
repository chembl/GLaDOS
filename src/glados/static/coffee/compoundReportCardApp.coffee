# This takes care of handling the compound report card.
class CompoundReportCardApp extends glados.ReportCardApp

  #This initializes all views and models necessary for the compound report card
  @init = ->

    super
    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    compound = CompoundReportCardApp.getCurrentCompound()

    CompoundReportCardApp.initNameAndClassification()
    CompoundReportCardApp.initRepresentations()
    CompoundReportCardApp.initCalculatedCompoundParentProperties()
    CompoundReportCardApp.initMechanismOfAction()
    CompoundReportCardApp.initMoleculeFeatures()
    CompoundReportCardApp.initAlternateForms()
    CompoundReportCardApp.initActivitySummary()
    CompoundReportCardApp.initAssaySummary()
    CompoundReportCardApp.initTargetSummary()
    CompoundReportCardApp.initSimilarCompounds()
    CompoundReportCardApp.initMetabolism()

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
        fetch_from_elastic: false
      return @currentCompound

    else return @currentCompound

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initNameAndClassification = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new CompoundNameClassificationView({
        model: compound,
        el: $('#CNCCard')})

    new CompoundImageView({
        model: compound,
        el: ('#CNCImageCard')})

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

    if GlobalVariables['EMBEDED']
      compound.fetch()

      ButtonsHelper.initCroppedContainers()
      ButtonsHelper.initExpendableMenus()

  @initCalculatedCompoundParentProperties = ->

    compound = CompoundReportCardApp.getCurrentCompound()

    new CompoundCalculatedParentPropertiesView
      model: compound
      el: $('#CalculatedParentPropertiesCard')
      section_id: 'CalculatedCompoundParentProperties'

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initMechanismOfAction = ->

    mechanismOfActionList = new MechanismOfActionList()
    mechanismOfActionList.url = glados.Settings.WS_BASE_URL + 'mechanism.json?molecule_chembl_id=' + GlobalVariables.CHEMBL_ID;
    new CompoundMechanismsOfActionView
      collection: mechanismOfActionList
      el: $('#MechOfActCard')
      molecule_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    mechanismOfActionList.fetch({reset: true})

  @initMoleculeFeatures = ->

    compound = CompoundReportCardApp.getCurrentCompound()
    new CompoundFeaturesView
      model: compound
      el: $('#MoleculeFeaturesCard')

    if GlobalVariables['EMBEDED']
      compound.fetch()

  @initAlternateForms = ->

    moleculeFormsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewAlternateFormsListForCarousel()
    moleculeFormsList.initURL glados.Utils.URLS.getCurrentModelChemblID()

    new CompoundMoleculeFormsListView
      collection: moleculeFormsList
      el: $('#AlternateFormsCard')
      molecule_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    moleculeFormsList.fetch({reset: true})

  @initActivitySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedActivities = CompoundReportCardApp.getRelatedActivitiesAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_compound__associated_activities_pie_title_base') + chemblID

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

    relatedActivities.fetch()

  @initAssaySummary = ->

    #TODO: needs to inlude related compounds in assays index
    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedAssays = CompoundReportCardApp.getRelatedAssaysAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_compound__associated_assays_pie_title_base') + chemblID

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_compound_name')
      embed_section_name: 'related_assays'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all assays related to ' + chemblID + ' used in this visualisation.'
        url: Assay.getAssaysListURL()

    new glados.views.ReportCards.PieInCardView
      model: relatedAssays
      el: $('#CAssociatedAssaysCard')
      config: viewConfig

    relatedAssays.fetch()

  @initTargetSummary = ->
    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedTargets = CompoundReportCardApp.getRelatedTargetsAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_compound__associated_targets_pie_title_base') + chemblID

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

    relatedTargets.fetch()

  @initSimilarCompounds = ->

    similarCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsListForCarousel()
    similarCompoundsList.initURL glados.Utils.URLS.getCurrentModelChemblID(), glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    new SimilarCompoundsView
      collection: similarCompoundsList
      el: $('#SimilarCompoundsCard')
      molecule_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()
      section_id: 'SimilarCompounds'

    similarCompoundsList.fetch({reset: true})

  @initMetabolismFullScreen = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getUrlPartInReversePosition 0
    compoundMetabolism = new CompoundMetabolism()
    compoundMetabolism.url = glados.Settings.STATIC_URL+'testData/metabolismSampleData.json'

    new CompoundMetabolismFSView
      model: compoundMetabolism
      el: $('#CompoundMetabolismMain')

    compoundMetabolism.fetch()

  @initMetabolism = ->

    compoundMetabolism = new CompoundMetabolism()
    compoundMetabolism.url = glados.Settings.STATIC_URL + 'testData/metabolismSampleData.json'

    new CompoundMetabolismView
      model: compoundMetabolism
      el: $('#MetabolismCard')
      molecule_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    compoundMetabolism.fetch()

  # you can provide chembld iD or a model already created
  @initMiniCompoundReportCard = ($containerElem, chemblID, model, customTemplate, additionalTemplateParams={},
  fetchModel=true, customColumns)->

    if model?
      compound = model
    else
      compound = new Compound({molecule_chembl_id: chemblID})

    view = new glados.views.MiniReportCardView
      el: $containerElem
      model: compound
      entity: Compound
      custom_template: customTemplate
      additional_params: additionalTemplateParams
      custom_columns: customColumns

    if not fetchModel
      view.render()
    else
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

  @getRelatedAssaysAgg = (chemblID) ->

    #TODO: needs to inlude related compounds in assays index
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'assay_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'assay_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
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