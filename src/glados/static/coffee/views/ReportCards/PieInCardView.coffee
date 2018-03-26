glados.useNameSpace 'glados.views.ReportCards',
  PieInCardView: CardView.extend

    initialize: ->
      @config = arguments[0].config
      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @
      @resource_type = @config.resource_type

      @paginatedView = new PieView
        model: @model
        el: $(@el).find('.BCK-Main-Pie-container')
        config: @config.pie_config

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

    render: ->

      @showSection() unless @config.is_outside_an_entity_report_card
      @showCardContent()

      if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE or \
      @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
        return

