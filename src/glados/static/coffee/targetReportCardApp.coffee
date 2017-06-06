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

    targetRelations = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetRelationsList()
    targetRelations.initURL GlobalVariables.CHEMBL_ID

    targetComponents = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetComponentsList()

    targetComponents.initURL GlobalVariables.CHEMBL_ID

    bioactivities = new TargetAssociatedBioactivities
      target_chembl_id: GlobalVariables.CHEMBL_ID

    associatedAssays = new TargetAssociatedAssays
      target_chembl_id: GlobalVariables.CHEMBL_ID

    filter = 'target_chembl_id=' + GlobalVariables.CHEMBL_ID + '&standard_type__in=IC50,Ki,EC50,Kd' +
    '&standard_value__isnull=false&ligand_efficiency__isnull=false'

    customQueryString = 'target_chembl_id:CHEMBL2093868 AND ' +
      'standard_type:(IC50 OR Ki OR EC50 OR Kd) AND _exists_:standard_value AND _exists_:ligand_efficiency'
    ligandEfficiencies = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(customQueryString)

#    ligandEfficiencies = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewActivitiesList(filter)

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

    new TargetAssociatedAssaysView
      model: associatedAssays
      el: $('#TAssociatedAssaysCard')

    new glados.views.Target.LigandEfficienciesView
      collection: ligandEfficiencies
      el: $('#TLigandEfficienciesCard')
      target_chembl_id: GlobalVariables.CHEMBL_ID

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

    filter = 'target_chembl_id=' + GlobalVariables.CHEMBL_ID + '&standard_type__in=IC50,Ki,EC50,Kd' +
    '&standard_value__isnull=false&ligand_efficiency__isnull=false'
    ligandEfficiencies = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewActivitiesList(filter)

    new glados.views.Target.LigandEfficienciesView
      collection: ligandEfficiencies
      el: $('#TLigandEfficienciesCard')

  @initMiniTargetReportCard = ($containerElem, chemblID) ->

    target = new Target({target_chembl_id: chemblID})
    new MiniReportCardView
      el: $containerElem
      model: target
      entity: Target
    target.fetch()

