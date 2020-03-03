describe 'Document Model', ->

  #-------------------------------------------------------------------------------------------------------------------
  # Generic Testing functions
  #-------------------------------------------------------------------------------------------------------------------
  testBasicProperties = (response, parsed) ->

    TestsUtils.expectObjectsAreEqual(response, parsed)

  testActivitiesURL = (response, parsed) ->

    chemblID = response.document_chembl_id
    activitiesURLMustBe = Activity.getActivitiesListURL('document_chembl_id:' + chemblID)
    expect(parsed.activities_url).toBe(activitiesURLMustBe)

  testReportCardURL = (response, parsed) ->

    chemblID = response.document_chembl_id
    activitiesURLMustBe = Document.get_report_card_url(chemblID)
    expect(parsed.report_card_url).toBe(activitiesURLMustBe)

  testCompoundsURL = (response, parsed) ->

    chemblID = response.document_chembl_id
    compoundsURLMustBe = Compound.getCompoundsListURL('_metadata.related_documents.all_chembl_ids:' + chemblID)
    expect(parsed.compounds_url).toBe(compoundsURLMustBe)
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
    it 'parses the activities URL', -> testActivitiesURL(wsResponse, parsed)
    it 'parses the report card URL', -> testReportCardURL(wsResponse, parsed)
    it 'parses the compounds URL', -> testCompoundsURL(wsResponse, parsed)

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

      urlMustBe = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/'+glados.Settings.CHEMBL_ES_INDEX_PREFIX+'document/_doc/' + chemblID
      expect(document.url).toBe(urlMustBe)

    it 'parses the basic information received from elastic', -> testBasicProperties(esResponse._source, parsed)
    it 'parses the activities URL', -> testActivitiesURL(esResponse._source, parsed)
    it 'parses the report card URL', -> testReportCardURL(esResponse._source, parsed)
