describe "Paginated Collections Cache", ->

  list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
    )

  it "initializes cache", ->

    expect(true).toBe(true)