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
        visualisations_ids: ({id:i, vis_title:visualisationsConfig[i].vis_title} for i in [0..numVisualisations-1])

      @loadVisHTMLContent()

    loadVisHTMLContent: ->

      visualisationsConfig = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_CONFIG
      for index, config of visualisationsConfig

        config = visualisationsConfig[index]

        $vizContainer = $(@el).find("[data-viz-item-id='Visualisation#{index}']").find('.BCK-vis-container')
        templateSourceURL = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_HB_SOURCES
        templateID = config.template_id
        loadPromise = glados.Utils.loadTemplateAndFillContentForElement(templateSourceURL, templateID, $vizContainer)

        loaderGenerator = (config) ->
          return ->
            initFunction = config.init_function
            initFunction()

        loadPromise.done loaderGenerator(config)
