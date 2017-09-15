glados.useNameSpace 'glados.views.PaginatedViews',
  DeferredViewsFunctions:

    createDeferredViewsContainer: ->
      @deferredViewsContainer = []

      if @hasSimilarityMapsEnabled()
        @showStructurePropNameCol = 'show_similarity_maps'
      else if @hasStructureHighlightingEnabled()
        @showStructurePropNameCol = 'show_substructure_highlighting'

      @showSpecialStructures = @collection.getMeta(@showStructurePropNameCol)

    cleanUpDeferredViewsContainer: -> @deferredViewsContainer = []

    createDeferredView: (model, $newItemElem) ->
      dfsView = new glados.views.Compound.DeferredStructureView
        model: model
        el: $newItemElem.find('.BCK-image')
        show_special_structure: @showSpecialStructures

      @deferredViewsContainer.push dfsView
      dfsView.showCorrectImage()

    renderSpecialStructuresToggler: ->

      if @hasSimilarityMapsEnabled()

        glados.Utils.fillContentForElement @$specialStructuresTogglerContainer,
          title: 'Similarity Maps'
          checked: @showSpecialStructures

      else if @hasStructureHighlightingEnabled()

        glados.Utils.fillContentForElement @$specialStructuresTogglerContainer,
          title: 'Highlight'
          checked: @showSpecialStructures

    hasStructureHighlightingEnabled: -> @collection.getMeta('enable_substructure_highlighting')
    hasSimilarityMapsEnabled: -> @collection.getMeta('enable_similarity_maps')

    toggleShowSpecialStructure: (checked) ->

      @showSpecialStructures = checked
      for view in @deferredViewsContainer
        view.setShowSpecialStructure(@showSpecialStructures)
        view.showCorrectImage()

