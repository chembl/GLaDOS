describe "Paginated Collections", ->

  describe "Links to all activities", ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
        glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
      )

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
