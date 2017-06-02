glados.useNameSpace 'glados',
  # --------------------------------------------------------------------------------------------------------------------
  # Marvin Full Screen App
  # --------------------------------------------------------------------------------------------------------------------
  MarvinFullScreenApp: class MarvinFullScreenApp

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------------------------------------------------------

    @init: ->
      # Marvin js sketcher
      @marvinSketcherView = new MarvinSketcherView()
      $('.modal').modal()
      cancel_href = glados.Settings.GLADOS_BASE_PATH_REL
      if document.referrer != window.location.href
        cancel_href = document.referrer
      $('#cancel-button').attr('href', cancel_href)
      molfile_data = window.sessionStorage.getItem('molfile_data')
      console.log(molfile_data)
      msv= @marvinSketcherView
      setTimeout(->
        msv.loadSDF(molfile_data)
      ,5000)





