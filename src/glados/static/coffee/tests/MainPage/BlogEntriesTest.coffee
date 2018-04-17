describe 'Blog Entries List', ->

  list = undefined
  sampleData = undefined

  beforeAll (done) ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBlogEntriesList()
    dataURL = glados.Settings.STATIC_URL + 'testData/MainPage/BlogEntries/sampleDataToParse.json'
    $.get dataURL, (testData) ->
      sampleData = testData
      done()

  beforeEach ->
    list.reset()

  it 'generates initial url', ->

    urlMustBe = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries"
    urlGot = list.initURL()
    expect(urlGot).toBe(urlMustBe)

    urlGot = list.getPaginatedURL()
    expect(urlGot).toBe(urlMustBe)

  it "generates url for next page", ->

    list.setDataFromResponse(sampleData)

    paginatedUrlMustBe = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries/#{sampleData.nextPageToken}"
    paginatedUrlGot = list.getPaginatedURL()

    console.log 'paginatedUrlMustBe: ', paginatedUrlMustBe
    console.log 'paginatedUrlGot: ', paginatedUrlGot

    expect(paginatedUrlGot).toBe(paginatedUrlMustBe)




  it 'saves next page token after receiving data', ->

    list.setDataFromResponse(sampleData)

    nextPageTokenMustBe = sampleData.nextPageToken
    nextPageTokenGot = list.getNextPageToken()

    expect(nextPageTokenGot).toBe(nextPageTokenMustBe)

  it 'loads new items correctly', ->

    list.setDataFromResponse(sampleData)

    blogEntriesMustBe = sampleData.entries

    for entryMustBe in blogEntriesMustBe

      titleMustBe = entryMustBe.title

      entryGot = list.findWhere { title: titleMustBe }
      expect(entryGot?).toBe(true)



