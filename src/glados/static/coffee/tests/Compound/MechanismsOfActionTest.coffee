describe 'Mechanisms of Action List', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL1946170'
    listist = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewMechanismsOfActionList()
