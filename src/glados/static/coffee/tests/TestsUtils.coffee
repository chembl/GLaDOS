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
        console.log item1, ' is different from ', item2
        return false

    return true

  @expectObjectsAreEqual = (response, parsed) ->

    for propKey, propVal of response

      if not popVal?
        expect(parsed[propVal]?).toBe(false)
      else if _.isNumber(popVal) or _.isSring(propVal) or _.isBoolean(propVal)
        expect(response[propVal]).toBe(parsed[propVal])
      # propably later check objects and arrays

  @testRestoredListIsEqualToOriginal = (list) ->

    state = list.getStateJSON()
    list2 = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFromState(state)

    for property in ['settings_path', 'custom_query_string', 'use_custom_query_string', 'esSearchQuery', 'sticky_query',
      'esSearchQuery', 'search_term', 'contextual_properties', 'generator_items_list']

      oldValue = list.getMeta(property)
      newValue = list2.getMeta(property)

      if _.isObject(oldValue)
        expect(_.isEqual(oldValue, newValue)).toBe(true)
      else
        expect(oldValue).toBe(newValue)

  @testSavesList = (list, pathInSettingsMustBe, queryStringMustBe="*", useQueryStringMustBe=false, stickyQueryMustBe,
    esSearchQueryMustBe, searchTermMustBe, contextualColumnsMustBe, generatorListMustBe, facetsStateMustBe)->

    state = list.getStateJSON()

    expect(state.settings_path).toBe(pathInSettingsMustBe)
    expect(state.custom_query_string).toBe(queryStringMustBe)
    expect(state.use_custom_query_string).toBe(useQueryStringMustBe)

    stickyQueryGot = state.sticky_query
    expect(_.isEqual(stickyQueryGot, stickyQueryMustBe)).toBe(true)
    expect(_.isEqual(state.esSearchQuery, esSearchQueryMustBe)).toBe(true)

    expect(state.search_term).toBe(searchTermMustBe)

    contextualColumnsGot = state.contextual_properties
    expect(_.isEqual(contextualColumnsGot, contextualColumnsMustBe)).toBe(true)

    generatorListGot = state.generator_items_list
    expect(_.isEqual(generatorListGot, generatorListMustBe)).toBe(true)

    facetsStateGot = state.facets_state
    expect(_.isEqual(facetsStateGot, facetsStateMustBe)).toBe(true)