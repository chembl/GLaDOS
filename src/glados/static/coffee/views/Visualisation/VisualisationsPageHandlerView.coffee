glados.useNameSpace 'glados.views.Visualisation',
  # this lis like the glados.views.MainPage.VisualisationsWithCaptionsView but for the standalone visualisations page,
  # no carousel
  VisualisationsPageHandlerView: glados.views.MainPage.VisualisationsWithCaptionsView.extend

    initialize: ->

      console.log 'init glados.views.Visualisation.VisualisationsPageHandlerView'