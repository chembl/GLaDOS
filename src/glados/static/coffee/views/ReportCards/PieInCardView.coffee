glados.useNameSpace 'glados.views.ReportCards',
  PieInCardView: CardView.extend

    initialize: ->
      @config = arguments[0].config
      CardView.prototype.initialize.call(@, arguments)
      @resource_type = @config.resource_type

      initAggFromModelEvent = @config.init_agg_from_model_event?
      if initAggFromModelEvent
        generatorModel = @config.init_agg_from_model_event.model
        generatorModel.on 'change', @initAggAndBindFromGenModel, @
      else
        @createPieView()
        @bindAgg()

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

    #-------------------------------------------------------------------------------------------------------------------
    # Events binding
    #-------------------------------------------------------------------------------------------------------------------
    initAggFromModel: ->

      generatorModel = @config.init_agg_from_model_event.model
      chemblID = generatorModel.get('id')

      aggGeneratorFunction = @config.init_agg_from_model_event.agg_generator_function
      @model = aggGeneratorFunction(generatorModel)

      pieConfigGeneratorFunction = @config.init_agg_from_model_event.pie_config_generator_function
      pieConfig = pieConfigGeneratorFunction(generatorModel)
      @config.pie_config = pieConfig

    bindAgg: -> @model.on 'change', @render, @

    initAggAndBindFromGenModel: ->

      initAggFromModelEvent = @config.init_agg_from_model_event?
      if initAggFromModelEvent
        @initAggFromModel()
        @createPieView()
        @bindAgg()
        @model.fetch()

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

