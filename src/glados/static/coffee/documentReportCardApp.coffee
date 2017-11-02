class DocumentReportCardApp

  # -------------------------------------------------------------
  # Initialization
  # -------------------------------------------------------------
  @init = ->

    document = DocumentReportCardApp.getCurrentDocument()

    DocumentReportCardApp.initBasicInformation()
    DocumentReportCardApp.initAssayNetwork()
    DocumentReportCardApp.initWordCloud()

    document.fetch()

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentDocument = ->

    if not @currentDocument?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentDocument = new Document
        document_chembl_id: chemblID
      return @currentDocument

    else return @currentDocument

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initBasicInformation = ->

    document = DocumentReportCardApp.getCurrentDocument()

    new DocumentBasicInformationView
      model: document
      el: $('#DBasicInformation')

    if GlobalVariables['EMBEDED']
      document.fetch()

  @initAssayNetwork = ->

    documentAssayNetwork = new DocumentAssayNetwork
      document_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new DocumentAssayNetworkView
      model: documentAssayNetwork
      el: $('#DAssayNetworkCard')

    documentAssayNetwork.fetch()

  @initWordCloud = ->

    docTerms = new DocumentTerms
      document_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new DocumentWordCloudView
      model: docTerms
      el: $('#DWordCloudCard')

    docTerms.fetch()

  @initTargetSummary = ->
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