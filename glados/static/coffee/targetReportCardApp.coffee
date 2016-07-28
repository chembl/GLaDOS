class TargetReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initTarget = (chembl_id) ->
    target = new Target
      target_chembl_id: chembl_id

    return target

  @initAppDrugClinCands = ->

    appDrugCCList = new ApprovedDrugClinicalCandidateList

    appDrugCCList.url = 'https://www.ebi.ac.uk/chembl/api/data/mechanism.json?target_chembl_id=CHEMBL4794&order_by=molecule_chembl_id'
    return appDrugCCList

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
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {TargetComponentsView} the view that has been created
  ###
  @initTComponentsView = (model, top_level_elem) ->

    tcView = new TargetComponentsView
      model: model
      el: top_level_elem

    return tcView
