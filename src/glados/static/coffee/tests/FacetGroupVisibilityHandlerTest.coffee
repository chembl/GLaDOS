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