describe 'Search URLs', ->

  describe 'url for for all results', ->
    it 'Generates the correct full url', ->

      searchURLGot = SearchModel.getInstance().getSearchURL()
      searchURLMustBe = "#{glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL}search_results/all"
      expect(searchURLGot).toBe(searchURLMustBe)

    it 'Generates the correct url fragment', ->

      searchURLGot = SearchModel.getInstance().getSearchURL(esEntityKey=undefined,
        searchTerm=undefined,
        currentState=undefined,
        fragmentOnly=true)

      searchURLMustBe = '#search_results/all'
      expect(searchURLGot).toBe(searchURLMustBe)