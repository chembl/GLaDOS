glados.useNameSpace 'glados.views.Compound',
  TargetPredictionsView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'

      settings1uM = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS
      filterFunc1uM = (p) -> p.value == 1
      settings1uM.generator =
        model: @model
        generator_property: '_metadata.target_predictions'
        filter: filterFunc1uM
      @list1uM = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings1uM)

#      settings10uM = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS
#      filterFunc1uM = (p) -> p.value == 1
#      settings1uM.generator =
#        model: @model
#        generator_property: '_metadata.target_predictions'
#        filter: filterFunc1uM
#      @list1uM = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings1uM)


    render: ->

      console.log 'RENDER TARG PREDS!'
      rawTargetPredidctions = @model.get('_metadata').target_predictions
      if not rawTargetPredidctions?
        return
      if rawTargetPredidctions.length == 0
        return

      console.log '@list1uM: ', @list1uM

      @showCardContent()
      @showSection()