# This takes care of handling the compound report card.
class CompoundReportCardApp

  #This initializes all views and models necessary for the compound report card
  @init = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    compound = new Compound({molecule_chembl_id: GlobalVariables.CHEMBL_ID})
    mechanismOfActionList = new MechanismOfActionList()
    mechanismOfActionList.url = glados.Settings.WS_BASE_URL + 'mechanism.json?molecule_chembl_id=' + GlobalVariables.CHEMBL_ID
    moleculeFormsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewAlternateFormsListForCarousel()
    moleculeFormsList.initURL GlobalVariables.CHEMBL_ID
    similarCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsListForCarousel()
    similarCompoundsList.initURL GlobalVariables.CHEMBL_ID, glados.Settings.DEFAULT_SIMILARITY_THRESHOLD
    compoundMetabolism = new CompoundMetabolism()
    compoundMetabolism.url = glados.Settings.STATIC_URL+'testData/metabolismSampleData.json'

    new CompoundNameClassificationView
      model: compound
      el: $('#CNCCard')

    new CompoundImageView
        model: compound
        el: ('#CNCImageCard')

    new CompoundRepresentationsView
        model: compound
        el: $('#CompRepsCard')

    new CompoundCalculatedParentPropertiesView
        model: compound
        el: $('#CalculatedParentPropertiesCard')

    new CompoundMechanismsOfActionView
        collection: mechanismOfActionList
        el: $('#MechOfActCard')

    new CompoundFeaturesView
        model: compound
        el: $('#MoleculeFeaturesCard')

    new CompoundMoleculeFormsListView
        collection: moleculeFormsList
        el: $('#AlternateFormsCard')

    new SimilarCompoundsView
      collection: similarCompoundsList
      el: $('#SimilarCompoundsCard')

    new CompoundMetabolismView
      model: compoundMetabolism
      el: $('#MetabolismCard')

    compound.fetch()
    mechanismOfActionList.fetch({reset: true})
    moleculeFormsList.fetch({reset: true})
    similarCompoundsList.fetch({reset: true})
    compoundMetabolism.fetch()

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()
    ButtonsHelper.initCroppedContainers()
    ButtonsHelper.initExpendableMenus()

    @initPieView()

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initNameAndClassification = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    compound = new Compound
      molecule_chembl_id: GlobalVariables.CHEMBL_ID

    console.log compound

    new CompoundNameClassificationView({
        model: compound,
        el: $('#CNCCard')})
    new CompoundImageView({
        model: compound,
        el: ('#CNCImageCard')})

    compound.fetch()

    ButtonsHelper.initCroppedContainers()
    ButtonsHelper.initExpendableMenus()


  @initRepresentations = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    compound = new Compound
      molecule_chembl_id: CHEMBL_ID

    compRepsView = new CompoundRepresentationsView
      model: compound
      el: $('#CompRepsCard')

    compound.fetch()

    ButtonsHelper.initCroppedContainers()
    ButtonsHelper.initExpendableMenus()

  @initCalculatedCompoundParentProperties = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()
    compound = new Compound
      molecule_chembl_id: CHEMBL_ID

    new CompoundCalculatedParentPropertiesView
        model: compound
        el: $('#CalculatedParentPropertiesCard')

    compound.fetch()

  @initMechanismOfAction = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    mechanismOfActionList = new MechanismOfActionList()
    mechanismOfActionList.url = glados.Settings.WS_BASE_URL + 'mechanism.json?molecule_chembl_id=' + GlobalVariables.CHEMBL_ID;
    new CompoundMechanismsOfActionView
      collection: mechanismOfActionList
      el: $('#MechOfActCard')
    mechanismOfActionList.fetch({reset: true})

  @initMoleculeFeatures = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    compound = new Compound
      molecule_chembl_id: CHEMBL_ID
    new CompoundFeaturesView
      model: compound
      el: $('#MoleculeFeaturesCard')
    compound.fetch()


  @initAlternateForms = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    compound = new Compound
      molecule_chembl_id: CHEMBL_ID

    moleculeFormsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewAlternateFormsListForCarousel()
    moleculeFormsList.initURL GlobalVariables.CHEMBL_ID

    new CompoundMoleculeFormsListView
      collection: moleculeFormsList,
      el: $('#AlternateFormsCard')

    moleculeFormsList.fetch({reset: true})

  @initSimilarCompounds = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    similarCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsListForCarousel()
    similarCompoundsList.initURL GlobalVariables.CHEMBL_ID, glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    new SimilarCompoundsView
      collection: similarCompoundsList
      el: $('#SimilarCompoundsCard')

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

    GlobalVariables.CHEMBL_ID = URLProcessor.getUrlPartInReversePosition 3

    compoundMetabolism = new CompoundMetabolism()
    compoundMetabolism.url = glados.Settings.STATIC_URL+'testData/metabolismSampleData.json'

    new CompoundMetabolismView
      model: compoundMetabolism
      el: $('#MetabolismCard')

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
  # Views
  # -------------------------------------------------------------

  @initPieView = ->
    # TODO DAVID WILL MAKE THIS SOMEDAY
#    pieview = new PieView
#    pieview.render()

  # -------------------------------------------------------------
  # Function Cells
  # -------------------------------------------------------------
  @initMiniBioactivitiesHistogram = ($containerElem, chemblID) ->

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


