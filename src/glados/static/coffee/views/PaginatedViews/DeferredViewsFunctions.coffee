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

    renderSpecialStructuresToggler: ->

      if @hasSimilarityMapsEnabled()

        @showStructurePropNameCol = 'show_similarity_maps'
        glados.Utils.fillContentForElement @$specialStructuresTogglerContainer,
          title: 'Similarity Maps'
          checked: @collection.getMeta(@showStructurePropNameCol)

      else if @hasStructureHighlightingEnabled()

        @showStructurePropNameCol = 'show_substructure_highlighting'
        glados.Utils.fillContentForElement @$specialStructuresTogglerContainer,
          title: 'Highlight'
          checked: @collection.getMeta(@showStructurePropNameCol)

    hasStructureHighlightingEnabled: -> @collection.getMeta('enable_substructure_highlighting')
    hasSimilarityMapsEnabled: -> @collection.getMeta('enable_similarity_maps')