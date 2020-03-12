glados.useNameSpace 'glados.views.Compound',
  TargetPredictionsView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'

      @initEmbedModal(arguments[0].embed_section_name, arguments[0].embed_identifier)
      @activateModals()


    render: ->

      molecule_structures = @model.get('molecule_structures')

      if not molecule_structures?
        @hideSection()
        return

      canonical_smiles = molecule_structures.canonical_smiles

      settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS
      flavour = glados.models.paginatedCollections.SpecificFlavours.TargetPredictionsList

      @list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings,
        generator=undefined, flavour)

      @list.initURL()
      @list.molecule_chembl_id = @model.get('id')
      @list.canonical_smiles = canonical_smiles
      @list.on 'reset', @renderPredictions, @

      glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
        @list, $(@el).find('.BCK-1MicroMolar-Predictions'), customRenderEvent=undefined, disableColumnsSelection=true)

      @list.fetch()

    renderPredictions: ->

      if @list.models.length == 0
        @hideSection()
        return

      $chemblIDSpan = $(@el).find('.BCK-Predictions-MolChemblID')
      $chemblIDSpan.text(@model.get('id'))

      $APICALLAnchor = $(@el).find('.BCK-Predictions-APICall')
      $APICALLAnchor.text(@list.url)
      $APICALLAnchor.attr('href', @list.url)

      @showCardContent()
      @showSection()