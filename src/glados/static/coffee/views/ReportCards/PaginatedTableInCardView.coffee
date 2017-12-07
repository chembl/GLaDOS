glados.useNameSpace 'glados.views.ReportCards',
  PaginatedTableInCardView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @collection.on 'reset', @.render, @
      @resource_type = 'Target'
      @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
        @collection, @el, customRenderEvent=undefined, disableColumnsSelection=true)

      @initEmbedModal('components', arguments[0].target_chembl_id)
      @activateModals()


    events: ->
      return _.extend {}, DownloadViewExt.events

    render: ->

      if @collection.size() == 0 and !@collection.getMeta('force_show')
        return

      @showSection()
      @showCardContent()