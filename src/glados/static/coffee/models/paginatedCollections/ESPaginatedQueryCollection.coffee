glados.useNameSpace 'glados.models.paginatedCollections',

  # --------------------------------------------------------------------------------------------------------------------
  # This class implements the pagination, sorting and searching for a collection in ElasticSearch
  # extend it to get a collection with the extra capabilities
  # --------------------------------------------------------------------------------------------------------------------
  ESPaginatedQueryCollection: Backbone.Collection.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Backbone Override
    # ------------------------------------------------------------------------------------------------------------------

    # Parses the Elastic Search Response and resets the pagination metadata
    parse: (data) ->
      @resetMeta(data.hits.total)
      jsonResultsList = []
      for hitI in data.hits.hits
        jsonResultsList.push(hitI._source)

      return jsonResultsList

    # Prepares an Elastic Search query to search in all the fields of a document in a specific index
    fetch: (options) ->
      @url = @getURL()
      # Creates the Elastic Search Query parameters and serializes them
      esJSONRequest = JSON.stringify(@getRequestData())
      # Uses POST to prevent result caching
      fetchESOptions =
        data: esJSONRequest
        type: 'POST'
        reset: true
      # Use options if specified by caller
      if not _.isUndefined(options) and _.isObject(options)
        _.extend(fetchESOptions, options)
      # Call Backbone's fetch
      return Backbone.Collection.prototype.fetch.call(this, fetchESOptions)

    # generates an object with the data necessary to do the ES request
    getRequestData: ->
      return {
        size: @getMeta('page_size'),
        from: ((@getMeta('current_page') - 1) * @getMeta('page_size'))
        query:
          query_string:
            fields: [
              "*.std_analyzed^20",
              "*.eng_analyzed^15",
              "*.pref_name_analyzed^1.1",
              "*.alt_name_analyzed",
              "*.keyword^100",
              "*.entity_id^100000",
              "*.id_reference^2",
              "*.chembl_id^10000",
              "*.chembl_id_reference^2"
            ]
            query: @getMeta('search_term')
      }

    # builds the url to do the request
    getURL: ->
      glados.models.paginatedCollections.Settings.ES_BASE_URL+@getMeta('index')+'/_search'


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
    # Pagination functions
    # ------------------------------------------------------------------------------------------------------------------

    resetPageSize: (newPageSize) ->
      @setMeta('page_size', parseInt(newPageSize))


    # Meta data values are:
    #  total_records
    #  current_page
    #  total_pages
    #  page_size
    #  records_in_page -- How many records are in the current page (useful if the last page has less than page_size)
    #  sorting data per column.
    #
    resetMeta: (totalRecords) ->
      @setMeta('total_records', parseInt(totalRecords))
      if !@hasMeta('current_page')
        @setMeta('current_page', 1)
      if !@hasMeta('search_term')
        @setMeta('search_term','')
      @setMeta('total_pages', Math.ceil(parseFloat(@getMeta('total_records')) / parseFloat(@getMeta('page_size'))))
      @calculateHowManyInCurrentPage()

    calculateHowManyInCurrentPage: ->
      @setMeta('records_in_page',
                if @getMeta('current_page')==@getMeta('total_pages')
                then (@getMeta('total_records')%@getMeta('page_size'))
                else @getMeta('page_size')
              )

    getCurrentPage: ->
      return @models

    setPage: (newPageNum) ->
      newPageNum =  parseInt(newPageNum)
      if 1 <= newPageNum and newPageNum <= @getMeta('total_pages')
        @setMeta('current_page', newPageNum)
        @fetch()

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

