describe "Activity", ->

  describe "Activity Model", ->

    #-------------------------------------------------------------------------------------------------------------------
    # Generic Testing functions
    #-------------------------------------------------------------------------------------------------------------------
    testHasNormalImageURL = (response, parsed) ->

      moleculeChemblID = parsed.molecule_chembl_id
      imageURLMustBe = "#{glados.Settings.WS_BASE_URL}image/#{moleculeChemblID}.svg"
      imgURLGot = parsed.image_url
      expect(imageURLMustBe).toBe(imgURLGot)

    testHasSpecialImageURL = (response, parsed, imageFileMustBe) ->

      imageURLMustBe = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/#{imageFileMustBe}"
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

        describe "Metal containing (molecule_chembl_id:CHEMBL1985413)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithMetalContainingCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'metalContaining.svg')

        describe "Oligosaccharidde (molecule_chembl_id:CHEMBL1201460)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithOligosaccharideCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'oligosaccharide.svg')

        describe "Natural Product (molecule_chembl_id:CHEMBL1201469)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithNaturalProductImageESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'naturalProduct.svg')

        describe "Small Molecule Polymer (molecule_chembl_id:CHEMBL2108139)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithSmallMolPolymerCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'smallMolPolymer.svg')

        describe "Small Molecule (molecule_chembl_id:CHEMBL3527276)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithSmallMolCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'smallMolecule.svg')

        describe "Antibody (molecule_chembl_id:CHEMBL1201580)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithAntibodyCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'antibody.svg')

        describe "Pepetide (molecule_chembl_id:CHEMBL1201866)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithPepetideCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'peptide.svg')

        # there are no activities with oligonulceotide image
        describe "Enzyme (molecule_chembl_id:CHEMBL2108147)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithEnzymeCompESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'enzyme.svg')

        # there are no activities with cell image
        describe "Unknown (molecule_chembl_id:CHEMBL1909064)", ->

          beforeAll (done) ->

            dataURL = glados.Settings.STATIC_URL +
              'testData/Activity/Images/activityWithUnknownImageESResponse.json'
            $.get dataURL, (testData) ->
              esResponse = testData
              parsed = activity.parse(esResponse)
              done()

          it 'generates the correct Image', -> testHasSpecialImageURL(esResponse, parsed, 'unknown.svg')


