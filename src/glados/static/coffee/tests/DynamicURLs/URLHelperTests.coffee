describe 'URL Helper', ->


  # ------------------------------------------------------------------------------------------------------------------
  # Generic Tests
  # ------------------------------------------------------------------------------------------------------------------
  testModeSetting = (currentMode) ->

    urlHelper = glados.helpers.URLHelper.getInstance()
    expect(urlHelper.mode).toBe(currentMode)

  # ------------------------------------------------------------------------------------------------------------------
  # Specific tests
  # ------------------------------------------------------------------------------------------------------------------
  describe 'Search Results Mode', ->

    currentMode = glados.helpers.URLHelper.MODES.SEARCH_RESULTS

    urlHelper = undefined
    searchModel = undefined

    beforeAll ->
      glados.helpers.URLHelper.testMode = true
      urlHelper = glados.helpers.URLHelper.getInstance()
      urlHelper.setMode(currentMode)
      searchModel = SearchModel.getInstance()

    it 'sets the modes correctly', -> testModeSetting(currentMode)

    it 'updates the search url', ->

      esEntityKey = 'compounds'
      searchTerm = 'dopamine'
      currentState = 'someState'
      [breadcrumbs, urlGot] = urlHelper.updateSearchURL(esEntityKey, searchTerm, currentState)
      urlMustBe = '#search_results/all/query=dopamine/state=someState'

      expect(urlMustBe).toBe(urlGot)

    it 'saves the latest data after updating the url', ->

      esEntityKey = 'compounds'
      searchTerm = 'dopamine'
      currentState = 'someState'
      [breadcrumbs, urlGot] = urlHelper.updateSearchURL(esEntityKey, searchTerm, currentState)

      expect(urlHelper.esEntityKey).toBe(esEntityKey)
      expect(urlHelper.searchTerm).toBe(searchTerm)
      expect(urlHelper.currentState).toBe(currentState)

    it 'responds to the SEARCH PARAMS UPDATED event', ->

      spyOn(urlHelper, 'updateSearchURL')
      esEntityKey = 'compounds'
      searchTerm = 'dopamine'
      currentState = 'someState'
      searchModel.trigger(SearchModel.EVENTS.SEARCH_PARAMS_HAVE_CHANGED, esEntityKey, searchTerm, currentState)
      expect(urlHelper.updateSearchURL).toHaveBeenCalled()

    it 'allows to call updateSearchURL defining unchanged params', ->

      esEntityKey = 'compounds'
      searchTerm = 'dopamine'
      currentState = 'someState'
      urlHelper.updateSearchURL(esEntityKey, searchTerm, currentState)
      [breadcrumbs, urlGot] = urlHelper.updateSearchURL(esEntityKey, glados.helpers.URLHelper.VALUE_UNCHANGED,
        glados.helpers.URLHelper.VALUE_UNCHANGED)

      expect(urlHelper.esEntityKey).toBe(esEntityKey)
      expect(urlHelper.searchTerm).toBe(searchTerm)
      expect(urlHelper.currentState).toBe(currentState)
      urlMustBe = '#search_results/all/query=dopamine/state=someState'
      expect(urlMustBe).toBe(urlGot)

  describe 'Entity Browsing Mode', ->

    currentMode = glados.helpers.URLHelper.MODES.BROWSE_ENTITY

    esList = undefined
    searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')

    beforeAll (done) ->

      glados.helpers.URLHelper.testMode = true
      urlHelper = glados.helpers.URLHelper.getInstance()
      urlHelper.setMode(currentMode)
      searchModel = SearchModel.getInstance()

      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('searchESQuery', searchESQuery)
      esList.setMeta('test_mode', true)
      TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)


    it 'initialises the instance', -> testModeSetting(currentMode)


