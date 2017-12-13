describe 'Drug Indications List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1094636'
    structuralAlertsSets = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugIndicationsList()
    structuralAlertsSets.initURL(testChemblID)

    urlMustBe = "URL"

    console.log 'urlMustBe: ', urlMustBe