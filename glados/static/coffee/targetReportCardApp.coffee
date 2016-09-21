class TargetReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initTarget = (chembl_id) ->
    target = new Target
      target_chembl_id: chembl_id

    return target

  @initAppDrugClinCands = (chembl_id) ->
    appDrugCCList = new ApprovedDrugClinicalCandidateList

    appDrugCCList.url = Settings.WS_BASE_URL + 'mechanism.json?target_chembl_id=' + (chembl_id) + '&order_by=molecule_chembl_id&limit=1000'
    return appDrugCCList

  @initAppDrugClinCandsTest = (chembl_id) ->
    appDrugCCList = new ApprovedDrugClinicalCandidateListTest

    appDrugCCList.url = Settings.WS_BASE_URL + 'mechanism.json?target_chembl_id=' + (chembl_id) + '&order_by=molecule_chembl_id&limit=1000'
    return appDrugCCList

  @initTargetRelations = (chembl_id) ->

    targRelList = new TargetRelationList

    targRelList.url = Settings.WS_DEV_BASE_URL + 'target_relation.json?related_target_chembl_id=' + chembl_id + '&order_by=target_chembl_id&limit=1000'
    return targRelList

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  ### *
    * Initializes the TNCView (Target Name and Clasification View)
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {TargetNameClassificationView} the view that has been created
  ###
  @initTNCView = (model, top_level_elem) ->
    tncView = new TargetNameAndClassificationView
      model: model
      el: top_level_elem

    return tncView


  ### *
    * Initializes the TComponentsView (Target Components View)
    * @param {Target} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {TargetComponentsView} the view that has been created
  ###
  @initTComponentsView = (model, top_level_elem) ->
    tcView = new TargetComponentsView
      model: model
      el: top_level_elem

    return tcView


  ### *
    * Initializes the ADCC View (Approved Drugs Clinical Candidates View)
    * @param {Collection} adccList, the collection of approved drugs and clinical candidates
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {TargetComponentsView} the view that has been created
  ###
  @initADCC = (adccList, top_level_elem) ->
    adccView = new ApprovedDrugsClinicalCandidatesView
      collection: adccList
      el: top_level_elem

    return adccView


  @initADCCTest = (adccList, top_level_elem) ->
    adccView = new ApprovedDrugsClinicalCandidatesViewTest
      collection: adccList
      el: top_level_elem

    return adccView

  ### *
    * Initializes the TRelationsView (Target Relations View)
    * @param {Compound} rel_list, the collection of the relations of the target
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {TargetComponentsView} the view that has been created
  ###
  @initTRelationsView = (rel_list, top_level_elem) ->

    trelView = new RelationsView
      collection: rel_list
      el: top_level_elem

    return trelView