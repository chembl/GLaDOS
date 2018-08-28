describe 'URL Helper', ->


  # ------------------------------------------------------------------------------------------------------------------
  # Generic Tests
  # ------------------------------------------------------------------------------------------------------------------
  testInitialisation = (currentMode) ->

    exceptionThrown = false
    try
      glados.helpers.URLHelper.initInstance()
    catch error
      exceptionThrown = true

    expect(exceptionThrown).toBe(true)

    exceptionThrown = false
    try
      glados.helpers.URLHelper.initInstance('unexisting mode')
    catch error
      exceptionThrown = true

    expect(exceptionThrown).toBe(true)

    glados.helpers.URLHelper.initInstance(currentMode, true)
    urlHelper = glados.helpers.URLHelper.getInstance()
    modeGot = urlHelper.mode
    expect(modeGot).toBe(currentMode)


  # ------------------------------------------------------------------------------------------------------------------
  # Specific tests
  # ------------------------------------------------------------------------------------------------------------------
  describe 'Search Results Mode', ->

    currentMode = glados.helpers.URLHelper.MODES.SEARCH_RESULTS
    it 'initialises the instance', -> testInitialisation(currentMode)

    urlHelper = undefined
    searchModel = undefined

    beforeAll ->
      glados.helpers.URLHelper.deleteInstance()
      glados.helpers.URLHelper.initInstance(currentMode, true)
      urlHelper = glados.helpers.URLHelper.getInstance()
      searchModel = SearchModel.getInstance()

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
    it 'initialises the instance', -> testInitialisation(currentMode)
    beforeAll ->
      glados.helpers.URLHelper.deleteInstance()
      glados.helpers.URLHelper.initInstance(currentMode, true)
    it 'works', ->


