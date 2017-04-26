describe "Legend Model", ->

  describe "Categorical", ->

    # ------------------------------------------------------------------------------------------------------------------
    # Generic Test Functions
    # ------------------------------------------------------------------------------------------------------------------
    testInitialisesFromADefaultDomainAndTickValues = (legendModel) ->

      domain = legendModel.get('domain')
      ticks = legendModel.get('ticks')

      expect(domain[0]).toBe(glados.Settings.DEFAULT_NULL_VALUE_LABEL)
      i = 1
      while i < 6
        expect(domain[i]).toBe(i - 1)
        expect(ticks[i]).toBe(i - 1)
        i++

      expect(legendModel.get('type')).toBe(glados.models.visualisation.LegendModel.DISCRETE)
      range = legendModel.get('colour-range')
      rangeShouldBe = [glados.Settings.VISUALISATION_GREY_BASE, '#e3f2fd', '#90caf9', '#42a5f5', '#1976d2', '#0d47a1']

      for comparison in _.zip(range, rangeShouldBe)
        expect(comparison[0]).toBe(comparison[1])

    testInitialisesAmountOfItemsPerCategory = (legendModel) ->

      domain = legendModel.get('domain')
      collection = legendModel.get('collection')
      prop = legendModel.get('property')

      if collection.allResults?
        allItemsObjs = collection.allResults
      else
        allItemsObjs = (model.attributes for model in collection.models)

      amountsPerValueMustBe = {}
      for obj in allItemsObjs
        value = glados.Utils.getNestedValue(obj, prop.propName)
        if not amountsPerValueMustBe[value]?
          amountsPerValueMustBe[value] = 0
        amountsPerValueMustBe[value]++

      totalItemsGot = 0
      for value, amount of amountsPerValueMustBe
        expect(legendModel.getTextAmountPerValue(value)).toBe(amount)
        totalItemsGot += amount
      expect(totalItemsGot).toBe(collection.getMeta('total_records'))

    testSelectsAValue = (legendModel) ->

      value = 0
      legendModel.selectByPropertyValue(value)
      expect(legendModel.isValueSelected(value)).toBe(true)

    testUnselectsAValue = (legendModel) ->

      value = 0
      legendModel.unselectByPropertyValue(value)
      expect(legendModel.isValueSelected(value)).toBe(false)

    testTogglesAValueSelection = (legendModel) ->

      value = 0
      numToggles = 10
      for i in [1..numToggles]
        legendModel.toggleValueSelection(value)
        if i%2 != 0
          expect(legendModel.isValueSelected(value)).toBe(true)
        else
          expect(legendModel.isValueSelected(value)).toBe(false)

    testUnselectsAllValues = (legendModel) ->

      legendModel.unSelectAllValues()
      domain = legendModel.get('domain')
      for value in domain
        expect(legendModel.isValueSelected(value)).toBe(false)

    testSelectsAllValues = (legendModel) ->

      legendModel.selectAllValues()
      domain = legendModel.get('domain')
      for value in domain
        expect(legendModel.isValueSelected(value)).toBe(true)

    # ------------------------------------------------------------------------------------------------------------------
    # Actual tests
    # ------------------------------------------------------------------------------------------------------------------
    describe "with a client side collection", ->

      prop = undefined
      legendModel = undefined
      collection = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

      beforeAll (done) ->
         TestsUtils.simulateDataWSClientList(
           collection, glados.Settings.STATIC_URL + 'testData/SearchResultsDopamineTestData.json', done)

      beforeEach ->

        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
        legendModel = new glados.models.visualisation.LegendModel
          property: prop
          collection: collection

      it 'initialises from a default domain and tick values', ->
        testInitialisesFromADefaultDomainAndTickValues(legendModel)
      it 'initialises the amount of items per category', -> testInitialisesAmountOfItemsPerCategory(legendModel)
      it 'selects a value', -> testSelectsAValue(legendModel)
      it 'unselects a value', -> testUnselectsAValue(legendModel)
      it 'toggles a value selection', -> testTogglesAValueSelection(legendModel)
      it 'unselects all values', -> testUnselectsAllValues(legendModel)
      it 'selects all values', -> testSelectsAllValues(legendModel)

    describe "with an elasticsearch collection", ->

      prop = undefined
      legendModel = undefined
      collection = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFor(
        glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND
      )

      beforeAll (done) ->
        TestsUtils.simulateDataESList(collection,
          glados.Settings.STATIC_URL + 'testData/SearchResultsAspirinTestData.json', done)

      beforeEach ->

        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
        legendModel = new glados.models.visualisation.LegendModel
          property: prop
          collection: collection

      it 'initialises from a default domain and tick values', ->
        testInitialisesFromADefaultDomainAndTickValues(legendModel)
      it 'initialises the amount of items per category', -> testInitialisesAmountOfItemsPerCategory(legendModel)
      it 'selects a value', -> testSelectsAValue(legendModel)
      it 'unselects a value', -> testUnselectsAValue(legendModel)
      it 'toggles a value selection', -> testTogglesAValueSelection(legendModel)
      it 'unselects all values', -> testUnselectsAllValues(legendModel)
      it 'selects all values', -> testSelectsAllValues(legendModel)