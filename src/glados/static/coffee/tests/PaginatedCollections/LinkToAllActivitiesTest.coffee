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

    it 'generates the link after selecting one item', ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)


#      expect(list.getSelectedItemsIDs()).toContain(itemToSelect)
