describe "An elasticsearch collection initialised from a custom query (full)", ->

  esQuery = {
    "query": {
      "match": {
        "molecule_chembl_id": "CHEMBL25"
      }
    }
  }

  esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(JSON.stringify(esQuery))

  it 'Sets initial parameters', ->

    expect(esList.getMeta('id_name')).toBe("ESCompound")
    expect(esList.getMeta('index')).toBe("/chembl_molecule")
    expect(esList.getMeta('key_name')).toBe("COMPOUND_COOL_CARDS")
    esQueryGot = esList.getMeta('custom_query')
    expect(_.isEqual(esQueryGot, JSON.stringify(esQuery))).toBe(true)

  it 'Distinguishes between a query string and a full query', ->

    expect(esList.customQueryIsFullQuery()).toBe(true)

  it 'Generates the correct request object', ->

    requestDataMustBe = $.extend({"size": 24, "from":0}, esQuery)
    requestDataGot = esList.getRequestData()
    expect(_.isEqual(requestDataGot, requestDataMustBe)).toBe(true)

  it 'generates a state object', -> TestsUtils.testSavesList(esList,
      pathInSettingsMustBe='ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_COOL_CARDS',
      queryStringMustBe=JSON.stringify(esQuery),
      useQueryStringMustBe=true)
