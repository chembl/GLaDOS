describe "A collection with a sticky query", ->

  settings = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.DRUGS_LIST
  stickyQueryMustBe =
    term:
      "_metadata.drug.is_drug": true

  list = undefined
  beforeAll ->
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(settings,
      customQueryString=undefined, useCustomQuery=false, itemsList=undefined, contextualProperties=undefined,
      searchTerm=undefined, stickyQueryMustBe)

  it "sets the initial parameters", ->

    stickyQueryGot = list.getMeta('sticky_query')
    expect(_.isEqual(stickyQueryMustBe, stickyQueryGot)).toBe(true)

  it 'Generates the correct request object', ->

    requestData = list.getRequestData()
    stickyQueryGot = requestData.query.bool.must[0]
    expect(_.isEqual(stickyQueryMustBe, stickyQueryGot)).toBe(true)

  describe 'And a custom querystring', ->

    customQueryString = 'molecule_chembl_id:CHEMBL25'

    list = undefined
    beforeAll ->
      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(settings,
        customQueryString, useCustomQuery=true, itemsList=undefined, contextualProperties=undefined,
        searchTerm=undefined, stickyQueryMustBe)

    it 'sets the initial parameters', ->

      expect(list.getMeta('custom_query')).toBe(customQueryString)
      stickyQueryGot = list.getMeta('sticky_query')
      expect(_.isEqual(stickyQueryMustBe, stickyQueryGot)).toBe(true)

    it 'Generates the correct request object', ->

      requestData = list.getRequestData()
      expect(requestData.query.bool.must[0].query_string.query).toBe(customQueryString)
      stickyQueryGot = requestData.query.bool.must[1]
      expect(_.isEqual(stickyQueryMustBe, stickyQueryGot)).toBe(true)

    it 'Generates a state object', -> TestsUtils.testSavesList(list,
      pathInSettingsMustBe='ES_INDEXES_NO_MAIN_SEARCH.DRUGS_LIST',
      queryStringMustBe=customQueryString,
      useQueryStringMustBe=true,
      stickyQueryMustBe)

    it 'creates a list from a state object', -> TestsUtils.testRestoredListIsEqualToOriginal(list)