describe "An elasticsearch collection", ->

  describe 'Fetching State ', ->

    glados.helpers.URLHelper.testMode = true
    esList = undefined
    searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')
    testDataToParse = undefined

    beforeAll (done) ->


      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('searchESQuery', searchESQuery)
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

    it 'sets the initial fecthing state', ->

      itemsStateGot = esList.getItemsFetchingState()
      itemsStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.INITIAL_STATE
      expect(itemsStateGot).toBe(itemsStateMustBe)

      facetsStateGot = esList.getFacetsFetchingState()
      facetsStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.INITIAL_STATE
      expect(facetsStateGot).toBe(facetsStateMustBe)

    it 'sets the correct state when fetching items', ->

      esList.fetch()
      stateGot = esList.getItemsFetchingState()
      stateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.FETCHING_ITEMS
      expect(stateGot).toBe(stateMustBe)

    it 'sets the correct state when filtering items (selecting a facet)', ->

      facetGroups = esList.getFacetsGroups()
      testFacetGroupKey = 'max_phase'
      testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
      esList.toggleFacetAndFetch(testFacetGroupKey, testFacetKey)
      itemsStateGot = esList.getItemsFetchingState()

      itemsStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.FETCHING_ITEMS
      expect(itemsStateGot).toBe(itemsStateMustBe)

      esList.loadFacetGroups()
      facetsStateGot = esList.getFacetsFetchingState()
      facetsStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.FETCHING_FACETS
      expect(facetsStateGot).toBe(facetsStateMustBe)

    it 'sets the correct state after parsing items', ->

      esList.reset(esList.parse(testDataToParse))

      itemsStateGot = esList.getItemsFetchingState()
      itemsStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.ITEMS_READY
      expect(itemsStateGot).toBe(itemsStateMustBe)

    it 'sets the correct state after parsing items (facets)', (done) ->

      simulateFacets = TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', ->)

      simulateFacets.then ->

        facetsStateGot = esList.getFacetsFetchingState()
        facetsStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.FACETS_READY
        expect(facetsStateGot).toBe(facetsStateMustBe)

        done()

    it 'triggers the correct event when changing items fetching state', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.ITEMS_FETCHING_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.setItemsFetchingState(glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.INITIAL_STATE)
      expect(eventTriggered).toBe(true)

    it 'triggers the correct event when changing facets fetching state', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_FETCHING_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.setFacetsFetchingState(glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.INITIAL_STATE)
      expect(eventTriggered).toBe(true)