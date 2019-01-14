glados.useNameSpace 'glados.views.Visualisation',
  # this lis like the glados.views.MainPage.VisualisationsWithCaptionsView but for the standalone visualisations page,
  # no carousel
  VisualisationsPageHandlerView: glados.views.MainPage.VisualisationsWithCaptionsView.extend

    initialize: ->

      console.log 'init glados.views.Visualisation.VisualisationsPageHandlerView'
      @render()

    render: ->

      visualisationsConfig = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_CONFIG
      numVisualisations = _.keys(visualisationsConfig).length

      glados.Utils.fillContentForElement $(@el),
        visualisations_ids: (i for i in [0..numVisualisations-1])
