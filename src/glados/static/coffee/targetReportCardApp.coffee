class TargetReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->
    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    target = new Target
      target_chembl_id: GlobalVariables.CHEMBL_ID

    appDrugsClinCandsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()
    appDrugsClinCandsList.initURL(GlobalVariables.CHEMBL_ID)
    
    console.log 'appDrugsClinCandsList: ', appDrugsClinCandsList

    targetRelations = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetRelationsList()
    targetRelations.initURL GlobalVariables.CHEMBL_ID

    targetComponents = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetComponentsList()

    targetComponents.initURL GlobalVariables.CHEMBL_ID

    bioactivities = new TargetAssociatedBioactivities
      target_chembl_id: GlobalVariables.CHEMBL_ID

    associatedAssays = new TargetAssociatedAssays
      target_chembl_id: GlobalVariables.CHEMBL_ID

    customQueryString = 'target_chembl_id:' + GlobalVariables.CHEMBL_ID + ' AND' +
      ' standard_type:(IC50 OR Ki OR EC50 OR Kd) AND _exists_:standard_value AND _exists_:ligand_efficiency'
    ligandEfficiencies = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(customQueryString)
    console.log 'query string: ', customQueryString

    new TargetNameAndClassificationView
      model: target
      el: $('#TNameClassificationCard')

    new TargetComponentsView
      collection: targetComponents
      el: $('#TComponentsCard')

    new RelationsView
      collection: targetRelations
      el: $('#TRelationsCard')

    new ApprovedDrugsClinicalCandidatesView
      collection: appDrugsClinCandsList
      el: $('#ApprovedDrugsAndClinicalCandidatesCard')

    new TargetAssociatedBioactivitiesView
      model: bioactivities
      el: $('#TAssociatedBioactivitiesCard')
      target_chembl_id: GlobalVariables.CHEMBL_ID

    new TargetAssociatedAssaysView
      model: associatedAssays
      el: $('#TAssociatedAssaysCard')

    new glados.views.Target.LigandEfficienciesView
      collection: ligandEfficiencies
      el: $('#TLigandEfficienciesCard')
      target_chembl_id: GlobalVariables.CHEMBL_ID

    @initAssociatedCompoundsContent(GlobalVariables.CHEMBL_ID)

    target.fetch()
    appDrugsClinCandsList.fetch()
    targetRelations.fetch({reset: true})
    targetComponents.fetch({reset: true})
    bioactivities.fetch()
    associatedAssays.fetch()

  @initTargetNameAndClassification = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    target = new Target
      target_chembl_id: GlobalVariables.CHEMBL_ID

    new TargetNameAndClassificationView
      model: target
      el: $('#TNameClassificationCard')
    target.fetch()

  @initTargetComponents = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    targetComponents = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetComponentsList()
    targetComponents.initURL GlobalVariables.CHEMBL_ID

    new TargetComponentsView
      collection: targetComponents
      el: $('#TComponentsCard')

    targetComponents.fetch({reset: true})

  @initTargetRelations = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    targetRelations = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetRelationsList()
    targetRelations.initURL GlobalVariables.CHEMBL_ID

    new RelationsView
      collection: targetRelations
      el: $('#TRelationsCard')

    targetRelations.fetch({reset: true})

  @initApprovedDrugsClinicalCandidates = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    appDrugsClinCandsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()
    appDrugsClinCandsList.initURL(GlobalVariables.CHEMBL_ID)

    new ApprovedDrugsClinicalCandidatesView
      collection: appDrugsClinCandsList
      el: $('#ApprovedDrugsAndClinicalCandidatesCard')

    appDrugsClinCandsList.fetch()

  @initBioactivities = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()
    bioactivities = new TargetAssociatedBioactivities
      target_chembl_id: GlobalVariables.CHEMBL_ID

    new TargetAssociatedBioactivitiesView
      model: bioactivities
      el: $('#TAssociatedBioactivitiesCard')

    bioactivities.fetch()

  @initAssociatedAssays = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()
    associatedAssays = new TargetAssociatedAssays
      target_chembl_id: GlobalVariables.CHEMBL_ID

    new TargetAssociatedAssaysView
      model: associatedAssays
      el: $('#TAssociatedAssaysCard')
      target_chembl_id: GlobalVariables.CHEMBL_ID

    associatedAssays.fetch()

  @initLigandEfficiencies = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()
    customQueryString = 'target_chembl_id:' + GlobalVariables.CHEMBL_ID + ' AND' +
      ' standard_type:(IC50 OR Ki OR EC50 OR Kd) AND _exists_:standard_value AND _exists_:ligand_efficiency'
    ligandEfficiencies = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(customQueryString)

    new glados.views.Target.LigandEfficienciesView
      collection: ligandEfficiencies
      el: $('#TLigandEfficienciesCard')
      target_chembl_id: GlobalVariables.CHEMBL_ID

  @initAssociatedCompoundsContent = (targetChemblID) ->

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

    associatedCompounds = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      target_chembl_id: targetChemblID
      aggs_config: aggsConfig

    new glados.views.Target.AssociatedCompoundsView
      el: $('#TAssociatedCompoundProperties')
      model: associatedCompounds

    associatedCompounds.fetch()

  @initAssociatedCompounds = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()
    @initAssociatedCompoundsContent(GlobalVariables.CHEMBL_ID)


  @initMiniTargetReportCard = ($containerElem, chemblID) ->

    target = new Target({target_chembl_id: chemblID})
    new glados.views.MiniReportCardView
      el: $containerElem
      model: target
      entity: Target
    target.fetch()

  @initMiniBioactivitiesHistogram = ($containerElem, chemblID) ->

    bioactivities = new TargetAssociatedBioactivities
      target_chembl_id: chemblID

    barsColourScale = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'STANDARD_TYPE',
      withColourScale=true).colourScale

    config =
      max_categories: 8
      bars_colour_scale: barsColourScale
      fixed_bar_width: true
      hide_title: true

    new glados.views.Visualisation.HistogramView
      model: bioactivities
      el: $containerElem
      config: config

    bioactivities.fetch()

  @initMiniHistogramFromFunctionLink = ->
    $clickedLink = $(@)
    paramsList = $(@).attr('data-function-paramaters').split(',')
    targetChemblID = paramsList[0]
    $containerElem = $clickedLink.parent()
    $containerElem.removeClass('number-cell')
    $containerElem.addClass('vis-container')

    glados.Utils.fillContentForElement($containerElem, {}, 'Handlebars-Common-MiniHistogramContainer')

    TargetReportCardApp.initMiniBioactivitiesHistogram($containerElem, targetChemblID)


