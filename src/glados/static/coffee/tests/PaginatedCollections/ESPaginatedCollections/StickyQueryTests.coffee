describe "A collection with a sticky query", ->

  settings = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.DRUGS_LIST
  stickyQueryMustBe =
    term:
      "_metadata.drug.is_drug": true

  list = undefined
  beforeAll ->
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(settings,
      customQueryString=undefined, useCustomQueryString=false, itemsList=undefined, contextualProperties=undefined,
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
        customQueryString, useCustomQueryString=true, itemsList=undefined, contextualProperties=undefined,
        searchTerm=undefined, stickyQueryMustBe)

    it 'sets the initial parameters', ->

      expect(list.getMeta('custom_query_string')).toBe(customQueryString)
      stickyQueryGot = list.getMeta('sticky_query')
      expect(_.isEqual(stickyQueryMustBe, stickyQueryGot)).toBe(true)

    it 'Generates the correct request object', ->

      requestData = list.getRequestData()
      expect(requestData.query.bool.must[0].query_string.query).toBe(customQueryString)
      stickyQueryGot = requestData.query.bool.must[1]
      expect(_.isEqual(stickyQueryMustBe, stickyQueryGot)).toBe(true)

    it 'Generates a state object', ->

      state = list.getStateJSON()

      pathInSettingsMustBe = 'ES_INDEXES_NO_MAIN_SEARCH.DRUGS_LIST'
      expect(state.settings_path).toBe(pathInSettingsMustBe)
      queryStringMustBe = customQueryString
      expect(state.custom_query_string).toBe(queryStringMustBe)
      expect(state.use_custom_query_string).toBe(true)

      stickyQueryGot = state.sticky_query
      expect(_.isEqual(stickyQueryGot, stickyQueryMustBe)).toBe(true)

    it 'creates a list from a state object', -> TestsUtils.testRestoredListIsEqualToOriginal(list)