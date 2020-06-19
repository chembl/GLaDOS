describe 'Facets Group Visibility Handler', ->

  facetsVisibilityHandler = undefined
  esList = undefined
  searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')

  beforeAll (done) ->

    esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
    glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
    ]
    esList.setMeta('searchESQuery', searchESQuery)
    esList.setMeta('test_mode', true)
    TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)

  beforeEach ->

    baseFacetsGroups = esList.getFacetsGroups(selected=undefined, onlyVisible=false)
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
