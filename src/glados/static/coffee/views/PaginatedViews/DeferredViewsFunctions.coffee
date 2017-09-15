glados.useNameSpace 'glados.views.PaginatedViews',
  DeferredViewsFunctions:

    createDeferredViewsContainer: -> @deferredStructuresContainer = []
    cleanUpDeferredViewsContainer: -> @createDeferredViewsContainer()

    createDeferredView: (model, $newItemElem) ->
      dfsView = new glados.views.Compound.DeferredStructureView
        model: model
        el: $newItemElem.find('.BCK-image')

      @deferredStructuresContainer.push dfsView
      dfsView.showCorrectImage()