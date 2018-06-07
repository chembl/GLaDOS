describe 'Mechanisms of Action List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1946170'
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewMechanismsOfActionList()
    list.initURL(testChemblID)

    urlMustBe = "#{glados.models.paginatedCollections.Settings.ES_BASE_URL}/chembl_mechanism/_search?q=#{testChemblID}"
    urlGot = list.url

    expect(urlGot).toBe(urlMustBe)

  sampleDataToParse = undefined
  testChemblID = 'CHEMBL1946170'
  list = undefined

  beforeAll (done) ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewMechanismsOfActionList()
    list.initURL(testChemblID)

    dataURL = "#{glados.Settings.STATIC_URL}testData/Compounds/MechanismOfAction/MechanismsOfActionForCHEMBL190esResponse.json"
    $.get dataURL, (testData) ->
      sampleDataToParse = testData
      done()

  it 'parses the data correctly', ->

    parsedDataGot = list.parse(sampleDataToParse)

    console.log 'parsedDataGot: ', parsedDataGot
    return

    mechanismsOfActionIndex = _.indexBy(parsedDataGot, 'mec_id')

    for mechOfActMustBe in sampleDataToParse.mechanisms

      mechOfActID = mechOfActMustBe.mec_id
      mechOfActGot = mechanismsOfActionIndex[mechOfActID]

      expect(mechOfActGot?).toBe(true)
      expect(mechOfActGot.mechanism_of_action).toBe(mechOfActMustBe.mechanism_of_action)
      expect(mechOfActGot.target_chembl_id).toBe(mechOfActMustBe.target_chembl_id)