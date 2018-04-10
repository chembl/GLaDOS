describe 'Unichem Connectivity List', ->

  list = undefined
  #CHEMBL2296002
  parentInchiKey = 'JJBCTCGUOQYZHK-ZSCHJXSPSA-N'
  parentDataToParse = undefined

  beforeAll (done) ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
    # this will be done directly from the info in the compounds
    list.setInchiKeys
      parent_key: parentInchiKey

    dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/UnichemConnectivity/JJBCTCGUOQYZHK-ZSCHJXSPSA-N_UnichemResponseToParse.json'
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
    matchesGotIndex = _.indexBy(parsedData, 'src_name')
    console.log 'parsedData: ', parsedData
    console.log 'matchesGotIndex: ', matchesGotIndex

    for matchMustBe in parentDataToParse[1]

      nameMustBe = matchMustBe.name_label
      matchGot = matchesGotIndex[nameMustBe]
      mustBeVsGot =
        "#{matchMustBe.name_label}": matchGot.src_name
        "#{matchMustBe.src_URL}": matchGot.scr_url

      for mustBe, got of mustBeVsGot
        expect(got).toBe(mustBe)


