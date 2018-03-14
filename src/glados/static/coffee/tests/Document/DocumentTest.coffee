describe 'Document', ->

  #-------------------------------------------------------------------------------------------------------------------
  # From Web services
  #-------------------------------------------------------------------------------------------------------------------
  describe 'Loaded from web services', ->

    chemblID = 'CHEMBL1614631'
    document = new Document
      document_chembl_id: chemblID
      fetch_from_elastic: false

    wsResponse = undefined
    parsed = undefined

    beforeAll (done) ->

      dataURL = glados.Settings.STATIC_URL + 'testData/Documents/CHEMBL1614631wsResponse.json'
      $.get dataURL, (testData) ->
        wsResponse = testData
        parsed = document.parse(wsResponse)
        done()


    it 'generates the web services url', ->

      urlMustBe = glados.Settings.WS_BASE_URL + 'document/' + chemblID + '.json'
      expect(document.url).toBe(urlMustBe)
