class TargetReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->
    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

    TargetReportCardApp.initTargetNameAndClassification()
    TargetReportCardApp.initApprovedDrugsClinicalCandidates()
    TargetReportCardApp.initTargetRelations()
    TargetReportCardApp.initTargetComponents()
    TargetReportCardApp.initBioactivities()
    TargetReportCardApp.initAssociatedAssays()
    TargetReportCardApp.initLigandEfficiencies()
    TargetReportCardApp.initAssociatedCompounds()
    
    target = TargetReportCardApp.getCurrentTarget()
    target.fetch()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentTarget = ->

    if not @currentTarget?

      targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentTarget = new Target
        target_chembl_id: targetChemblID
      return @currentTarget

    else return @currentTarget

  # -------------------------------------------------------------
  # Section initialisation
  # -------------------------------------------------------------
  @initTargetNameAndClassification = ->

    target = TargetReportCardApp.getCurrentTarget()

    new TargetNameAndClassificationView
      model: target
      el: $('#TNameClassificationCard')

    if GlobalVariables['EMBEDED']
      target.fetch()

  @initTargetComponents = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    targetComponents = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetComponentsList()
    targetComponents.initURL targetChemblID

    new TargetComponentsView
      collection: targetComponents
      el: $('#TComponentsCard')

    targetComponents.fetch({reset: true})

  @initTargetRelations = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    targetRelations = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetRelationsList()
    targetRelations.initURL targetChemblID

    new RelationsView
      collection: targetRelations
      el: $('#TRelationsCard')

    targetRelations.fetch({reset: true})

  @initApprovedDrugsClinicalCandidates = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    appDrugsClinCandsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()
    appDrugsClinCandsList.initURL(targetChemblID)

    new ApprovedDrugsClinicalCandidatesView
      collection: appDrugsClinCandsList
      el: $('#ApprovedDrugsAndClinicalCandidatesCard')

    appDrugsClinCandsList.fetch()

  @initBioactivities = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    bioactivities = new TargetAssociatedBioactivities
      target_chembl_id: targetChemblID

    new TargetAssociatedBioactivitiesView
      model: bioactivities
      el: $('#TAssociatedBioactivitiesCard')

    bioactivities.fetch()

  @initAssociatedAssays = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedAssays = new TargetAssociatedAssays
      target_chembl_id: targetChemblID

    new TargetAssociatedAssaysView
      model: associatedAssays
      el: $('#TAssociatedAssaysCard')
      target_chembl_id: GlobalVariables.CHEMBL_ID

    associatedAssays.fetch()

  @initLigandEfficiencies = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    customQueryString = 'target_chembl_id:' + targetChemblID + ' AND' +
      ' standard_type:(IC50 OR Ki OR EC50 OR Kd) AND _exists_:standard_value AND _exists_:ligand_efficiency'
    ligandEfficiencies = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(customQueryString)

    new glados.views.Target.LigandEfficienciesView
      collection: ligandEfficiencies
      el: $('#TLigandEfficienciesCard')
      target_chembl_id: targetChemblID

  @initAssociatedCompounds = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()

    [queryConfig, aggsConfig] = TargetReportCardApp.getAssociatedCompoundsAggConfig()

    associatedCompounds = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      target_chembl_id: targetChemblID
      aggs_config: aggsConfig

    new glados.views.Target.AssociatedCompoundsView
      el: $('#TAssociatedCompoundProperties')
      model: associatedCompounds

    associatedCompounds.fetch()

  @initMiniTargetReportCard = ($containerElem, chemblID) ->

    target = new Target({target_chembl_id: chemblID})
    new glados.views.MiniReportCardView
      el: $containerElem
      model: target
      entity: Target
    target.fetch()

  @initMiniBioactivitiesHistogram = ($containerElem, chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'target_chembl_id:{{target_chembl_id}}'
      template_data:
        target_chembl_id: 'target_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'standard_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'target_chembl_id:{{target_chembl_id}} ' +
                                    'AND standard_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              target_chembl_id: 'target_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Activity.getActivitiesListURL


    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      target_chembl_id: chemblID
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

  @initMiniCompoundsHistogram = ($containerElem, chemblID) ->

    [queryConfig, aggsConfig] = TargetReportCardApp.getAssociatedCompoundsAggConfig(minCols=8, maxCols=8,
      defaultCols=8)

    associatedCompounds = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      target_chembl_id: chemblID
      aggs_config: aggsConfig

    config =
      max_categories: 8
      fixed_bar_width: true
      hide_title: false
      x_axis_prop_name: 'x_axis_agg'
      properties:
        mwt: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
      initial_property_x: 'mwt'

    new glados.views.Visualisation.HistogramView
      model: associatedCompounds
      el: $containerElem
      config: config

    associatedCompounds.fetch()

  @initMiniHistogramFromFunctionLink = ->
    $clickedLink = $(@)

    [paramsList, constantParamsList, $containerElem] = \
    glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell($clickedLink)

    histogramType = constantParamsList[0]
    targetChemblID = paramsList[0]
    if histogramType == 'activities'
      TargetReportCardApp.initMiniBioactivitiesHistogram($containerElem, targetChemblID)
    else if histogramType == 'compounds'
      TargetReportCardApp.initMiniCompoundsHistogram($containerElem, targetChemblID)

  # --------------------------------------------------------------------------------------------------------------------
  # AggregationsConfig
  # --------------------------------------------------------------------------------------------------------------------
  @getAssociatedCompoundsAggConfig = (minCols=1, maxCols=20, defaultCols=10) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'target_chembl_id'
      fields: ['_metadata.related_targets.chembl_ids.*']

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'molecule_properties.full_mwt'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          min_columns: 1
          max_columns: 20
          num_columns: 10
          bucket_links:
            bucket_filter_template: '_metadata.related_targets.chembl_ids.\\*:{{target_chembl_id}} ' +
              'AND molecule_properties.full_mwt:(>={{min_val}} AND <={{max_val}})'
            template_data:
              target_chembl_id: 'target_chembl_id'
              min_val: 'BUCKET.from'
              max_val: 'BUCKETS.to'
            link_generator: Compound.getCompoundsListURL

    return [queryConfig, aggsConfig]