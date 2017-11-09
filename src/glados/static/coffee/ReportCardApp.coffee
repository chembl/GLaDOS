glados.useNameSpace 'glados',
  ReportCardApp: class ReportCardApp

    @hideSection = (sectionID) -> $('#' + sectionID).hide()
    @showSection = (sectionID) -> $('#' + sectionID).show()