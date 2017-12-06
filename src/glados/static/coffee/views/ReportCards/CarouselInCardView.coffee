glados.useNameSpace 'glados.views.ReportCards',
  CarouselInCardView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @collection.on 'reset', @.render, @
      @collection.on 'error', @.showCompoundErrorCard, @
      @config = arguments[0].config
      @resource_type = arguments[0].resource_type
      @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewCardsPaginatedView(@collection, @el)

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()
      @render()

    render: ->

      glados.Utils.fillContentForElement $(@el).find('.BCK-CarouselTitle'),
        title: @config.title

      @showSection()
      @showCardContent()
