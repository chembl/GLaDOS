describe "Paginated Collection", ->
  describe "A 3 elements collection", ->
    appDrugCCList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

    beforeAll (done) ->
      simulateDataWSClientList(appDrugCCList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData0.json', done)

    afterAll: (done) ->
      appDrugCCList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()
      simulateDataWSClientList(appDrugCCList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData0.json', done)

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
      simulateDataWSClientList(drugList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData1.json', done)

    it "gives the first page correctly", ->
      assert_chembl_ids(drugList, ["CHEMBL6939", "CHEMBL22", "CHEMBL6941", "CHEMBL6942", "CHEMBL6944"])


  describe "A 68 elements collection", ->
    appDrugCCList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

    beforeAll (done) ->
      simulateDataWSClientList(appDrugCCList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData2.json', done)

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

      to_show = appDrugCCList.getCurrentPage()
      chembl_ids = _.map(to_show, (o)-> o.get('molecule_chembl_id'))
      expected_chembl_ids = ["CHEMBL1091", "CHEMBL1152", "CHEMBL1159650", "CHEMBL1161", "CHEMBL1200342",
        "CHEMBL1200376"]

      comparator = _.zip(chembl_ids, expected_chembl_ids)
      for elem in comparator
        expect(elem[0]).toBe(elem[1])

      total_pages = appDrugCCList.getMeta('total_pages')
      expect(total_pages).toBe(14)

    it "gives page 7 correctly with 5 per page", ->
      appDrugCCList.resetPageSize(5)
      appDrugCCList.setPage(7)

      to_show = appDrugCCList.getCurrentPage()
      chembl_ids = _.map(to_show, (o)-> o.get('molecule_chembl_id'))
      expected_chembl_ids = ["CHEMBL1200975", "CHEMBL1200989", "CHEMBL1201012", "CHEMBL1201014", "CHEMBL1201064",
        "CHEMBL1201081"]

      comparator = _.zip(chembl_ids, expected_chembl_ids)
      for elem in comparator
        expect(elem[0]).toBe(elem[1])


    it "gives last page correctly", ->
      appDrugCCList.resetPageSize(5)
      appDrugCCList.setPage(14)

      to_show = appDrugCCList.getCurrentPage()
      chembl_ids = _.map(to_show, (o)-> o.get('molecule_chembl_id'))
      expected_chembl_ids = ["CHEMBL635", "CHEMBL650", "CHEMBL989"]

      comparator = _.zip(chembl_ids, expected_chembl_ids)
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
      expect(total_pages).toBe(84335)
      expect(total_records).toBe(1686695)
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

  #TODO: tests for sorting and filtering search


  # ------------------------------
  # Helpers
  # ------------------------------

  assert_chembl_ids = (collection, expected_chembl_ids) ->
    to_show = collection.getCurrentPage()
    chembl_ids = _.map(to_show, (o)-> o.get('molecule_chembl_id'))

    comparator = _.zip(chembl_ids, expected_chembl_ids)
    for elem in comparator
      expect(elem[0]).toBe(elem[1])

  simulateDataWSClientList = (list, dataURL, done) ->
    $.get dataURL, (testData) ->
      list.reset(testData)
      done()








