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

    #-------------------------------------------------------------------------------------------------------------------
    # Specific cases
    #-------------------------------------------------------------------------------------------------------------------
    describe "Loaded From Web Services", ->

      chemblID = 'CHEMBL25'
      compound = new Compound
        molecule_chembl_id: chemblID
      wsResponse = undefined

      beforeAll (done) ->

        dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL25wsResponse.json'
        $.get dataURL, (testData) ->
          wsResponse = testData
          done()

      it 'generates the web services url', ->

        urlMustBe = glados.Settings.WS_BASE_URL + 'molecule/' + chemblID + '.json'
        expect(compound.url).toBe(urlMustBe)

      it 'parses the basic information received from web services', ->

        parsed = compound.parse(wsResponse)
        testBasicProperties(wsResponse, parsed)

    describe "Loaded From Elastic Search", ->

      compound = new Compound
        molecule_chembl_id: 'CHEMBL25'
        fetch_from_elastic: true

      it 'parses the data from elastic correctly', ->



