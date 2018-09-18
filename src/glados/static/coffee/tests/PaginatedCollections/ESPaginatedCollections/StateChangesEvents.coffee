# When the state of the lists changes, an event that indicates this must be triggered.
# Here the estate is "the parameters from which the list can be re created', this means that whenever the list
# changes so the state object will be different, the STATE_OBJECT_CHANGED event must be triggered
describe "An elasticsearch collection", ->

  describe 'State object changed event', ->

    esList = undefined
    searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')
    testDataToParse = undefined

    beforeAll (done) ->

      console.log 'url helper events disabled'
      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('test_mode', true)
      TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)

    beforeEach ->
      esList.clearAllFacetsSelections()

    beforeAll (done) ->

      dataURL = glados.Settings.STATIC_URL + 'testData/ESCollectionTestData1.json'
      $.get dataURL, (testData) ->
        testDataToParse = testData
        done()

    # For now, only some actions trigger the event, more actions can be added later
    it 'Triggers the event after selecting a facet', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.STATE_OBJECT_CHANGED,
      (-> eventTriggered = true)

      facetGroups = esList.getFacetsGroups()
      testFacetGroupKey = 'max_phase'
      testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
      esList.toggleFacetAndFetch(testFacetGroupKey, testFacetKey)

      expect(eventTriggered).toBe(true)

    it 'Triggers the event after clearing facets selections', ->

      facetGroups = esList.getFacetsGroups()
      testFacetGroupKey = 'max_phase'
      testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
      esList.toggleFacetAndFetch(testFacetGroupKey, testFacetKey)

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.STATE_OBJECT_CHANGED,
      (-> eventTriggered = true)

      esList.clearAllFacetsSelections()
      expect(eventTriggered).toBe(true)

    it 'Triggers the event after changing the querystring', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.STATE_OBJECT_CHANGED,
      (-> eventTriggered = true)

      esList.setMeta('custom_query', 'new querystring')
      expect(eventTriggered).toBe(true)



