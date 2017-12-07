describe 'Compound Structural Alerts', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL457419'
    structuralAlerts = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewStructuralAlertsList()
    structuralAlerts.initURL(testChemblID)

    urlMustBe = 'URL'
    urlGot = structuralAlerts.url

    console.log 'urlMustBe: ', urlMustBe
    console.log 'urlGot: ', urlGot