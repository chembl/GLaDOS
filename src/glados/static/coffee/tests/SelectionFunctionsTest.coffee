describe "Selection Functions", ->

  appDrugCCList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

  beforeAll (done) ->
    simulateDataWSClientList(appDrugCCList, glados.Settings.STATIC_URL + 'testData/WSCollectionTestData2.json', done)

  beforeEach ->
    appDrugCCList.unSelectAll()

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

  it 'gives the number of selected items after selecting none', ->

    expect(appDrugCCList.getNumberOfSelectedItems()).toBe(0)

  it 'gives the number of selected items after selecting some', ->

    allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
    itemsToSelect = allItemsIDs[0..5]

    for itemID in itemsToSelect
      appDrugCCList.selectItem(itemID)

    expect(appDrugCCList.getNumberOfSelectedItems()).toBe(itemsToSelect.length)

  it 'gives the number of selected items after selecting all', ->

    appDrugCCList.selectAll()
    expect(appDrugCCList.getNumberOfSelectedItems()).toBe(appDrugCCList.models.length)

  it 'gives the number of selected items after selecting all and then unselecting one', ->

    appDrugCCList.selectAll()
    allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
    [..., itemToSelect] = allItemsIDs
    appDrugCCList.unSelectItem(itemToSelect)
    expect(appDrugCCList.getNumberOfSelectedItems()).toBe(appDrugCCList.models.length - 1)

  it 'gives the number of selected items after unselecting some', ->

    appDrugCCList.selectAll()
    allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
    itemsToUnSelect = allItemsIDs[0..5]

    for itemID in itemsToUnSelect
      appDrugCCList.unSelectItem(itemID)

    expect(appDrugCCList.getNumberOfSelectedItems()).toBe(allItemsIDs.length - itemsToUnSelect.length)

  it 'gives the number of selected items after unselecting all', ->

    appDrugCCList.selectAll()
    appDrugCCList.unSelectAll()
    expect(appDrugCCList.getNumberOfSelectedItems()).toBe(0)

  it 'gives the number of selected items after unselecting all and then selecting one', ->

    appDrugCCList.selectAll()
    appDrugCCList.unSelectAll()

    allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)
    [..., itemToSelect] = allItemsIDs
    appDrugCCList.selectItem(itemToSelect)

    expect(appDrugCCList.getNumberOfSelectedItems()).toBe(1)


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

  it 'accumulates previous selections (bulk UNselection)', ->

    allItemsIDs = (model.attributes.molecule_chembl_id for model in appDrugCCList.models)

    itemsToUnSelectA = allItemsIDs[0..4]
    itemsToUnSelectB = allItemsIDs[2..6]

    appDrugCCList.selectAll()
    appDrugCCList.unSelectItems(itemsToUnSelectA)
    appDrugCCList.unSelectItems(itemsToUnSelectB)

    unSelectedItemsShouldBe = _.union(itemsToUnSelectA, itemsToUnSelectB)
    for itemID in unSelectedItemsShouldBe
      expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)

    appDrugCCList.selectAll()
    appDrugCCList.unSelectAll()
    appDrugCCList.unSelectItems(itemsToUnSelectA)
    for itemID in allItemsIDs
      expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)
    expect(appDrugCCList.getMeta('all_items_selected')).toBe(false)
    expect(appDrugCCList.thereAreExceptions()).toBe(false)

    # try to mess with the sate of the selections by selecting all except for a small set
    appDrugCCList.selectAll()
    appDrugCCList.unSelectAll()

    for itemID in itemsToUnSelectA
      appDrugCCList.selectItem(itemID)

    appDrugCCList.unSelectItems(itemsToUnSelectB)
    selectedItemsShouldBe = _.difference(itemsToUnSelectA, itemsToUnSelectB)
    unSelectedItemsShouldBe = _.difference(allItemsIDs, selectedItemsShouldBe)

    expect(appDrugCCList.getMeta('all_items_selected')).toBe(true)
    expect(appDrugCCList.thereAreExceptions()).toBe(true)
    for itemID in unSelectedItemsShouldBe
      expect(appDrugCCList.itemIsSelected(itemID)).toBe(false)
    for itemID in selectedItemsShouldBe
      expect(appDrugCCList.itemIsSelected(itemID)).toBe(true)

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

  # ------------------------------
  # Helpers
  # ------------------------------
  simulateDataWSClientList = (list, dataURL, done) ->
    $.get dataURL, (testData) ->
      list.reset(testData)
      done()