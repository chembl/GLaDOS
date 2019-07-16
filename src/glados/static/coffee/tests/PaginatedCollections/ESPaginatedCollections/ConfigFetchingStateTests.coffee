describe "An elasticsearch collection", ->

  describe 'Config Fetching State', ->

    esList = undefined
    searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')

    beforeAll ->

      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('test_mode', true)

    beforeEach ->
      esList.setInitialConfigState()
      esList.setMeta('test_mode', true)

    it 'sets the initial state', ->

      configStateGot = esList.getConfigState()
      configStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.CONFIGURATION_FETCHING_STATES.INITIAL_STATE
      expect(configStateGot).toBe(configStateMustBe)

    it 'Sets the correct state when starting to fetch the config', ->

      esList.fetchColumnsDescription()
      configStateGot = esList.getConfigState()
      configStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.CONFIGURATION_FETCHING_STATES.FETCHING_CONFIGURATION
      expect(configStateGot).toBe(configStateMustBe)

    it 'triggers the correct event when changing searching state', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.CONFIG_FETCHING_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.setConfigState(
        glados.models.paginatedCollections.PaginatedCollectionBase.CONFIGURATION_FETCHING_STATES.CONFIGURATION_READY
      )
      expect(eventTriggered).toBe(true)

    it 'does not trigger the event chane after setting exactly the same state again', ->

      esList.setConfigState(
        glados.models.paginatedCollections.PaginatedCollectionBase.CONFIGURATION_FETCHING_STATES.CONFIGURATION_READY
      )

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.CONFIG_FETCHING_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.setConfigState(
        glados.models.paginatedCollections.PaginatedCollectionBase.CONFIGURATION_FETCHING_STATES.CONFIGURATION_READY
      )
      expect(eventTriggered).toBe(false)


