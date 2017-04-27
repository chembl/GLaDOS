class TestsUtils
  #simulates data for a client side web services paginated collection with the the data in datarURL
  @simulateDataWSClientList = (list, dataURL, done) ->
    $.get dataURL, (testData) ->
      list.reset(testData)
      done()

  @getAllItemsIDs = (list) ->
    #this can be done because of the simulation of data, remember that allResults is not always available for
    # Elasticsearch collections
    if list.allResults?
      return (model.molecule_chembl_id for model in list.allResults)
    else
      return (model.attributes.molecule_chembl_id for model in list.models)

  # simulates only the data inside, nothing related with the elasticsearch query,
  # initialises all results list only
  @simulateDataESList = (list, dataURL, done) ->
    $.get dataURL, (testData) ->
      list.allResults = testData
      list.setMeta('total_records', testData.length)
      done()

  @generateListOfRandomValues = (minVal, maxVal) ->

    values = ((Math.random() * (maxVal - minVal)) + minVal  for i in [1..10])
    values.push(minVal)
    values.push(maxVal)
    values = _.shuffle(values)