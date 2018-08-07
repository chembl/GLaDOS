describe "Paginated Collections", ->

  describe "Links to other entities", ->

    # ------------------------------------------------------------------------------------------------------------------
    # Utils
    # ------------------------------------------------------------------------------------------------------------------
    getLinkMustBe = (destinationEntityName, filter) ->

      if destinationEntityName == Activity.prototype.entityName
        return Activity.getActivitiesListURL(filter)
      else if destinationEntityName == Compound.prototype.entityName
        return Compound.getCompoundsListURL(filter)
      else if destinationEntityName == Target.prototype.entityName
        return Target.getTargetsListURL(filter)
      else if destinationEntityName == Document.prototype.entityName
        return Document.getDocumentsListURL(filter)
      else if destinationEntityName == Assay.prototype.entityName
        return Assay.getAssaysListURL(filter)
      else if destinationEntityName == CellLine.prototype.entityName
        return CellLine.getCellsListURL(filter)
      else if destinationEntityName == glados.models.Tissue.prototype.entityName
        return glados.models.Tissue.getTissuesListURL(filter)

    getFilterMustBe = (destinationEntityName, selectedItems, list) ->

      sourceEntityName = list.getMeta('model').prototype.entityName
      idsList = selectedItems

      if sourceEntityName == Activity.prototype.entityName
        idsList = []
        if destinationEntityName == Compound.prototype.entityName
          for id in selectedItems
            selectedModel = list.get(id)
            idsList.push(selectedModel.get('molecule_chembl_id'))

      return glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
        .ENTITY_NAME_TO_FILTER_GENERATOR[sourceEntityName][destinationEntityName]
          ids: idsList
    # ------------------------------------------------------------------------------------------------------------------
    # Generic test functions
    # ------------------------------------------------------------------------------------------------------------------
    testLinkGenerationAfterSelectingOneItem = (list, destinationEntityName, done) ->

      console.log 'testLinkGenerationAfterSelectingOneItem'
      allItemsIDs = TestsUtils.getAllItemsIDs(list, list.getIDProperty())
      console.log 'allItemsIDs: ', allItemsIDs
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)
      filterMustBe = getFilterMustBe(destinationEntityName, [itemToSelect], list)
      linkToActsMustBe = getLinkMustBe(destinationEntityName, filterMustBe)

      linkToOtherEntitiesPromise.then (linkGot) ->

        expect(linkGot).toBe(linkToActsMustBe)
        done()

    testLinkGenerationAfterSelectingMultipleItems = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list, list.getIDProperty())
      itemsToSelect = allItemsIDs[0..(allItemsIDs.length - 1)]
      list.selectItems(itemsToSelect)

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)
      filterMustBe = getFilterMustBe(destinationEntityName, itemsToSelect, list)
      linkToActsMustBe = getLinkMustBe(destinationEntityName, filterMustBe)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkToActsMustBe).toBe(linkGot)
        done()

    testLinkGenerationAfterSelectingAllItems = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list, list.getIDProperty())
      list.selectAll()

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)
      filterToActsMustBe = getFilterMustBe(destinationEntityName, allItemsIDs, list)
      linkToActsMustBe = getLinkMustBe(destinationEntityName, filterToActsMustBe)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkToActsMustBe).toBe(linkGot)
        done()

    testLinkGenerationAfterSelectingNoItems = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list, list.getIDProperty())
      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)
      filterToActsMustBe = getFilterMustBe(destinationEntityName, allItemsIDs, list)
      linkToActsMustBe = getLinkMustBe(destinationEntityName, filterToActsMustBe)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkGot).toBe(linkToActsMustBe)
        done()

    testLinksCacheIsSet = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)

      cache = list.getMeta(list.LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName])
      expect(cache?).toBe(false)

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      linkToOtherEntitiesPromise.then (linkGot) ->
        cache = list.getMeta(list.LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName])
        expect(cache).toBe(linkGot)
        done()

    testLinksCacheIsUsed = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)

      cachePropName = list.LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName]

      cacheMustBe = 'We do what we must, Because we can.'
      list.setMeta(cachePropName, cacheMustBe)

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      linkToOtherEntitiesPromise.then (linkGot) ->
        expect(linkGot).toBe(cacheMustBe)
        done()

    testResetsCacheIsReset = (list, destinationEntityName, done) ->

      allItemsIDs = TestsUtils.getAllItemsIDs(list)
      itemToSelect = allItemsIDs[0]
      list.selectItem(itemToSelect)
      cachePropName = list.LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName]

      linkToOtherEntitiesPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

      linkToOtherEntitiesPromise.then (linkGot) ->

        #the cache must be as expected
        cache = list.getMeta(cachePropName)
        expect(cache).toBe(linkGot)

        #now I selecct another item
        itemToSelect2 = allItemsIDs[1]
        list.selectItem(itemToSelect2)
        cache = list.getMeta(cachePropName)
        #cache must be undefined
        expect(cache?).toBe(false)

        linkToActPromise = list.getLinkToRelatedEntitiesPromise(destinationEntityName)
        linkToActPromise.then (linkGot) ->

          linkToActPromise2 = list.getLinkToRelatedEntitiesPromise(destinationEntityName)

          linkToActPromise2.then (linkGot2) ->

            sourceEntityName = list.getMeta('model').prototype.entityName
            filterToActsMustBe = glados.models.paginatedCollections.PaginatedCollectionBase.prototype\
            .ENTITY_NAME_TO_FILTER_GENERATOR[sourceEntityName][destinationEntityName]
              ids: [itemToSelect, itemToSelect2]

            linkToActsMustBe = getLinkMustBe(destinationEntityName, filterToActsMustBe)

            #the link new link must be correct
            expect(linkToActsMustBe).toBe(linkGot2)
            done()

    # ------------------------------------------------------------------------------------------------------------------
    # test cases
    # ------------------------------------------------------------------------------------------------------------------
    describe "Links to all activities from compound", ->

      list = undefined

      beforeAll (done) ->

        list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
          glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
        )

        TestsUtils.simulateDataESList(list,
          glados.Settings.STATIC_URL + 'testData/WSCollectionTestData2.json', done)

      beforeEach ->
        list.unSelectAll()

      it 'produces the link after selecting one item', (done) -> testLinkGenerationAfterSelectingOneItem(list,
        Activity.prototype.entityName, done)
      it 'produces the link after selecting multiple items', (done) ->
        testLinkGenerationAfterSelectingMultipleItems(list, Activity.prototype.entityName, done)
      it 'produces the link after selecting all items', (done) ->
        testLinkGenerationAfterSelectingAllItems(list, Activity.prototype.entityName, done)
      it 'produces the link after selecting no items', (done) ->
        testLinkGenerationAfterSelectingNoItems(list, Activity.prototype.entityName, done)
      it 'sets the link cache', (done) -> testLinksCacheIsSet(list, Activity.prototype.entityName, done)
      it 'uses the link cache', (done) -> testLinksCacheIsUsed(list, Activity.prototype.entityName, done)
      it 'resets the link cache', (done) -> testResetsCacheIsReset(list, Activity.prototype.entityName, done)

    describe "Links to all compounds from activities", ->

      list = undefined

      beforeAll (done) ->

        list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
          glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.ACTIVITY
        )

        TestsUtils.simulateDataESList(list,
          glados.Settings.STATIC_URL + 'testData/Activity/activitySamplePagColl.json', done)


      beforeEach ->
        list.unSelectAll()

      # ------------------------------------------------------------------------------------------------------------------
      # tes links for all the possible entities
      # ------------------------------------------------------------------------------------------------------------------
      it 'produces the link after selecting one item', (done) -> testLinkGenerationAfterSelectingOneItem(list,
        Compound.prototype.entityName, done)
      it 'produces the link after selecting multiple items', (done) ->
        testLinkGenerationAfterSelectingMultipleItems(list, Compound.prototype.entityName, done)
      it 'produces the link after selecting all items', (done) ->
        testLinkGenerationAfterSelectingAllItems(list, Compound.prototype.entityName, done)
      it 'produces the link after selecting no items', (done) ->
        testLinkGenerationAfterSelectingNoItems(list, Compound.prototype.entityName, done)
