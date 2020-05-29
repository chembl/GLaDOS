describe "An elasticsearch collection", ->

  describe 'Facets Config Fetching State', ->

    esList = undefined

    beforeAll ->

      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('test_mode', true)

    beforeEach ->
      esList.setInitialFacetsConfigState()
      esList.setMeta('test_mode', true)

    it 'sets the initial state', ->

      configStateGot = esList.getFacetsConfigState()
      configStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_CONFIGURATION_FETCHING_STATES.INITIAL_STATE
      expect(configStateGot).toBe(configStateMustBe)

    it 'Sets the correct state when starting to fetch the facets config', ->

      esList.fetchFacetsDescription()
      configStateGot = esList.getFacetsConfigState()
      configStateMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_CONFIGURATION_FETCHING_STATES.FETCHING_CONFIGURATION
      expect(configStateGot).toBe(configStateMustBe)

    it 'triggers the correct event when changing fetching state', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_CONFIG_FETCHING_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.setFacetsConfigState(
        glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_CONFIGURATION_FETCHING_STATES.CONFIGURATION_READY
      )
      expect(eventTriggered).toBe(true)

    it 'does not trigger the event chane after setting exactly the same state again', ->

      esList.setFacetsConfigState(
        glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_CONFIGURATION_FETCHING_STATES.CONFIGURATION_READY
      )

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_CONFIG_FETCHING_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.setConfigState(
        glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_CONFIGURATION_FETCHING_STATES.CONFIGURATION_READY
      )
      expect(eventTriggered).toBe(false)
