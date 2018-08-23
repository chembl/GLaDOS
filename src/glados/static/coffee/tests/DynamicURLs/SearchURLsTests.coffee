describe 'Search URLs', ->

  entityKeys = _.keys(glados.Settings.ES_KEY_2_SEARCH_PATH)
  entityKeys.unshift('all')
  for entityKey in entityKeys

    for searchTerm in [undefined, 'dopamine']

      for currentState in [undefined, 'some_defined_state']

        for fragmentOnly in [true, false]

          test = (entityKey, searchTerm, currentState, fragmentOnly) ->

            it "URL for #{entityKey}, searchTerm: '#{searchTerm}', state: '#{currentState}', fragmentOnly: '#{fragmentOnly}'", ->

              searchURLGot = SearchModel.getInstance().getSearchURL(entityKey, searchTerm, currentState, fragmentOnly)
              tab = 'all'
              if entityKey? and _.has(glados.Settings.ES_KEY_2_SEARCH_PATH, entityKey)
                tab = glados.Settings.ES_KEY_2_SEARCH_PATH[entityKey]
              searchURLMustBe = ''
              if not fragmentOnly
                searchURLMustBe += glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL
                searchURLMustBe += "search_results/#{tab}"
              else
                searchURLMustBe += "#search_results/#{tab}"
              if searchTerm? and _.isString(searchTerm) and searchTerm.trim().length > 0
                searchURLMustBe += "/query=" + encodeURIComponent(searchTerm)
              if currentState?
                searchURLMustBe += "/state=#{currentState}"

              expect(searchURLGot).toBe(searchURLMustBe)

          test(entityKey, searchTerm, currentState, fragmentOnly)