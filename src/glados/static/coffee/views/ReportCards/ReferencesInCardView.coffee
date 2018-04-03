glados.useNameSpace 'glados.views.ReportCards',
  ReferencesInCardView: CardView.extend

    initialize: ->
      @config = arguments[0].config
      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @

      @resource_type = arguments[0].resource_type
      @embed_section_name = arguments[0].embed_section_name
      @embed_identifier = arguments[0].embed_identifier

      @initEmbedModal(@embed_section_name, @embed_identifier)
      @activateModals()

      refsConfig = @config.refs_config
      new glados.views.References.ReferencesView
        model: @model
        el: $(@el).find('.BCK-ReferencesContainer')
        config: refsConfig

    render: ->


      if @config.refs_config.is_unichem
        if not @model.get('_metadata').unichem?
          @hideSection()
          return

      @showSection()
      @showCardContent()