describe 'Mechanisms of Action List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1946170'
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewMechanismsOfActionList()
    list.initURL(testChemblID)

    baseUrlMustBe = "#{glados.Settings.WS_BASE_URL}mechanism.json?molecule_chembl_id=#{testChemblID}"
    baseURLGot = list.getMeta('base_url')

    expect(baseURLGot).toBe(baseUrlMustBe)
