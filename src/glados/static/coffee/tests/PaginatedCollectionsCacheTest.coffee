describe "Paginated Collections Cache", ->

  describe 'WS Collections', ->
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSubstructureSearchResultsList()

    it "initializes cache", ->

      expect(true).toBe(true)


  describe 'ES Collections', ->
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
        glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
      )

    it "initializes cache", ->

      expect(true).toBe(true)