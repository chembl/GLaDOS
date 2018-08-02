describe "Paginated Collections", ->

  describe "Links to other entities", ->

    describe "Links to all activities", ->

      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
          glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
        )

      allActsLinkCachePropName =
      glados.models.paginatedCollections.PaginatedCollectionBase.prototype.ALL_ACTIVITIES_LINK_CACHE_PROP_NAME

      beforeAll (done) ->
        TestsUtils.simulateDataESList(list,
          glados.Settings.STATIC_URL + 'testData/WSCollectionTestData2.json', done)

      beforeEach ->
        list.unSelectAll()

      it 'produces the link after selecting one item', (done) ->

        allItemsIDs = TestsUtils.getAllItemsIDs(list)
        itemToSelect = allItemsIDs[0]
        list.selectItem(itemToSelect)

        linkToActPromise = list.getLinkToAllActivitiesPromise()
        filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
          .ENTITY_NAME_TO_FILTER_GENERATOR.Compound
            ids: [itemToSelect]

        linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

        linkToActPromise.then (linkGot) ->
          expect(linkToActsMustBe).toBe(linkGot)
          done()

      it 'produces the link after selecting multiple items', (done) ->

        allItemsIDs = TestsUtils.getAllItemsIDs(list)
        itemsToSelect = allItemsIDs[0..(allItemsIDs.length - 1)]
        list.selectItems(itemsToSelect)

        linkToActPromise = list.getLinkToAllActivitiesPromise()
        filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
          .ENTITY_NAME_TO_FILTER_GENERATOR.Compound
            ids: itemsToSelect

        linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

        linkToActPromise.then (linkGot) ->
          expect(linkToActsMustBe).toBe(linkGot)
          done()

      it 'produces the link after selecting all items', (done) ->

        allItemsIDs = TestsUtils.getAllItemsIDs(list)
        list.selectAll()

        linkToActPromise = list.getLinkToAllActivitiesPromise()
        filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
          .ENTITY_NAME_TO_FILTER_GENERATOR.Compound
            ids: allItemsIDs

        linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

        linkToActPromise.then (linkGot) ->
          expect(linkToActsMustBe).toBe(linkGot)
          done()

      it 'produces the link after selecting no items', (done) ->

        allItemsIDs = TestsUtils.getAllItemsIDs(list)

        linkToActPromise = list.getLinkToAllActivitiesPromise()
        filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
          .ENTITY_NAME_TO_FILTER_GENERATOR.Compound
            ids: allItemsIDs

        linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

        linkToActPromise.then (linkGot) ->
          expect(linkGot).toBe(linkToActsMustBe)
          done()

      it 'sets the link cache', (done) ->

        allItemsIDs = TestsUtils.getAllItemsIDs(list)
        itemToSelect = allItemsIDs[0]
        list.selectItem(itemToSelect)
        cache = list.getMeta(allActsLinkCachePropName)
        expect(cache?).toBe(false)

        linkToActPromise = list.getLinkToAllActivitiesPromise()
        linkToActPromise.then (linkGot) ->
          cache = list.getMeta(allActsLinkCachePropName)
          expect(cache).toBe(linkGot)
          done()

      it 'uses the link cache', (done) ->

        allItemsIDs = TestsUtils.getAllItemsIDs(list)
        itemToSelect = allItemsIDs[0]
        list.selectItem(itemToSelect)

        cacheMustBe = 'We do what we must, Because we can.'
        list.setMeta(allActsLinkCachePropName, cacheMustBe)

        linkToActPromise = list.getLinkToAllActivitiesPromise()
        linkToActPromise.then (linkGot) ->
          expect(linkGot).toBe(cacheMustBe)
          done()

      it 'resets the link cache', (done) ->

        allItemsIDs = TestsUtils.getAllItemsIDs(list)
        itemToSelect = allItemsIDs[0]
        list.selectItem(itemToSelect)

        linkToActPromise = list.getLinkToAllActivitiesPromise()
        linkToActPromise.then (linkGot) ->

          #the cache must be as expected
          cache = list.getMeta(allActsLinkCachePropName)
          expect(cache).toBe(linkGot)

          #now I selecct another item
          itemToSelect2 = allItemsIDs[1]
          list.selectItem(itemToSelect2)
          cache = list.getMeta(allActsLinkCachePropName)
          #cache must be undefined
          expect(cache?).toBe(false)

          linkToActPromise2 = list.getLinkToAllActivitiesPromise()
          linkToActPromise2.then (linkGot2) ->

            filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
            .ENTITY_NAME_TO_FILTER_GENERATOR.Compound
              ids: [itemToSelect, itemToSelect2]

            linkToActsMustBe = Activity.getActivitiesListURL(filterToActsMustBe)

            #the link new link must be correct
            expect(linkToActsMustBe).toBe(linkGot2)
            done()
