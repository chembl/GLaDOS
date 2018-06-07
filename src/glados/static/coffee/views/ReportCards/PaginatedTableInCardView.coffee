glados.useNameSpace 'glados.views.ReportCards',
  PaginatedTableInCardView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @collection.on 'reset', @.render, @
      @config = arguments[0].config
      @resource_type = arguments[0].resource_type
      @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
        @collection, @el, customRenderEvent=undefined, disableColumnsSelection=true)

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

    events: ->
      return _.extend {}, DownloadViewExt.events

    render: ->

      if @collection.size() == 0 and !@collection.getMeta('force_show')
        @hideSection()
        return

      if @config.show_if?
        show = @config.show_if(@model)
        if not show
          @hideSection()
          return

      linkToAllText = @config.link_to_all_text
      linkToAllURL = @config.link_to_all_url
      if linkToAllText? and linkToAllURL?
        $linkToAllContainer = $(@el).find('.BCK-link-to-all')
        glados.Utils.fillContentForElement $linkToAllContainer,
          link_text: linkToAllText
          url: linkToAllURL

      @showSection()
      @showCardContent()