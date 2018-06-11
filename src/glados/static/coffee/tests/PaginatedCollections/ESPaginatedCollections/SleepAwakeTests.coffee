describe "An elasticsearch collection", ->

  describe 'Sleep/Awake State', ->

    esList = undefined

    beforeAll (done) ->

      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('test_mode', true)
      TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)

    it 'starts with an undefined state', ->

      currentAwakenState = esList.getAwakenState()
      expect(currentAwakenState?).toBe(false)
      expect(esList.isSleeping()).toBe(false)
      expect(esList.isAwaken()).toBe(false)
      expect(esList.awakenStateIsUnknown()).toBe(true)

    beforeEach ->
      esList.setAwakenState(undefined)

    it 'sets the state correctly after awaking the list', ->

      esList.wakeUp()
      expect(esList.isSleeping()).toBe(false)
      expect(esList.isAwaken()).toBe(true)

    it 'sets the state correctly after sleeping the list', ->

      esList.sleep()
      expect(esList.isSleeping()).toBe(true)
      expect(esList.isAwaken()).toBe(false)

    it 'triggers the state correctly when awaken', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.AWAKE_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.wakeUp()
      expect(eventTriggered).toBe(true)

    it 'triggers the state correctly when put to sleep', ->

      eventTriggered = false
      esList.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.AWAKE_STATE_CHANGED,
      (-> eventTriggered = true)

      esList.sleep()
      expect(eventTriggered).toBe(true)


