class AssayReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    assay = AssayReportCardApp.getCurrentAssay()
    AssayReportCardApp.initAssayBasicInformation()
    AssayReportCardApp.initCurationSummary()

    assay.fetch()

    $('.scrollspy').scrollSpy();
    ScrollSpyHelper.initializeScrollSpyPinner();

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initAssayBasicInformation = ->

    assay = AssayReportCardApp.getCurrentAssay()

    new AssayBasicInformationView
      model: assay
      el: $('#ABasicInformation')

    if GlobalVariables['EMBEDED']
      assay.fetch()

  @initCurationSummary = ->

    target = new Target
      assay_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new AssayCurationSummaryView
      model: target
      el: $('#ACurationSummaryCard')

    target.fetchFromAssayChemblID();

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentAssay = ->

    if not @currentAssay?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentAssay = new Assay
        assay_chembl_id: chemblID
      return @currentAssay

    else return @currentAssay
