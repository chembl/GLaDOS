describe "Compound Hierarchy", ->

  testIsParent = (compound) ->
    expect(compound.isParent()).toBe(true)
  #-------------------------------------------------------------------------------------------------------------------
  # True Parents
  #-------------------------------------------------------------------------------------------------------------------
  describe "True Parent", ->

    chemblID = 'CHEMBL25'
    compound = new Compound
      molecule_chembl_id: chemblID
      fetch_from_elastic: true

    esResponse = undefined
    parsed = undefined

    beforeAll (done) ->

      dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL25esResponse.json'
      $.get dataURL, (testData) ->
        esResponse = testData
        parsed = compound.parse(esResponse)
        compound.set(parsed)
        done()

    it 'identifies correctly a parent', -> testIsParent(compound)

  #-------------------------------------------------------------------------------------------------------------------
  # Virtual Parents
  #-------------------------------------------------------------------------------------------------------------------
  describe "True Parent", ->

    chemblID = 'CHEMBL2111124'
    compound = new Compound
      molecule_chembl_id: chemblID
      fetch_from_elastic: true

    esResponse = undefined
    parsed = undefined

    beforeAll (done) ->

      dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL2111124esVirtualParent.json'
      $.get dataURL, (testData) ->
        esResponse = testData
        parsed = compound.parse(esResponse)
        compound.set(parsed)
        done()

    it 'identifies correctly a parent', -> testIsParent(compound)