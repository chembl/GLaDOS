glados.useNameSpace 'glados',
  ReportCardApp: class ReportCardApp

    @hideSection = (sectionID) -> $('#' + sectionID).hide()
    @showSection = (sectionID) -> $('#' + sectionID).show()
    @init = ->
      @scrollSpyHandler = new glados.models.ScrollSpy.ScrollSpyHandler