describe "Activity", ->

  describe "Activity Model", ->

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

          it 'generates the correct Image', ->

            console.log 'parsed: ', parsed

