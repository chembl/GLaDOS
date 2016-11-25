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

    appDrugsClinCandsList = new ApprovedDrugClinicalCandidateList
    appDrugsClinCandsList.url = Settings.WS_BASE_URL + 'mechanism.json?target_chembl_id=' + (GlobalVariables.CHEMBL_ID)
    +'&order_by=molecule_chembl_id&limit=1000'

    targetRelations = new TargetRelationList
    targetRelations.url = Settings.WS_DEV_BASE_URL + 'target_relation.json?related_target_chembl_id=' + GlobalVariables.CHEMBL_ID + '&order_by=target_chembl_id&limit=1000'

    new TargetNameAndClassificationView
      model: target
      el: $('#TNameClassificationCard')

    new TargetComponentsView
      model: target
      el: $('#TComponentsCard')

    new RelationsView
      collection: targetRelations
      el: $('#TRelationsCard')

    new ApprovedDrugsClinicalCandidatesView
      collection: appDrugsClinCandsList
      el: $('#ApprovedDrugsAndClinicalCandidatesCard')

    target.fetch()
    appDrugsClinCandsList.fetch()
    targetRelations.fetch({reset: true})

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

    target = new Target
      target_chembl_id: GlobalVariables.CHEMBL_ID

    new TargetComponentsView
      model: target
      el: $('#TComponentsCard')

    target.fetch()

  @initTargetRelations = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    targetRelations = new TargetRelationList
    targetRelations.url = Settings.WS_DEV_BASE_URL + 'target_relation.json?related_target_chembl_id=' + GlobalVariables.CHEMBL_ID + '&order_by=target_chembl_id&limit=1000'

    new RelationsView
      collection: targetRelations
      el: $('#TRelationsCard')

    targetRelations.fetch({reset: true})

  @initApprovedDrugsClinicalCandidates = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    appDrugsClinCandsList = new ApprovedDrugClinicalCandidateList
    appDrugsClinCandsList.url = Settings.WS_BASE_URL + 'mechanism.json?target_chembl_id=' + GlobalVariables.CHEMBL_ID + '&order_by=molecule_chembl_id&limit=1000'

    new ApprovedDrugsClinicalCandidatesView
      collection: appDrugsClinCandsList
      el: $('#ApprovedDrugsAndClinicalCandidatesCard')

    appDrugsClinCandsList.fetch()

