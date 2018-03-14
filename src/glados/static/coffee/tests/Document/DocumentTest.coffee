describe 'Document Model', ->

  #-------------------------------------------------------------------------------------------------------------------
  # Generic Testing functions
  #-------------------------------------------------------------------------------------------------------------------
  testBasicProperties = (response, parsed) ->

    TestsUtils.expectObjectsAreEqual(response, parsed)

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

    it 'parses the basic information received from web services', -> testBasicProperties(wsResponse, parsed)

  #-------------------------------------------------------------------------------------------------------------------
  # From Elasticsearch
  #-------------------------------------------------------------------------------------------------------------------
  describe "Loaded From Elastic Search", ->

    chemblID = 'CHEMBL1614631'
    document = new Document
      document_chembl_id: chemblID
      fetch_from_elastic: true

    esResponse = undefined
    parsed = undefined

    beforeAll (done) ->

      dataURL = glados.Settings.STATIC_URL + 'testData/Documents/CHEMBL1614631esResponse.json'
      $.get dataURL, (testData) ->
        esResponse = testData
        parsed = document.parse(esResponse)
        done()

    it 'generates the elasctisearch url', ->

      urlMustBe = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_document/document/' + chemblID
      expect(document.url).toBe(urlMustBe)
