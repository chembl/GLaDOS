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
      @resetMeta(0, 0)
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
      @trigger('before_fetch_elastic')
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



    # generates an object with the data necessary to do the ES request
    # set a customPage if you want a page different than the one set as current
    # the same for customPageSize
    getRequestData: (customPage, customPageSize) ->
      page = if customPage? then customPage else @getMeta('current_page')
      pageSize = if customPageSize? then customPageSize else @getMeta('page_size')
      singular_terms = @getMeta('singular_terms')
      exact_terms = @getMeta('exact_terms')
      filter_terms = @getMeta("filter_terms")
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
        term_i_query =
          {
            bool:
              should:
                [
                  {
                    multi_match:
                      fields: [
                        "*.std_analyzed^10",
                        "*.eng_analyzed^5"
                      ],
                      query: term_i,
                      boost: 1
                      fuzziness: 'AUTO'
                  }
              ]
          }
        if term_i.length > 4
          term_i_query.bool.should.push(
            {
              constant_score:
                query:
                  multi_match:
                    fields: [
                      "*.pref_name_analyzed^1.3",
                      "*.alt_name_analyzed",
                    ],
                    query: term_i,
                    minimum_should_match: "80%"
                boost: 1
            }
          )
        by_term_query.bool.should.push(term_i_query)
      es_query = {
        size: pageSize,
        from: ((page - 1) * pageSize)
        query:
          bool:
            must:
              bool:
                should:[
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
      if filter_terms.length > 0
        filter_terms_joined = filter_terms.join(' ')
        es_query.query.bool.filter =
          [
            {
              query_string:
                fields: [
                  "*"
                ]
                fuzziness: 0
                query: filter_terms_joined
            }
          ]
      if singular_terms.length > 0
        es_query.query.bool.must.bool.should.push(by_term_query)
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
      max_score = if _.isNumber(max_score) then max_score else 0
      @setMeta('max_score', max_score)
      @trigger('score_update')
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


    # ------------------------------------------------------------------------------------------------------------------
    # Download functions
    # ------------------------------------------------------------------------------------------------------------------
    # you can pass an Jquery elector to be used to report the status, see the template Handlebars-Common-DownloadColMessages0
    downloadAllItems: (format, $progressElement) ->

      #-----------------------------------------------Get All Items-------------------------------------------

      totalRecords = @getMeta('total_records')
      pageSize = if totalRecords <= 100 then totalRecords else 100


      if totalRecords >= 10000
        if $progressElement?
          $progressElement.html 'It is still not supported to download 10000 items or more!'

          # erase element contents after some milliseconds
          setTimeout( ()->
            $progressElement.html ''
          , 3000)
        return

      if $progressElement?
        $progressElement.html Handlebars.compile( $('#Handlebars-Common-DownloadColMessages0').html() )
          percentage: '0'

      url = @getURL()
      totalPages = Math.ceil(totalRecords / pageSize)
      console.log 'page size: ', pageSize
      console.log 'totalPages: ', totalPages

      #initialise the array in which all the items are going to be saved as they are received from the server
      items = (undefined for num in [1..totalRecords])
      itemsReceived = 0

      #this function knows how to get one page of results and add them in the corresponding positions in the all
      # items array
      thisCollection = @
      getItemsFromPage = (currentPage) ->

        data = JSON.stringify(thisCollection.getRequestData(currentPage, pageSize))
        console.log 'data: ', data

        return $.post( url, data).done( (response) ->

          #I know that I must be receiving currentPage.
          newItems = (item._source for item in response.hits.hits)
          # now I add them in the corresponding position in the items array
          startingPosition = (currentPage - 1) * pageSize

          for i in [0..(newItems.length-1)]
            items[i + startingPosition] = newItems[i]
            itemsReceived++

          progress = parseInt((itemsReceived / totalRecords) * 100)

          if $progressElement? and (progress % 10) == 0
            $progressElement.html Handlebars.compile( $('#Handlebars-Common-DownloadColMessages0').html() )
              percentage: progress


        )

      deferreds = []
      # Now I request all pages, I accumulate all the deferreds in a list
      for page in [1..totalPages]
        deferreds.push(getItemsFromPage page)

      #-----------------------------------------------End Get All Items-------------------------------------------
      # Here I know that everything is done
      $.when.apply($, deferreds).done( () ->

        console.log 'DONE!'
        console.log 'allItems: ', items

      )


