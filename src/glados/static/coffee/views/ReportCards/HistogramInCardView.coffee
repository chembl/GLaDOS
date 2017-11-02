glados.useNameSpace 'glados.views.ReportCards',
  HistogramInCardView: CardView.extend

    initialize: ->

      @config = arguments[0].config
      @model.on 'change', @render, @
      $progressElem = $(@el).find('.load-messages-container')
      @model.set('progress_elem', $progressElem)

      @resource_type = @config.resource_type
      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

      histogramConfig = @config.histogram_config
      @model.set('current_xaxis_property', histogramConfig.properties[histogramConfig.initial_property_x].propName)
      @model.set('num_columns', histogramConfig.x_axis_initial_num_columns)
      @model.set('x_axis_min_columns', histogramConfig.x_axis_min_columns)
      @model.set('x_axis_max_columns', histogramConfig.x_axis_max_columns)

      @histogramView = new glados.views.Visualisation.HistogramView
        el: $(@el).find('.BCK-MainHistogramContainer')
        config: histogramConfig
        model: @model

    render: ->
      @showCardContent()
