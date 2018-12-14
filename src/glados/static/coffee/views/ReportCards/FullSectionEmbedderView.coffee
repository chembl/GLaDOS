glados.useNameSpace 'glados.views.ReportCards',
  FullSectionEmbedderView: CardView.extend

    initialize: ->

      @config = arguments[0].config
      CardView.prototype.initialize.call(@, arguments)
      @resource_type = @config.resource_type

      @initEmbedModal('activity_charts', @config.embed_identifier)
      @activateModals()