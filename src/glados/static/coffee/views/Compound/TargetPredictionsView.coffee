glados.useNameSpace 'glados.views.Compound',
  TargetPredictionsView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'


      settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS
      flavour = glados.models.paginatedCollections.SpecificFlavours.TargetPredictionsList

      @list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings,
        generator=undefined, flavour)

      @list.initURL(@model.get('id'))
      @list.on 'reset', @render, @

      glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
        @list, $(@el).find('.BCK-1MicroMolar-Predictions'), customRenderEvent=undefined, disableColumnsSelection=true)

      @list.fetch()

      @initEmbedModal(arguments[0].embed_section_name, arguments[0].embed_identifier)
      @activateModals()


    render: ->

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