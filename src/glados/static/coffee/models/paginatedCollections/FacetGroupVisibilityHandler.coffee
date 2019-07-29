glados.useNameSpace 'glados.models.paginatedCollections',

  FacetGroupVisibilityHandler: Backbone.Model.extend

    setShowHideFGroupStatus: (identifier, show) ->

      console.log('setShowHideFGroupStatus')
      @get('all_facets_groups')[identifier].show = show
      @trigger(glados.models.paginatedCollections.FacetGroupVisibilityHandler.EVENTS.COLUMNS_SHOW_STATUS_CHANGED)

    setShowHideAllFGroupStatus: (show) ->

      allFGroups = @get('all_facets_groups')
      for key, fGroup of allFGroups
        fGroup.show = show

      @trigger(glados.models.paginatedCollections.FacetGroupVisibilityHandler.EVENTS.COLUMNS_SHOW_STATUS_CHANGED)

    getAllFacetsGroups: -> @get('all_facets_groups')
    getVisibleFacetsGroups: ->

      onlyVisible = {}
      for facetGroupKey, facetGroup of @getAllFacetsGroups()
        if facetGroup.show
          onlyVisible[facetGroupKey] = facetGroup

      return onlyVisible

    getAllFacetsGroupsAsList: ->

      allGroupsList = []
      allFGroups = @get('all_facets_groups')
      for key, fGroup of allFGroups
        allGroupsList.push _.extend({key: key}, fGroup)
      allGroupsList.sort (a, b) -> a.position - b.position
      return allGroupsList

    getPropertyLabel: (fGroupKey) -> @get('all_facets_groups')[fGroupKey].label
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

      #use the event of the columns handler, to avoid having duplicate definitions of the same thing
      @trigger(glados.models.paginatedCollections.ColumnsHandler.EVENTS.COLUMNS_ORDER_CHANGED)

glados.models.paginatedCollections.FacetGroupVisibilityHandler.EVENTS =
  COLUMNS_SHOW_STATUS_CHANGED: 'COLUMNS_SHOW_STATUS_CHANGED'