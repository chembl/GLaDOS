class TestsUtils
  #simulates data for a client side web services paginated collection with the the data in datarURL
  @simulateDataWSClientList = (list, dataURL, done) ->
    $.get dataURL, (testData) ->
      list.reset(testData)
      done()

  @getAllItemsIDs = (list, idProperty='molecule_chembl_id') ->
    #this can be done because of the simulation of data, remember that allResults is not always available for
    # Elasticsearch collections
    if list.allResults?
      return (model[idProperty] for model in list.allResults)
    else
      return (model.attributes[idProperty] for model in list.models)

  @pluckFromListItems = (list, propertyName) ->

    if list.allResults?
      return (glados.Utils.getNestedValue(model, propertyName) for model in list.allResults)
    else
      return (glados.Utils.getNestedValue(model.attributes, propertyName) for model in list.models)


  # simulates only the data inside, nothing related with the elasticsearch query,
  @simulateDataESList = (list, dataURL, done) ->

    $.get dataURL, (testData) ->

      if testData.hits?
        rawModels = (h._source for h in testData.hits.hits)
      else
        rawModels = testData

      list.allResults = rawModels

      list.setMeta('total_records', rawModels.length)
      Entity = list.getMeta('model')
      models = (new Entity(Entity.prototype.parse(result)) for result in rawModels)

      list.reset(models)
      done()

  @simulateDataModel = (model, dataURL, done) ->
    $.get dataURL, (testData) ->
      model.set(model.parse(testData))
      done()
  # simulates facet groups received for the list
  # it is meant to work only for a ES compound list
  @simulateFacetsESList = (list, dataURL, done) ->

    return $.get dataURL, (testData) ->

      for item in testData
        aggData = item.aggData
        firstCall = item.firstCall
        for facetGroupKey, facetGroup of list.getFacetsGroups()

          facetGroup.faceting_handler.parseESResults(aggData, firstCall)
      list.setFacetsFetchingState(glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.FACETS_READY)
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

    for property in ['settings_path', 'custom_query', 'use_custom_query', 'esSearchQuery', 'sticky_query',
      'esSearchQuery', 'search_term', 'contextual_properties', 'generator_items_list']

      oldValue = list.getMeta(property)
      newValue = list2.getMeta(property)

      if _.isObject(oldValue)
        expect(_.isEqual(oldValue, newValue)).toBe(true)
      else
        expect(oldValue).toBe(newValue)

    facetGroupsMustBe = list.getFacetsGroups()

    facetGroupsGot = list2.getFacetsGroups()
    facetsState = state.facets_state

    if not facetsState?
      return
    for facetGroupKey, fGroup of facetGroupsGot

      facetingHandler = fGroup.faceting_handler
      facetingHandlerStateGot = facetingHandler.getStateJSON()

      originalFacetingHandler = facetGroupsMustBe[facetGroupKey].faceting_handler
      facetingHandlerStateMustBe = originalFacetingHandler.getStateJSON()

      expect(_.isEqual(facetingHandlerStateGot, facetingHandlerStateMustBe)).toBe(true)

  @testSavesList = (list, pathInSettingsMustBe, queryStringMustBe="*", useQueryStringMustBe=false, stickyQueryMustBe,
    esSearchQueryMustBe, searchTermMustBe, contextualColumnsMustBe, generatorListMustBe)->

    state = list.getStateJSON()

    expect(state.settings_path).toBe(pathInSettingsMustBe)
    expect(state.custom_query).toBe(queryStringMustBe)
    expect(state.use_custom_query).toBe(useQueryStringMustBe)

    stickyQueryGot = state.sticky_query
    expect(_.isEqual(stickyQueryGot, stickyQueryMustBe)).toBe(true)
    expect(_.isEqual(state.searchESQuery, esSearchQueryMustBe)).toBe(true)

    expect(state.search_term).toBe(searchTermMustBe)

    contextualColumnsGot = state.contextual_properties
    expect(_.isEqual(contextualColumnsGot, contextualColumnsMustBe)).toBe(true)

    generatorListGot = state.generator_items_list
    expect(_.isEqual(generatorListGot, generatorListMustBe)).toBe(true)

    facetsStateGot = state.facets_state
    originalFacetGroups = list.getFacetsGroups()

    if facetsStateGot?
      for fGroupKey, fGroupState of facetsStateGot
        originalFacetingHandler = originalFacetGroups[fGroupKey].faceting_handler

        fGroupStateMustBe = originalFacetingHandler.getStateJSON()
        expect(_.isEqual(fGroupState, fGroupStateMustBe)).toBe(true)

  @testIteratesPages = (esList, pageSize, totalPages) ->

    for pageNumber in [1..totalPages]
      requestData = esList.setPage(pageNumber, doFetch=true, testMode=true)
      expect(requestData['from']).toBe(pageSize * (pageNumber - 1))
      expect(requestData['size']).toBe(pageSize)

  @testIteratesPagesWithDifferentPageSizes = (esList, totalRecords) ->
    esList.setMeta('total_records', totalRecords)

    for pageSize in [1..totalRecords]
      esList.setMeta('page_size', pageSize)
      totalPages = Math.ceil(totalRecords / pageSize)
      esList.setMeta('total_pages', totalPages)
      TestsUtils.testIteratesPages(esList, pageSize, totalPages)