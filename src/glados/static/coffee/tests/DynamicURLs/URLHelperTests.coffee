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
    beforeAll ->

      glados.helpers.URLHelper.testMode = true
      urlHelper = glados.helpers.URLHelper.getInstance()
      urlHelper.setMode(currentMode)
      searchModel = SearchModel.getInstance()

    it 'initialises the instance', -> testModeSetting(currentMode)


