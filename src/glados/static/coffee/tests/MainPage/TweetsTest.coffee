describe "Tweets", ->

  it 'Sets up the url correctly', ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTweetsList()
    list.initURL()

    urlMustBe = "#{glados.Settings.GLADOS_BASE_PATH_REL}tweets?limit=15&offset=0"
    urlGot = list.url

    expect(urlMustBe).toBe(urlGot)

