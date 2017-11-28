describe 'Compound Metabolism', ->

  parsedDataMustBe = undefined

  beforeAll (done) ->

    dataURL = glados.Settings.STATIC_URL + 'testData/metabolismSampleData.json'
    $.get dataURL, (testData) ->
      parsedDataMustBe = testData
      done()


  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL25'
    compoundMetabolism = new glados.models.Compound.Metabolism
      molecule_chembl_id: testChemblID

    urlMustBe = glados.models.paginatedCollections.Settings.ES_BASE_URL +
      '/chembl_metabolism/_search?q=drug_chembl_id:' + testChemblID + '&size=10000'
    expect(compoundMetabolism.url).toBe(urlMustBe)

  it 'parses the nodes correctly', ->

    console.log 'parsedDataMustBe: ', parsedDataMustBe

