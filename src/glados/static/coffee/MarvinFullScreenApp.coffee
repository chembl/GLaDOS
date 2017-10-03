glados.useNameSpace 'glados',
  # --------------------------------------------------------------------------------------------------------------------
  # Marvin Full Screen App
  # --------------------------------------------------------------------------------------------------------------------
  MarvinFullScreenApp: class MarvinFullScreenApp

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------------------------------------------------------

    @init: ->
      molfile_data = window.sessionStorage.getItem('molfile_data')
      # Marvin js sketcher
      @marvinSketcherView = new MarvinSketcherView({sdf_to_load_on_ready: molfile_data})
      $('.modal').modal()
      cancel_href = glados.Settings.GLADOS_BASE_PATH_REL
      if document.referrer != window.location.href
        cancel_href = document.referrer
      $('#cancel-button').attr('href', cancel_href)





