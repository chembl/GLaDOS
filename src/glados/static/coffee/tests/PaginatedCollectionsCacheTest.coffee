describe "Paginated Collections Cache", ->

  #-------------------------------------------------------------------------------------------------------------------
  # Generic test functions
  #-------------------------------------------------------------------------------------------------------------------

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

  testRetrieveObjs = (list) ->

    #-------------------------------------
    # No Objects in Cache
    #-------------------------------------
    startingPosition = 0
    endPosition = 10

    objsGot = list.getObjectsInCache(startingPosition, endPosition)
    expect(objsGot.length).toBe(0)

    #-------------------------------------
    # AddTestObjs
    #-------------------------------------
    numTestObjects = 10
    testObjs = []
    for i in [0..numTestObjects-1]
      newObj =
        name: i
      list.addObjectToCache(newObj, i)
      testObjs.push newObj

    #-------------------------------------
    # Start > End
    #-------------------------------------
    startingPosition = 1
    endPosition = 0

    objsGot = list.getObjectsInCache(startingPosition, endPosition)
    expect(objsGot.length).toBe(0)

    #-------------------------------------
    # Start == End
    #-------------------------------------
    startingPosition = 0
    endPosition = 0

    objsGot = list.getObjectsInCache(startingPosition, endPosition)
    expect(objsGot[startingPosition].name).toBe(testObjs[startingPosition].name)

    #-------------------------------------
    # Start < End
    #-------------------------------------
    startingPosition = 0
    endPosition = testObjs.length

    objsGot = list.getObjectsInCache(startingPosition, endPosition)
    for i in [0..testObjs.length-1]
      expect(objsGot[i].name).toBe(testObjs[i].name)

  testAddsFromPage = (list) ->

    pageSize = 10
    objects = []
    for i in [0..pageSize-1]
      objects.push
        name: i

    for pageNum in [1..10]

      list.addObjectsToCacheFromPage(objects, pageNum)

      cache = list.getMeta('cache')
      startingPosition = objects.length * (pageNum - 1)
      for i in [0..objects.length-1]
        expectedPosition = startingPosition + i
        expect(cache[expectedPosition].name).toBe(i)


  #-------------------------------------------------------------------------------------------------------------------
  # Specific descriptions
  #-------------------------------------------------------------------------------------------------------------------
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
    it 'retrieves one object', -> testRetrieveObj(list)
    it 'retrieves objects in a range', -> testRetrieveObjs(list)
    it 'adds objects from received pages', -> testAddsFromPage(list)

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
    it 'retrieves one object', -> testRetrieveObj(list)
    it 'adds objects from received pages', -> testAddsFromPage(list)