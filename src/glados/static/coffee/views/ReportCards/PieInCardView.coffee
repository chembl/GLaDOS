glados.useNameSpace 'glados.views.ReportCards',
  PieInCardView: CardView.extend

    initialize: ->
      @config = arguments[0].config
      CardView.prototype.initialize.call(@, arguments)
      @resource_type = @config.resource_type

      initAggFromModelEvent = @config.init_agg_from_model_event?
      if initAggFromModelEvent
        generatorModel = @config.init_agg_from_model_event.model
        generatorModel.on 'change', @initAggAndBind, @
      else
        @initAggAndBind()

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

    #-------------------------------------------------------------------------------------------------------------------
    # Events binding
    #-------------------------------------------------------------------------------------------------------------------
    initAggFromModel: ->

      console.log 'initAggFromModel: '
      generatorModel = @config.init_agg_from_model_event.model
      chemblID = generatorModel.get('id')
      console.log 'chemblID: ', chemblID
      aggGeneratorFunction = @config.init_agg_from_model_event.agg_generator_function
      @model = aggGeneratorFunction(generatorModel)
      console.log '@model: ', @model

    initAggAndBind: ->

      console.log 'INIT AGG VIEW AND BINDING!'
      initAggFromModelEvent = @config.init_agg_from_model_event?
      if initAggFromModelEvent
        @initAggFromModel()
        return
      console.log 'GOING TO BIND EVENTS FOR AGG'
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

