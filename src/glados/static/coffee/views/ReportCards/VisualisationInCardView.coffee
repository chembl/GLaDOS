glados.useNameSpace 'glados.views.ReportCards',
  VisualisationInCardView: CardView.extend

    initialize: ->

      @config = arguments[0].config
      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @

      @resource_type = @config.resource_type
      unless @config.disable_embedding
        @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
        @activateModals()

      ViewClass = @config.view_class

      new ViewClass
        el: $(@el).find('.BCK-visualisation-container')
        model: @model
        config: @config.view_config

    render: ->

      @showCardContent()
