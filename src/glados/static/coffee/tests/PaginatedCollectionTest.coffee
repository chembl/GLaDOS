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

    it "selects one item", ->
      appDrugCCList.selectItem('CHEMBL1091')
      expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(true)
      expect(appDrugCCList.itemIsSelected('CHEMBL1152')).toBe(false)
      expect(appDrugCCList.getSelectedItemsIDs()).toContain('CHEMBL1091')

    it "selects all items", ->
      appDrugCCList.selectAll()
      expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(true)
      selectedItemsShouldBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()

      for item in selectedItemsShouldBe
        expect(selectedItemsGot).toContain(item)
        expect(appDrugCCList.itemIsSelected(item)).toBe(true)

    it "unselects one item", ->
      appDrugCCList.unSelectItem('CHEMBL1091')
      expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(false)
      expect(appDrugCCList.getSelectedItemsIDs()).not.toContain('CHEMBL1091')

    it "unselects all items", ->
      appDrugCCList.unSelectAll()
      expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(false)
      selectedItemsShouldNotBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()

      for item in selectedItemsShouldNotBe
        expect(selectedItemsGot).not.toContain(item)
        expect(appDrugCCList.itemIsSelected(item)).toBe(false)

    it "selects all items, except one", ->

      exception = 'CHEMBL1152'
      appDrugCCList.selectAll()
      appDrugCCList.unSelectItem(exception)
      selectedItemsShouldBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models when model.attributes.molecule_chembl_id != exception)

      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()

      for item in selectedItemsShouldBe
        expect(selectedItemsGot).toContain(item)
        expect(appDrugCCList.itemIsSelected(item)).toBe(true)

      expect(selectedItemsGot).not.toContain(exception)
      expect(appDrugCCList.itemIsSelected(exception)).toBe(false)

    it "unselects all items, except one", ->

      exception = 'CHEMBL1152'
      appDrugCCList.unSelectAll()
      appDrugCCList.selectItem(exception)
      selectedItemsShouldNOTBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models when model.attributes.molecule_chembl_id != exception)

      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()
      for item in selectedItemsShouldNOTBe
        expect(selectedItemsGot).not.toContain(item)
        expect(appDrugCCList.itemIsSelected(item)).toBe(false)

      expect(selectedItemsGot).toContain(exception)
      expect(appDrugCCList.itemIsSelected(exception)).toBe(true)

    it "selects all items, then selects one item", ->

      appDrugCCList.selectAll()
      appDrugCCList.selectItem('CHEMBL1091')

      expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(true)
      selectedItemsShouldBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()

      for item in selectedItemsShouldBe
        expect(selectedItemsGot).toContain(item)
        expect(appDrugCCList.itemIsSelected(item)).toBe(true)

    it "unselects all items, then unselects one item", ->

      appDrugCCList.unSelectAll()
      appDrugCCList.unSelectItem('CHEMBL1091')

      expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(false)

      selectedItemsShouldNotBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()

      for item in selectedItemsShouldNotBe
        expect(selectedItemsGot).not.toContain(item)
        expect(appDrugCCList.itemIsSelected(item)).toBe(false)

    it 'toggles an unselected item', ->

      numToggles = 10
      for i in [1..10]
        appDrugCCList.toggleSelectItem('CHEMBL1091')
        if i%2 != 0
          expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(true)
        else
          expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(false)

    it 'toggles a selected item', ->

      numToggles = 10
      appDrugCCList.selectItem('CHEMBL1091')

      for i in [1..10]
        appDrugCCList.toggleSelectItem('CHEMBL1091')
        if i%2 != 0
          expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(false)
        else
          expect(appDrugCCList.itemIsSelected('CHEMBL1091')).toBe(true)

    it "goes to a select all state when all items are manually selected", ->

      allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      lastItemID = allItemsIDs[allItemsIDs.length - 1]
      allItemsIDsExceptLast = allItemsIDs[0..allItemsIDs.length - 2]

      for itemID in allItemsIDsExceptLast
        appDrugCCList.selectItem(itemID)

      expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)
      appDrugCCList.selectItem(lastItemID)
      expect(appDrugCCList.getMeta('all_items_selected')).toBe(true)

    it "goes to a unselect all state when all items are manually unselected", ->

      appDrugCCList.selectAll()
      allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      lastItemID = allItemsIDs[allItemsIDs.length - 1]
      allItemsIDsExceptLast = allItemsIDs[0..allItemsIDs.length - 2]

      for itemID in allItemsIDsExceptLast
        appDrugCCList.unSelectItem(itemID)

      expect(appDrugCCList.getMeta('all_items_selected')).toBe(true)
      appDrugCCList.unSelectItem(lastItemID)
      expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)

    it 'bulk selects a selection list with no items', ->

      itemsToSelect = []
      appDrugCCList.selectItems(itemsToSelect)
      expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)
      expect(appDrugCCList.thereAreExceptions()).toBe(false)

    it 'bulk selects a from a list of items to select', ->

      # the idea was to optimize it reversing the exceptions but it is still not feasible for server side collections
      allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      itemsToSelect = allItemsIDs[0..Math.floor(allItemsIDs.length / 2) - 1]
      appDrugCCList.selectItems(itemsToSelect)

      expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)
      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()

      for itemID in itemsToSelect
        expect(selectedItemsGot).toContain(itemID)
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)

    it 'goes to a select all state when all the items are in the selection lists', ->

      allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      itemsToSelectA = allItemsIDs[0..Math.floor(allItemsIDs.length / 2)]
      itemsToSelectB = allItemsIDs[Math.floor(allItemsIDs.length / 2)..allItemsIDs.length]

      appDrugCCList.selectItems(itemsToSelectA)
      appDrugCCList.selectItems(itemsToSelectB)

      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()
      expect(appDrugCCList.getMeta('all_items_selected')).toBe(true)
      expect(appDrugCCList.thereAreExceptions()).toBe(false)

      for itemID in itemsToSelectA
        expect(selectedItemsGot).toContain(itemID)
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)

      for itemID in itemsToSelectB
        expect(selectedItemsGot).toContain(itemID)
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)

    it 'bulk unselects a from a list of items to select', ->

      # the idea was to optimize it reversing the exceptions but it is still not feasible for server side collections
      appDrugCCList.selectAll()
      allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      itemsToUnSelect = allItemsIDs[0..Math.floor(allItemsIDs.length / 2) - 1]
      appDrugCCList.unSelectItems(itemsToUnSelect)

      expect(appDrugCCList.getMeta('all_items_selected')).toBe(true)
      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()

      for itemID in itemsToUnSelect
        expect(selectedItemsGot).not.toContain(itemID)
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)

    it 'bulk unselects a selection list with no items', ->

      itemsToUnSelect = []
      appDrugCCList.unSelectItems(itemsToUnSelect)
      expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)
      expect(appDrugCCList.thereAreExceptions()).toBe(false)

    it 'goes to a select none state when all the items are in the unselection lists', ->

      allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      itemsToUnSelectA = allItemsIDs[0..Math.floor(allItemsIDs.length / 2)]
      itemsToUnSelectB = allItemsIDs[Math.floor(allItemsIDs.length / 2)..allItemsIDs.length]

      appDrugCCList.unSelectItems(itemsToUnSelectA)
      appDrugCCList.unSelectItems(itemsToUnSelectB)

      selectedItemsGot = appDrugCCList.getSelectedItemsIDs()
      expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)
      expect(appDrugCCList.thereAreExceptions()).toBe(false)

      for itemID in itemsToUnSelectA
        expect(selectedItemsGot).not.toContain(itemID)
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)

      for itemID in itemsToUnSelectB
        expect(selectedItemsGot).not.toContain(itemID)
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)

    it 'accumulates previous selections (bulk selection)', ->

      allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)

      itemsToSelectA = allItemsIDs[0..4]
      itemsToSelectB = allItemsIDs[2..6]

      appDrugCCList.selectItems(itemsToSelectA)
      appDrugCCList.selectItems(itemsToSelectB)

      selectedItemsShouldBe = _.union(itemsToSelectA, itemsToSelectB)
      for itemID in selectedItemsShouldBe
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)

      appDrugCCList.unSelectAll()
      appDrugCCList.selectAll()
      appDrugCCList.selectItems(itemsToSelectA)
      for itemID in allItemsIDs
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)
      expect(appDrugCCList.getMeta('all_items_selected')).toBe(true)
      expect(appDrugCCList.thereAreExceptions()).toBe(false)

      # try to mess with the sate of the selections by selecting all except for a small set
      appDrugCCList.unSelectAll()
      appDrugCCList.selectAll()

      for itemID in itemsToSelectA
        appDrugCCList.unSelectItem(itemID)

      appDrugCCList.selectItems(itemsToSelectB)
      unSelectedItemsShouldBe = _.difference(itemsToSelectA, itemsToSelectB)
      selectedItemsShouldBe = _.difference(allItemsIDs, unSelectedItemsShouldBe)

      expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)
      expect(appDrugCCList.thereAreExceptions()).toBe(true)
      for itemID in unSelectedItemsShouldBe
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)
      for itemID in selectedItemsShouldBe
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)

    it 'reverses exceptions', ->

      allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
      itemsToSelect = allItemsIDs[0..4]
      unSelectedItems = _.difference(allItemsIDs, itemsToSelect)
      for itemID in itemsToSelect
        appDrugCCList.selectItem(itemID)

      appDrugCCList.reverseExceptions()
      exceptions = appDrugCCList.getMeta('selection_exceptions')
      for itemID in itemsToSelect
        expect(exceptions[itemID]?).toBe(false)
      for itemID in unSelectedItems
        expect(exceptions[itemID]?).toBe(true)

    it 'selects items based on a property value', ->

      propName = 'max_phase'
      propValue = 4

      selectedValuesShouldBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models \
        when glados.Utils.getNestedValue(model.attributes, propName) == propValue)
      selectedValuesShouldNotBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models \
        when glados.Utils.getNestedValue(model.attributes, propName) != propValue)

      appDrugCCList.selectByPropertyValue(propName, propValue)

      for itemID in selectedValuesShouldBe
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)

      for itemID in selectedValuesShouldNotBe
        expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)

#    it 'unselects items based on a property value', ->
#
#      propName = 'max_phase'
#      propValue = 4
#
#      selectedValuesShouldBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models \
#        when glados.Utils.getNestedValue(model.attributes, propName) != propValue)
#      selectedValuesShouldNotBe = (model.attributes.molecule_chembl_id for model in appDrugCCList.models \
#        when glados.Utils.getNestedValue(model.attributes, propName) == propValue)
#
#      appDrugCCList.unSelectByPropertyValue(propName, propValue)
#
#      for itemID in selectedValuesShouldBe
#        expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)
#
#      for itemID in selectedValuesShouldNotBe
#        expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)

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








