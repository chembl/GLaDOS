class DocumentReportCardApp

  # -------------------------------------------------------------
  # Initialization
  # -------------------------------------------------------------
  @init = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    document = new Document
      document_chembl_id: GlobalVariables.CHEMBL_ID

    documentAssayNetwork = new DocumentAssayNetwork
      document_chembl_id: GlobalVariables.CHEMBL_ID

    new DocumentBasicInformationView
      model: document
      el: $('#DBasicInformation')

    new DocumentAssayNetworkView
      model: documentAssayNetwork
      el: $('#DAssayNetworkCard')

    document.fetch()
    documentAssayNetwork.fetch()

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initBasicInformation = ->
    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    document = new Document
      document_chembl_id: GlobalVariables.CHEMBL_ID

    new DocumentBasicInformationView
      model: document
      el: $('#DBasicInformation')

    document.fetch()

  @initAssayNetwork = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    documentAssayNetwork = new DocumentAssayNetwork
      document_chembl_id: GlobalVariables.CHEMBL_ID

    new DocumentAssayNetworkView
      model: documentAssayNetwork
      el: $('#DAssayNetworkCard')

    documentAssayNetwork.fetch()


  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------


  ### *
    * Initializes the DANFSView (Document Assay Network Full Screen View)
    * @param {Compound} model, base model for the view
    * @param {JQuery} top_level_elem element that renders the model.
    * @return {DocumentAssayNetworkFSView} the view that has been created
  ###
  @initDANFSView = (model, top_level_elem) ->

    danFSView = new DocumentAssayNetworkFSView
      el: top_level_elem
      model: model

    return danFSView