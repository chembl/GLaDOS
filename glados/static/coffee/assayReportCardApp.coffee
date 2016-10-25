class AssayReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    assay = new Assay
      assay_chembl_id: GlobalVariables.CHEMBL_ID

    new AssayBasicInformationView
      model: assay
      el: $('#ABasicInformation')

    new AssayCurationSummaryView
      model: assay
      el: $('#ACurationSummaryCard')

    assay.fetch();

    $('.scrollspy').scrollSpy();
    ScrollSpyHelper.initializeScrollSpyPinner();

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initAssayBasicInformation = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    assay = new Assay
      assay_chembl_id: GlobalVariables.CHEMBL_ID

    new AssayBasicInformationView
      model: assay
      el: $('#ABasicInformation')

    assay.fetch()

  @initCurationSummary = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    assay = new Assay
      assay_chembl_id: GlobalVariables.CHEMBL_ID

    new AssayCurationSummaryView
      model: assay
      el: $('#ACurationSummaryCard')

    assay.fetch();


