describe "Compounds vs Target Matrix", ->

  ctm = new CompoundTargetMatrix

  beforeAll (done) ->
    simulateDataMatrix(ctm, glados.Settings.STATIC_URL + 'testData/MatrixTestData0.json', done)

  it 'Gives the correct link for a column', ->
    expect(ctm.getLinkForRowHeader('CHEMBL59')).toBe('/compound_report_card/CHEMBL59')

  it 'Gives the correct link for a row', ->

    expect(ctm.getLinkForColHeader('Targ: CHEMBL612545')).toBe('/target_report_card/CHEMBL612545')

  simulateDataMatrix = (matrix, dataURL, done) ->
    $.get dataURL, (testData) ->
      ctm.set('config', testData.config)
      ctm.set('matrix', testData.matrix)
      done()
