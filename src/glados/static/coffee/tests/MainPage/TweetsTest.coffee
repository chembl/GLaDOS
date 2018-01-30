describe "Tweets", ->

  it 'Sets up the url correctly', ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTweetsList()
    list.initURL()

    urlMustBe = "#{glados.Settings.GLADOS_BASE_PATH_REL}tweets?limit=15&offset=0"
    urlGot = list.url

    expect(urlMustBe).toBe(urlGot)

  sampleDataToParse = undefined

  beforeAll (done) ->

    dataURL = glados.Settings.STATIC_URL + 'testData/MainPage/Tweets/sampleDataToParse.json'
    $.get dataURL, (testData) ->
      sampleDataToParse = testData
      done()

  it 'parses the data correctly', ->
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTweetsList()
    list.initURL()
    parsedDataGot = list.parse(sampleDataToParse)

    tweetIndex = _.indexBy(parsedDataGot, 'id')

    for tweetMustBe in sampleDataToParse.tweets

      tweetGot = tweetIndex[tweetMustBe.id]
      expect(tweetGot?).toBe(true)

      userScreenNameMustBe = tweetMustBe.user.screen_name
      expect(tweetGot.user.screenName).toBe(userScreenNameMustBe)

      userNameMustBe = tweetMustBe.user.name
      expect(tweetGot.user.name).toBe(userNameMustBe)

      userProfileImgMustBe = tweetMustBe.user.profile_image_url
      expect(tweetGot.user.profileImgUrl).toBe(userProfileImgMustBe)



