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

    mechanismsOfActionToParse = sampleDataToParse.hits.hits
    mechanismsOfActionIndex = _.indexBy(parsedDataGot, 'mech_identifier')

    for mechMustBe in mechanismsOfActionToParse

      mechIdentifier = "#{mechMustBe._source.target_chembl_id}-#{mechMustBe._source.mechanism_of_action}"
      numRows = _.countBy(parsedDataGot, (mech) -> mech.mech_identifier == mechIdentifier).true

      #there must be only one row
      expect(numRows).toBe(1)

      # all the refs must be there
      refsMustBe = mechMustBe._source.mechanism_refs
      refsGot = mechanismsOfActionIndex[mechIdentifier].mechanism_refs

      for refMustBe in refsMustBe
        refInRefsGot = _.findWhere(refsGot, {ref_id: refMustBe.ref_id})?
        expect(refInRefsGot).toBe(true)

  it 'sorts the mechanisms alphabetically by default', ->

     parsedDataGot = list.parse(sampleDataToParse)

     previousMech = 'A'
     for mechanism in parsedDataGot
       currentMech = mechanism.mechanism_of_action
       expect(currentMech >= previousMech).toBe(true)
       previousMech = currentMech

