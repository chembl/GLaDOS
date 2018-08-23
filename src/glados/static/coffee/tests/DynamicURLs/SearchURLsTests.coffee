describe 'Search URLs', ->

  describe 'url for for all results', ->
    it 'Generates the correct full url', ->

      searchURLGot = SearchModel.getInstance().getSearchURL()
      console.log 'searchURLGot: ', searchURLGot
      searchURLMustBe = "#{glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL}search_results/all"
      console.log 'searchURLMustBe: ', searchURLMustBe
      expect(searchURLGot).toBe(searchURLMustBe)