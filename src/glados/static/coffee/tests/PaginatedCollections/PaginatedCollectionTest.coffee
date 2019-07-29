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

  # ------------------------------
  # Helpers
  # ------------------------------

  assert_chembl_ids = (collection, expected_chembl_ids) ->
    to_show = collection.getCurrentPage()
    chembl_ids = _.map(to_show, (o)-> o.get('molecule_chembl_id'))

    comparator = _.zip(chembl_ids, expected_chembl_ids)
    for elem in comparator
      expect(elem[0]).toBe(elem[1])