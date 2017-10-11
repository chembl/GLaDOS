describe 'Facets Group Visibility Handler', ->

  facetsVisibilityHandler = undefined

  beforeEach ->

    baseFacetsGroups = glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.FACETS_GROUPS
    facetsVisibilityHandler = new glados.models.paginatedCollections.FacetGroupVisibilityHandler
      all_facets_groups: baseFacetsGroups

  it 'Changes the state when showing or hiding a facet group', ->

    allFGroups = facetsVisibilityHandler.get('all_facets_groups')

    # show a hidden column
    hiddenColumnIdentifier = _.findKey(allFGroups, (col) -> not col.show)
    facetsVisibilityHandler.setShowHideFGroupStatus(hiddenColumnIdentifier, true)
    expect(allFGroups[hiddenColumnIdentifier].show).toBe(true)

    #hide a shown column
    shownColumnIdentifier = _.findKey(allFGroups, (col) -> col.show)
    facetsVisibilityHandler.setShowHideFGroupStatus(shownColumnIdentifier, false)
    expect(allFGroups[shownColumnIdentifier].show).toBe(false)

  it 'Changes the state when showing or hiding ALL facets groups', ->

    allFGroups = facetsVisibilityHandler.get('all_facets_groups')

    #show all facets
    facetsVisibilityHandler.setShowHideAllFGroupStatus(true)
    for key, fGroup of allFGroups
      expect(fGroup.show).toBe(true)

  it 'Changes the order of facets groups', ->

    allFGroups = facetsVisibilityHandler.get('all_facets_groups')

    draggedIndex = 6
    receivingIndex = 1

    valuesWithKeys = []
    for key, fGroup of allFGroups
      valuesWithKeys.push _.extend({key: key}, fGroup)

    valuesWithKeys.sort (a, b) -> a.position - b.position
    facetKeysInOrder = (fg.key for fg in valuesWithKeys)
    draggedKey = facetKeysInOrder[draggedIndex]
    receivingKey = facetKeysInOrder[receivingIndex]

    facetKeysInOrder.splice(receivingIndex, 0, draggedKey)
    if draggedIndex >= receivingIndex
      facetKeysInOrder.splice(draggedIndex + 1, 1)
    else
      facetKeysInOrder.splice(draggedIndex, 1)

    facetsVisibilityHandler.changeColumnsOrder(receivingKey, draggedKey)

    for i in [0..facetKeysInOrder.length-1]
      key = facetKeysInOrder[i]
      positionGot = allFGroups[key].position
      positionMustBe = i + 1
      expect(positionGot).toBe(positionMustBe)

  it 'gives all facets groups', ->

    allFGroupsMustBe = facetsVisibilityHandler.get('all_facets_groups')
    allFGroupsGot = facetsVisibilityHandler.getAllFacetsGroups()

    for key, fGroup of allFGroupsMustBe
      expect(allFGroupsGot[key]?).toBe(true)

  it 'gives visible facets groups', ->

    allFGroupsMustBe = facetsVisibilityHandler.get('all_facets_groups')
    visibleFGroupsGot = facetsVisibilityHandler.getVisibleFacetsGroups()

    for key, fGroup of allFGroupsMustBe

      if fGroup.show
        expect(visibleFGroupsGot[key]?).toBe(true)
      else
        expect(visibleFGroupsGot[key]?).toBe(false)

  it 'gives all facets groups as a list, soerted by position', ->

    allFGroupsMustBe = facetsVisibilityHandler.get('all_facets_groups')
    allFGroupsListGot = facetsVisibilityHandler.getAllFacetsGroupsAsList()

    lastPosition = 0
    for fGroup in allFGroupsListGot
      
      expect(allFGroupsMustBe[fGroup.key]?).toBe(true)
      expect(fGroup.position > lastPosition).toBe(true)
      lastPosition = fGroup.position
