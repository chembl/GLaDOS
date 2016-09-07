class CellLineReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------

  @initCellLine = (chembl_id) ->
    cell_line = new CellLine
      cell_chembl_id: chembl_id

    cell_line.url = Settings.WS_BASE_URL + 'cell_line/' + chembl_id + '.json'
    return cell_line

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  ### *
    * Initializes the CBIView (Cell Basic Information View)
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {CellBasicInformationViewView} the view that has been created
  ###
  @initCBIView = (model, top_level_elem) ->

    cbiView = new CellLineBasicInformationView
      model: model
      el: top_level_elem

    return cbiView
