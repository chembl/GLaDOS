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

    glados.helpers.URLHelper.initInstance(currentMode)
    urlHelper = glados.helpers.URLHelper.getInstance()
    modeGot = urlHelper.mode
    expect(modeGot).toBe(currentMode)


  describe 'Search Results Mode', ->

    currentMode = glados.helpers.URLHelper.MODES.SEARCH_RESULTS
    it 'initialises the instance', -> testInitialisation(currentMode)

  describe 'Entity Browsing Mode', ->

    currentMode = glados.helpers.URLHelper.MODES.BROWSE_ENTITY
    it 'initialises the instance', -> testInitialisation(currentMode)


