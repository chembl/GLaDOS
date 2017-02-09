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
      console.log("ERROR QUERYING ELASTIC SEARCH:",collection, response, options)
      @reset()

    # Parses the Elastic Search Response and resets the pagination metadata
    parse: (data) ->
      @resetMeta(data.hits.total, data.hits.max_score)
      jsonResultsList = []
      for hitI in data.hits.hits
        jsonResultsList.push(hitI._source)

      return jsonResultsList

    # Prepares an Elastic Search query to search in all the fields of a document in a specific index
    fetch: (options) ->
      @trigger('before_fetch_elastic');
      if @getMeta('singular_terms') or @getMeta('exact_terms')
        @url = @getURL()
        # Creates the Elastic Search Query parameters and serializes them
        esJSONRequest = JSON.stringify(@getRequestData())
        # Uses POST to prevent result caching
        fetchESOptions =
          data: esJSONRequest
          type: 'POST'
          reset: true
          error: @errorHandler.bind(@)
        # Use options if specified by caller
        if not _.isUndefined(options) and _.isObject(options)
          _.extend(fetchESOptions, options)
        # Call Backbone's fetch
        return Backbone.Collection.prototype.fetch.call(this, fetchESOptions)
      else
        console.log("EMPTY SEARCH")
        return @reset()



    # generates an object with the data necessary to do the ES request
    getRequestData: ->
      singular_terms = @getMeta('singular_terms')
      exact_terms = @getMeta('exact_terms')
      sing_terms_joined = singular_terms.join(' ')
      exact_terms_joined = exact_terms.join(' ')
      console.log(sing_terms_joined)
      console.log(exact_terms_joined)
      es_query = {
        size: @getMeta('page_size'),
        from: ((@getMeta('current_page') - 1) * @getMeta('page_size'))
        query:
          bool:
            must:
              bool:
                should:[
                  {
                    multi_match:
                      type: "best_fields",
                      fields: [
                        "*.pref_name_analyzed^1.5",
                        "*.alt_name_analyzed",
                        "*.std_analyzed^30",
                        "*.eng_analyzed^20"
                      ],
                      query: sing_terms_joined,
                      minimum_should_match: "70%"
                  }
                  ,
                  {
                    query_string:
                      fields: [
                        "*.std_analyzed^30",
                        "*.eng_analyzed^20",
                        "*.keyword^1000",
                        "*.entity_id^100000",
                        "*.id_reference^1000",
                        "*.chembl_id^10000",
                        "*.chembl_id_reference^5000"
                      ]
                      query: exact_terms_joined
                  }
                ]
      }
      console.log(es_query)
      return es_query

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
    resetMeta: (totalRecords, max_score) ->
      @setMeta('max_score', max_score)
      @setMeta('total_records', parseInt(totalRecords))
      if !@hasMeta('current_page')
        @setMeta('current_page', 1)
      if !@hasMeta('search_term')
        @setMeta('search_term','')
      @setMeta('total_pages', Math.ceil(parseFloat(@getMeta('total_records')) / parseFloat(@getMeta('page_size'))))
      @calculateHowManyInCurrentPage()

    calculateHowManyInCurrentPage: ->
      current_page = @getMeta('current_page')
      total_pages = @getMeta('total_pages')
      total_records = @getMeta('total_records')
      page_size = @getMeta('page_size')

      if total_records == 0
        @setMeta('records_in_page', 0 )
      else if current_page == total_pages and total_records % page_size != 0
        @setMeta('records_in_page', total_records % page_size)
      else
        @setMeta('records_in_page', @getMeta('page_size'))

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

