glados.useNameSpace 'glados',
  ReportCardApp: class ReportCardApp

    @init = ->
      @scrollSpyHandler = new glados.models.ScrollSpy.ScrollSpyHandler
      ScrollSpyHelper.initializeScrollSpyPinner()
      new glados.views.ScrollSpy.ScrollSpyView
        el: $('.BCK-ScrollSpy')
        model: @scrollSpyHandler


    @hideSection = (sectionID) -> $('#' + sectionID).hide()
    @showSection = (sectionID) ->
      @scrollSpyHandler.showSection(sectionID)
      $('#' + sectionID).show()
    @registerSection = (sectionID, sectionLabel) ->
      @scrollSpyHandler.registerSection(sectionID, sectionLabel)
