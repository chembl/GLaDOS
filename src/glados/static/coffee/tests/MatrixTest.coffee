describe "Compounds vs Target Matrix", ->

  testFilter = (ctm, testIDs) ->

    requestData = ctm.getRequestData()
    console.log 'requestData: ', JSON.stringify(requestData)
    iDsGot = requestData.query.terms[ctm.get('filter_property')]
    expect(iDsGot.length).toBe(testIDs.length)

    for i in [0..testIDs.length-1]
      expect(iDsGot[i]).toBe(testIDs[i])

  describe "Starting From Compounds", ->

    testMoleculeIDs = ['CHEMBL59', 'CHEMBL138921', 'CHEMBL138040', 'CHEMBL457419']
    ctm = new glados.models.Activity.ActivityAggregationMatrix
      filter_property: 'molecule_chembl_id'
      chembl_ids: testMoleculeIDs

    describe "Request Data", ->

      it 'Generates the correct filter', -> testFilter(ctm, testMoleculeIDs)

  describe "Starting From Targets", ->

    testTargetIDs = ['CHEMBL2111342', 'CHEMBL2111341', 'CHEMBL2111359', 'CHEMBL3102']
    ctm = new glados.models.Activity.ActivityAggregationMatrix
      filter_property: 'target_chembl_id'
      chembl_ids: testTargetIDs

    describe "Request Data", ->

      it 'Generates the correct filter', -> testFilter(ctm, testTargetIDs)

  describe "General Functions", ->

    ctm = new glados.models.Activity.ActivityAggregationMatrix()

    beforeEach (done) ->
      TestsUtils.simulateDataMatrix(ctm, glados.Settings.STATIC_URL + 'testData/MatrixTestData0.json', done)

    it 'Gives a list of values in a cell for a property', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
        'PCHEMBL_VALUE_AVG')

      links = ctm.get('matrix').links
      valuesShouldBe = []
      for rowIndex, row of links
        for colIndex, cell of row
          value = cell[prop.propName]
          if value?
            valuesShouldBe.push(value)

      valuesGot = ctm.getValuesListForProperty(prop.propName)
      comparisons = _.zip(valuesGot, valuesShouldBe)
      for comp in comparisons
        expect(comp[0]).toBe(comp[1])

    it 'sorts rows by property', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
        'PCHEMBL_VALUE_MAX')

      ctm.sortMatrixRowsBy(prop.propName)
      orderedRows = _.sortBy(ctm.get('matrix').rows, 'currentPosition')

      for i in [0..orderedRows.length-2]
        j = i + 1
        valueA = orderedRows[i][prop.propName]
        valueB = orderedRows[j][prop.propName]
        valueA = 0 if not valueA?
        valueB = 0 if not valueB?
        expect(valueA <= valueB).toBe(true)

    it 'sorts rows by property (reverse)', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
        'PCHEMBL_VALUE_MAX')

      ctm.sortMatrixRowsBy(prop.propName, reverse=true)
      orderedRows = _.sortBy(ctm.get('matrix').rows, 'currentPosition')

      for i in [0..orderedRows.length-2]
        j = i + 1
        valueA = orderedRows[i][prop.propName]
        valueB = orderedRows[j][prop.propName]
        valueA = 0 if not valueA?
        valueB = 0 if not valueB?
        expect(valueA >= valueB).toBe(true)

    it 'sorts cols by property', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
        'PCHEMBL_VALUE_MAX')

      ctm.sortMatrixColsBy(prop.propName)
      orderedCols = _.sortBy(ctm.get('matrix').columns, 'currentPosition')

      for i in [0..orderedCols.length-2]
        j = i + 1
        valueA = orderedCols[i][prop.propName]
        valueB = orderedCols[j][prop.propName]
        valueA = 0 if not valueA?
        valueB = 0 if not valueB?
        expect(valueA <= valueB).toBe(true)

    it 'sorts cols by property (reverse)', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
        'PCHEMBL_VALUE_MAX')

      ctm.sortMatrixColsBy(prop.propName, reverse=true)
      orderedCols = _.sortBy(ctm.get('matrix').columns, 'currentPosition')

      for i in [0..orderedCols.length-2]
        j = i + 1
        valueA = orderedCols[i][prop.propName]
        valueB = orderedCols[j][prop.propName]
        valueA = 0 if not valueA?
        valueB = 0 if not valueB?
        expect(valueA >= valueB).toBe(true)