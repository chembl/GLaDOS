describe 'Unichem Connectivity List', ->

  list = undefined
  parentInchiKey = 'BSYNRYMUTXBXSQ-UHFFFAOYSA-N'

  beforeAll ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
    # this will be done directly from the info in the compounds
    list.setInchiKeys
      parent_key: parentInchiKey

  it 'initialises the links correctly', ->

    uCBKey = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY
    urlMustBe = "#{glados.ChemUtils.UniChem.connectivity_url}#{parentInchiKey}/0/0/4?callback=#{uCBKey}"
    urlGot = list.getURLForInchi(parentInchiKey)

    expect(urlGot).toBe(urlMustBe)

  it 'parses the response from the parent correctly', ->

    list.fetchDataForInchiKey(parentInchiKey)

