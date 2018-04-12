glados.useNameSpace 'glados.views.Compound',
  UnichemConnectivityMatchesView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @
      @model.on 'error', @showCompoundErrorCard, @
      @resource_type = 'Compound'
      @collectionFetched = false

      @initEmbedModal(arguments[0].embed_section_name, arguments[0].embed_identifier)
      @activateModals()

    events:
      'click .BCK-ToggleAlternateForms': 'toogleAlternateForms'

    render: ->

      thereAreNoReferences = not @model.get('_metadata').unichem?
      if thereAreNoReferences
        @hideSection()
        return

      inchiKey = @model.get('molecule_structures').standard_inchi_key
      if not @collection?
        @collection = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
        @collection.setInchiKey(inchiKey)
        @collection.on 'reset',  @render, @

      $descriptionContainer = $(@el).find('.BCK-DescriptionContainer')
      glados.Utils.fillContentForElement $descriptionContainer,
        inchi_key: inchiKey

      $legendContainer = $(@el).find('.BCK-LegendContainer')
      glados.Utils.fillContentForElement($legendContainer)
      $includeSaltsButtonContainer = $(@el).find('.BCK-LoadAlternativeSaltsButtonContainer')
      glados.Utils.fillContentForElement $includeSaltsButtonContainer,
        include: @collection.isShowingAlternativeForms()

      if not @tableView?
        @tableView = glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
          @collection, $(@el).find('.BCK-MatchesTable'), customRenderEvent=undefined, disableColumnsSelection=true)

      if not @collectionFetched
        @collection.fetch()
        @collectionFetched = true

      @showSection()
      @showCardContent()

    toogleAlternateForms: ->

      @tableView.resetPageNumber()
      @collection.toggleAlternativeSaltsAndMixtures()