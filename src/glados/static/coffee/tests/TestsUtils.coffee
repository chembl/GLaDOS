class TestsUtils
    #simulates data for a client side web services paginated collection with the the data in datarURL
    @simulateDataWSClientList = (list, dataURL, done) ->
      $.get dataURL, (testData) ->
        list.reset(testData)
        done()
