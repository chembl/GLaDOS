glados.useNameSpace 'glados.models.paginatedCollections',

# --------------------------------------------------------------------------------------------------------------------
# This class implements the pagination, sorting and searching for a collection in ElasticSearch
# extend it to get a collection with the extra capabilities
# --------------------------------------------------------------------------------------------------------------------
  ESPaginatedQueryCollection: Backbone.Collection.extend
# ------------------------------------------------------------------------------------------------------------------
# Backbone Override
# ------------------------------------------------------------------------------------------------------------------

    errorHandler: (collection, response, options)->
      console.log("ERROR QUERYING ELASTIC SEARCH:", collection, response, options)
      @resetMeta(0, 0)
      @reset()

# ------------------------------------------------------------------------------------------------------------------
# Parse/Fetch Collection data
# ------------------------------------------------------------------------------------------------------------------

# Parses the Elastic Search Response and resets the pagination metadata
    parse: (data) ->
      @resetMeta(data.hits.total, data.hits.max_score)
      jsonResultsList = []
      for hitI in data.hits.hits
        jsonResultsList.push(hitI._source)
      return jsonResultsList

# Prepares an Elastic Search query to search in all the fields of a document in a specific index
    fetch: (options, testMode=false) ->
      @trigger('before_fetch_elastic')
      @url = @getURL()

      if @getMeta('facets_changed')
        @invalidateAllDownloadedResults()
        @unSelectAll()
        @setMeta('current_page', 1)
        @setMeta('facets_changed', false)

      # Creates the Elastic Search Query parameters and serializes them
      requestData = @getRequestData()
      esJSONRequest = JSON.stringify(@getRequestData())
      console.log 'request data to fetch: ', requestData
      # Uses POST to prevent result caching
      fetchESOptions =
        data: esJSONRequest
        type: 'POST'
        reset: true
        error: @errorHandler.bind(@)
      # Use options if specified by caller
      if not _.isUndefined(options) and _.isObject(options)
        _.extend(fetchESOptions, options)

      @loadFacetGroups() unless testMode
      # Call Backbone's fetch
      Backbone.Collection.prototype.fetch.call(this, fetchESOptions) unless testMode
      return requestData

# ------------------------------------------------------------------------------------------------------------------
# Parse/Fetch Facets Groups data
# ------------------------------------------------------------------------------------------------------------------

# Parses the facets groups aggregations data
    parseFacetsGroups: (facets_data)->
      if _.isUndefined(facets_data.aggregations)
        for facet_group_key, facet_group of @meta.facets_groups
          facet_group.faceting_handler.parseESResults(facets_data.aggregations)

# ------------------------------------------------------------------------------------------------------------------
# Elastic Search Query structure
# ------------------------------------------------------------------------------------------------------------------

    getSingleTermQuery: (single_term)->
      single_term_query = {bool: {should: []}}
      single_term_query.bool.should.push {
        multi_match:
          fields: [
            "*.std_analyzed^10",
            "*.eng_analyzed^5"
          ],
          query: single_term,
          boost: 1
      }
      single_term_query.bool.should.push {
        multi_match:
          fields: [
            "*.std_analyzed^10",
            "*.eng_analyzed^5"
          ],
          query: single_term,
          boost: 0.1
          fuzziness: 'AUTO'
      }
      if single_term.length >= 4
        single_term_query.bool.should.push {
          constant_score:
            query:
              multi_match:
                fields: [
                  "*.pref_name_analyzed^1.3",
                  "*.alt_name_analyzed",
                ],
                query: single_term,
                minimum_should_match: "80%"
            boost: 100
        }
      return single_term_query

# given a list of chembl ids, it gives the request data to query for only those ids
    getRequestDataForChemblIDs: (page, pageSize, idsList) ->
      return {
        size: pageSize,
        from: ((page - 1) * pageSize)
        query:
          terms:
            molecule_chembl_id: idsList
      }

    getNormalSearchQuery: ()->
      singular_terms = @getMeta('singular_terms')
      exact_terms = @getMeta('exact_terms')
      exact_terms_joined = null
      if singular_terms.length == 0 and exact_terms.length == 0
        exact_terms_joined = '*'
      else if exact_terms.length == 0
        exact_terms_joined = ''
      else
        exact_terms_joined = exact_terms.join(' ')
      by_term_query = {
        bool:
          minimum_should_match: "70%"
          boost: 100
          should: []
      }
      for term_i in singular_terms
        term_i_query = @getSingleTermQuery(term_i)
        by_term_query.bool.should.push(term_i_query)


      search_query ={
        bool:
          should: [
            {
              query_string:
                fields: [
                  "*.std_analyzed^10",
                  "*.keyword^1000",
                  "*.entity_id^100000",
                  "*.id_reference^1000",
                  "*.chembl_id^10000",
                  "*.chembl_id_reference^5000"
                ]
                fuzziness: 0
                query: exact_terms_joined
            }
          ]
      }
      if singular_terms.length > 0
        search_query.bool.should.push(by_term_query)
      return search_query

# generates an object with the data necessary to do the ES request
# customPage: set a customPage if you want a page different than the one set as current
# the same for customPageSize
    getRequestData: (customPage, customPageSize, request_facets=false, facets_first_call) ->
      # If facets are requested the facet filters are excluded from the query
      facets_filtered = true
      page = if customPage? then customPage else @getMeta('current_page')
      pageSize = if customPageSize? then customPageSize else @getMeta('page_size')

      # Base Elastic query
      es_query = {
        size: pageSize,
        from: ((page - 1) * pageSize)
        _source:
          includes: [ '*', '_metadata.*']
          excludes: [ '_metadata.related_targets.chembl_ids.*', '_metadata.related_compounds.chembl_ids.*']
        query:
          bool:
            must: null
      }

      # Custom query String query
      customQueryString = @getMeta('custom_query_string')
      console.log 'custom query string: ', customQueryString
      if @getMeta('use_custom_query_string')
        es_query.query.bool.must = {
          query_string:
            analyze_wildcard: true
            query: customQueryString
        }
      # Normal Search query
      else
        es_query.query.bool.must = @getNormalSearchQuery()

      # Includes the filter query by query filter terms and selected facets
      filter_query = @getFilterQuery(facets_filtered)
      if filter_query
        es_query.query.bool.filter = [filter_query]


      if request_facets
        if _.isUndefined(facets_first_call)
          throw "ERROR! If the request includes the facets the parameter facets_first_call should be defined!"
        facets_query = @getFacetsGroupsAggsQuery(facets_first_call)
        if facets_query
          es_query.aggs = facets_query
      return es_query

    getFilterQuery: (facets_filtered) ->
      filter_query = {bool: {must: []}}
# TODO: UPDATE TO GRAMMAR HANDLING OF SEARCH  EXACT TERMS
#      filter_terms = @getMeta("filter_terms")
#      if filter_terms and filter_terms.length > 0
#        filter_terms_joined = filter_terms.join(' ')
#        filter_query.bool.must.push(
#          {
#            query_string:
#              fields: [
#                "*"
#              ]
#              fuzziness: 0
#              query: filter_terms_joined
#          }
#        )
      if facets_filtered
        faceting_handlers = []
        for facet_group_key, facet_group of @meta.facets_groups
          faceting_handlers.push(facet_group.faceting_handler)
        facets_groups_query = glados.models.paginatedCollections.esSchema.FacetingHandler\
        .getAllFacetGroupsSelectedQuery(faceting_handlers)
        if facets_groups_query
          filter_query.bool.must.push facets_groups_query
      if filter_query.bool.must.length == 0
        return null
      return filter_query

    getFacetsGroupsAggsQuery: (facets_first_call)->
      non_selected_facets_groups = @getFacetsGroups(false)
      if non_selected_facets_groups
        aggs_query = {}
        for facet_group_key, facet_group of non_selected_facets_groups
          facet_group.faceting_handler.addQueryAggs(aggs_query, facets_first_call)
        return aggs_query

    requestFacetsGroupsData: (first_call)->
      es_url = @getURL()
      # Creates the Elastic Search Query parameters and serializes them
      # Includes the request for the faceting data
      esJSONRequestData = JSON.stringify(@getRequestData(1, 0, true, first_call))
      # Uses POST to prevent result caching
      ajax_deferred = $.post(es_url, esJSONRequestData)
      return ajax_deferred

    loadFacetGroups: (first_call=true)->
      non_selected_facets_groups = @getFacetsGroups(false)
      if _.keys(non_selected_facets_groups).length == 0
        return

      call_time = new Date().getTime()
      if first_call and @loading_facets and call_time - @loading_facets_t_ini < 5000
        console.log "WARNING! Facets requested again before they finished loading!", @getURL()
        return
      if first_call
        @loading_facets = true
        @loading_facets_t_ini = call_time
        @needs_second_call = false
        for group_key, facet_group of non_selected_facets_groups
          if facet_group.faceting_handler.needsSecondRequest()
            @needs_second_call = true

      ajax_deferred = @requestFacetsGroupsData(first_call)
      done_callback = (es_data)->
        if _.isUndefined(es_data) or _.isUndefined(es_data.aggregations)
          throw "ERROR! The aggregations data in the response is missing!"
        for facet_group_key, facet_group of non_selected_facets_groups
          facet_group.faceting_handler.parseESResults(es_data.aggregations, first_call)
        if first_call and @needs_second_call
          @loadFacetGroups(false)
        else
          console.log 'TRIGGERING FACETS CHANGED!'
          @trigger('facets-changed')
          @loading_facets = false
      ajax_deferred.done(done_callback.bind(@))

    getFacetsGroups: (selected)->
      if not selected?
        return @meta.facets_groups
      else
        sub_facet_groups = {}
        for facet_group_key, facet_group of @meta.facets_groups
          if selected == facet_group.faceting_handler.hasSelection()
            sub_facet_groups[facet_group_key] = facet_group
        return sub_facet_groups

    clearAllFacetsGroups: ()->
      for facet_group_key, facet_group of @meta.facets_groups
        facet_group.faceting_handler.clearFacets()

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

    setMeta: (attr, value) ->
      @meta[attr] = value
      @trigger('meta-changed')

    getMeta: (attr) ->
      return @meta[attr]

    hasMeta: (attr) ->
      return attr in _.keys(@meta)

# ------------------------------------------------------------------------------------------------------------------
# Search functions
# ------------------------------------------------------------------------------------------------------------------

    search: (singular_terms, exact_terms, filter_terms)->
      singular_terms = if _.isUndefined(singular_terms) then [] else singular_terms
      exact_terms = if _.isUndefined(exact_terms) then [] else exact_terms
      filter_terms = if _.isUndefined(filter_terms) then [] else filter_terms
      @setMeta('singular_terms', singular_terms)
      @setMeta('exact_terms', exact_terms)
      @setMeta('filter_terms', filter_terms)
      @invalidateAllDownloadedResults()
      @unSelectAll()
      @clearAllResults()
      @clearAllFacetsGroups()
      @setPage(1, false)
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
      @setMeta('total_pages', Math.ceil(parseFloat(@getMeta('total_records')) / parseFloat(@getMeta('page_size'))))
      @calculateHowManyInCurrentPage()

      #Triggers the event after the values have been updated
      @trigger('score_and_records_update')

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

    setPage: (newPageNum, doFetch=true, testMode=false) ->
      newPageNum = parseInt(newPageNum)
      if doFetch and 1 <= newPageNum and newPageNum <= @getMeta('total_pages')
        @setMeta('current_page', newPageNum)
        @fetch(options=undefined, testMode)

     # tells if the current page is the las page
    currentlyOnLastPage: -> @getMeta('current_page') == @getMeta('total_pages')
# ------------------------------------------------------------------------------------------------------------------
# Sorting functions
# ------------------------------------------------------------------------------------------------------------------

    sortCollection: (comparator) ->
#TODO implement sorting

    resetSortData: ->
#TODO implement sorting

# organises the information of the columns that are going to be sorted.
# returns true if the sorting needs to be descending, false otherwise.
    setupColSorting: (columns, comparator) ->
#TODO implement sorting

# sets the term to search in the collection
# when the collection is server side, the corresponding column and type are required.
# This is because the web services don't provide a search with OR
# for client side, it can be null, but for example for server side
# for chembl25, term will be 'chembl25', column will be 'molecule_chembl_id', and type will be 'text'
# the url will be generated taking into account this terms.
    setSearch: (term, column, type)->
#TODO Check if this is required

# from all the comparators, returns the one that is being used for sorting.
# if none is being used for sorting returns undefined
    getCurrentSortingComparator: () ->
#TODO implement sorting

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
      if @allResults? and @DOWNLOADED_ITEMS_ARE_VALID
        return [jQuery.Deferred().resolve()]

      totalRecords = @getMeta('total_records')

      if not totalRecords?
        url = @getURL()
        requestData = JSON.stringify(thisCollection.getRequestData(1, 1))
        $.post(url, requestData).done((response) ->
          thisCollection.setMeta('total_records', response.hits.total)
          thisCollection.getAllResults($progressElement, askingForOnlySelected)
        )
        return

      pageSize = if totalRecords <= 100 then totalRecords else 100

      if totalRecords >= 10000 and not iNeedToGetOnlySome
        msg = 'It is still not supported to process 10000 items or more! (' + totalRecords + ' requested)'
        @DOWNLOAD_ERROR_STATE = true
        errorModalID = 'error-' + parseInt(Math.random() * 1000)
        $newModal = $(Handlebars.compile($('#Handlebars-Common-DownloadErrorModal').html())
          modal_id: errorModalID
          msg: msg
        )
        $('#BCK-GeneratedModalsContainer').append($newModal)
        $newModal.modal()
        $newModal.modal('open')
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

        return $.post(url, data).done((response) ->

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

      return deferreds

    setValidDownload: ->
      @DOWNLOADED_ITEMS_ARE_VALID = true
      @DOWNLOAD_ERROR_STATE = false
      @trigger(glados.Events.Collections.ALL_ITEMS_DOWNLOADED)

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



# you can pass an Jquery elector to be used to report the status, see the template Handlebars-Common-DownloadColMessages0
    downloadAllItems: (format, columns, $progressElement) ->
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
          DownloadModelOrCollectionExt.downloadCSV('results.tsv', null, downloadObject, true)
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