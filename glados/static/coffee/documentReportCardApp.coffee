class DocumentReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------

  @initDocument = (chembl_id) ->
    document = new Document
      document_chembl_id: chembl_id

    document.url = 'https://www.ebi.ac.uk/chembl/api/data/document/' + chembl_id + '.json'
    return document

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  ### *
    * Initializes the DBIView (Document Basic Information View)
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {DocumentBasicInformationViewView} the view that has been created
  ###
  @initDBIView = (model, top_level_elem) ->

    dbiView = new DocumentBasicInformationView
      model: model
      el: top_level_elem

    return dbiView