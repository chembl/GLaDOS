class CellLineReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    cellLine = new CellLine
      cell_chembl_id: GlobalVariables.CHEMBL_ID

    new CellLineBasicInformationView
      model: cellLine
      el: $('#CBasicInformation')

    cellLine.fetch()

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initBasicInformation = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    cellLine = new CellLine
      cell_chembl_id: GlobalVariables.CHEMBL_ID

    new CellLineBasicInformationView
      model: cellLine
      el: $('#CBasicInformation')

    cellLine.fetch()