class DocumentReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------

  @initDocument = (chembl_id) ->
    document = new Document
      document_chembl_id: chembl_id

    document.url = 'https://www.ebi.ac.uk/chembl/api/data/document/' + chembl_id + '.json'
    return document

  @initDocumentAssayNetwork = (doc_chembl_id) ->
    dan = new DocumentAssayNetwork
      document_chembl_id: doc_chembl_id

    return dan


  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  ### *
    * Initializes the DBIView (Document Basic Information View)
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {DocumentBasicInformationView} the view that has been created
  ###
  @initDBIView = (model, top_level_elem) ->

    dbiView = new DocumentBasicInformationView
      model: model
      el: top_level_elem

    return dbiView


  ### *
    * Initializes the DANView (Document Assay Network View)
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {DocumentAssayNetworkView} the view that has been created
  ###
  @initDANView = (top_level_elem) ->

    danView = new DocumentAssayNetworkView
      el: top_level_elem

    return danView