describe 'Unichem Connectivity List', ->

  list = undefined
  parentInchiKey = 'BSYNRYMUTXBXSQ-UHFFFAOYSA-N'

  beforeAll ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
    # this will be done directly from the info in the compounds
    list.setInchiKeys
      parent_key: parentInchiKey

  it 'initialises the links correctly', ->

    urlMustBe = "#{glados.ChemUtils.UniChem.connectivity_url}#{parentInchiKey}/0/0/4?callback=xyz"
    urlGot = list.getURLForParent()

    expect(urlGot).toBe(urlMustBe)
