describe 'URL Helper', ->


  # ------------------------------------------------------------------------------------------------------------------
  # Generic Tests
  # ------------------------------------------------------------------------------------------------------------------
  testInitialisation = (currentMode) ->

    console.log 'currentMode: ', currentMode
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

    glados.helpers.URLHelper.initInstance(currentMode)
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

    beforeAll ->
      glados.helpers.URLHelper.initInstance(currentMode, true)
      urlHelper = glados.helpers.URLHelper.getInstance()

    it 'updates the search url', ->

      esEntityKey = 'compounds'
      searchTerm = 'dopamine'
      currentState = 'someState'
      [breadcrumbs, urlGot] = urlHelper.updateSearchURL(esEntityKey, searchTerm, currentState)
      urlMustBe = '#search_results/all/query=dopamine/state=someState'

      expect(urlMustBe).toBe(urlGot)

  describe 'Entity Browsing Mode', ->

    currentMode = glados.helpers.URLHelper.MODES.BROWSE_ENTITY
    it 'initialises the instance', -> testInitialisation(currentMode)
    beforeAll ->
      glados.helpers.URLHelper.initInstance(currentMode, true)
    it 'works', ->


