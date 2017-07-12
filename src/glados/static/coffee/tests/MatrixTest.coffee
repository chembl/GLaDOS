describe "Compounds vs Target Matrix", ->

  testFilter = (ctm, testIDs) ->

    requestData = ctm.getRequestData()
    iDsGot = requestData.query.terms[ctm.get('filter_property')]
    expect(iDsGot.length).toBe(testIDs.length)

    for i in [0..testIDs.length-1]
      expect(iDsGot[i]).toBe(testIDs[i])

  testAggregations = (ctm, testAggList) ->

    requestData = ctm.getRequestData()
    aggsContainer = requestData.aggs
    for propName in testAggList
      aggName = propName + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
      currentAgg = aggsContainer[aggName]
      expect(currentAgg?).toBe(true)
      expect(currentAgg.terms.field).toBe(propName)
      aggsContainer = currentAgg.aggs


  testCellsAggregations = (ctm, testAggList) ->

    requestData = ctm.getRequestData()

    aggsContainer = requestData.aggs
    for propName in testAggList
      aggName = propName + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
      aggsContainer = aggsContainer[aggName].aggs

    # this is hardcoded for simplicity
    cellsAggsContainer = aggsContainer
    agg1 = cellsAggsContainer.pchembl_value_avg
    expect(agg1?).toBe(true)
    expect(agg1.avg.field).toBe('pchembl_value')

    agg2 = cellsAggsContainer.pchembl_value_max
    expect(agg2?).toBe(true)
    expect(agg2.max.field).toBe('pchembl_value')

  #---------------------------------------------------------------------------------------------------------------------
  # From Compounds
  #---------------------------------------------------------------------------------------------------------------------
  describe "Starting From Compounds", ->

    testMoleculeIDs = ['CHEMBL59', 'CHEMBL138921', 'CHEMBL138040', 'CHEMBL457419']
    testAggList = ['molecule_chembl_id', 'target_chembl_id']
    ctm = new glados.models.Activity.ActivityAggregationMatrix
      filter_property: 'molecule_chembl_id'
      chembl_ids: testMoleculeIDs
      aggregations: testAggList
    testDataToParse = undefined

    describe "Request Data", ->

      it 'Generates the filter', -> testFilter(ctm, testMoleculeIDs)
      it 'Generates the aggregation structure', -> testAggregations(ctm, testAggList)
      it 'Generates the cell aggregations', -> testCellsAggregations(ctm, testAggList)

    describe "Parsing", ->

      beforeAll (done) ->
        $.get (glados.Settings.STATIC_URL + 'testData/ActivityMatrixFromCompoundsSampleResponse.json'), (testData) ->
          testDataToParse = testData
          done()

      it 'parses the rows', ->

        matrix = (ctm.parse testDataToParse).matrix
        rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
        rowsMustBe = (bucket.key for bucket in testDataToParse.aggregations[rowsAggName].buckets)
        rowsGot = matrix.rows_index
        for row in rowsMustBe
          expect(rowsGot[row]?).toBe(true)

      it 'parses the columns', ->

        matrix = (ctm.parse testDataToParse).matrix

        rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
        colsAggName = testAggList[1] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

        colsGot = matrix.columns_index
        rowsContainer = testDataToParse.aggregations[rowsAggName].buckets
        for rowObj in rowsContainer
          for colObj in rowObj[colsAggName].buckets
            colMustBe = colObj.key
            expect(colsGot[colMustBe]?).toBe(true)

      it 'parses the links', ->

        matrix = (ctm.parse testDataToParse).matrix

        rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
        colsAggName = testAggList[1] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

        linksGot = matrix.links
        rowsGot = matrix.rows_index
        colsGot = matrix.columns_index
        rowsContainer = testDataToParse.aggregations[rowsAggName].buckets

        for rowObj in rowsContainer

          rowKey = rowObj.key
          rowOriginalIndex = rowsGot[rowKey].originalIndex

          for colObj in rowObj[colsAggName].buckets
            colKey = colObj.key
            colOriginalIndex = colsGot[colKey].originalIndex
            linkGot = linksGot[rowOriginalIndex][colOriginalIndex]

            rowIdInLink = linkGot.row_id
            colIdInlink = linkGot.col_id
            expect(rowIdInLink).toBe(rowKey)
            expect(colIdInlink).toBe(colKey)

  #---------------------------------------------------------------------------------------------------------------------
  # From Targets
  #---------------------------------------------------------------------------------------------------------------------
  describe "Starting From Targets", ->

    testTargetIDs = ['CHEMBL2111342', 'CHEMBL2111341', 'CHEMBL2111359', 'CHEMBL3102']
    testAggList = ['target_chembl_id', 'molecule_chembl_id']
    ctm = new glados.models.Activity.ActivityAggregationMatrix
      filter_property: 'target_chembl_id'
      chembl_ids: testTargetIDs
      aggregations: testAggList

    describe "Request Data", ->

      it 'Generates the filter', -> testFilter(ctm, testTargetIDs)
      it 'Generates the aggregation structure', -> testAggregations(ctm, testAggList)
      it 'Generates the cell aggregations', -> testCellsAggregations(ctm, testAggList)

  #---------------------------------------------------------------------------------------------------------------------
  # General Functions
  #---------------------------------------------------------------------------------------------------------------------
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