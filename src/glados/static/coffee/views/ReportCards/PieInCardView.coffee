glados.useNameSpace 'glados.views.ReportCards',
  PieInCardView: CardView.extend

    initialize: ->
      @config = arguments[0].config
      CardView.prototype.initialize.call(@, arguments)
      @resource_type = @config.resource_type

      @initAggViewAndBinding()

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

    #-------------------------------------------------------------------------------------------------------------------
    # Events binding
    #-------------------------------------------------------------------------------------------------------------------
    initAggViewAndBinding: ->

      @model.on 'change', @render, @
      @createPieView()
      
    createPieView: ->

      @paginatedView = new PieView
        model: @model
        el: $(@el).find('.BCK-Main-Pie-container')
        config: @config.pie_config

    #-------------------------------------------------------------------------------------------------------------------
    # Render
    #-------------------------------------------------------------------------------------------------------------------
    render: ->

      @showSection() unless @config.is_outside_an_entity_report_card
      @showCardContent()

      if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE or \
      @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
        return

