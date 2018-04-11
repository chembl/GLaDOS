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

      inchiKey = @model.get('molecule_structures').standard_inchi_key

      $descriptionContainer = $(@el).find('.BCK-DescriptionContainer')
      glados.Utils.fillContentForElement $descriptionContainer,
        inchi_key: inchiKey

      $legendContainer = $(@el).find('.BCK-LegendContainer')
      glados.Utils.fillContentForElement($legendContainer)
      $includeSaltsButtonContainer = $(@el).find('.BCK-LoadAlternativeSaltsButtonContainer')
      glados.Utils.fillContentForElement($includeSaltsButtonContainer)

      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
      list.setInchiKey(inchiKey)

      glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
        list, $(@el).find('.BCK-MatchesTable'), customRenderEvent=undefined, disableColumnsSelection=true)

      list.fetch()
      console.log 'LIST: ', list

      @showSection()
      @showCardContent()

