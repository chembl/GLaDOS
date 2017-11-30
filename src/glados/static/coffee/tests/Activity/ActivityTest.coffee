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

    testHasMetalContainingImageURL = (response, parsed) ->

      imageURLMustBe = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/metalContaining.svg"
      imgURLGot = parsed.image_url
      expect(imageURLMustBe).toBe(imgURLGot)

    testHasOligosaccharideImageURL = (response, parsed) ->

      imageURLMustBe = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/oligosaccharide.svg"
      imgURLGot = parsed.image_url
      console.log 'imgURLGot: ', imgURLGot
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

        describe "Metal containing (molecule_chembl_id:CHEMBL1985413)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithMetalContainingCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasMetalContainingImageURL(esResponse, parsed)

        describe "Oligosaccharidde (molecule_chembl_id:CHEMBL1201460)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithOligosaccharideCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasOligosaccharideImageURL(esResponse, parsed)

