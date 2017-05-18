describe "Compounds vs Target Matrix", ->

  ctm = new CompoundTargetMatrix

  beforeAll (done) ->
    TestsUtils.simulateDataMatrix(ctm, glados.Settings.STATIC_URL + 'testData/MatrixTestData0.json', done)

  it 'Gives the correct link for a column', ->
    expect(ctm.getLinkForRowHeader('CHEMBL59')).toBe('/compound_report_card/CHEMBL59')

  it 'Gives the correct link for a row', ->

    expect(ctm.getLinkForColHeader('Targ: CHEMBL612545')).toBe('/target_report_card/CHEMBL612545')

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
