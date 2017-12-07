describe 'Compound Structural Alerts', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL457419'
    structuralAlerts = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewStructuralAlertsList()
    structuralAlerts.initURL(testChemblID)

    urlMustBe = "#{glados.Settings.WS_BASE_URL}compound_structural_alert.json?molecule_chembl_id=#{testChemblID}&limit=10000"
    urlGot = structuralAlerts.url

    expect(urlMustBe).toBe(urlGot)