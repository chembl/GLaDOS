class CellLineReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    cellLine = CellLineReportCardApp.getCurrentCellLine()
    CellLineReportCardApp.initBasicInformation()
    cellLine.fetch()

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentCellLine = ->

    if not @currentCellLine?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentCellLine = new CellLine
        cell_chembl_id: chemblID
      return @currentCellLine

    else return @currentCellLine

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initBasicInformation = ->


    cellLine = CellLineReportCardApp.getCurrentCellLine()

    new CellLineBasicInformationView
      model: cellLine
      el: $('#CBasicInformation')

    if GlobalVariables['EMBEDED']
      cellLine.fetch()