glados.useNameSpace 'glados.models.paginatedCollections',

  FacetGroupVisibilityHandler: Backbone.Model.extend

    setShowHideFGroupStatus: (identifier, show) -> @get('all_facets_groups')[identifier].show = show

    setShowHideAllFGroupStatus: (show) ->

      allFGroups = @get('all_facets_groups')
      for key, fGroup of allFGroups
        fGroup.show = show

    getAllFacetsGroups: -> @get('all_facets_groups')
    getVisibleFacetsGroups: ->

      onlyVisible = {}
      for facetGroupKey, facetGroup of @getAllFacetsGroups()
        if facetGroup.show
          onlyVisible[facetGroupKey] = facetGroup

      return onlyVisible

    changeColumnsOrder: (receivingKey, draggedKey) ->

      allFGroups = @get('all_facets_groups')

      if receivingKey == draggedKey
        return

      receivingPosition = allFGroups[receivingKey].position
      draggedPosition = allFGroups[draggedKey].position

      isFirstCase = draggedPosition < receivingPosition
      affectedRange = switch
        when isFirstCase then [(draggedPosition + 1)..(receivingPosition-1)]
        else [receivingPosition..(draggedPosition - 1)]

      for key, fGroup of allFGroups

        if key == draggedKey
          if isFirstCase
            fGroup.position = receivingPosition - 1
          else
            fGroup.position = receivingPosition
          continue

        currentPosition = fGroup.position

        if currentPosition in affectedRange
          if isFirstCase
            fGroup.position--
          else
            fGroup.position++