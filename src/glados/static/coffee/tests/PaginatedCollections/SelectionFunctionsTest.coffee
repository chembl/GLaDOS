describe "Paginated Collections", ->

  describe "Selection Functions", ->

    # -------------------------------------------------------------------------------------------------
    # Generic Test Functions
    # -------------------------------------------------------------------------------------------------

    testSelectsOneItem = (list) ->
      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      itemNotSelected = allItemsIDs[1]

      list.selectItem(itemToSelect)
      expect(list.itemIsSelected(itemToSelect)).toBe(true)
      expect(list.itemIsSelected(itemNotSelected)).toBe(false)
      expect(list.getItemsIDs()).toContain(itemToSelect)

    testSelectsAllItems = (list) ->
      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      list.selectAll()
      selectedItemsShouldBe = allItemsIDs
      selectedItemsGot = list.getItemsIDs()

      for item in selectedItemsShouldBe
        expect(selectedItemsGot).toContain(item)
        expect(list.itemIsSelected(item)).toBe(true)

    testUnselectsOneItem = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToUnselect = allItemsIDs[0]

      list.unSelectItem(itemToUnselect)
      expect(list.itemIsSelected(itemToUnselect)).toBe(false)
      expect(list.getItemsIDs()).not.toContain(itemToUnselect)

    testUnselectsAllItems = (list) ->
      allItemsIDs = TestsUtils.getAllItemsIDs(list)

      list.unSelectAll()
      selectedItemsShouldNotBe = allItemsIDs
      selectedItemsGot = list.getItemsIDs()

      for item in selectedItemsShouldNotBe
        expect(selectedItemsGot).not.toContain(item)
        expect(list.itemIsSelected(item)).toBe(false)

    testGivesNumberOfSelectedItemsAfterSelectingNone = (list) ->
      expect(list.getNumberOfSelectedItems()).toBe(0)

    testGivesNumberOfSelectedItemsAfterSelectingSome = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemsToSelect = allItemsIDs[0..5]

      for itemID in itemsToSelect
        list.selectItem(itemID)

      expect(list.getNumberOfSelectedItems()).toBe(itemsToSelect.length)

    testGivesNumberOfSelectedItemsAfterSelectingAll = (list) ->
      list.selectAll()
      expect(list.getNumberOfSelectedItems()).toBe(list.getMeta('total_records'))

    testGivesNumberOfSelectedItemsAfterSelectingAllAndThenUnselectingOne = (list) ->
      list.selectAll()
      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      [..., itemToSelect] = allItemsIDs
      list.unSelectItem(itemToSelect)
      expect(list.getNumberOfSelectedItems()).toBe(list.getMeta('total_records') - 1)

    testGivesNumberOfSelectedItemsAfterUnselectingSome = (list) ->
      list.selectAll()
      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemsToUnSelect = allItemsIDs[0..5]

      for itemID in itemsToUnSelect
        list.unSelectItem(itemID)

      expect(list.getNumberOfSelectedItems()).toBe(allItemsIDs.length - itemsToUnSelect.length)

    testGivesNumberOfSelectedItemsAfterUnselectingAll = (list) ->

      list.selectAll()
      list.unSelectAll()
      expect(list.getNumberOfSelectedItems()).toBe(0)

    testGivesNumberOfSelectedItemsAfterUnselectingAllAndThenSelectingOne = (list) ->

      list.selectAll()
      list.unSelectAll()

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      [..., itemToSelect] = allItemsIDs
      list.selectItem(itemToSelect)

      expect(list.getNumberOfSelectedItems()).toBe(1)

    testSelectsAllItemsExceptOne = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)

      [..., exception] = allItemsIDs
      list.selectAll()
      list.unSelectItem(exception)

      if list.allResults?
        selectedItemsShouldBe = (model.molecule_chembl_id for model in list.allResults\
          when model.molecule_chembl_id != exception)
      else
        selectedItemsShouldBe = (model.attributes.molecule_chembl_id for model in list.models\
          when model.attributes.molecule_chembl_id != exception)

      selectedItemsGot = list.getItemsIDs()

      for item in selectedItemsShouldBe
        expect(selectedItemsGot).toContain(item)
        expect(list.itemIsSelected(item)).toBe(true)

      expect(selectedItemsGot).not.toContain(exception)
      expect(list.itemIsSelected(exception)).toBe(false)

    testUnselectsAllItemsExceptOne = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)

      [..., exception] = allItemsIDs
      list.unSelectAll()
      list.selectItem(exception)

      if list.allResults?
        selectedItemsShouldNOTBe = (model.molecule_chembl_id for model in list.allResults\
          when model.molecule_chembl_id != exception)
      else
        selectedItemsShouldNOTBe = (model.attributes.molecule_chembl_id for model in list.models\
          when model.attributes.molecule_chembl_id != exception)

      selectedItemsGot = list.getItemsIDs()
      for item in selectedItemsShouldNOTBe
        expect(selectedItemsGot).not.toContain(item)
        expect(list.itemIsSelected(item)).toBe(false)

      expect(selectedItemsGot).toContain(exception)
      expect(list.itemIsSelected(exception)).toBe(true)

    testSelectsAllItemsThenSelectsOneItem = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectAll()
      list.selectItem(allItemsIDs)

      expect(list.itemIsSelected(allItemsIDs)).toBe(true)
      selectedItemsShouldBe = allItemsIDs
      selectedItemsGot = list.getItemsIDs()

      for item in selectedItemsShouldBe
        expect(selectedItemsGot).toContain(item)
        expect(list.itemIsSelected(item)).toBe(true)

    testUnselectsAllItemsThenUnselectsOneItem = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToUnselect = allItemsIDs[0]
      list.unSelectAll()
      list.unSelectItem(itemToUnselect)

      expect(list.itemIsSelected(itemToUnselect)).toBe(false)

      selectedItemsShouldNotBe = allItemsIDs
      selectedItemsGot = list.getItemsIDs()

      for item in selectedItemsShouldNotBe
        expect(selectedItemsGot).not.toContain(item)
        expect(list.itemIsSelected(item)).toBe(false)

    testTogglesAnUnselectedItem = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToToggle = allItemsIDs[0]

      numToggles = 10
      for i in [1..numToggles]
        list.toggleSelectItem(itemToToggle)
        if i%2 != 0
          expect(list.itemIsSelected(itemToToggle)).toBe(true)
        else
          expect(list.itemIsSelected(itemToToggle)).toBe(false)

    testTogglesASelectedItem = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToToggle = allItemsIDs[0]

      numToggles = 10
      list.selectItem(itemToToggle)

      for i in [1..numToggles]
        list.toggleSelectItem(itemToToggle)
        if i%2 != 0
          expect(list.itemIsSelected(itemToToggle)).toBe(false)
        else
          expect(list.itemIsSelected(itemToToggle)).toBe(true)

    testGoesToASelectAllStateWhenAllItemsAreManuallySelected = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      lastItemID = allItemsIDs[allItemsIDs.length - 1]
      allItemsIDsExceptLast = allItemsIDs[0..allItemsIDs.length - 2]

      for itemID in allItemsIDsExceptLast
        list.selectItem(itemID)

      expect(list.getMeta('all_items_selected')).toBe(false)
      list.selectItem(lastItemID)
      expect(list.getMeta('all_items_selected')).toBe(true)

    testGoesToAUnselectAllStateWhenAllItemsAreManuallyUnselected = (list) ->

      list.selectAll()
      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      lastItemID = allItemsIDs[allItemsIDs.length - 1]
      allItemsIDsExceptLast = allItemsIDs[0..allItemsIDs.length - 2]

      for itemID in allItemsIDsExceptLast
        list.unSelectItem(itemID)

      expect(list.getMeta('all_items_selected')).toBe(true)
      list.unSelectItem(lastItemID)
      expect(list.getMeta('all_items_selected')).toBe(false)

    testBulkSelectsFromASelectionListWithNoItems = (list) ->

      itemsToSelect = []
      list.selectItems(itemsToSelect)
      expect(list.getMeta('all_items_selected')).toBe(false)
      expect(list.thereAreExceptions()).toBe(false)

    testBulkSelectsFromAListOfItemsToSelect = (list) ->

      # the idea was to optimize it reversing the exceptions but it is still not feasible for server side collections
      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemsToSelect = allItemsIDs[0..Math.floor(allItemsIDs.length / 2) - 1]
      list.selectItems(itemsToSelect)

      expect(list.getMeta('all_items_selected')).toBe(false)
      selectedItemsGot = list.getItemsIDs()

      for itemID in itemsToSelect
        expect(selectedItemsGot).toContain(itemID)
        expect(list.itemIsSelected(itemID)).toBe(true)

    testGoesToASelectAllStateWhenAllTheItemsAreInTheSelectionLists = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemsToSelectA = allItemsIDs[0..Math.floor(allItemsIDs.length / 2)]
      itemsToSelectB = allItemsIDs[Math.floor(allItemsIDs.length / 2)..allItemsIDs.length]

      list.selectItems(itemsToSelectA)
      list.selectItems(itemsToSelectB)

      selectedItemsGot = list.getItemsIDs()
      expect(list.getMeta('all_items_selected')).toBe(true)
      expect(list.thereAreExceptions()).toBe(false)

      for itemID in itemsToSelectA
        expect(selectedItemsGot).toContain(itemID)
        expect(list.itemIsSelected(itemID)).toBe(true)

      for itemID in itemsToSelectB
        expect(selectedItemsGot).toContain(itemID)
        expect(list.itemIsSelected(itemID)).toBe(true)

    testUnselectsFromAListOfItemsToUnselect = (list) ->

      # the idea was to optimize it reversing the exceptions but it is still not feasible for server side collections
      list.selectAll()
      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemsToUnSelect = allItemsIDs[0..Math.floor(allItemsIDs.length / 2) - 1]
      list.unSelectItems(itemsToUnSelect)

      expect(list.getMeta('all_items_selected')).toBe(true)
      selectedItemsGot = list.getItemsIDs()

      for itemID in itemsToUnSelect
        expect(selectedItemsGot).not.toContain(itemID)
        expect(list.itemIsSelected(itemID)).toBe(false)

    testUnselectsASelectionListWithNoItems = (list) ->

      itemsToUnSelect = []
      list.unSelectItems(itemsToUnSelect)
      expect(list.getMeta('all_items_selected')).toBe(false)
      expect(list.thereAreExceptions()).toBe(false)

    testGoesToASelectNoneStateWhenAllTheItemsAreInTheUnselectionLists = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemsToUnSelectA = allItemsIDs[0..Math.floor(allItemsIDs.length / 2)]
      itemsToUnSelectB = allItemsIDs[Math.floor(allItemsIDs.length / 2)..allItemsIDs.length]

      list.unSelectItems(itemsToUnSelectA)
      list.unSelectItems(itemsToUnSelectB)

      expect(list.getMeta('all_items_selected')).toBe(false)
      expect(list.thereAreExceptions()).toBe(false)

    testReversesExceptions = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemsToSelect = allItemsIDs[0..4]
      unSelectedItems = _.difference(allItemsIDs, itemsToSelect)
      for itemID in itemsToSelect
        list.selectItem(itemID)

      list.reverseExceptions()
      exceptions = list.getMeta('selection_exceptions')
      for itemID in itemsToSelect
        expect(exceptions[itemID]?).toBe(false)
      for itemID in unSelectedItems
        expect(exceptions[itemID]?).toBe(true)

    testAccumulatesPreviousSelectionsForSelections = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)

      itemsToSelectA = allItemsIDs[0..4]
      itemsToSelectB = allItemsIDs[2..6]

      list.selectItems(itemsToSelectA)
      list.selectItems(itemsToSelectB)

      selectedItemsShouldBe = _.union(itemsToSelectA, itemsToSelectB)
      for itemID in selectedItemsShouldBe
        expect(list.itemIsSelected(itemID)).toBe(true)

      list.unSelectAll()
      list.selectAll()
      list.selectItems(itemsToSelectA)
      for itemID in allItemsIDs
        expect(list.itemIsSelected(itemID)).toBe(true)
      expect(list.getMeta('all_items_selected')).toBe(true)
      expect(list.thereAreExceptions()).toBe(false)

      # try to mess with the sate of the selections by selecting all except for a small set
      list.unSelectAll()
      list.selectAll()

      for itemID in itemsToSelectA
        list.unSelectItem(itemID)

      list.selectItems(itemsToSelectB)
      unSelectedItemsShouldBe = _.difference(itemsToSelectA, itemsToSelectB)
      selectedItemsShouldBe = _.difference(allItemsIDs, unSelectedItemsShouldBe)

      expect(list.getMeta('all_items_selected')).toBe(false)
      expect(list.thereAreExceptions()).toBe(true)
      for itemID in unSelectedItemsShouldBe
        expect(list.itemIsSelected(itemID)).toBe(false)
      for itemID in selectedItemsShouldBe
        expect(list.itemIsSelected(itemID)).toBe(true)

    testAccumulatesPreviousSelectionsForUnselections = (list) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)

      itemsToUnSelectA = allItemsIDs[0..4]
      itemsToUnSelectB = allItemsIDs[2..6]

      list.selectAll()
      list.unSelectItems(itemsToUnSelectA)
      list.unSelectItems(itemsToUnSelectB)

      unSelectedItemsShouldBe = _.union(itemsToUnSelectA, itemsToUnSelectB)
      for itemID in unSelectedItemsShouldBe
        expect(list.itemIsSelected(itemID)).toBe(false)

      list.selectAll()
      list.unSelectAll()
      list.unSelectItems(itemsToUnSelectA)
      for itemID in allItemsIDs
        expect(list.itemIsSelected(itemID)).toBe(false)
      expect(list.getMeta('all_items_selected')).toBe(false)
      expect(list.thereAreExceptions()).toBe(false)

      # try to mess with the sate of the selections by selecting all except for a small set
      list.selectAll()
      list.unSelectAll()

      for itemID in itemsToUnSelectA
        list.selectItem(itemID)

      list.unSelectItems(itemsToUnSelectB)
      selectedItemsShouldBe = _.difference(itemsToUnSelectA, itemsToUnSelectB)
      unSelectedItemsShouldBe = _.difference(allItemsIDs, selectedItemsShouldBe)

      expect(list.getMeta('all_items_selected')).toBe(true)
      expect(list.thereAreExceptions()).toBe(true)
      for itemID in unSelectedItemsShouldBe
        expect(list.itemIsSelected(itemID)).toBe(false)
      for itemID in selectedItemsShouldBe
        expect(list.itemIsSelected(itemID)).toBe(true)

    testSelectsItemsBasedOnAPropertyValue = (list) ->

      propName = 'max_phase'
      propValue = 4

      if list.allResults?
        selectedValuesShouldBe = (model.molecule_chembl_id for model in list.allResults \
          when glados.Utils.getNestedValue(model, propName) == propValue)
        selectedValuesShouldNotBe = (model.molecule_chembl_id for model in list.allResults \
          when glados.Utils.getNestedValue(model, propName) != propValue)
      else
        selectedValuesShouldBe = (model.attributes.molecule_chembl_id for model in list.models \
          when glados.Utils.getNestedValue(model.attributes, propName) == propValue)
        selectedValuesShouldNotBe = (model.attributes.molecule_chembl_id for model in list.models \
          when glados.Utils.getNestedValue(model.attributes, propName) != propValue)

      list.selectByPropertyValue(propName, propValue)

      for itemID in selectedValuesShouldBe
        expect(list.itemIsSelected(itemID)).toBe(true)

      for itemID in selectedValuesShouldNotBe
        expect(list.itemIsSelected(itemID)).toBe(false)

    testUnselectsItemsBasedOnAPropertyValue = (list) ->

      list.selectAll()
      propName = 'max_phase'
      propValue = 4

      if list.allResults?
        unselectedValuesShouldBe = (model.molecule_chembl_id for model in list.allResults \
          when glados.Utils.getNestedValue(model, propName) == propValue)
        unselectedValuesShouldNotBe = (model.molecule_chembl_id for model in list.allResults \
          when glados.Utils.getNestedValue(model, propName) != propValue)
      else
        unselectedValuesShouldBe = (model.attributes.molecule_chembl_id for model in list.models \
          when glados.Utils.getNestedValue(model.attributes, propName) == propValue)
        unselectedValuesShouldNotBe = (model.attributes.molecule_chembl_id for model in list.models \
          when glados.Utils.getNestedValue(model.attributes, propName) != propValue)

      list.unselectByPropertyValue(propName, propValue)

      for itemID in unselectedValuesShouldBe
        expect(list.itemIsSelected(itemID)).toBe(false)

      for itemID in unselectedValuesShouldNotBe
        expect(list.itemIsSelected(itemID)).toBe(true)

    testSelectItemsByRange = (list) ->

      propName = 'full_mwt'
      allResults = if list.allResults? then list.allResults else (model.attributes for model in list.models)
      allResults = _.sortBy(allResults, (item) -> parseFloat(item[propName]))

      rangeStart = Math.round(allResults.length * 0.25)
      rangeEnd = Math.round(allResults.length * 0.75)
      minValue = allResults[rangeStart][propName]
      maxValue = allResults[rangeEnd][propName]

      selectedItemsShouldBe = (model.molecule_chembl_id for model in allResults[rangeStart..rangeEnd])
      selectedItemsShouldNotBe = (model.molecule_chembl_id for model in \
         _.union(allResults[0..rangeStart-1], allResults[rangeEnd+1..allResults.length-1]))

      list.selectByPropertyRange(propName, minValue, maxValue)

      for itemID in selectedItemsShouldBe
        expect(list.itemIsSelected(itemID)).toBe(true)

      for itemID in selectedItemsShouldNotBe
        expect(list.itemIsSelected(itemID)).toBe(false)
    # -------------------------------------------------------------------------------------------------
    # Actual Tests
    # -------------------------------------------------------------------------------------------------
    describe "Client Side Collections", ->

      list = glados.models.paginatedCollections\
      .PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

      beforeAll (done) ->
        TestsUtils.simulateDataWSClientList(list,
          glados.Settings.STATIC_URL + 'testData/WSCollectionTestData2.json', done)

      beforeEach ->
        list.unSelectAll()

      it "selects one item", -> testSelectsOneItem(list)
      it "selects all items", -> testSelectsAllItems(list)
      it "unselects one item", -> testUnselectsOneItem(list)
      it "unselects all items", -> testUnselectsAllItems(list)
      it 'gives the number of selected items after selecting none', ->
        testGivesNumberOfSelectedItemsAfterSelectingNone(list)
      it 'gives the number of selected items after selecting some', ->
        testGivesNumberOfSelectedItemsAfterSelectingSome(list)
      it 'gives the number of selected items after selecting all', ->
        testGivesNumberOfSelectedItemsAfterSelectingAll(list)
      it 'gives the number of selected items after selecting all and then unselecting one', ->
        testGivesNumberOfSelectedItemsAfterSelectingAllAndThenUnselectingOne(list)
      it 'gives the number of selected items after unselecting some', ->
        testGivesNumberOfSelectedItemsAfterUnselectingSome(list)
      it 'gives the number of selected items after unselecting all', ->
        testGivesNumberOfSelectedItemsAfterUnselectingAll(list)
      it 'gives the number of selected items after unselecting all and then selecting one', ->
        testGivesNumberOfSelectedItemsAfterUnselectingAllAndThenSelectingOne(list)
      it "selects all items, except one", -> testSelectsAllItemsExceptOne(list)
      it "unselects all items, except one", -> testUnselectsAllItemsExceptOne(list)
      it "selects all items, then selects one item", -> testSelectsAllItemsThenSelectsOneItem(list)
      it "unselects all items, then unselects one item", -> testUnselectsAllItemsThenUnselectsOneItem(list)
      it 'toggles an unselected item', -> testTogglesAnUnselectedItem(list)
      it 'toggles a selected item', -> testTogglesASelectedItem(list)
      it "goes to a select all state when all items are manually selected", ->
        testGoesToASelectAllStateWhenAllItemsAreManuallySelected(list)
      it "goes to a unselect all state when all items are manually unselected", ->
        testGoesToAUnselectAllStateWhenAllItemsAreManuallyUnselected(list)
      it 'bulk selects a selection list with no items', -> testBulkSelectsFromASelectionListWithNoItems(list)
      it 'bulk selects a from a list of items to select', -> testBulkSelectsFromAListOfItemsToSelect(list)
      it 'goes to a select all state when all the items are in the selection lists', ->
        testGoesToASelectAllStateWhenAllTheItemsAreInTheSelectionLists(list)
      it 'bulk unselects a from a list of items to select', -> testUnselectsFromAListOfItemsToUnselect(list)
      it 'bulk unselects a selection list with no items', -> testUnselectsASelectionListWithNoItems(list)
      it 'goes to a select none state when all the items are in the unselection lists', ->
        testGoesToASelectNoneStateWhenAllTheItemsAreInTheUnselectionLists(list)
      it 'reverses exceptions', -> testReversesExceptions(list)
      it 'accumulates previous selections (bulk selection)', ->
        testAccumulatesPreviousSelectionsForSelections(list)
      it 'accumulates previous selections (bulk UNselection)', ->
        testAccumulatesPreviousSelectionsForUnselections(list)
      it 'selects items based on a property value', -> testSelectsItemsBasedOnAPropertyValue(list)
      it 'unselects items based on a property value', -> testUnselectsItemsBasedOnAPropertyValue(list)
      it 'selects items based on a property range', -> testSelectItemsByRange(list)

    describe 'Elasticsearch Results Collections', ->

      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
        glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
      )

      beforeAll (done) ->
        TestsUtils.simulateDataESList(list,
          glados.Settings.STATIC_URL + 'testData/WSCollectionTestData2.json', done)

      beforeEach ->
        list.unSelectAll()

      it "selects one item", -> testSelectsOneItem(list)
      it "selects all items", -> testSelectsAllItems(list)
      it "unselects one item", -> testUnselectsOneItem(list)
      it "unselects all items", -> testUnselectsAllItems(list)
      it 'gives the number of selected items after selecting none', ->
        testGivesNumberOfSelectedItemsAfterSelectingNone(list)
      it 'gives the number of selected items after selecting some', ->
        testGivesNumberOfSelectedItemsAfterSelectingSome(list)
      it 'gives the number of selected items after selecting all', ->
        testGivesNumberOfSelectedItemsAfterSelectingAll(list)
      it 'gives the number of selected items after selecting all and then unselecting one', ->
        testGivesNumberOfSelectedItemsAfterSelectingAllAndThenUnselectingOne(list)
      it 'gives the number of selected items after unselecting some', ->
        testGivesNumberOfSelectedItemsAfterUnselectingSome(list)
      it 'gives the number of selected items after unselecting all', ->
        testGivesNumberOfSelectedItemsAfterUnselectingAll(list)
      it 'gives the number of selected items after unselecting all and then selecting one', ->
        testGivesNumberOfSelectedItemsAfterUnselectingAllAndThenSelectingOne(list)
      it "selects all items, except one", -> testSelectsAllItemsExceptOne(list)
      it "unselects all items, except one", -> testUnselectsAllItemsExceptOne(list)
      it "selects all items, then selects one item", -> testSelectsAllItemsThenSelectsOneItem(list)
      it "unselects all items, then unselects one item", -> testUnselectsAllItemsThenUnselectsOneItem(list)
      it 'toggles an unselected item', -> testTogglesAnUnselectedItem(list)
      it 'toggles a selected item', -> testTogglesASelectedItem(list)
      it "goes to a select all state when all items are manually selected", ->
        testGoesToASelectAllStateWhenAllItemsAreManuallySelected(list)
      it "goes to a unselect all state when all items are manually unselected", ->
        testGoesToAUnselectAllStateWhenAllItemsAreManuallyUnselected(list)
      it 'bulk selects a selection list with no items', -> testBulkSelectsFromASelectionListWithNoItems(list)
      it 'bulk selects a from a list of items to select', -> testBulkSelectsFromAListOfItemsToSelect(list)
      it 'goes to a select all state when all the items are in the selection lists', ->
        testGoesToASelectAllStateWhenAllTheItemsAreInTheSelectionLists(list)
      it 'bulk unselects a from a list of items to select', -> testUnselectsFromAListOfItemsToUnselect(list)
      it 'bulk unselects a selection list with no items', -> testUnselectsASelectionListWithNoItems(list)
      it 'goes to a select none state when all the items are in the unselection lists', ->
        testGoesToASelectNoneStateWhenAllTheItemsAreInTheUnselectionLists(list)
      it 'reverses exceptions', -> testReversesExceptions(list)
      it 'accumulates previous selections (bulk selection)', ->
        testAccumulatesPreviousSelectionsForSelections(list)
      it 'accumulates previous selections (bulk UNselection)', ->
        testAccumulatesPreviousSelectionsForUnselections(list)
      it 'selects items based on a property value', -> testSelectsItemsBasedOnAPropertyValue(list)
      it 'unselects items based on a property value', -> testUnselectsItemsBasedOnAPropertyValue(list)
      it 'selects items based on a property range', -> testSelectItemsByRange(list)
