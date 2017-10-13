describe "Paginated Collection", ->
  describe "A 3 elements collection", ->
    appDrugCCList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

    beforeAll (done) ->
      TestsUtils.simulateDataWSClientList(appDrugCCList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData0.json', done)

    afterAll: (done) ->
      appDrugCCList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()
      TestsUtils.simulateDataWSClientList(appDrugCCList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData0.json', done)

    it "initialises correctly", ->
      page_size = appDrugCCList.getMeta('page_size')
      current_page = appDrugCCList.getMeta('current_page')
      total_pages = appDrugCCList.getMeta('total_pages')
      total_records = appDrugCCList.getMeta('total_records')
      records_in_page = appDrugCCList.getMeta('records_in_page')

      expect(page_size).toBe(10)
      expect(current_page).toBe(1)
      expect(total_pages).toBe(1)
      expect(total_records).toBe(3)
      expect(records_in_page).toBe(3)
      expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)
      expect(Object.keys(appDrugCCList.getMeta('selection_exceptions')).length).toBe(0)

    it "gives the first page correctly", ->
      assert_chembl_ids(appDrugCCList, ["CHEMBL1200526", "CHEMBL2218913", "CHEMBL614"])

    it "sorts the collection by name (ascending)", ->
      appDrugCCList.sortCollection('pref_name')
      assert_chembl_ids(appDrugCCList, ["CHEMBL2218913", "CHEMBL614", "CHEMBL1200526"])

    it "sorts the collection by name (descending)", ->
      appDrugCCList.resetMeta()

      appDrugCCList.sortCollection('pref_name')
      appDrugCCList.sortCollection('pref_name')

      assert_chembl_ids(appDrugCCList, ["CHEMBL1200526", "CHEMBL614", "CHEMBL2218913"])

    it "searches for a CHEMBL1200526", ->
      appDrugCCList.setSearch('CHEMBL1200526')
      assert_chembl_ids(appDrugCCList, ["CHEMBL1200526"])


  describe "A 5 elements collection, having 5 elements per page", ->
    drugList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugList()
    drugList.setMeta('page_size', 5)
    drugList.setMeta('server_side', true)

    beforeAll (done) ->
      TestsUtils.simulateDataWSClientList(drugList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData1.json', done)

    it "gives the first page correctly", ->
      assert_chembl_ids(drugList, ["CHEMBL6939", "CHEMBL22", "CHEMBL6941", "CHEMBL6942", "CHEMBL6944"])


  describe "A 68 elements collection", ->
    appDrugCCList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

    beforeAll (done) ->
      TestsUtils.simulateDataWSClientList(appDrugCCList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData2.json', done)

    beforeEach ->
      appDrugCCList.unSelectAll()

    it "initialises correctly", ->
      page_size = appDrugCCList.getMeta('page_size')
      current_page = appDrugCCList.getMeta('current_page')
      total_pages = appDrugCCList.getMeta('total_pages')
      total_records = appDrugCCList.getMeta('total_records')
      records_in_page = appDrugCCList.getMeta('records_in_page')

      expect(page_size).toBe(10)
      expect(current_page).toBe(1)
      expect(total_pages).toBe(7)
      expect(total_records).toBe(68)
      expect(records_in_page).toBe(10)

    it "gives 5 records per page correctly", ->
      appDrugCCList.resetPageSize(5)

      allItemsIDs = (model.get('molecule_chembl_id') for model in appDrugCCList.models)
      to_show = appDrugCCList.getCurrentPage()
      shownIDs = (model.get('molecule_chembl_id') for model in to_show)
      expected_chembl_ids = allItemsIDs[0..4]
      comparator = _.zip(shownIDs, expected_chembl_ids)
      for elem in comparator
        expect(elem[0]).toBe(elem[1])

      total_pages = appDrugCCList.getMeta('total_pages')
      expect(total_pages).toBe(14)

    it "gives page 7 correctly with 5 per page", ->
      pageSize = 5
      pageNum = 7
      appDrugCCList.resetPageSize(pageSize)
      appDrugCCList.setPage(pageNum)

      allItemsIDs = (model.get('molecule_chembl_id') for model in appDrugCCList.models)
      start = (pageNum - 1) * pageSize
      stop = start + pageSize - 1
      expectedChEMBLIDs = allItemsIDs[start..stop]
      to_show = appDrugCCList.getCurrentPage()
      shownIDs = _.map(to_show, (o)-> o.get('molecule_chembl_id'))

      comparator = _.zip(shownIDs, expectedChEMBLIDs)
      for elem in comparator
        expect(elem[0]).toBe(elem[1])


    it "gives last page correctly", ->

      pageSize = 5
      pageNum = 14

      appDrugCCList.resetPageSize(pageSize)
      appDrugCCList.setPage(pageNum)

      allItemsIDs = (model.get('molecule_chembl_id') for model in appDrugCCList.models)

      to_show = appDrugCCList.getCurrentPage()
      shownIDs = _.map(to_show, (o)-> o.get('molecule_chembl_id'))
      start = (pageNum - 1) * pageSize
      stop = allItemsIDs.length - 1
      expectedChEMBLIDs = allItemsIDs[start..stop]

      comparator = _.zip(shownIDs, expectedChEMBLIDs)
      for elem in comparator
        expect(elem[0]).toBe(elem[1])

  describe "A server side collection", ->
    drugList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugList()

    #    drugList = new DrugList
    drugList.setMeta('page_size', 20)

    beforeEach (done) ->
      drugList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugList()
      drugList.fetch
        success: done

    it "(SERVER DEPENDENT) initialises correctly", (done) ->
      page_size = drugList.getMeta('page_size')
      current_page = drugList.getMeta('current_page')
      total_pages = drugList.getMeta('total_pages')
      total_records = drugList.getMeta('total_records')
      records_in_page = drugList.getMeta('records_in_page')

      expect(page_size).toBe(20)
      expect(current_page).toBe(1)
      expect(total_pages).toBe(86773)
      expect(total_records).toBe(1735442)
      expect(records_in_page).toBe(20)
      expect(drugList.getMeta('all_items_selected')).toBe(false)
      expect(Object.keys(drugList.getMeta('selection_exceptions')).length).toBe(0)

      done()

    it "defines the initial url", ->
      expect(drugList.url).toBe('https://www.ebi.ac.uk/chembl/api/data/molecule.json?limit=20&offset=0')


    it "defines the url for the 5th page", ->
      drugList.setPage(5)
      expect(drugList.url).toBe('https://www.ebi.ac.uk/chembl/api/data/molecule.json?limit=20&offset=80')

    it "defines the url after switching to 5 items per page", ->
      drugList.resetPageSize(5)
      expect(drugList.url).toBe('https://www.ebi.ac.uk/chembl/api/data/molecule.json?limit=5&offset=0')

    it "generates a url from custom parameters", ->

      customPageSize = 50
      customPageNum = 10
      url = drugList.getPaginatedURL(customPageSize, customPageNum)
      expect(url).toBe('https://www.ebi.ac.uk/chembl/api/data/molecule.json?limit=50&offset=450')

    it "generates a correct paginated url (sorting)", ->
      drugList.sortCollection('molecule_chembl_id')
      url = drugList.getPaginatedURL()

      expect(url).toContain('order_by=molecule_chembl_id')


    it "generates a correct paginated url (search)", ->
      drugList.setSearch('25', 'molecule_chembl_id', 'text')
      drugList.setSearch('ASP', 'pref_name', 'text')

      url = drugList.getPaginatedURL()

      expect(url).toContain('molecule_chembl_id__contains=25')
      expect(url).toContain('pref_name__contains=ASP')


  describe "An elasticsearch collection", ->
    esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
    glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
    ]


    beforeEach (done) ->
      esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
      glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
      ]
      esList.setMeta('singular_terms', ['aspirin'])
      esList.setMeta('exact_terms', ['"CHEMBL59"'])
      esList.setMeta('filter_terms', [])
      esList.resetSortData()

      #
      done()

    it "Sets initial parameters", ->
      expect(esList.getMeta('current_page')).toBe(1)
      expect(esList.getMeta('index')).toBe('/chembl_molecule')
      expect(esList.getMeta('page_size')).toBe(24)
      expect(esList.getMeta('all_items_selected')).toBe(false)
      expect(Object.keys(esList.getMeta('selection_exceptions')).length).toBe(0)

    it "Sets the request data to get the 5th page", ->
      esList.setPage(5)
      expect(esList.getURL()).toBe(glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_molecule/_search')

      requestData = esList.getRequestData()
      expect(requestData['from']).toBe(0)
      expect(requestData['size']).toBe(24)

    it "Sets the request data to switch to 10 items per page", ->
      esList.resetPageSize(10)
      expect(esList.getURL()).toBe(glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_molecule/_search')

      requestData = esList.getRequestData()
      expect(requestData['from']).toBe(0)
      expect(requestData['size']).toBe(10)

    testIteratesPages = (esList, pageSize, totalPages) ->

      for pageNumber in [1..totalPages]
        requestData = esList.setPage(pageNumber, doFetch=true, testMode=true)
        expect(requestData['from']).toBe(pageSize * (pageNumber - 1))
        expect(requestData['size']).toBe(pageSize)

    testIteratesPagesWithDifferentPageSizes = (esList, totalRecords) ->
      esList.setMeta('total_records', totalRecords)

      for pageSize in [1..totalRecords]
        esList.setMeta('page_size', pageSize)
        totalPages = Math.ceil(totalRecords / pageSize)
        esList.setMeta('total_pages', totalPages)
        testIteratesPages(esList, pageSize)

      #so it doesn't give the warning
      expect(true).toBe(true)

    it 'updates the request data as the pagination moves', ->

      totalRecords = 100
      esList.setMeta('total_records', totalRecords)
      pageSize = 10
      esList.setMeta('page_size', pageSize)
      totalPages = Math.ceil(totalRecords / pageSize)
      esList.setMeta('total_pages', totalPages)
      testIteratesPages(esList, pageSize, totalPages)

    it 'updates the request data as the pagination moves, with different pager sizes', ->

      totalRecords = 100
      testIteratesPagesWithDifferentPageSizes(esList, totalRecords)

    it 'updates the state for sorting (asc)', ->

      sortingComparator = 'molecule_chembl_id'
      esList.sortCollection(sortingComparator)
      columns = esList.getMeta('columns')
      for col in columns
        if col.comparator == sortingComparator
          expect(col.is_sorting).toBe(1)
        else
          expect(col.is_sorting).toBe(0)

    it 'updates the state for sorting (desc)', ->

      sortingComparator = 'molecule_chembl_id'
      esList.sortCollection(sortingComparator)
      esList.sortCollection(sortingComparator)
      columns = esList.getMeta('columns')
      for col in columns
        if col.comparator == sortingComparator
          expect(col.is_sorting).toBe(-1)
        else
          expect(col.is_sorting).toBe(0)

    it 'resets sorting', ->

      esList.resetSortData()
      columns = esList.getMeta('columns')
      for col in columns
        expect(col.is_sorting).toBe(0)

    it 'generates the request data for sorting (asc)', ->

      sortingComparator = 'molecule_chembl_id'
      esList.sortCollection(sortingComparator)
      requestData = esList.getRequestData()
      sortingInfo = requestData.sort[0]
      console.log 'sortingInfo: ', sortingInfo
      expect(sortingInfo[sortingComparator]?).toBe(true)
      expect(sortingInfo[sortingComparator].order).toBe('asc')

    it 'generates the request data for sorting (desc)', ->

      sortingComparator = 'molecule_chembl_id'
      esList.sortCollection(sortingComparator)
      esList.sortCollection(sortingComparator)
      requestData = esList.getRequestData()
      sortingInfo = requestData.sort[0]
      expect(sortingInfo[sortingComparator]?).toBe(true)
      expect(sortingInfo[sortingComparator].order).toBe('desc')

    describe 'Faceting: ', ->

      beforeAll (done) ->

        TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)

      beforeEach ->
        esList.clearAllFacetsSelections()

      it 'starts with all facets unselected', ->

        facetGroups = esList.getFacetsGroups()
        for fGroupKey, fGroup of facetGroups
          for fKey, fData of fGroup.faceting_handler.faceting_data
            expect(fData.selected).toBe(false)

      it 'clears all facets selection', ->

        facetGroups = esList.getFacetsGroups()
        testFacetGroupKey = 'full_mwt'
        testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
        facetingHandler = facetGroups[testFacetGroupKey].faceting_handler
        facetingHandler.toggleKeySelection(testFacetKey)

        esList.clearAllFacetsSelections()

        for fGroupKey, fGroup of facetGroups
          for fKey, fData of fGroup.faceting_handler.faceting_data
            console.log "DEBUGGING", fData
            expect(fData.selected).toBe(false)

      it 'selects one facet', ->

        facetGroups = esList.getFacetsGroups()
        testFacetGroupKey = 'full_mwt'
        testFacetKey = facetGroups[testFacetGroupKey].faceting_handler.faceting_keys_inorder[0]
        facetingHandler = facetGroups[testFacetGroupKey].faceting_handler
        facetingHandler.toggleKeySelection(testFacetKey)

        expect(facetGroups[testFacetGroupKey].faceting_handler.faceting_data[testFacetKey].selected).toBe(true)


      describe 'After selecting a facet', ->

        beforeAll (done) ->

          esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
          glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
          ]
          TestsUtils.simulateFacetsESList(esList, glados.Settings.STATIC_URL + 'testData/FacetsTestData.json', done)

        beforeEach ->

          facetGroups = esList.getFacetsGroups()
          testFacetGroupKey = 'full_mwt'
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

          testIteratesPages(esList, pageSize, totalPages)

        it 'updates the request data as the pagination moves, with different pager sizes', ->

          totalRecords = 100
          testIteratesPagesWithDifferentPageSizes(esList, totalRecords)

  #TODO: tests for sorting and filtering search
  describe "An elasticsearch collection initialised from a custom querystring", ->

    customQueryString = 'target_chembl_id:CHEMBL2093868 AND ' +
      'standard_type:(IC50 OR Ki OR EC50 OR Kd) AND _exists_:standard_value AND _exists_:ligand_efficiency'
    esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(customQueryString)

    it 'Sets initial parameters', ->
      expect(esList.getMeta('id_name')).toBe("ESActivitity")
      expect(esList.getMeta('index')).toBe("/chembl_activity")
      expect(esList.getMeta('key_name')).toBe("ACTIVITY")
      expect(esList.getMeta('custom_query_string')).toBe(customQueryString)

    it 'Generates the correct request object', ->

      requestData = esList.getRequestData()
      expect(requestData.query.bool.must[0].query_string.query).toBe(customQueryString)

  describe "A WS collection initialised with a filter", ->

    filter = 'target_chembl_id=CHEMBL2096905&standard_type=Ki'
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewActivitiesList(filter)

    it 'generates the initial url', ->

      console.log 'generates the initial url'
      urlMustBe = 'https://wwwdev.ebi.ac.uk/chembl/api/data/activity.json?limit=20&offset=0&target_chembl_id=CHEMBL2096905&standard_type=Ki'
      expect(list.url).toBe(urlMustBe)

  # ------------------------------
  # Helpers
  # ------------------------------

  assert_chembl_ids = (collection, expected_chembl_ids) ->
    to_show = collection.getCurrentPage()
    chembl_ids = _.map(to_show, (o)-> o.get('molecule_chembl_id'))

    comparator = _.zip(chembl_ids, expected_chembl_ids)
    for elem in comparator
      expect(elem[0]).toBe(elem[1])