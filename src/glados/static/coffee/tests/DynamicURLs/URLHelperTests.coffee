describe 'URL Helper', ->

  describe 'Search Results Mode', ->

    currentMode = glados.helpers.URLHelper.MODES.SEARCH_RESULTS
    it 'initialises the instance', ->

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
