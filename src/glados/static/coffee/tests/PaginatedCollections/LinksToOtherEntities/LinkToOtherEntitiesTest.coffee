describe "Paginated Collections", ->

  describe "Links to other entities", ->

    # ------------------------------------------------------------------------------------------------------------------
    # Generic test functions
    # ------------------------------------------------------------------------------------------------------------------
    testLinkGenerationAfterSelectingOneItem = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      sourceEntityName = list.getMeta('model').prototype.entityName
      filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
        .ENTITY_NAME_TO_FILTER_GENERATOR[sourceEntityName][destinationEntityName]
          ids: [itemToSelect]

      linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkToActsMustBe).toBe(linkGot)
        done()

    testLinkGenerationAfterSelectingMultipleItems = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemsToSelect = allItemsIDs[0..(allItemsIDs.length - 1)]
      list.selectItems(itemsToSelect)

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      sourceEntityName = list.getMeta('model').prototype.entityName
      filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
        .ENTITY_NAME_TO_FILTER_GENERATOR[sourceEntityName][destinationEntityName]
          ids: itemsToSelect

      linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkToActsMustBe).toBe(linkGot)
        done()

    testLinkGenerationAfterSelectingAllItems = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      list.selectAll()

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      sourceEntityName = list.getMeta('model').prototype.entityName
      filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
        .ENTITY_NAME_TO_FILTER_GENERATOR[sourceEntityName][destinationEntityName]
          ids: allItemsIDs

      linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkToActsMustBe).toBe(linkGot)
        done()

    testLinkGenerationAfterSelectingNoItems = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      sourceEntityName = list.getMeta('model').prototype.entityName
      filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
        .ENTITY_NAME_TO_FILTER_GENERATOR[sourceEntityName][destinationEntityName]
          ids: allItemsIDs

      linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkGot).toBe(linkToActsMustBe)
        done()

    testLinksCacheIsSet = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)

      cache = list.getMeta(list.LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName])
      expect(cache?).toBe(false)

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      linkToOtherEntitiesPromise.then (linkGot) ->
        cache = list.getMeta(list.LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName])
        expect(cache).toBe(linkGot)
        done()

    testLinksCacheIsUsed = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)

      cachePropName = list.LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName]

      cacheMustBe = 'We do what we must, Because we can.'
      list.setMeta(cachePropName, cacheMustBe)

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkGot).toBe(cacheMustBe)
        done()

    testResetsCacheIsReset = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)
      cachePropName = list.LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName]

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      linkToOtherEntitiesPromise.then (linkGot) ->

        #the cache must be as expected
        cache = list.getMeta(cachePropName)
        expect(cache).toBe(linkGot)

        #now I selecct another item
        itemToSelect2 = allItemsIDs[1]
        list.selectItem(itemToSelect2)
        cache = list.getMeta(cachePropName)
        #cache must be undefined
        expect(cache?).toBe(false)

        linkToActPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)
        linkToActPromise.then (linkGot) ->

          linkToActPromise2 = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

          linkToActPromise2.then (linkGot2) ->

            sourceEntityName = list.getMeta('model').prototype.entityName
            filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
            .ENTITY_NAME_TO_FILTER_GENERATOR[sourceEntityName][destinationEntityName]
              ids: [itemToSelect, itemToSelect2]

            linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

            #the link new link must be correct
            expect(linkToActsMustBe).toBe(linkGot2)
            done()

    # ------------------------------------------------------------------------------------------------------------------
    # test cases
    # ------------------------------------------------------------------------------------------------------------------
    describe "Links to all activities from compound", ->

      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
          glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
        )

      beforeAll (done) ->
        TestsUtils.simulateDataESList(list,
          glados.Settings.STATIC_URL + 'testData/WSCollectionTestData2.json', done)

      beforeEach ->
        list.unSelectAll()

      it 'produces the link after selecting one item', (done) -> testLinkGenerationAfterSelectingOneItem(list,
        Activity.prototype.entityName, done)

      it 'produces the link after selecting multiple items', (done) ->
        testLinkGenerationAfterSelectingMultipleItems(list, Activity.prototype.entityName, done)
      it 'produces the link after selecting all items', (done) ->
        testLinkGenerationAfterSelectingAllItems(list, Activity.prototype.entityName, done)
      it 'produces the link after selecting no items', (done) ->
        testLinkGenerationAfterSelectingNoItems(list, Activity.prototype.entityName, done)
      it 'sets the link cache', (done) -> testLinksCacheIsSet(list, Activity.prototype.entityName, done)
      it 'uses the link cache', (done) -> testLinksCacheIsUsed(list, Activity.prototype.entityName, done)
      it 'resets the link cache', (done) -> testResetsCacheIsReset(list, Activity.prototype.entityName, done)

    describe "Links to all compounds from activities", ->

      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
          glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.ACTIVITY
        )

      beforeAll (done) ->
        TestsUtils.simulateDataESList(list,
          glados.Settings.STATIC_URL + 'testData/Activity/activitySamplePagColl.json', done, rawES=true)


      it 'works', ->

        console.log 'list: ', list
