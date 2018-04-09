glados.useNameSpace 'glados.views.Compound',
  UnichemConnectivityMatchesView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @
      @model.on 'error', @showCompoundErrorCard, @
      @resource_type = 'Compound'

      @initEmbedModal(arguments[0].embed_section_name, arguments[0].embed_identifier)
      @activateModals()

    render: ->

      @showCardContent()
      @showSection()

