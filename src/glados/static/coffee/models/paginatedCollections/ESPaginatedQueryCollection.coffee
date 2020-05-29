glados.useNameSpace 'glados.models.paginatedCollections',

  # --------------------------------------------------------------------------------------------------------------------
  # This class implements the pagination, sorting and searching for a collection in ElasticSearch
  # extend it to get a collection with the extra capabilities
  # --------------------------------------------------------------------------------------------------------------------
  ESPaginatedQueryCollection:
    # ------------------------------------------------------------------------------------------------------------------
    # Backbone Override
    # ------------------------------------------------------------------------------------------------------------------

    errorHandler: (collection, response, options)->
      @resetMeta(0, 0)
      @reset()

    # ------------------------------------------------------------------------------------------------------------------
    # State handling
    # ------------------------------------------------------------------------------------------------------------------
    loadStateForSearchList: (stateObject) ->

      queryString = stateObject.custom_query
      useQueryString = stateObject.use_custom_query
      searchESQuery = stateObject.searchESQuery
      stickyQuery = stateObject.sticky_query
      itemsList = stateObject.generator_items_list
      contextualProperties = stateObject.contextual_properties
      searchTerm = stateObject.search_term

      @setMeta('custom_query', queryString)
      @setMeta('use_custom_query', useQueryString)
      @setMeta('searchESQuery', searchESQuery)
      @setMeta('sticky_query', stickyQuery)
      @setMeta('generator_items_list', itemsList)
      @setMeta('contextual_properties', contextualProperties)
      @setMeta('search_term', searchTerm)
      @setMeta('at_least_one_facet_is_selected', stateObject.at_least_one_facet_is_selected)

      facetGroups = @getFacetsGroups()
      facetsState = stateObject.facets_state

      if facetsState?
        for fGroupKey, fGroupState of facetsState

          originalFGroupState = facetsState[fGroupKey]
          if not facetGroups[fGroupKey]?
            continue
          facetingHandler = facetGroups[fGroupKey].faceting_handler
          facetingHandler.loadState(originalFGroupState)
          @setMeta('skip_clean_up_once', true)


    # ------------------------------------------------------------------------------------------------------------------
    # Parse/Fetch Collection data
    # ------------------------------------------------------------------------------------------------------------------
    simplifyHighlights: (highlights)->
      gs_data = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[@getMeta('index_name')]
      simplifiedHL = {}
      for propPath in _.keys(highlights)
        hlData = highlights[propPath]
        for suffixJ in glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_SUFFIXES_TO_REMOVE
          if suffixJ instanceof RegExp
            propPath = propPath.replace suffixJ, ''
          else if propPath.endsWith suffixJ
            propPath = propPath.replace new RegExp('\.'+suffixJ+'$'), ''
        if not _.has simplifiedHL, propPath
          simplifiedHL[propPath] = {}
        for hlK in hlData
          simpleHlK = hlK.replace(
            new RegExp(
              glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG_REGEX_ESCAPED, 'g'
            ), ''
          )
          simpleHlK = simpleHlK.replace(
            new RegExp(
              glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG_REGEX_ESCAPED, 'g'
            ), ''
          )
          included = false
          _.each _.keys(simplifiedHL[propPath]), (keyJ, indexJ, keysList) ->
            included |= keyJ.includes(simpleHlK) or simpleHlK.includes(keyJ)
          if not included
            simplifiedHL[propPath][simpleHlK] = hlK
      for propPath in _.keys(simplifiedHL)
        maxValueLength = 0
        _.each _.values(simplifiedHL[propPath]), (valueJ, indexJ, valuesList) ->
          if valueJ.length > 0
            maxValueLength = valueJ.length

        joinStr = ', '
        if maxValueLength > glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_MAX_WORD_LENGTH * 10
          joinStr = ' .... '

        label = propPath
        label_mini = propPath
        if gs_data[propPath]?
          label = django.gettext(gs_data[propPath].label_id)
          label_mini = django.gettext(gs_data[propPath].label_mini_id)


        hlValue =  Array.from(_.values(simplifiedHL[propPath])).join(joinStr)
        miniHLValue = hlValue
        if hlValue.length > glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_MAX_WORD_LENGTH * 10
          firstSimplified = _.keys(simplifiedHL[propPath])[0].trim()
          firstComplete = _.values(simplifiedHL[propPath])[0].trim()
          startsHighlighted = firstComplete.startsWith(
            glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG
          )
          endsHighlighted = firstComplete.startsWith(
            glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG
          )

          simpleHlKWords = firstSimplified.split(/([^a-zA-Z0-9]|\s)/)

          firstWord = simpleHlKWords[0]
          firstWord = firstWord.substring(
            -1, glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_MAX_WORD_LENGTH
          )
          if startsHighlighted
            firstWord = glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG + firstWord +
              glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG

          lastWord = simpleHlKWords[simpleHlKWords.length - 1]
          lastWord = lastWord.substring(
            -1, glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_MAX_WORD_LENGTH
          )
          if endsHighlighted
            lastWord = glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG + lastWord +
              glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG

          tagIdx = firstComplete.indexOf(
            glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG
          ) + glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG.length
          closeTagIdx = firstComplete.indexOf(
            glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG
          )
          firstTag = firstComplete.substring(
            tagIdx, closeTagIdx
          )

          firstTag = firstTag.substring(
            -1, glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_MAX_WORD_LENGTH
          )

          firstTag = glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG + firstTag +
            glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG

          tagCount = (firstComplete.match(new RegExp(
              glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG_REGEX_ESCAPED, 'g'
            ), ''
          ) || []).length

          miniHLValue = firstWord + ' ... ' + firstTag + ' ...'
          if tagCount == 1 and (startsHighlighted or endsHighlighted)
            miniHLValue = firstWord + ' ... ' + lastWord
          if tagCount == 2 and (startsHighlighted and endsHighlighted)
            miniHLValue = firstWord + ' ... ' + lastWord

        simplifiedHL[propPath] = {
          value_mini: miniHLValue
          value: hlValue
          label: label
          label_mini: label_mini
          active_tooltip: miniHLValue != hlValue
        }
      return simplifiedHL

    # Parses the Elastic Search Response and resets the pagination metadata
    parse: (response) ->

      data = response.es_response

      lastPageResultsIds = null
      lastPageResultsIds = @getMeta('last_page_results_ids')
      if not lastPageResultsIds?
        lastPageResultsIds = {}
      curPageResultsIds = {}

      @resetMeta(data.hits.total.value, data.hits.max_score)
      @setMeta('data_loaded', true)
      jsonResultsList = []

      ItemsModel = @getMeta('model')
      idAttribute = ItemsModel.ID_COLUMN.comparator
      scores = @getMeta('scores')

      pageChanged = false
      for hitI in data.hits.hits
        if not _.has(lastPageResultsIds, hitI._id)
          pageChanged = true

        currentItemData = hitI._source
        idValue = glados.Utils.getNestedValue(currentItemData, idAttribute)

        parsingModel = new ItemsModel
          id: idValue

        hitI = parsingModel.parse(hitI)
        curPageResultsIds[hitI._id] = true

        currentItemData._highlights = if hitI.highlight? then @simplifyHighlights(hitI.highlight) else null
        currentItemData._score = hitI._score

        if not currentItemData._score? and scores?
          currentItemData._score = scores[currentItemData[idAttribute]]

        if @getMeta('enable_similarity_maps')
          currentItemData.enable_similarity_map = @getMeta('enable_similarity_maps')
          currentItemData.reference_smiles = @getMeta('reference_smiles')
          currentItemData.reference_smiles_error = @getMeta('reference_smiles_error')
          currentItemData.reference_smiles_error_jqxhr = @getMeta('reference_smiles_error_jqxhr')

        if @getMeta('enable_substructure_highlighting')
          currentItemData.enable_substructure_highlighting = @getMeta('enable_substructure_highlighting')
          currentItemData.reference_smiles = @getMeta('reference_smiles')
          currentItemData.reference_ctab = @getMeta('reference_ctab')
          currentItemData.reference_smarts = @getMeta('reference_smarts')
          currentItemData.reference_smiles_error = @getMeta('reference_smiles_error')
          currentItemData.reference_smiles_error_jqxhr = @getMeta('reference_smiles_error_jqxhr')

        jsonResultsList.push(currentItemData)
      if not pageChanged
        pageChanged = _.keys(lastPageResultsIds).length != _.keys(curPageResultsIds).length
      @setMeta('page_changed', pageChanged)

      @setMeta('last_page_results_ids', curPageResultsIds)

      #if this causes problems this can be moved to a custom reset function
      @setItemsFetchingState(glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.ITEMS_READY)

      if @searchQueryIsSet()
        @setSearchState(glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_IS_READY)

      return jsonResultsList

    fetchFacetsDescription: ->

      alert('FETCH FACETS CONFIG!')

    fetchColumnsDescription: ->
      @setConfigState(
        glados.models.paginatedCollections.PaginatedCollectionBase.CONFIGURATION_FETCHING_STATES.FETCHING_CONFIGURATION
      )

      thisCollection = @
      descriptionPromise = new Promise((resolve, reject) ->

        configGroups = thisCollection.getMeta('config_groups')
        totalGroupsToLoad = Object.keys(configGroups).length

        numLoadedGroups = 0
        propertiesConfigModels = {}
        for viewKey, groupName of configGroups

          propertiesConfigModel = new glados.models.paginatedCollections.esSchema.PropertiesConfigurationModel
            index_name: thisCollection.getMeta('index_name')
            group_name: groupName
            entity: thisCollection.getMeta('model')

          propertiesConfigModels[viewKey] = propertiesConfigModel

          propertiesConfigModel.on('error', (model, jqXHR) -> reject(jqXHR))
          propertiesConfigModel.once('change:parsed_configuration', ->
            numLoadedGroups++
            if numLoadedGroups == totalGroupsToLoad

              thisCollection.loadConfigFromFetchedModels(propertiesConfigModels)
              thisCollection.setConfigState(
                glados.models.paginatedCollections.PaginatedCollectionBase.CONFIGURATION_FETCHING_STATES.CONFIGURATION_READY
              )
              resolve('success')
          )
          unless thisCollection.getMeta('test_mode')
            propertiesConfigModel.fetch()

      )
      return descriptionPromise

    loadConfigFromFetchedModels: (propertiesConfigModels) ->

      columnsDescription = {}
      propsComparatorsSet = {}
      comparatorsForTextFilterSet = {}
      allColumns = []

      for viewKey, configModel of propertiesConfigModels
        columnsDescription[viewKey] = configModel.get('parsed_configuration')
        newPropsComparators = configModel.get('props_comparators_set')
        currentComparatorsForTextFilter = configModel.get('comparators_for_text_filter_set')
        currentAllColumns = configModel.get('all_columns')

        for column in currentAllColumns
          propId = column.prop_id
          if not propsComparatorsSet[propId]
            allColumns.push(column)

        for key, value of newPropsComparators
          propsComparatorsSet[key] = key

        for key, value of currentComparatorsForTextFilter
          comparatorsForTextFilterSet[key] = key

      @setMeta('columns', allColumns)
      @setMeta('columns_description', columnsDescription)
      @setMeta('props_comparators_set', propsComparatorsSet)
      @setMeta('comparators_for_text_filter_set', comparatorsForTextFilterSet)
      @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.COLUMNS_CONFIGURATION_LOADED)

    fetch: (options, testMode=false) ->

      testMode |= @getMeta('test_mode')
      if testMode or @configIsReady()
        return @fetchData(options, testMode)

      descriptionPromise = @fetchColumnsDescription()

      thisCollection = @
      descriptionPromise.then( ->
        thisCollection.fetchData(options, testMode=false)
      ).catch( (jqXHR) ->
        thisCollection.trigger('error', thisCollection, jqXHR)
      )

      facetsDescriptionPromise = @fetchFacetsDescription()

    # Prepares an Elastic Search query to search in all the fields of a document in a specific index
    fetchData: (options, testMode=false) ->

      testMode |= @getMeta('test_mode')
      @trigger('before_fetch_elastic')
      @url = @getURL()

      if @getMeta('facets_changed')
        @resetCache() unless not @getMeta('enable_collection_caching')
        @invalidateAllDownloadedResults()
        @unSelectAll()
        @setMeta('current_page', 1)
        @setMeta('facets_changed', false)

      @setItemsFetchingState(
        glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.FETCHING_ITEMS
      )
      # Creates the Elastic Search Query parameters and serializes them
      esCacheRequestData = @getESRequestData()

      unless testMode

        fetchURL = glados.Settings.ES_PROXY_ES_DATA_URL
        fetchPromise = $.post(fetchURL, esCacheRequestData)
        thisCollection = @

        fetchPromise.then (data) -> thisCollection.reset(thisCollection.parse(data))
        fetchPromise.fail (jqXHR) -> thisCollection.trigger('error', thisCollection, jqXHR)

        @loadFacetGroups(@getRequestData())

      return esCacheRequestData

    # ------------------------------------------------------------------------------------------------------------------
    # Elastic Search Query structure
    # ------------------------------------------------------------------------------------------------------------------
    
    # given a list of chembl ids, it gives the request data to query for only those ids
    getRequestDataForChemblIDs: (page, pageSize, idsList) ->

      idPropertyName = @getMeta('id_column').comparator
      query =
        terms: {}
      query.terms[idPropertyName] = idsList
      return {
        size: pageSize,
        from: ((page - 1) * pageSize)
        query: query
        track_total_hits: true
      }

    getQueryForGeneratorList: ->

      idAttribute = @getMeta('model').ID_COLUMN.comparator
      idsList = @getMeta('generator_items_list')
      query_fgl = {
        terms: {}
      }
      query_fgl.terms[idAttribute] = idsList

      return {
        filter_query:
          query_fgl
      }

    customQueryIsFullQuery: ->

      customQuery = @getMeta('custom_query')
      try
        JSON.parse(customQuery)
        return true
      catch error
        return false

    # ------------------------------------------------------------------------------------------------------------------
    # Request data
    # ------------------------------------------------------------------------------------------------------------------
    getESRequestData: (customPage, customPageSize) ->
      # Request to get the data of the items of the page

      ssSearchModel = @getMeta('sssearch_model')
      cacheRequestData =
        index_name: @getMeta('index_name')
        es_query: JSON.stringify(@getRequestData(customPage, customPageSize))
        contextual_sort_data: JSON.stringify(@getContextualSortingProperties())
        context_obj: if ssSearchModel? then JSON.stringify(ssSearchModel.getContextObj()) else undefined

      return cacheRequestData

    getFacetsRequestData: (firstCall) ->
      # Request to get the data of the facets of the page

      ssSearchModel = @getMeta('sssearch_model')
      cacheRequestData =
        index_name: @getMeta('index_name')
        es_query: JSON.stringify(@getRequestData(1, 0, true, firstCall))
        contextual_sort_data: JSON.stringify(@getContextualSortingProperties())
        context_obj: if ssSearchModel? then JSON.stringify(ssSearchModel.getContextObj()) else undefined

      return cacheRequestData

    # generates an object with the data necessary to do the ES request
    # customPage: set a customPage if you want a page different than the one set as current
    # the same for customPageSize
    getRequestData: (customPage, customPageSize, requestFacets=false, facetsFirstCall=true) ->

      # If facets are requested the facet filters are excluded from the query
      facetsFiltered = true
      page = if customPage? then customPage else @getMeta('current_page')
      pageSize = if customPageSize? then customPageSize else @getMeta('page_size')

      useCustomQuery = @getMeta('use_custom_query')
      customQueryIsFullQuery = @customQueryIsFullQuery()

      propsComparatorsSet = @getMeta('props_comparators_set')
      propsComparatorsSet ?= {}
      # This is a list of permanent comparators that will be included in the source, regardless of the properties
      # configuration received. In the case of compounds this is necessary to obtain the correct image
      permanentComparatorsToFetch = @getMeta('permanent_comparators_to_fetch')
      permanentComparatorsToFetch ?= []
      for comparator in permanentComparatorsToFetch
        propsComparatorsSet[comparator] = comparator

      sourceList = Object.keys(propsComparatorsSet)
      # Base Elasticsearch query
      esQuery = {
        size: pageSize,
        from: ((page - 1) * pageSize)
        _source: sourceList
        query:
          bool:
            must: []
            filter: []
        track_total_hits: true
      }

      if useCustomQuery and customQueryIsFullQuery
        customQuery = JSON.parse(@getMeta('custom_query'))
        esQuery = $.extend(esQuery, customQuery)

      @addSortingToQuery(esQuery)

      generatorList = @getMeta('generator_items_list')
      searchESQuery = @getMeta('searchESQuery')
      if useCustomQuery and not customQueryIsFullQuery
        @addCustomQueryString(esQuery)
      # Normal Search query
      else if generatorList?
        glq = @getQueryForGeneratorList()
        esQuery.query.bool.filter.push glq.filter_query
      else if searchESQuery?
        esQuery.query.bool.must = searchESQuery
        @addHighlightsToQuery(esQuery)
      # Includes the selected facets filter
      @addFacetsToQuery(esQuery, facetsFiltered, requestFacets, facetsFirstCall)
      @addTextFilterToQuery(esQuery)
      @addStickyQuery(esQuery)
      # do not save request facets calls for the editor
      @setMeta('latest_request_data', esQuery) unless requestFacets

      return esQuery

    getAllColumns: ->

      defaultColumns = @getMeta('columns')
      contextualColumns = @getMeta('contextual_properties')
      return _.union(defaultColumns, contextualColumns)

    addCustomQueryString: (esQuery) ->

      customQuery = @getMeta('custom_query')

      esQuery.query.bool.must = [{
        query_string:
          analyze_wildcard: true
          query: customQuery
      }]

    addStickyQuery: (esQuery) ->

      stickyQuery = @getMeta('sticky_query')
      if stickyQuery? and stickyQuery != ''
        esQuery.query.bool.must = [] unless esQuery.query.bool.must?
        esQuery.query.bool.must.push stickyQuery

    addHighlightsToQuery: (esQuery)->
# TEMPORAL DISABLE OF HIGHLIGHTING
#      esQuery.highlight = {
#        order: 'score'
#        fragment_size: 150
#        number_of_fragments: 3
#        fragmenter: 'simple'
#        pre_tags: [glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG]
#        post_tags: [glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG]
#        type: 'fvh'
#        fields:
#          '*': {}
#      }
      return

    addFacetsToQuery: (esQuery, facetsFiltered, requestFacets, facetsFirstCall) ->

      # Includes the selected facets filter
      if facetsFiltered
        filter_query = @getFacetFilterQuery()
        if _.isArray(filter_query) and filter_query.length > 0
          esQuery.query.bool.filter = _.union esQuery.query.bool.filter, filter_query
        else if filter_query? and not _.isArray(filter_query)
          esQuery.query.bool.filter.push filter_query

      if requestFacets
        if not facetsFirstCall?
          throw "ERROR! If the request includes the facets the parameter facets_first_call should be defined!"
        facets_query = @getFacetsGroupsAggsQuery(facetsFirstCall)
        if facets_query
          esQuery.aggs = facets_query

    addTextFilterToQuery: (esQuery) ->

      currentTextFilter = @getTextFilter()
      if not currentTextFilter? or currentTextFilter == ''
        return

      currentTextFilter = currentTextFilter.replace('/', '\\/').replace(':', '\\:').replace('(', '\\(').replace(')', '\\)').replace('.', '\\.')
      comparatorsForTextFilterSet = @getMeta('comparators_for_text_filter_set')
      comparatorsList = _.keys(comparatorsForTextFilterSet)
      comparatorsList.sort()

      textFilterQuery = {
        "query_string": {
          "fields": ("#{comp}" for comp in comparatorsList),
          "query": currentTextFilter,
        }
      }
      esQuery.query.bool.filter.push textFilterQuery

    getContextualSortingProperties: ->

      sortObj = {}
      columns = @getAllColumns()
      for col in columns

        if col.is_sorting? and col.is_sorting !=0 and col.is_contextual
          if col.is_sorting == 1
            order = 'asc'
          if col.is_sorting == -1
            order = 'desc'

          sortObj =
            "#{col.comparator}": order

      return sortObj

    addSortingToQuery: (esQuery) ->
      sortList = []

      columns = @getAllColumns()
      for col in columns

        if col.is_sorting? and col.is_sorting !=0 and not col.is_contextual

          sortObj = {}
          if col.is_sorting == 1
            order = 'asc'
          if col.is_sorting == -1
            order = 'desc'

          sortObj[col.comparator] =
            order: order
          sortList.push sortObj

      esQuery.sort = sortList

    getFacetFilterQuery: () ->
      facet_queries = []
      faceting_handlers = []
      for facet_group_key, facet_group of @getFacetsGroups(true)
        faceting_handlers.push(facet_group.faceting_handler)
      facets_groups_query = glados.models.paginatedCollections.esSchema.FacetingHandler\
        .getAllFacetGroupsSelectedQuery(faceting_handlers)
      if facets_groups_query
        facet_queries.push facets_groups_query
      return facet_queries

    getFacetsGroupsAggsQuery: (facets_first_call)->
      non_selected_facets_groups = @getFacetsGroups(false)
      if non_selected_facets_groups
        aggs_query = {}
        for facet_group_key, facet_group of non_selected_facets_groups
          facet_group.faceting_handler.addQueryAggs(aggs_query, facets_first_call)

        return aggs_query

    # ------------------------------------------------------------------------------------------------------------------
    # Elastic Search Facets request
    # ------------------------------------------------------------------------------------------------------------------
    # returns true if the final state of the facet is selected, false otherwise
    toggleFacetAndFetch: (fGroupKey, fKey) ->

      facetsGroups = @getFacetsGroups()
      facetingHandler = facetsGroups[fGroupKey].faceting_handler
      isSelected = facetingHandler.toggleKeySelection(fKey)
      @setMeta('facets_changed', true)
      @setMeta('at_least_one_facet_is_selected', true)
      @setPage(1, doFetch=false)
      @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.STATE_OBJECT_CHANGED, @)
      @trigger(
        glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.SHOULD_RESET_PAGE_NUMBER)
      @fetch()

      return isSelected

    __requestFacetsGroupsData: (first_call)->

      fetchURL = glados.Settings.ES_PROXY_ES_DATA_URL
      requestData = @getFacetsRequestData(first_call)
      fetchPromise = $.post(fetchURL, requestData)

      return fetchPromise

    __parseFacetsGroupsData: (non_selected_facets_groups, esResponse, first_call, resolve, reject, needs_second_call)->

      es_data = esResponse.es_response
      if not es_data? or not es_data.aggregations?
        console.error "ERROR! The aggregations data in the response is missing!"
        reject()
      for facet_group_key, facet_group of non_selected_facets_groups
        facet_group.faceting_handler.parseESResults(es_data.aggregations, first_call)
      if (first_call and not needs_second_call) or not first_call
        resolve()

    __loadFacetGroups: ()->
      promiseFunc = (resolve, reject)->
        non_selected_facets_groups = @getFacetsGroups(false)
        if _.keys(non_selected_facets_groups).length == 0
          resolve()
          return
        needs_second_call = false
        for group_key, facet_group of non_selected_facets_groups
          if facet_group.faceting_handler.needsSecondRequest()
            needs_second_call = true
        ajax_deferred = @__requestFacetsGroupsData(true)
        first_call = true
        done_callback = (es_data)->
          @__parseFacetsGroupsData(non_selected_facets_groups, es_data, first_call, resolve, reject, needs_second_call)
        fail_callback = ()->
          reject()
          setTimeout(@loadFacetGroups.bind(@), 1000)
        then_callback = ()->
          ajax_deferred_sc = @__requestFacetsGroupsData(false)
          first_call = false
          ajax_deferred_sc.done(done_callback.bind(@))
          ajax_deferred_sc.fail(fail_callback.bind(@))

        ajax_deferred.done(done_callback.bind(@))
        ajax_deferred.fail(fail_callback.bind(@))
        if needs_second_call
          ajax_deferred.then(then_callback.bind(@), null)
      runPromise = ()->
        @__last_facets_promise = new Promise(promiseFunc.bind(@))
        triggerEvent = ()->
          @trigger('facets-changed')
          @setFacetsFetchingState(glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.FACETS_READY)
        @__last_facets_promise.then(triggerEvent.bind(@))

      if @__last_facets_promise?
        @__last_facets_promise.then(runPromise.bind(@))
      else
        runPromise.bind(@)()

    loadFacetGroups: (esRequestData) ->

      @setFacetsFetchingState(
        glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.FETCHING_FACETS)

      if @getMeta('test_mode')
        return

      if not @__debouncedLoadFacetGroups?
        @__debouncedLoadFacetGroups = _.debounce(@__loadFacetGroups, 10)
      @__debouncedLoadFacetGroups()

    getFacetsGroups: (selected, onlyVisible=true)->

      if onlyVisible
        facetGroups = {}
        for facetGroupKey, facetGroup of @meta.facets_groups
          if facetGroup.show
            facetGroups[facetGroupKey] = facetGroup
      else
        facetGroups = @meta.facets_groups

      if not selected?
        return facetGroups
      else
        subFacetGroups = {}
        for facetGroupKey, facetGroup of facetGroups
          if selected == facetGroup.faceting_handler.hasSelection()
            subFacetGroups[facetGroupKey] = facetGroup
        return subFacetGroups

    clearAllFacetsSelections: (doFetch=true) ->

      for fGroupKey, fGroup of @getFacetsGroups(true, onlyVisible=false)
        fGroup.faceting_handler.clearSelections()

      @trigger(
        glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.SHOULD_RESET_PAGE_NUMBER)

      if @getMeta('at_least_one_facet_is_selected')
        @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.STATE_OBJECT_CHANGED, @)
      @setMeta('at_least_one_facet_is_selected', false)

      if @getMeta('test_mode')
        return
      @setMeta('facets_changed', true)
      @fetch() unless not doFetch

    # builds the url to do the request
    getURL: ->
      glados.models.paginatedCollections.Settings.ES_BASE_URL + @getMeta('index') + '/_search'

    # ------------------------------------------------------------------------------------------------------------------
    # Items Selection
    # ------------------------------------------------------------------------------------------------------------------
    toggleSelectAll: ->
      @setMeta('all_items_selected', !@getMeta('all_items_selected'))
      @trigger('selection-changed')

    # ------------------------------------------------------------------------------------------------------------------
    # Metadata Handlers for query and pagination
    # ------------------------------------------------------------------------------------------------------------------

    removeMeta: (attr)->
      delete @meta[attr]

    setMeta: (attr, value) ->
      @meta[attr] = value
      if attr == 'custom_query'
        @resetCache()
        @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.STATE_OBJECT_CHANGED, @)
      @trigger('meta-changed')

    getMeta: (attr) ->
      return @meta[attr]

    hasMeta: (attr) ->
      return _.has(@meta, attr)

    # ------------------------------------------------------------------------------------------------------------------
    # Cleanup
    # ------------------------------------------------------------------------------------------------------------------
    cleanUpList: (doFetch) ->

      if @getMeta('skip_clean_up_once')
        @setMeta('skip_clean_up_once', false)
        return

      @resetCache() unless not @getMeta('enable_collection_caching')
      @invalidateAllDownloadedResults()
      @unSelectAll()
      @clearAllResults()
      @clearAllFacetsSelections(doFetch)
      @setPage(1, doFetch)
      @setInitialFetchingState()

    # ------------------------------------------------------------------------------------------------------------------
    # Search functions
    # ------------------------------------------------------------------------------------------------------------------

    search: (searchESQuery=@getMeta('searchESQuery'), doFetch=false, cleanUpBeforeFetch=true)->
      @setMeta('searchESQuery', searchESQuery)
      @setSearchState(glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_QUERY_SET)
      @sleep()

#      if cleanUpBeforeFetch
      @cleanUpList(doFetch)

      if not doFetch
        @doFetchWhenAwaken()
      else
        @fetch()

    # ------------------------------------------------------------------------------------------------------------------
    # Pagination functions
    # ------------------------------------------------------------------------------------------------------------------

    resetPageSize: (newPageSize) ->
      @setMeta('page_size', parseInt(newPageSize))
      @setPage(1)

    # Meta data values are:
    #  total_records
    #  current_page
    #  total_pages
    #  page_size
    #  records_in_page -- How many records are in the current page (useful if the last page has less than page_size)
    #  sorting data per column.
    #
    resetMeta: (totalRecords, max_score) ->
      max_score = if _.isNumber(max_score) then max_score else 0
      @setMeta('max_score', max_score)
      @setMeta('total_records', parseInt(totalRecords))
      if !@hasMeta('current_page')
        @setMeta('current_page', 1)
      if !@hasMeta('search_term')
        @setMeta('search_term', '')

      if totalRecords == 0
        totalPages = 0
      else
        totalPages = Math.ceil(parseFloat(@getMeta('total_records')) / parseFloat(@getMeta('page_size')))

      @setMeta('total_pages', totalPages)

      @calculateHowManyInCurrentPage()

    calculateHowManyInCurrentPage: ->
      current_page = @getMeta('current_page')
      total_pages = @getMeta('total_pages')
      total_records = @getMeta('total_records')
      page_size = @getMeta('page_size')

      if total_records == 0
        @setMeta('records_in_page', 0)
      else if current_page == total_pages and total_records % page_size != 0
        @setMeta('records_in_page', total_records % page_size)
      else
        @setMeta('records_in_page', @getMeta('page_size'))

    getCurrentPage: ->
      return @models

    setPage: (newPageNum, doFetch=true, testMode=false, customPageSize) ->
      newPageNum = parseInt(newPageNum)
      if doFetch and 1 <= newPageNum and newPageNum <= @getMeta('total_pages')
        @setMeta('current_page', newPageNum)
        if customPageSize?
          @setMeta('page_size', customPageSize)

        if @getMeta('enable_collection_caching')
          modelsInCache = @getObjectsInCacheFromPage(newPageNum)
          if modelsInCache?
            if modelsInCache.length > 0

              # this should be done in a better way
              if @getMeta('enable_substructure_highlighting') or @getMeta('enable_similarity_maps')
                for model in modelsInCache
                  model.set('show_similarity_map', @getMeta('show_similarity_maps'))
                  model.set('show_substructure_highlighting', @getMeta('show_substructure_highlighting'))

              @resetMeta(@getMeta('total_records'), @getMeta('total_records'))
              @reset(modelsInCache)
              @trigger('do-repaint')
              return

        retValue = @fetch(options=undefined, testMode)
        return retValue

     # tells if the current page is the las page
    currentlyOnLastPage: -> @getMeta('current_page') == @getMeta('total_pages')
    
    # ------------------------------------------------------------------------------------------------------------------
    # Sorting functions
    # ------------------------------------------------------------------------------------------------------------------

    sortCollection: (colID) ->
      @unSelectAll()
      @resetCache() unless not @getMeta('enable_collection_caching')
      columns = @getAllColumns()
      @setupColSorting(columns, colID)
      @invalidateAllDownloadedResults()
      @setMeta('current_page', 1)
      @fetch()

    # ------------------------------------------------------------------------------------------------------------------
    # Download functions
    # ------------------------------------------------------------------------------------------------------------------
    DOWNLOADED_ITEMS_ARE_VALID: false
    DOWNLOAD_ERROR_STATE: false
    invalidateAllDownloadedResults: -> @DOWNLOADED_ITEMS_ARE_VALID = false
    clearAllResults: -> @allResults = undefined
    clearSelectedResults: -> @selectedResults = undefined

# this function iterates over all the pages and downloads all the results. This is independent of the pagination,
# but in the future it could be used to optimize the pagination after this has been called.
# it returns a list of deferreds which are the requests to the server, when the deferreds are done it means that
# I got everything. The idea is that if the results have been already loaded it immediately returns a resolved deferred
# without requesting again to the server.
# you can use a progress element to show the progress if you want.
    getAllResults: ($progressElement, askingForOnlySelected = false) ->
      # this really needs to be refactored!

      if $progressElement?
        $progressElement.empty()

      thisCollection = @

      if askingForOnlySelected
        iNeedToGetEverything = not @thereAreExceptions()
        iNeedToGetEverythingExceptSome = @getMeta('all_items_selected') and @thereAreExceptions()
        iNeedToGetOnlySome = not @getMeta('all_items_selected') and @thereAreExceptions()
      else
        iNeedToGetEverything = true
        iNeedToGetEverythingExceptSome = false
        iNeedToGetOnlySome = false

      currentDownloadObj = @getMeta('current_download_obj')
      if currentDownloadObj?
        if iNeedToGetEverything and currentDownloadObj.iNeedToGetEverything
          return currentDownloadObj.deferreds

      #if they want the selected ones only, and I already have them all just pick them from the list
      if askingForOnlySelected and @allResults? and @DOWNLOADED_ITEMS_ARE_VALID
        if not @thereAreExceptions()
          @selectedResults = @allResults
        else
          @selectedResults = _.filter(thisCollection.allResults, (item) ->
            itemID = glados.Utils.getNestedValue(item, thisCollection.getMeta('id_column').comparator)
            return thisCollection.itemIsSelected(itemID)
          )
        return [jQuery.Deferred().resolve()]

      # check if I already have all the results and they are valid
      if @downloadIsValidAndReady()
        return [jQuery.Deferred().resolve()]

      totalRecords = @getMeta('total_records')

      if not totalRecords?
        url = @getURL()
        requestData = JSON.stringify(thisCollection.getRequestData(1, 1))
        restartGetAllResults = $.post(
          {
            url: url
            data: requestData
            dataType: 'json'
            contentType: 'application/json'
            mimeType: 'application/json'
          }).done((response) ->
          thisCollection.setMeta('total_records', response.hits.total.value)
          thisCollection.getAllResults($progressElement, askingForOnlySelected)
        )
        return [restartGetAllResults]

      pageSize = if totalRecords <= 100 then totalRecords else 100

      if totalRecords >= 10000 and not iNeedToGetOnlySome
        msg = 'It is still not supported to process 10000 items or more! (' + totalRecords + ' requested)'
        @DOWNLOAD_ERROR_STATE = true
        return [jQuery.Deferred().reject(msg)]
      else if totalRecords == 0
        msg = 'There are no items to process'
        @setValidDownload()
        return [jQuery.Deferred().reject(msg)]

      if $progressElement?
        $progressElement.html Handlebars.compile($('#Handlebars-Common-DownloadColMessages0').html())
          percentage: '0'

      url = @getURL()

      #initialise the array in which all the items are going to be saved as they are received from the server
      if iNeedToGetOnlySome
        idsList = Object.keys(@getMeta('selection_exceptions'))
        @selectedResults = (undefined for num in [1..idsList.length])
        totalPages = Math.ceil(idsList.length / pageSize)
      else
        @allResults = (undefined for num in [1..totalRecords])
        @selectedResults = (undefined for num in [1..totalRecords])
        totalPages = Math.ceil(totalRecords / pageSize)

      itemsReceived = 0

      #this function knows how to get one page of results and add them in the corresponding positions in the all
      # items array
      getItemsFromPage = (currentPage) ->
        if iNeedToGetOnlySome
          data = JSON.stringify(thisCollection.getRequestDataForChemblIDs(currentPage, pageSize, idsList))
        else
          data = JSON.stringify(thisCollection.getRequestData(currentPage, pageSize))

        return $.post(
          {
            url: url
            data: data
            dataType: 'json'
            contentType: 'application/json'
            mimeType: 'application/json'
          }).done((response) ->
          #I know that I must be receiving currentPage.
          newItems = (item._source for item in response.hits.hits)
          # now I add them in the corresponding position in the items array
          startingPosition = (currentPage - 1) * pageSize

          for i in [0..(newItems.length - 1)]

            currentItem = newItems[i]

            if iNeedToGetEverythingExceptSome
              itemID = glados.Utils.getNestedValue(currentItem, thisCollection.getMeta('id_column').comparator)
              thisCollection.allResults[i + startingPosition] = currentItem
              if thisCollection.itemIsSelected(itemID)
                thisCollection.selectedResults[i + startingPosition] = currentItem

            else if iNeedToGetOnlySome
              thisCollection.selectedResults[i + startingPosition] = currentItem
            else if iNeedToGetEverything
              thisCollection.allResults[i + startingPosition] = currentItem

            itemsReceived++

          progress = parseInt((itemsReceived / totalRecords) * 100)

          if $progressElement? and (progress % 10) == 0
            $progressElement.html Handlebars.compile($('#Handlebars-Common-DownloadColMessages0').html())
              percentage: progress
        )

      deferreds = []
      # Now I request all pages, I accumulate all the deferreds in a list
      for page in [1..totalPages]
        deferreds.push(getItemsFromPage page)

      setValidDownload = $.proxy(@setValidDownload, @)
      $.when.apply($, deferreds).done -> setValidDownload()

      if iNeedToGetEverythingExceptSome
        f = $.proxy((->
          @removeHolesInAllResults
          @removeHolesInSelectedResults()
        ), @)
        $.when.apply($, deferreds).done -> f()

      if iNeedToGetEverything and askingForOnlySelected
        f = $.proxy(@makeSelectedSameAsAllResults, @)
        $.when.apply($, deferreds).done -> f()

      currentDownloadObj =
        iNeedToGetEverything: iNeedToGetEverything
        iNeedToGetEverythingExceptSome: iNeedToGetEverythingExceptSome
        iNeedToGetOnlySome: iNeedToGetOnlySome
        deferreds: deferreds

      @setMeta('current_download_obj', currentDownloadObj)

      return deferreds

    setValidDownload: ->
      @DOWNLOADED_ITEMS_ARE_VALID = true
      @DOWNLOAD_ERROR_STATE = false
      @setMeta('current_download_obj', undefined)
      @trigger(glados.Events.Collections.ALL_ITEMS_DOWNLOADED)
      # If the downloaded items are all of the collection use them as cache
      if @getMeta('enable_collection_caching') and not @getMeta('disable_cache_on_download')
        if @allResults?
          i = 0
          for obj in @allResults
            ModelType = @getMeta('model')
            model = new ModelType(obj)
            # trick to make sure parsed attributes such as img are created.
            model.set(model.parse(model.attributes))
            @addObjectToCache(model, i)
            i++

    removeHolesInAllResults: ->
      i = 0
      while i < @allResults.length
        currentItem = @allResults[i]
        if not currentItem?
          @allResults.splice(i, 1)
          i--
        i++

    removeHolesInSelectedResults: ->
      i = 0
      while i < @selectedResults.length
        currentItem = @selectedResults[i]
        if not currentItem?
          @selectedResults.splice(i, 1)
          i--
        i++

    makeSelectedSameAsAllResults: -> @selectedResults = @allResults

    getDownloadObject: (columns) ->
      downloadObj = []

      for item in @selectedResults

        row = {}
        for col in columns
          colLabel = col.name_to_show
          colValue = glados.Utils.getNestedValue(item, col.comparator)
          if col.parse_function?
            row[colLabel] = col.parse_function(colValue)
          else
            row[colLabel] = colValue

        downloadObj.push row

      return downloadObj

    # you can pass an Jquery elector to be used to report the status, 
    # see the template Handlebars-Common-DownloadColMessages0
    downloadAllItems: (format, columns=@getMeta('download_columns'), $progressElement) ->
      deferreds = @getAllResults($progressElement, true)

      thisCollection = @
      # Here I know that all the items have been obtainer, now I need to generate the file
      $.when.apply($, deferreds).done(->
        if $progressElement?
          $progressElement.html Handlebars.compile($('#Handlebars-Common-DownloadColMessages1').html())()

        downloadObject = thisCollection.getDownloadObject.call(thisCollection, columns)

        if format == glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV']
          DownloadModelOrCollectionExt.downloadCSV('results.csv', null, downloadObject)
          # erase progress element contents after some milliseconds
          setTimeout((()-> $progressElement.html ''), 1000)
        else if format == glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']
          DownloadModelOrCollectionExt.downloadCSV('results.tsv', null, downloadObject, isTabSeparated=true)
          # erase progress element contents after some milliseconds
          setTimeout((()-> $progressElement.html ''), 1000)
        else if format == glados.Settings.DEFAULT_FILE_FORMAT_NAMES['SDF']
          idsList = (item.molecule_chembl_id for item in thisCollection.selectedResults)
          # here I have the IDs, I have to request them to the server as SDF
          DownloadModelOrCollectionExt.generateSDFFromChemblIDs idsList, $progressElement
      ).fail((msg) ->
        if $progressElement?
          $progressElement.html Handlebars.compile($('#Handlebars-Common-CollectionErrorMsg').html())
            msg: msg
      )
      
    HIGHLIGHT_SUFFIXES_TO_REMOVE: [
      'eng_analyzed', 'ws_analyzed', 'std_analyzed', 'alphanumeric_lowercase_keyword', /\.\d*$/
    ]
    HIGHLIGHT_OPEN_TAG: '<em class="glados-result-highlight">'
    HIGHLIGHT_CLOSE_TAG: '</em>'
    HIGHLIGHT_MAX_WORD_LENGTH: 10

glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG_REGEX_ESCAPED = \
  glados.Utils.escapeRegExp glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_OPEN_TAG
glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG_REGEX_ESCAPED = \
  glados.Utils.escapeRegExp glados.models.paginatedCollections.ESPaginatedQueryCollection.HIGHLIGHT_CLOSE_TAG