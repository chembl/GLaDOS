class AssayReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------

  @initAssay = (chembl_id) ->
    assay = new Assay
      assay_chembl_id: chembl_id

    return assay

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  ### *
    * Initializes the ABIView (Assay Basic Information View)
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {AssayBasicInformationView} the view that has been created
  ###
  @initABIView = (model, top_level_elem) ->

    abiView = new AssayBasicInformationView
      model: model
      el: top_level_elem

    return abiView

  ### *
    * Initializes the ACSView (Assay Curation Summary View)
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {AssayBCurationSummaryView} the view that has been created
  ###
  @initACSView  = (model, top_level_elem) ->

    aciView = new AssayCurationSummaryView
      model: model
      el: top_level_elem

    return aciView