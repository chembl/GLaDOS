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

    docTerms = new DocumentTerms
      document_chembl_id: GlobalVariables.CHEMBL_ID

    dWordCloudView = new DocumentWordCloudView
      model: docTerms
      el: $('#BCK-DocWordCloud')


    new DocumentAssayNetworkView
      model: documentAssayNetwork
      el: $('#DAssayNetworkCard')

    document.fetch()
    documentAssayNetwork.fetch()
    docTerms.fetch()

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
  # Full Screen views
  # -------------------------------------------------------------
  @initAssayNetworkFS = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    documentAssayNetwork = new DocumentAssayNetwork
      document_chembl_id: GlobalVariables.CHEMBL_ID

    danFSView = new DocumentAssayNetworkFSView
      model: documentAssayNetwork
      el: $('#DAN-Main')

    documentAssayNetwork.fetch()