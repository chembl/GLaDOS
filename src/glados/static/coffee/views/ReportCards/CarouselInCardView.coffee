glados.useNameSpace 'glados.views.ReportCards',
  CarouselInCardView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @collection.on 'reset', @.render, @
      @collection.on 'error', @.showCompoundErrorCard, @
      @resource_type = arguments[0].resource_type
      @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewCardsPaginatedView(@collection, @el)

      @initEmbedModal('alternate_forms', arguments[0].molecule_chembl_id)
      @activateModals()
      @render()

    render: ->
      if @collection.length == 1 and @collection.at(0).get('molecule_chembl_id') == GlobalVariables.CHEMBL_ID and not GlobalVariables['EMBEDED']
        return

      @showSection()
      glados.Utils.fillContentForElement $(@el).find('.alternate-compounds-title'),
        chembl_id: GlobalVariables.CHEMBL_ID

      @showCardContent()
