describe "An elasticsearch collection", ->

  describe 'Text Filter: ', ->

    esList = undefined
    searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')

    comparatorsForTextFilterSet = {

      "molecule_chembl_id": "molecule_chembl_id"
      "molecule_properties.full_molformula": "molecule_properties.full_molformula"
      "molecule_properties.molecular_species": "molecule_properties.molecular_species"
      "molecule_properties.ro3_pass": "molecule_properties.ro3_pass"
      "molecule_structures.canonical_smiles": "molecule_structures.canonical_smiles"
      "molecule_synonyms": "molecule_synonyms"
      "molecule_type": "molecule_type"
      "pref_name": "pref_name"
      "structure_type": "structure_type"
    }

    beforeAll (done) ->

      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('searchESQuery', searchESQuery)
      esList.setMeta('test_mode', true)
      esList.setMeta('comparators_for_text_filter_set', comparatorsForTextFilterSet)
      TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)

    beforeEach ->
      esList.setMeta('test_mode', true)
      esList.clearAllFacetsSelections()
      esList.clearTextFilter()

    it 'starts with an empty text filter', ->

      currentTextFilter = esList.getMeta('text_filter')
      expect(currentTextFilter?).toBe(false)

    it 'sets a text filter', ->

      filter = 'some filter'
      esList.setTextFilter(filter)

      currentTextFilter = esList.getTextFilter()
      expect(currentTextFilter).toBe(filter)

    it 'clears the text filter', ->

      filter = 'some filter'
      esList.setTextFilter(filter)
      esList.clearTextFilter()

      currentTextFilter = esList.getMeta('text_filter')
      expect(currentTextFilter?).toBe(false)

    it 'does not affect the query when no filter', ->

      requestData = esList.getRequestData()
      boolFilterMustBe = []
      boolFilterGot = requestData.query.bool.filter

      expect(_.isEqual(boolFilterMustBe, boolFilterGot)).toBe(true)

    it 'adds the correct query to the request', ->

      filter = 'some filter'
      esList.setTextFilter(filter)

      comparatorsList = _.keys(comparatorsForTextFilterSet)
      comparatorsList.sort()

      textFilterQueryMustBe = {
        "query_string": {
          "fields": ("#{comp}.*" for comp in comparatorsList),
          "query": esList.getTextFilter()
        }
      }

      requestDataGot = esList.getRequestData()
      texFilterQueryGot = requestDataGot.query.bool.filter[0]

      expect(_.isEqual(textFilterQueryMustBe, texFilterQueryGot)).toBe(true)

    it 'generates a state object with the text filter', ->

      filter = 'some filter'
      esList.setTextFilter(filter)

      TestsUtils.testSavesList(esList,
        pathInSettingsMustBe='ES_INDEXES.COMPOUND',
        queryStringMustBe=undefined,
        useQueryStringMustBe=undefined,
        stickyQueryMustBe=undefined,
        esSearchQueryMustBe= searchESQuery,
        searchTermMustBe=undefined,
        contextualColumnsMustBe=undefined,
        generatorListMustBe=undefined,
        textFilterMustBe=filter
      )

    it 'creates a list from a state object', ->

      filter = 'some filter'
      esList.setTextFilter(filter)

      TestsUtils.testRestoredListIsEqualToOriginal(esList)


