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
      rangeShouldBe = [
            glados.Settings.VISUALISATION_GRID_NO_DATA,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL2,
            glados.Settings.VIS_COLORS.TEAL1
          ]
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
      collection = glados.models.paginatedCollections\
        .PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

      beforeAll (done) ->
         TestsUtils.simulateDataWSClientList(
           collection, glados.Settings.STATIC_URL + 'testData/SearchResultsDopamineTestData.json', done)

      beforeEach ->

        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
        legendModel = new glados.models.visualisation.LegendModel
          property: prop
          collection: collection
          enable_selection: true

      it 'initialises from a domain and tick values', ->
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
          enable_selection: true

      it 'initialises from a domain and tick values', ->
        testInitialisesFromADefaultDomainAndTickValues(legendModel)
      it 'initialises the amount of items per category', -> testInitialisesAmountOfItemsPerCategory(legendModel)
      it 'selects a value', -> testSelectsAValue(legendModel)
      it 'unselects a value', -> testUnselectsAValue(legendModel)
      it 'toggles a value selection', -> testTogglesAValueSelection(legendModel)
      it 'unselects all values', -> testUnselectsAllValues(legendModel)
      it 'selects all values', -> testSelectsAllValues(legendModel)

  describe "Continuous", ->

    # ------------------------------------------------------------------------------------------------------------------
    # Generic Test Functions
    # ------------------------------------------------------------------------------------------------------------------
    testInitialisesFromProperty = (legendModel) ->

      domain = legendModel.get('domain')
      range = legendModel.get('colour-range')
      ticks = legendModel.get('ticks')

      domainMustBe = legendModel.get('property').domain
      for i in [0..domainMustBe.length - 1]
        expect(domain[i]).toBe(domainMustBe[i])
      rangeMustBe = legendModel.get('property').coloursRange
      for i in [0..rangeMustBe.length - 1]
        expect(range[i]).toBe(rangeMustBe[i])

      numTicks = legendModel.get('property').ticksNumber
      start = domain[0]
      stop = domain[1]
      step = Math.abs(stop - start) / (numTicks - 1)
      ticksMustBe = d3.range(start, stop, step)
      ticksMustBe.push(stop)

      for i in [0..ticksMustBe.length - 1]
        expect(ticks[i]).toBe(ticksMustBe[i])

    testSelectsByRange = (legendModel) ->
      minValue = 0
      maxValue = 1
      legendModel.selectRange(minValue, maxValue)
      expect(legendModel.get('values-selection-min')).toBe(minValue)
      expect(legendModel.get('values-selection-max')).toBe(maxValue)

    # ------------------------------------------------------------------------------------------------------------------
    # Actual tests
    # ------------------------------------------------------------------------------------------------------------------
    describe "with a client side collection", ->

      prop = undefined
      legendModel = undefined
      collection = glados.models.paginatedCollections\
        .PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

      beforeAll (done) ->
        TestsUtils.simulateDataWSClientList(
         collection, glados.Settings.STATIC_URL + 'testData/SearchResultsDopamineTestData.json', done)

      beforeEach ->

        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
        values = glados.Utils.pluckFromListItems(collection, prop.propName)
        glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(prop, values)
        glados.models.visualisation.PropertiesFactory.generateColourScale(prop)
        legendModel = new glados.models.visualisation.LegendModel
          property: prop
          collection: collection
          enable_selection: true


      it 'initialises from the property', -> testInitialisesFromProperty(legendModel)
      it 'selects a range', -> testSelectsByRange(legendModel)

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

        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
        values = (glados.Utils.getNestedValue(item, prop.propName) for item in collection.allResults)
        values = glados.Utils.pluckFromListItems(collection, prop.propName)
        glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(prop, values)
        glados.models.visualisation.PropertiesFactory.generateColourScale(prop)
        legendModel = new glados.models.visualisation.LegendModel
          property: prop
          collection: collection
          enable_selection: true

      it 'initialises from the property', -> testInitialisesFromProperty(legendModel)
      it 'selects a range', -> testSelectsByRange(legendModel)

    describe "with no collection (and no selection)", ->

      prop = undefined
      legendModel = undefined

      ctm = new glados.models.Activity.ActivityAggregationMatrix

      beforeAll (done) ->
        TestsUtils.simulateDataMatrix(ctm, glados.Settings.STATIC_URL + 'testData/MatrixTestData0.json', done)

      beforeEach ->

        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
            'PCHEMBL_VALUE_AVG')

        colourValues = ctm.getValuesListForProperty(prop.propName)
        glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(prop, colourValues)
        glados.models.visualisation.PropertiesFactory.generateColourScale(prop)

        legendModel = new glados.models.visualisation.LegendModel
          property: prop

      it 'initialises from the property', -> testInitialisesFromProperty(legendModel)

  describe "Threshold", ->

     # ------------------------------------------------------------------------------------------------------------------
    # Generic Test Functions
    # ------------------------------------------------------------------------------------------------------------------
    testInitialisesFromProperty = (legendModel) ->

      timeStart = (new Date()).getTime()

      domain = legendModel.get('domain')
      range = legendModel.get('colour-range')
      ticks = legendModel.get('ticks')
      expect(legendModel.isThreshold()).toBe(true)

      domainMustBe = legendModel.get('property').domain
      for i in [0..domainMustBe.length - 1]
        expect(domain[i]).toBe(domainMustBe[i])
      rangeMustBe = legendModel.get('property').coloursRange
      for i in [0..rangeMustBe.length - 1]
        expect(range[i]).toBe(rangeMustBe[i])

      # this test could be better if there is time
      ticksMustBe = ["<1", "[1,100)", "[100,1000)", ">=1000"]
      for i in [0..ticksMustBe.length - 1]
        expect(ticks[i]).toBe(ticksMustBe[i])

    testGetsAmountPerRange = (legendModel) ->

      timeStart = (new Date()).getTime()
      domain = legendModel.get('domain')
      ticks = legendModel.get('ticks')

      collection = legendModel.get('collection')
      if collection.allResults?
        allItemsObjs = collection.allResults
      else
        allItemsObjs = (model.attributes for model in collection.models)

      amountsPerRangeMustBe = {}

      for tick in ticks
        amountsPerRangeMustBe[tick] = 0

      for obj in allItemsObjs
        value = glados.Utils.getNestedValue(obj, prop.propName, forceAsNumber=true)

        for i in [-1..domain.length-1]
          lower = domain[i]
          upper = domain[i+1]
          if i < 0
            lower = -Number.MAX_VALUE
          if i == domain.length - 1
            upper = Number.MAX_VALUE
          if lower <= value < upper
            amountsPerRangeMustBe[ticks[i+1]]++
            break

      amountsPerRangeGot = legendModel.get('amounts-per-range')
      for range, amount of amountsPerRangeMustBe
        expect(amountsPerRangeGot[range]).toBe(amountsPerRangeGot[range])

    prop = undefined
    legendModel = undefined
    collection = glados.models.paginatedCollections\
      .PaginatedCollectionFactory.getNewESActivitiesList()

    beforeAll (done) ->
      TestsUtils.simulateDataESList(collection,
        glados.Settings.STATIC_URL + 'testData/ActivitiesTestData.json', done)

    beforeEach ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'STANDARD_VALUE',
      withColourScale=true)

      legendModel = new glados.models.visualisation.LegendModel
        property: prop
        collection: collection
        enable_selection: false

      console.log 'LIST INITIALISED'

    it 'initializes from the property', -> testInitialisesFromProperty(legendModel)
    it 'gets the amount per range', -> testGetsAmountPerRange(legendModel)