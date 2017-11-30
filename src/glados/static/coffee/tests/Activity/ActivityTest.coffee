describe "Activity", ->

  describe "Activity Model", ->

    #-------------------------------------------------------------------------------------------------------------------
    # Generic Testing functions
    #-------------------------------------------------------------------------------------------------------------------
    testHasNormalImageURL = (response, parsed) ->

      moleculeChemblID = parsed.molecule_chembl_id
      imageURLMustBe = "#{glados.Settings.WS_BASE_URL}image/#{moleculeChemblID}.svg?engine=indigo"
      imgURLGot = parsed.image_url
      expect(imageURLMustBe).toBe(imgURLGot)

    #-------------------------------------------------------------------------------------------------------------------
    # From Elasticsearch
    #-------------------------------------------------------------------------------------------------------------------
    describe "Loaded From Elastic Search", ->

      activity = new Activity

      esResponse = undefined
      parsed = undefined

      describe "Images", ->

        describe "Normal image", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithNormalImageSampleESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasNormalImageURL(esResponse, parsed)

