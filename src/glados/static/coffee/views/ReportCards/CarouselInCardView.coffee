glados.useNameSpace 'glados.views.ReportCards',
  CarouselInCardView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @config = arguments[0].config

      @collection.on 'reset', @.render, @

      if @config.hide_on_error
        @collection.on 'error', @hideSection, @
      else
        @collection.on 'error', @.showCompoundErrorCard, @

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
