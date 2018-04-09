describe 'Unichem Connectivity List', ->

  list = undefined
  parentInchiKey = 'BSYNRYMUTXBXSQ-UHFFFAOYSA-N'
  parentDataToParse = undefined

  beforeAll (done) ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
    # this will be done directly from the info in the compounds
    list.setInchiKeys
      parent_key: parentInchiKey

    dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/UnichemConnectivity/CHEMBL25UnichemResponseToParse.json'
    $.get dataURL, (testData) ->
      parentDataToParse = testData
      done()

  it 'initialises the links correctly', ->

    uCBKey = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY
    urlMustBe = "#{glados.ChemUtils.UniChem.connectivity_url}#{parentInchiKey}/0/0/4?callback=#{uCBKey}"
    urlGot = list.getURLForInchi(parentInchiKey)

    expect(urlGot).toBe(urlMustBe)

  it 'parses the response from the parent correctly', ->

    parsedData = list.parse(parentDataToParse)

    console.log 'parsedData: ', parsedData

    for matchMustBe in parentDataToParse[1]

      srcNameMustBe = matchMustBe.src_name
      srcNameGot = matchMustBe.src_name
      expect(srcNameGot).toBe(srcNameMustBe)


