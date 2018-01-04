describe 'Drug Indications List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1094636'
    drugIndicationsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugIndicationsList()
    drugIndicationsList.initURL(testChemblID)

    baseUrlMustBe = "#{glados.Settings.WS_BASE_URL}drug_indication.json?molecule_chembl_id=#{testChemblID}"
    baseURLGot = drugIndicationsList.getMeta('base_url')

    expect(baseURLGot).toBe(baseUrlMustBe)

  sampleDataToParse = undefined
  testChemblID = undefined
  drugIndicationsList = undefined

  beforeAll (done) ->

    testChemblID = 'CHEMBL1094636'
    drugIndicationsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugIndicationsList()
    drugIndicationsList.initURL(testChemblID)

    dataURL = "#{glados.Settings.STATIC_URL}testData/Compounds/DrugIndication/drugIndicationsForCHEMBL1094636SampleWSResponse.json"
    $.get dataURL, (testData) ->
      sampleDataToParse = testData
      done()

  it 'parses the data correctly', ->

    console.log 'sampleDataToParse: ', sampleDataToParse
    console.log 'testChemblID: ', testChemblID
    console.log 'drugIndicationsList: ', drugIndicationsList
