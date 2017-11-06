describe "Compound", ->

  describe "Compound Model", ->

    #-------------------------------------------------------------------------------------------------------------------
    # Generic Testing functions
    #-------------------------------------------------------------------------------------------------------------------
    testBasicProperties = (response, parsed) ->

      for propKey, propVal of response

        if not popVal?
          expect(parsed[propVal]?).toBe(false)
        else if _.isNumber(popVal) or _.isSring(propVal) or _.isBoolean(propVal)
          expect(response[propVal]).toBe(parsed[propVal])
        # propably later check objects and arrays

    testActivitiesURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      activitiesURLMustBe = Activity.getActivitiesListURL('molecule_chembl_id:' + chemblID)
      expect(parsed.activities_url).toBe(activitiesURLMustBe)

    testSDFURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      sdfURLMustBe = glados.Settings.WS_BASE_URL + 'molecule/' + chemblID + '.sdf'
      expect(parsed.sdf_url).toBe(sdfURLMustBe)

    testRo5Pass = (response, parsed) ->

      ro5Pass = response.molecule_properties.num_ro5_violations == 0
      expect(parsed.ro5).toBe(ro5Pass)

    testReportCardURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      reportCardURLMustBe = Compound.get_report_card_url(chemblID)
      expect(parsed.report_card_url).toBe(reportCardURLMustBe)

    testRelatedTargetsURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      urlMustBe = Target.getTargetsListURL('_metadata.related_compounds.chembl_ids.\\*:' + chemblID)
      expect(parsed.targets_url).toBe(urlMustBe)

    testHasNormalImageURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      imageURLMustBe = glados.Settings.WS_BASE_URL + 'image/' + chemblID + '.svg?engine=indigo'
      expect(parsed.image_url).toBe(imageURLMustBe)

    #-------------------------------------------------------------------------------------------------------------------
    # Specific cases
    #-------------------------------------------------------------------------------------------------------------------
    describe "Loaded From Web Services", ->

      chemblID = 'CHEMBL25'
      compound = new Compound
        molecule_chembl_id: chemblID
      wsResponse = undefined
      parsed = undefined

      beforeAll (done) ->

        dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL25wsResponse.json'
        $.get dataURL, (testData) ->
          wsResponse = testData
          parsed = compound.parse(wsResponse)
          done()

      it 'generates the web services url', ->

        urlMustBe = glados.Settings.WS_BASE_URL + 'molecule/' + chemblID + '.json'
        expect(compound.url).toBe(urlMustBe)

      it 'parses the basic information received from web services', -> testBasicProperties(wsResponse, parsed)
      it 'parses the activities URL', -> testActivitiesURL(wsResponse, parsed)
      it 'parses the sdf URL', -> testSDFURL(wsResponse, parsed)
      it 'parses Rule of 5 pass', -> testRo5Pass(wsResponse, parsed)
      it 'parses the report card url', -> testReportCardURL(wsResponse, parsed)
      it 'parses the related targets url', -> testRelatedTargetsURL(wsResponse, parsed)
      it 'parses a normal image url', -> testHasNormalImageURL(wsResponse, parsed)

      describe 'Metal Containing Compound', ->

        
        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL25wsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correctImage', ->




    describe "Loaded From Elastic Search", ->

      compound = new Compound
        molecule_chembl_id: 'CHEMBL25'
        fetch_from_elastic: true

      it 'parses the data from elastic correctly', ->



