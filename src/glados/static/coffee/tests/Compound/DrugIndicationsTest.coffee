describe 'Drug Indications List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1094636'
    drugIndicationsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugIndicationsList()
    drugIndicationsList.initURL(testChemblID)

    baseUrlMustBe = "#{glados.models.paginatedCollections.Settings.ES_BASE_URL}/chembl_drug_indication/_search?q=_metadata.all_molecule_chembl_ids:#{testChemblID}"
    console.log 'baseUrlMustBe: ', baseUrlMustBe
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

    parsedDataGot = drugIndicationsList.parse(sampleDataToParse)

    drugIndicationsIndex = _.indexBy(parsedDataGot, 'drugind_id')

    for drugIndicationMustBe in sampleDataToParse.drug_indications

      drugIndID = drugIndicationMustBe.drugind_id
      drugIndicationGot = drugIndicationsIndex[drugIndID]

      expect(drugIndicationGot?).toBe(true)
      expect(drugIndicationGot.mesh_heading).toBe(drugIndicationMustBe.mesh_heading)
      expect(drugIndicationGot.mesh_id).toBe(drugIndicationMustBe.mesh_id)
      expect(drugIndicationGot.max_phase_for_ind).toBe(drugIndicationMustBe.max_phase_for_ind)

  it 'sorts the items by drug indication by default', ->

    parsedDataGot = drugIndicationsList.parse(sampleDataToParse)
    console.log 'parsedDataGot: ', parsedDataGot

    previousMaxPhase = 4
    for drugIndicationGot in parsedDataGot
      currentMaxPhase = drugIndicationGot.max_phase_for_ind
      expect(currentMaxPhase <= previousMaxPhase).toBe(true)
      previousMaxPhase = currentMaxPhase

