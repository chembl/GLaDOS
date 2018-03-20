describe 'Mechanisms of Action List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1946170'
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewMechanismsOfActionList()
    list.initURL(testChemblID)

    baseUrlMustBe = "#{glados.Settings.WS_BASE_URL}mechanism.json?molecule_chembl_id=#{testChemblID}"
    baseURLGot = list.getMeta('base_url')

    expect(baseURLGot).toBe(baseUrlMustBe)

  sampleDataToParse = undefined
  testChemblID = 'CHEMBL1946170'
  list = undefined

  beforeAll (done) ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewMechanismsOfActionList()
    list.initURL(testChemblID)

    dataURL = "#{glados.Settings.STATIC_URL}testData/Compounds/MechanismOfAction/MechanismsOfActionForCHEMBL1946170esResponse.json"
    $.get dataURL, (testData) ->
      sampleDataToParse = testData
      done()

  it 'parses the data correctly', ->

    parsedDataGot = list.parse(sampleDataToParse)

    mechanismsOfActionIndex = _.indexBy(parsedDataGot, 'mec_id')

    for mechOfActMustBe in sampleDataToParse.mechanisms

      mechOfActID = mechOfActMustBe.mec_id
      mechOfActGot = mechanismsOfActionIndex[mechOfActID]

      expect(mechOfActGot?).toBe(true)
      expect(mechOfActGot.mechanism_of_action).toBe(mechOfActMustBe.mechanism_of_action)
      expect(mechOfActGot.target_chembl_id).toBe(mechOfActMustBe.target_chembl_id)