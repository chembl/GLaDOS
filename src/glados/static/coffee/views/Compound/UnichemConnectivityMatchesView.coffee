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

      thereAreNoReferences = not @model.get('_metadata').unichem?
      if thereAreNoReferences
        @hideSection()
        return

      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
      list.setCompound(@model)
      # this will be done directly from the info in the compounds
      parentInchiKey = 'BSYNRYMUTXBXSQ-UHFFFAOYSA-N'
      list.setInchiKeys
        parent_key: parentInchiKey

      glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
        list, $(@el).find('.BCK-MatchesTable'), customRenderEvent=undefined, disableColumnsSelection=true)

      #show preloader!
#      list.fetch()

      @showSection()
      @showCardContent()

