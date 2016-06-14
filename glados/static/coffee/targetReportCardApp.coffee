class TargetReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initTarget = (chembl_id) ->
    target = new Target
      target_chembl_id: chembl_id

    target.url = 'https://www.ebi.ac.uk/chembl/api/data/target/' + chembl_id + '.json'
    return target

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
