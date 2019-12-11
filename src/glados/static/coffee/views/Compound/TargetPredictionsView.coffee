glados.useNameSpace 'glados.views.Compound',
  TargetPredictionsView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'

      sortByFunc = (item) -> -parseFloat(item.probability)
      settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS
      filterFunc1uM = (p) -> p.value == 1

      generator1uM =
        model: @model
        generator_property: '_metadata.target_predictions'
        filter: filterFunc1uM
        sort_by_function: sortByFunc

      list1uM = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings,
        generator1uM)

      glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
        list1uM, $(@el).find('.BCK-1MicroMolar-Predictions'), customRenderEvent=undefined, disableColumnsSelection=true)


      @initEmbedModal(arguments[0].embed_section_name, arguments[0].embed_identifier)
      @activateModals()


    render: ->

      rawTargetPredidctions = @model.get('_metadata').target_predictions
      if not rawTargetPredidctions?
        @hideSection()
        return
      if rawTargetPredidctions.length == 0
        @hideSection()
        return

      $chemblIDSpan = $(@el).find('.BCK-Predictions-MolChemblID')
      $chemblIDSpan.text(@model.get('id'))

      @showCardContent()
      @showSection()