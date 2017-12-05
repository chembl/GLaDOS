glados.useNameSpace 'glados.views.ReportCards',
  EntityDetailsInCardView: CardView.extend

    initialize: ->
      CardView.prototype.initialize.call(@, arguments)
      @config = arguments[0].config
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

    render: ->

      @showSection()
      @showCardContent()

      console.log 'RENDER DETAILS!!'
