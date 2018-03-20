describe 'Mechanisms of Action List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1946170'
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewMechanismsOfActionList()
    console.log 'list: ', list
