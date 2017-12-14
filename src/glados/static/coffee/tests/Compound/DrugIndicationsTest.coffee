describe 'Drug Indications List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1094636'
    drugIndicationsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugIndicationsList()
    drugIndicationsList.initURL(testChemblID)

    baseUrlMustBe = "#{glados.Settings.WS_BASE_URL}drug_indication.json?molecule_chembl_id=#{testChemblID}"
    baseURLGot = drugIndicationsList.getMeta('base_url')

    expect(baseURLGot).toBe(baseUrlMustBe)