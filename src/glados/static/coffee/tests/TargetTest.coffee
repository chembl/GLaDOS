describe "Target", ->

  describe "Target Model", ->

    #-------------------------------------------------------------------------------------------------------------------
    # Generic Testing functions
    #-------------------------------------------------------------------------------------------------------------------
    testProteinTargetClassification = (target) ->

      classification = target.get('protein_classifications')
      class1 = classification[8][0]
      class2 = classification[601][0]
      expect(class1).toBe('Other cytosolic protein')
      expect(class2).toBe('Unclassified protein')

    testActivitiesURL = (response, parsed) ->

      chemblID = response.target_chembl_id
      activitiesURLMustBe = Activity.getActivitiesListURL('target_chembl_id:' + chemblID)
      expect(parsed.activities_url).toBe(activitiesURLMustBe)

    testCompoundsURL = (response, parsed) ->

      chemblID = response.target_chembl_id
      urlMustBe = Compound.getCompoundsListURL('_metadata.related_targets.all_chembl_ids:' + chemblID)
      expect(parsed.compounds_url).toBe(urlMustBe)

    testReportCardURL = (response, parsed) ->

      chemblID = response.target_chembl_id
      urlMustBe = Target.get_report_card_url(chemblID)
      expect(parsed.report_card_url).toBe(urlMustBe)

    #-------------------------------------------------------------------------------------------------------------------
    # From Web services
    #-------------------------------------------------------------------------------------------------------------------
    describe "Loaded From Web Services", ->

      chemblID = 'CHEMBL2363965'
      target = new Target
          target_chembl_id: chemblID
          fetch_from_elastic: false

      # TODO: this needs to be replaced with a better tests which does not depend on the server
#      beforeAll (done) ->
#        target.fetch()
#
#        # this timeout is to give time to get the
#        # target classification information, it happens after the fetch,
#        # there is a way to know that it loaded at least one classification: get('protein_classifications_loaded')
#        # but there is no way to know that it loaded all the classifications.
#        setTimeout ( ->
#          done()
#        ), 10000

      wsResponse = undefined
      parsed = undefined

      beforeAll (done) ->

        dataURL = glados.Settings.STATIC_URL + 'testData/Targets/CHEMBL2363965-WS-Response.json'
        $.get dataURL, (testData) ->
          wsResponse = testData
          parsed = target.parse(wsResponse)
          done()

      it 'generates the web services url', ->

        urlMustBe = glados.Settings.WS_BASE_URL + 'target/' + chemblID + '.json'
        expect(target.url).toBe(urlMustBe)

      # TODO: this needs to be replaced with a better tests which does not depend on the server
#      it "(SERVER DEPENDENT) loads the protein target classification", -> testProteinTargetClassification(target)
      it 'parses the activities URL', -> testActivitiesURL(wsResponse, parsed)
      it 'parses the compounds URL', -> testCompoundsURL(wsResponse, parsed)
      it 'parses the report card URL', -> testReportCardURL(wsResponse, parsed)


    #-------------------------------------------------------------------------------------------------------------------
    # From Elasticsearch
    #-------------------------------------------------------------------------------------------------------------------
    describe "Loaded From Elasticsearch", ->

      chemblID = 'CHEMBL2363965'
      target = new Target
          target_chembl_id: chemblID
          fetch_from_elastic: true

#      beforeAll (done) ->
#        target.fetch()
#
#        # this timeout is to give time to get the
#        # target classification information, it happens after the fetch,
#        # there is a way to know that it loaded at least one classification: get('protein_classifications_loaded')
#        # but there is no way to know that it loaded all the classifications.
#        setTimeout ( ->
#          done()
#        ), 10000

      esResponse = undefined
      parsed = undefined

      beforeAll (done) ->

        dataURL = glados.Settings.STATIC_URL + 'testData/Targets/CHEMBL2363965-ES-Response.json'
        $.get dataURL, (testData) ->
          esResponse = testData
          parsed = target.parse(esResponse)
          done()

      it 'generates the elasticsearch url', ->

        urlMustBe = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/'+settings.CHEMBL_ES_INDEX_PREFIX+'target/_doc/' + chemblID
        expect(target.url).toBe(urlMustBe)

      # TODO: this needs to be replaced with a better tests which does not depend on the server
#      it "(SERVER DEPENDENT) loads the protein target classification", -> testProteinTargetClassification(target)
      it 'parses the activities URL', -> testActivitiesURL(esResponse._source, parsed)
      it 'parses the compounds URL', -> testCompoundsURL(esResponse._source, parsed)
      it 'parses the report card URL', -> testReportCardURL(esResponse._source, parsed)

