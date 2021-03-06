describe "An elasticsearch collection", ->

  describe 'Searching State', ->

    esList = undefined
    searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')
    testDataToParse = undefined

    beforeAll (done) ->

      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('test_mode', true)
      TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)

    beforeAll (done) ->

      dataURL = glados.Settings.STATIC_URL + 'testData/ESCollectionTestData1.json'
      $.get dataURL, (testData) ->
        testDataToParse = testData
        done()

    beforeEach ->
      esList.setInitialFetchingState()
      esList.setMeta('test_mode', true)
      esList.clearAllFacetsSelections()
      esList.setInitialSearchState()

    it 'Sets the initial searching state, along with fetching and facets states', ->

      itemsStateGot = esList.getItemsFetchingState()
      itemsStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.INITIAL_STATE
      expect(itemsStateGot).toBe(itemsStateMustBe)

      facetsStateGot = esList.getFacetsFetchingState()
      facetsStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.INITIAL_STATE
      expect(facetsStateGot).toBe(facetsStateMustBe)

      searchStateGot = esList.getSearchState()
      searchStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_UNDEFINED
      expect(searchStateGot).toBe(searchStateMustBe)

    it 'Sets the correct state when setting a search', ->

      esList.search(searchESQuery, doFetch=false)
      searchStateGot = esList.getSearchState()
      searchStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_QUERY_SET
      expect(searchStateGot).toBe(searchStateMustBe)

    it 'sets the correct state after parsing items', ->

      esList.search(searchESQuery, doFetch=false)
      esList.reset(esList.parse(testDataToParse))
      searchStateGot = esList.getSearchState()
      searchStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_IS_READY
      expect(searchStateGot).toBe(searchStateMustBe)

    it 'triggers the correct event when changing searching state', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.SEARCH_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.setSearchState(glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_IS_READY)
      expect(eventTriggered).toBe(true)

    it 'does not trigger the event chane after setting exactly the same state again', ->

      esList.setSearchState(glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_QUERY_SET)

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.SEARCH_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.setSearchState(glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_QUERY_SET)
      expect(eventTriggered).toBe(false)