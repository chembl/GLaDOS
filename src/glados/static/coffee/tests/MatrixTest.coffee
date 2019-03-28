describe "Compounds vs Target Matrix", ->

  #---------------------------------------------------------------------------------------------------------------------
  # Generic test functions
  #---------------------------------------------------------------------------------------------------------------------
  testFilter = (ctm, testIDs) ->

    requestData = ctm.getRequestData()
    iDsGot = requestData.query.terms[ctm.get('filter_property')]
    expect(iDsGot.length).toBe(testIDs.length)

    for i in [0..testIDs.length-1]
      expect(iDsGot[i]).toBe(testIDs[i])

  testQueryString = (ctm, testQueryString) ->

    requestData = ctm.getRequestData()
    expect(requestData.query.query_string.query).toBe(testQueryString)

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

  testParsesRows = (ctm, testAggList, testDataToParse) ->

    matrix = (ctm.parse testDataToParse).matrix
    rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
    rowsMustBe = (bucket.key for bucket in testDataToParse.aggregations[rowsAggName].buckets)
    rowsGot = matrix.rows_index
    for row in rowsMustBe
      expect(rowsGot[row]?).toBe(true)

  testAddsRowsWithNoData = (ctm, testAggList, testDataToParse, testIDs) ->

    matrix = (ctm.parse testDataToParse).matrix
    rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
    rowsWithDataMustBe = (bucket.key for bucket in testDataToParse.aggregations[rowsAggName].buckets)
    additionalIdsMustBe = _.difference(testIDs, rowsWithDataMustBe)

    rowsGot = matrix.rows_index
    for row in additionalIdsMustBe
      expect(rowsGot[row]?).toBe(true)

  testParsesColumns = (ctm, testAggList, testDataToParse) ->

    matrix = (ctm.parse testDataToParse).matrix

    rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
    colsAggName = testAggList[1] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

    colsGot = matrix.columns_index
    rowsContainer = testDataToParse.aggregations[rowsAggName].buckets
    for rowObj in rowsContainer
      for colObj in rowObj[colsAggName].buckets
        colMustBe = colObj.key
        expect(colsGot[colMustBe]?).toBe(true)

  testParsesLinks = (ctm, testAggList, testDataToParse) ->
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

  testGeneratesFooterExternalLinks = (ctm, testAggList, testDataToParse) ->

    ctm.set(ctm.parse testDataToParse)
    matrix = ctm.get('matrix')

    rowsPropName = testAggList[0]
    colsPropName = testAggList[1]
    rowsAggName = rowsPropName + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
    colsAggName = colsPropName + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

    linksGot = matrix.links
    rowsGot = matrix.rows_index
    colsGot = matrix.columns_index
    rowsContainer = testDataToParse.aggregations[rowsAggName].buckets

    for rowObj in rowsContainer

      rowKey = rowObj.key
      rowActivityFilter = rowsPropName + ':' + rowKey
      rowFooterURLMustBe = Activity.getActivitiesListURL(rowActivityFilter)
      expect(ctm.getRowFooterLink(rowKey)).toBe(rowFooterURLMustBe)
      # expect to be saved after generated
      expect(rowsGot[rowKey].footer_url).toBe(rowFooterURLMustBe)

      for colObj in rowObj[colsAggName].buckets

        colKey = colObj.key

        relatedRows = ctm.getRelatedRowIDsFromColID(colKey, linksGot, colsGot)
        rowsListFilter = rowsPropName + ':(' + ('"' + row + '"' for row in relatedRows).join(' OR ') + ')'
        colActivityFilter = colsPropName + ':' + colKey + ' AND ' + rowsListFilter
        colFooterURLMustBe = Activity.getActivitiesListURL(colActivityFilter)
        expect(ctm.getColFooterLink(colKey)).toBe(colFooterURLMustBe)
        expect(colsGot[colKey].footer_url).toBe(colFooterURLMustBe)


  testParsesHeaderExternalLinks = (ctm, testAggList, testDataToParse) ->

    ctm.set(ctm.parse testDataToParse)
    matrix = ctm.get('matrix')

    rowsPropName = testAggList[0]
    colsPropName = testAggList[1]
    rowsAggName = rowsPropName + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
    colsAggName = colsPropName + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

    rowsGot = matrix.rows_index
    colsGot = matrix.columns_index
    rowsContainer = testDataToParse.aggregations[rowsAggName].buckets

    for rowObj in rowsContainer

      rowKey = rowObj.key

      if rowsPropName == 'molecule_chembl_id'
        rowHeaderURLMustBe = Compound.get_report_card_url(rowKey)
      else
        rowHeaderURLMustBe = Target.get_report_card_url(rowKey)

      expect(ctm.getRowHeaderLink(rowKey)).toBe(rowHeaderURLMustBe)
      expect(rowsGot[rowKey].header_url).toBe(rowHeaderURLMustBe)

      for colObj in rowObj[colsAggName].buckets

        colKey = colObj.key

        if colsPropName == 'molecule_chembl_id'
          colHeaderURLMustBe = Compound.get_report_card_url(colKey)
        else
          colHeaderURLMustBe = Target.get_report_card_url(colKey)

        expect(ctm.getColHeaderLink(colKey)).toBe(colHeaderURLMustBe)
        expect(colsGot[colKey].header_url).toBe(colHeaderURLMustBe)

  testGeneratesLinkToAllColumns = (ctm, testAggList, testDataToParse) ->

    ctm.set(ctm.parse testDataToParse)
    matrix = ctm.get('matrix')

    rowsPropName = testAggList[0]
    colsPropName = testAggList[1]
    rowsGot = matrix.rows_index



    if rowsPropName == 'molecule_chembl_id'
      relatedEntitiesPropName = '_metadata.related_compounds.all_chembl_ids'
      filter = "#{relatedEntitiesPropName}:(#{_.keys(rowsGot).join(' OR ')})"
      allColsHeaderURLMustBe = Target.getTargetsListURL(filter)
    else
      relatedEntitiesPropName = '_metadata.related_targets.all_chembl_ids'
      filter = "#{relatedEntitiesPropName}:(#{_.keys(rowsGot).join(' OR ')})"
      allColsHeaderURLMustBe = Compound.getCompoundsListURL(filter)

    console.log 'allColsHeaderURLMustBe: ', allColsHeaderURLMustBe
    expect(ctm.getLinkToAllColumns()).toBe(allColsHeaderURLMustBe)
    expect(matrix.link_to_all_columns).toBe(allColsHeaderURLMustBe)

  testHitCount = (ctm, testAggList, testDataToParse) ->

    matrix = (ctm.parse testDataToParse).matrix

    rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
    colsAggName = testAggList[1] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

    rowsGot = matrix.rows_index
    colsGot = matrix.columns_index
    rowsContainer = testDataToParse.aggregations[rowsAggName].buckets
    rowHitCountsMustBe = {}
    colHitCountsMustBe = {}

    for rowObj in rowsContainer
      rowKey = rowObj.key
      rowHitCountsMustBe[rowKey] = 0 unless rowHitCountsMustBe[rowKey]?
      for colObj in rowObj[colsAggName].buckets
        colKey = colObj.key
        colHitCountsMustBe[colKey] = 0 unless colHitCountsMustBe[colKey]?

        rowHitCountsMustBe[rowKey]++
        colHitCountsMustBe[colKey]++

    for rowID, rowObj of rowsGot
      hitCountGot = rowObj.hit_count
      # ignore additional columns
      if rowHitCountsMustBe[rowID]?
        expect(hitCountGot).toBe(rowHitCountsMustBe[rowID])

    for colID, colObj of colsGot
      hitCountGot = colObj.hit_count
      expect(hitCountGot).toBe(colHitCountsMustBe[colID])

  testActivityCount = (ctm, testAggList, testDataToParse) ->

    matrix = (ctm.parse testDataToParse).matrix

    rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
    colsAggName = testAggList[1] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

    rowsGot = matrix.rows_index
    colsGot = matrix.columns_index
    rowsContainer = testDataToParse.aggregations[rowsAggName].buckets
    rowSumsMustBe = {}
    colSumsMustBe = {}

    for rowObj in rowsContainer
      rowKey = rowObj.key
      rowSumsMustBe[rowKey] = 0 unless rowSumsMustBe[rowKey]?
      for colObj in rowObj[colsAggName].buckets
        colKey = colObj.key
        colSumsMustBe[colKey] = 0 unless colSumsMustBe[colKey]?

        rowSumsMustBe[rowKey] += colObj.doc_count
        colSumsMustBe[colKey] += colObj.doc_count

    for rowID, rowObj of rowsGot
      actCountGot = rowObj.activity_count
      if rowSumsMustBe[rowID]?
        expect(actCountGot).toBe(rowSumsMustBe[rowID])

    for colID, colObj of colsGot
      actCountGot = colObj.activity_count
      expect(actCountGot).toBe(colSumsMustBe[colID])

  testPchemblValue = (ctm, testAggList, testDataToParse) ->

    matrix = (ctm.parse testDataToParse).matrix

    rowsAggName = testAggList[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
    colsAggName = testAggList[1] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

    rowsGot = matrix.rows_index
    colsGot = matrix.columns_index
    rowsContainer = testDataToParse.aggregations[rowsAggName].buckets
    rowMaxsMustBe = {}
    colMaxsMustBe = {}

    for rowObj in rowsContainer
      rowKey = rowObj.key
      for colObj in rowObj[colsAggName].buckets
        colKey = colObj.key

        newPchemblValMax = colObj.pchembl_value_max.value
        currentRowPchemblValMax = rowMaxsMustBe[rowKey]
        if not currentRowPchemblValMax?
          rowMaxsMustBe[rowKey] = newPchemblValMax
        else if newPchemblValMax?
          rowMaxsMustBe[rowKey] = Math.max(currentRowPchemblValMax, newPchemblValMax)

        currentColPchemblValMax = colMaxsMustBe[colKey]
        if not currentColPchemblValMax?
          colMaxsMustBe[colKey] = newPchemblValMax
        else if newPchemblValMax?
          colMaxsMustBe[colKey] = Math.max(currentColPchemblValMax, newPchemblValMax)

    for rowID, rowObj of rowsGot
      maxPchemblGot = rowObj.pchembl_value_max
      if rowMaxsMustBe[rowID]?
        expect(maxPchemblGot).toBe(rowMaxsMustBe[rowID])

    for colID, colObj of colsGot
      maxPchemblGot = colObj.pchembl_value_max
      expect(maxPchemblGot).toBe(colMaxsMustBe[colID])

  testLinkToAllActivities = (ctm, testMoleculeIDs) ->

    filterMustBe = ctm.get('filter_property') + ':(' + ('"' + id + '"' for id in testMoleculeIDs).join(' OR ') + ')'
    urlMustBe = Activity.getActivitiesListURL(filterMustBe)
    urlGot = ctm.getLinkToAllActivities()
    expect(urlGot).toBe(urlMustBe)

  testLinkToFullScreen = (ctm, testIDs) ->

    filterProperty = ctm.get('filter_property')
    startingFrom = switch filterProperty
      when 'molecule_chembl_id' then 'Compounds'
      else 'Targets'

    filterMustBe = ctm.get('filter_property') + ':(' + ('"' + id + '"' for id in testIDs).join(' OR ') + ')'

    urlMustBe = Activity.getActivitiesListURL(filterMustBe) + '/state/matrix_fs_' + startingFrom
    urlGot = ctm.getLinkToFullScreen()
    expect(urlGot).toBe(urlMustBe)

  #---------------------------------------------------------------------------------------------------------------------
  # From Compounds
  #---------------------------------------------------------------------------------------------------------------------
  describe "Starting From Compounds", ->

    # there will be no data for chembl 25 in the response
    testMoleculeIDs = ['CHEMBL59', 'CHEMBL138921', 'CHEMBL138040', 'CHEMBL457419', 'CHEMBL25']
    testAggList = ['molecule_chembl_id', 'target_chembl_id']
    ctm = new glados.models.Activity.ActivityAggregationMatrix
      filter_property: 'molecule_chembl_id'
      chembl_ids: testMoleculeIDs
      aggregations: testAggList
    testDataToParse = undefined

    describe "General", ->

      it 'Generates the link to browse all activities', -> testLinkToAllActivities(ctm, testMoleculeIDs)
      it 'Generates the link to full screen view', -> testLinkToFullScreen(ctm, testMoleculeIDs)

    describe "Request Data", ->

      it 'Generates the filter', -> testFilter(ctm, testMoleculeIDs)
      it 'Generates the aggregation structure', -> testAggregations(ctm, testAggList)
      it 'Generates the cell aggregations', -> testCellsAggregations(ctm, testAggList)

    describe "Parsing", ->

      beforeAll (done) ->
        $.get (glados.Settings.STATIC_URL + 'testData/ActivityMatrixFromCompoundsSampleResponse.json'), (testData) ->
          testDataToParse = testData
          done()

      it 'parses the rows', -> testParsesRows(ctm, testAggList, testDataToParse)
      it 'adds the rows with no data', -> testAddsRowsWithNoData(ctm, testAggList, testDataToParse, testMoleculeIDs)
      it 'parses the columns', -> testParsesColumns(ctm, testAggList, testDataToParse)
      it 'parses the links', -> testParsesLinks(ctm, testAggList, testDataToParse)
      it 'calculates the hit count per row and per column', -> testHitCount(ctm, testAggList, testDataToParse)
      it 'calculates activity count per row and column', -> testActivityCount(ctm, testAggList, testDataToParse)
      it 'calculates pchembl value max per row and column', -> testPchemblValue(ctm, testAggList, testDataToParse)
      it 'generates the footer links', -> testGeneratesFooterExternalLinks(ctm, testAggList, testDataToParse)
      it 'parses the header links', -> testParsesHeaderExternalLinks(ctm, testAggList, testDataToParse)
      it 'generates the link to all columns', -> testGeneratesLinkToAllColumns(ctm, testAggList, testDataToParse)

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
    testDataToParse = undefined

    describe "General", ->

      it 'Generates the link to browse all activities', -> testLinkToAllActivities(ctm, testTargetIDs)
      it 'Generates the link to full screen view', -> testLinkToFullScreen(ctm, testTargetIDs)

    describe "Request Data", ->

      it 'Generates the filter', -> testFilter(ctm, testTargetIDs)
      it 'Generates the aggregation structure', -> testAggregations(ctm, testAggList)
      it 'Generates the cell aggregations', -> testCellsAggregations(ctm, testAggList)

    describe "Parsing", ->

      beforeAll (done) ->
        $.get (glados.Settings.STATIC_URL + 'testData/ActivityMatrixFromTargetsSampleResponse.json'), (testData) ->
          testDataToParse = testData
          done()

      it 'parses the rows', -> testParsesRows(ctm, testAggList, testDataToParse)
      it 'adds the rows with no data', -> testAddsRowsWithNoData(ctm, testAggList, testDataToParse, testTargetIDs)
      it 'parses the columns', -> testParsesColumns(ctm, testAggList, testDataToParse)
      it 'parses the links', -> testParsesLinks(ctm, testAggList, testDataToParse)
      it 'calculates the hit count per row and per column', -> testHitCount(ctm, testAggList, testDataToParse)
      it 'calculates activity count per row and column', -> testActivityCount(ctm, testAggList, testDataToParse)
      it 'calculates pchembl value max per row and column', -> testPchemblValue(ctm, testAggList, testDataToParse)
      it 'generates the footer links', -> testGeneratesFooterExternalLinks(ctm, testAggList, testDataToParse)
      it 'parses the header links', -> testParsesHeaderExternalLinks(ctm, testAggList, testDataToParse)
      it 'generates the link to all columns', -> testGeneratesLinkToAllColumns(ctm, testAggList, testDataToParse)

  #---------------------------------------------------------------------------------------------------------------------
  # From a Query String
  #---------------------------------------------------------------------------------------------------------------------
  #TODO: this needs to be merged with the aggregation class. The chembl ids should be in a terms query, and the filter
  #TODO: should be in a querystring
  describe "Starting From a querystring", ->

    describe "And using compounds as base", ->

      # there will be no data for chembl 25 in the response
      testMoleculeIDs = ['CHEMBL59', 'CHEMBL138921', 'CHEMBL138040', 'CHEMBL457419', 'CHEMBL25']
      testQueryS = 'molecule_chembl_id:(' + ('"' + id + '"' for id in testMoleculeIDs).join(' OR ') + ')'

      testAggList = ['molecule_chembl_id', 'target_chembl_id']
      ctm = new glados.models.Activity.ActivityAggregationMatrix
        filter_property: 'molecule_chembl_id'
        query_string: testQueryS
        aggregations: testAggList
      testDataToParse = undefined

      describe "Request Data", ->

        it 'Generates the filter', -> testQueryString(ctm, testQueryS)
        it 'Generates the aggregation structure', -> testAggregations(ctm, testAggList)
        it 'Generates the cell aggregations', -> testCellsAggregations(ctm, testAggList)

      describe "Parsing", ->

        beforeAll (done) ->
          $.get (glados.Settings.STATIC_URL + 'testData/ActivityMatrixFromCompoundsSampleResponse.json'), (testData) ->
            testDataToParse = testData
            done()

        it 'parses the rows', -> testParsesRows(ctm, testAggList, testDataToParse)
        it 'adds the rows with no data', -> testAddsRowsWithNoData(ctm, testAggList, testDataToParse, testMoleculeIDs)
        it 'parses the columns', -> testParsesColumns(ctm, testAggList, testDataToParse)
        it 'parses the links', -> testParsesLinks(ctm, testAggList, testDataToParse)
        it 'calculates the hit count per row and per column', -> testHitCount(ctm, testAggList, testDataToParse)
        it 'calculates activity count per row and column', -> testActivityCount(ctm, testAggList, testDataToParse)
        it 'calculates pchembl value max per row and column', -> testPchemblValue(ctm, testAggList, testDataToParse)
        it 'generates the footer links', -> testGeneratesFooterExternalLinks(ctm, testAggList, testDataToParse)
        it 'parses the header links', -> testParsesHeaderExternalLinks(ctm, testAggList, testDataToParse)


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