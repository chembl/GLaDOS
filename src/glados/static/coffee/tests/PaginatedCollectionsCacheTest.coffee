describe "Paginated Collections Cache", ->

  testInitCache = (list) -> expect(list.getMeta('cache')?).toBe(true)

  testAddObj = (list) ->

    testObj =
      name: 'test'

    list.addObjectToCache(testObj, 1)
    expect(list.getMeta('cache')[1].name).toBe('test')

  testResetCache = (list) ->

    list.resetCache()
    expect(list.getMeta('cache')?).toBe(true)
    expect(Object.keys(list.getMeta('cache')).length).toBe(0)

  testRetrieveObj = (list) ->

    testObj =
      name: 'test'

    list.addObjectToCache(testObj, 1)
    objGot = list.getObjectInCache(1)
    expect(objGot.name).toBe(testObj.name)

  describe 'Collection with no caching', ->
    list = undefined

    beforeAll -> list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetComponentsList()

    it "does not initialise cache", -> expect(list.getMeta('cache')?).toBe(false)

  describe 'WS Collections with caching', ->
    list = undefined

    beforeAll ->
      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSubstructureSearchResultsList()
    beforeEach ->
      list.resetCache()

    it 'initializes cache', -> testInitCache(list)
    it 'adds an object to cache', -> testAddObj(list)
    it 'resets cache', -> testResetCache(list)
    it 'retrieves objects', -> testRetrieveObj(list)

  describe 'ES Collections', ->

    list = undefined

    beforeAll ->

      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
          glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
        )

    beforeEach ->
      list.resetCache()

    it "initializes cache", -> testInitCache(list)
    it 'adds an object to cache', -> testAddObj(list)
    it 'resets cache', -> testResetCache(list)
    it 'retrieves objects', -> testRetrieveObj(list)