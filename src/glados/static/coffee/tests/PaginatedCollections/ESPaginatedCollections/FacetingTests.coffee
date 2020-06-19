describe "An elasticsearch collection", ->

  describe 'Faceting: ', ->

    esList = undefined
    searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')

    beforeAll (done) ->

      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('searchESQuery', searchESQuery)
      esList.setMeta('test_mode', true)
      TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)

    beforeEach ->
      esList.setMeta('test_mode', true)
      esList.clearAllFacetsSelections()

    it 'starts with all facets unselected', ->

      facetGroups = esList.getFacetsGroups()

      for fGroupKey, fGroup of facetGroups

        console.log 'fGroup.faceting_handler.faceting_data: ', fGroup.faceting_handler.faceting_data

        for fKey, fData of fGroup.faceting_handler.faceting_data
          expect(fData.selected).toBe(false)

    it 'clears all facets selection', ->

      facetGroups = esList.getFacetsGroups()
      testFacetGroupKey = 'max_phase'
      testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
      facetingHandler = facetGroups[testFacetGroupKey].faceting_handler
      facetingHandler.toggleKeySelection(testFacetKey)

      esList.clearAllFacetsSelections()

      for fGroupKey, fGroup of facetGroups
        for fKey, fData of fGroup.faceting_handler.faceting_data
          expect(fData.selected).toBe(false)

    it 'selects one facet', ->

      facetGroups = esList.getFacetsGroups()
      testFacetGroupKey = 'max_phase'
      testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
      facetingHandler = facetGroups[testFacetGroupKey].faceting_handler
      facetingHandler.toggleKeySelection(testFacetKey)

      expect(facetGroups[testFacetGroupKey].faceting_handler.faceting_data[testFacetKey].selected).toBe(true)


    describe 'After selecting a facet', ->

      beforeAll (done) ->

        esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
        glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
        ]
        esList.setMeta('test_mode', true)
        TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)


      beforeEach ->

        esList.setMeta('searchESQuery', searchESQuery)
        facetGroups = esList.getFacetsGroups()
        testFacetGroupKey = 'max_phase'
        testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
        facetingHandler = facetGroups[testFacetGroupKey].faceting_handler
        facetingHandler.toggleKeySelection(testFacetKey)
        esList.setMeta('facets_changed', true)
        esList.fetch(options=undefined, testMode=true)

      it 'Updates the request data as the pagination moves', ->

        totalRecords = 100
        esList.setMeta('total_records', totalRecords)
        pageSize = 10
        esList.setMeta('page_size', pageSize)
        totalPages = Math.ceil(totalRecords / pageSize)
        esList.setMeta('total_pages', totalPages)

        TestsUtils.testIteratesPages(esList, pageSize, totalPages)

        facetGroups = esList.getFacetsGroups()
        testFacetGroupKey = 'max_phase'
        testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
        expect(facetGroups[testFacetGroupKey].faceting_handler.faceting_data[testFacetKey].selected).toBe(true)

      it 'updates the request data as the pagination moves, with different pager sizes', ->

        totalRecords = 100
        TestsUtils.testIteratesPagesWithDifferentPageSizes(esList, totalRecords)

    describe 'After selecting multiple facets', ->

      beforeAll ->
        esList.clearAllFacetsSelections()

      testFacetGroupKey1 = 'max_phase'
      testFacetGroupKey2 = 'molecule_properties.num_ro5_violations'

      beforeEach ->

        esList.setMeta('searchESQuery', searchESQuery)
        esList.setMeta('test_mode', true)
        facetGroups = esList.getFacetsGroups()

        testFacetKey1 = facetGroups[testFacetGroupKey1].faceting_handler.faceting_keys_inorder[0]
        facetingHandler = facetGroups[testFacetGroupKey1].faceting_handler
        facetingHandler.toggleKeySelection(testFacetKey1)

        testFacetKey2 = facetGroups[testFacetGroupKey2].faceting_handler.faceting_keys_inorder[0]
        facetingHandler = facetGroups[testFacetGroupKey2].faceting_handler
        facetingHandler.toggleKeySelection(testFacetKey2)

        esList.setMeta('facets_changed', true)
        esList.fetch(options=undefined, testMode=true)

      it 'generates a state object', ->  TestsUtils.testSavesList(esList,
        pathInSettingsMustBe='ES_INDEXES.COMPOUND',
        queryStringMustBe=undefined,
        useQueryStringMustBe=undefined,
        stickyQueryMustBe=undefined,
        esSearchQueryMustBe= searchESQuery,
        searchTermMustBe=undefined,
        contextualColumnsMustBe=undefined,
        generatorListMustBe=undefined,
      )

      it 'creates a list from a state object', -> TestsUtils.testRestoredListIsEqualToOriginal(esList)


