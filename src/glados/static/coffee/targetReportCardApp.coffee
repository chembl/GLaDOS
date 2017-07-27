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

    associatedCompounds = new glados.models.Target.TargetAssociatedCompounds
      target_chembl_id: GlobalVariables.CHEMBL_ID

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

    new glados.views.Target.AssociatedCompoundsView
      el: $('#TAssociatedCompoundProperties')
      model: associatedCompounds

    target.fetch()
    appDrugsClinCandsList.fetch()
    targetRelations.fetch({reset: true})
    targetComponents.fetch({reset: true})
    bioactivities.fetch()
    associatedAssays.fetch()
    associatedCompounds.fetch()

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

  @initAssociatedCompounds = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    associatedCompounds = new glados.models.Target.TargetAssociatedCompounds
        target_chembl_id: GlobalVariables.CHEMBL_ID

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()
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


