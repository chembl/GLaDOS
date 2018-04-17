describe 'Blog Entries List', ->

  list = undefined
  sampleDataToParse = undefined

  beforeAll (done) ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBlogEntriesList()
    dataURL = glados.Settings.STATIC_URL + 'testData/MainPage/BlogEntries/sampleDataToParse.json'
    $.get dataURL, (testData) ->
      sampleDataToParse = testData
      done()

  it 'generates initial url', ->

    urlMustBe = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries"
    urlGot = list.initURL()

    expect(urlGot).toBe(urlMustBe)

  it 'parses data correctly', ->

    console.log 'sampleDataToParse: ', sampleDataToParse

    parsedDataGot = list.parse(sampleDataToParse)
    list.setDataAfterParse(parsedDataGot)
    nextPageTokenMustBe = parsedDataGot.nextPageToken
    nextPageTokenGot = list.getNextPageToken()

    console.log 'nextPageTokenGot', nextPageTokenGot
    console.log 'nextPageTokenMustBe', nextPageTokenMustBe

    expect(nextPageTokenGot).toBe(nextPageTokenMustBe)
