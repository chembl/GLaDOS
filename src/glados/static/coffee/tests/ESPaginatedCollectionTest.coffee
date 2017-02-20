describe "ElasticSearch Paginated Collection", ->

  describe "A collection resulting from the search of the term 'Dopamine'", ->

    collection = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND)
    collection.setMeta('singular_terms', ['Dopamine'])
    collection.setMeta('exact_terms', [])
    collection.setMeta('filter_terms', [])

    it "defines the parameters for the request to get the first page", ->

      parameters = collection.getRequestData()
      expect(parameters.size).toBe(6)
      expect(parameters.from).toBe(0)

    it "defines the parameters for the request to get page 5", ->

      parameters = collection.getRequestData(5)
      expect(parameters.size).toBe(6)
      expect(parameters.from).toBe(24)
