describe "Compounds vs Target Matrix", ->

  ctm = new CompoundTargetMatrix

  beforeEach (done) ->
    TestsUtils.simulateDataMatrix(ctm, glados.Settings.STATIC_URL + 'testData/MatrixTestData0.json', done)

  it 'Gives a list of values in a cell for a property', ->

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
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

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
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

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
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

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
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

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
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