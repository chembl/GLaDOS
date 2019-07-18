describe "An elasticsearch collection initialised from a custom querystring", ->

  customQueryString = 'target_chembl_id:CHEMBL2093868 AND ' +
    'standard_type:(IC50 OR Ki OR EC50 OR Kd) AND _exists_:standard_value AND _exists_:ligand_efficiency'
  esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(customQueryString)

  it 'Sets initial parameters', ->
    expect(esList.getMeta('id_name')).toBe("ESActivitity")
    expect(esList.getMeta('index')).toBe("/chembl_activity")
    expect(esList.getMeta('key_name')).toBe("ACTIVITY")
    expect(esList.getMeta('custom_query')).toBe(customQueryString)

  it 'Distinguishes between a query string and a full query', ->

    expect(esList.customQueryIsFullQuery()).toBe(false)

  it 'Generates the correct request object', ->

    console.log('DEBUG')
    requestData = esList.getRequestData()
    expect(requestData.query.bool.must[0].query_string.query).toBe(customQueryString)

  it 'generates a state object', ->

    TestsUtils.testSavesList(esList,
      pathInSettingsMustBe='ES_INDEXES_NO_MAIN_SEARCH.ACTIVITY',
      queryStringMustBe=customQueryString,
      useQueryStringMustBe=true)

  it 'creates a list from a state object', -> TestsUtils.testRestoredListIsEqualToOriginal(esList)