describe 'Unichem Connectivity List', ->

  unichemConnectivityList = undefined

  beforeAll ->

    unichemConnectivityList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()

  it 'works', ->

    console.log 'unichemConnectivityList: ', unichemConnectivityList