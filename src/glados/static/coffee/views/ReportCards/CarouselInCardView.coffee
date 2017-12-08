glados.useNameSpace 'glados.views.ReportCards',
  CarouselInCardView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @collection.on 'reset', @.render, @
      @collection.on 'error', @.showCompoundErrorCard, @
      @config = arguments[0].config
      @resource_type = arguments[0].resource_type
      @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewCardsCarouselView(@collection, @el)

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()
      @render()

    render: ->

      glados.Utils.fillContentForElement $(@el).find('.BCK-CarouselTitle'),
        title: @config.title

      fullListURL = @config.full_list_url
      if fullListURL?
        glados.Utils.fillContentForElement $(@el).find('.BCK-LinkToFullList'),
          full_list_link: fullListURL

      @showSection()
      @showCardContent()
