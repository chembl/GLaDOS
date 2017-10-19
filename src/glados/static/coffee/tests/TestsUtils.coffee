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

  @pluckFromListItems = (list, propertyName) ->

    if list.allResults?
      return (glados.Utils.getNestedValue(model, propertyName) for model in list.allResults)
    else
      return (glados.Utils.getNestedValue(model.attributes, propertyName) for model in list.models)


  # simulates only the data inside, nothing related with the elasticsearch query,
  # initialises all results list only
  @simulateDataESList = (list, dataURL, done) ->
    $.get dataURL, (testData) ->
      list.allResults = testData
      list.setMeta('total_records', testData.length)
      done()

  @simulateDataModel = (model, dataURL, done) ->
    $.get dataURL, (testData) ->
      model.set(model.parse(testData))
      done()
  # simulates facet groups received for the list
  # it is meant to work only for a ES compound list
  @simulateFacetsESList = (list, dataURL, done) ->

    $.get dataURL, (testData) ->

      for item in testData
        aggData = item.aggData
        firstCall = item.firstCall
        for facetGroupKey, facetGroup of list.getFacetsGroups()

          facetGroup.faceting_handler.parseESResults(aggData, firstCall)

      done()

  @generateListOfRandomValues = (minVal, maxVal) ->

    values = ((Math.random() * (maxVal - minVal)) + minVal  for i in [1..10])
    values.push(minVal)
    values.push(maxVal)
    values = _.shuffle(values)

  @simulateDataMatrix = (matrix, dataURL, done) ->
    $.get dataURL, (testData) ->
      matrix.set('matrix', testData.matrix)
      done()

  @listsAreEqual = (list1, list2) ->

    if list1.length != list2.length
      return false

    for i in [0..list1.length-1]
      item1 = list1[i]
      item2 = list2[i]

      if item1 != item2
        return false

    return true