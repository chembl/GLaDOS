glados.useNameSpace 'glados.models.paginatedCollections',

  # --------------------------------------------------------------------------------------------------------------------
  # This class implements the pagination, sorting and searching for a collection using the Web Services
  # extend it to get a collection with the extra capabilities
  # --------------------------------------------------------------------------------------------------------------------
  WSPaginatedCollection: Backbone.Collection.extend

    # ------------------------------------------------------------------------------------------------------------------
    # change page size when it is a carousel
    # ------------------------------------------------------------------------------------------------------------------
    responsivisePageSize: ->
      resetPageSizeProxy = $.proxy(@resetPageSize, @)
      $(window).resize ->
        if GlobalVariables.CURRENT_SCREEN_TYPE_CHANGED
          resetPageSizeProxy glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]

    # ------------------------------------------------------------------------------------------------------------------
    # URL handling
    # ------------------------------------------------------------------------------------------------------------------
    initialiseUrl: ->
      console.log 'setting url'
      @url = @getPaginatedURL()

    getPaginatedURL: (customPageSize, customPageNum) ->

      url = @getMeta('base_url')
      page_num = if customPageNum? then customPageNum else @getMeta('current_page')
      page_size = if customPageSize? then customPageSize else @getMeta('page_size')
      params = []

      limit_str = 'limit=' + page_size
      page_str = 'offset=' + (page_num - 1) * page_size
      params.push(limit_str)
      params.push(page_str)

      # ----------------------------------------------
      # Sorting
      # ----------------------------------------------

      columns = @getMeta('columns')

      sorting = _.filter(columns, (col) -> col.is_sorting != 0)
      for field in sorting
        comparator = field.comparator
        comparator = '-' + comparator unless field.is_sorting == 1
        params.push('order_by=' + comparator)

      # ----------------------------------------------
      # Search terms
      # ----------------------------------------------
      searchTerms = @getMeta('search_terms')


      for column, info of searchTerms

        type = info[0]
        term = info[1]

        if type == 'text'

          params.push(column + "__contains=" + term) unless term == ''

        else if type == 'numeric'

          values = term.split(',')
          min = values[0]
          max = values[1]

          params.push(column + "__gte=" + min)
          params.push(column + "__lte=" + max)

        else if type == 'boolean'

          params.push(column + "=" + term) unless term == 'any'

      firstSeparator = if @getMeta('base_url').indexOf('?') != -1 then '&' else '?'
      full_url = url + firstSeparator + params.join('&')
      customFilter = @getMeta('custom_filter')
      full_url += '&' + customFilter unless not customFilter? or customFilter == ''

      return full_url

    # ------------------------------------------------------------------------------------------------------------------
    # Metadata Handlers for query and pagination
    # ------------------------------------------------------------------------------------------------------------------

    # Meta data is:
    #  total_records
    #  current_page
    #  total_pages
    #  records_in_page -- How many records are in the current page
    #  sorting data per column.

    setMeta: (attr, value, storeAsString=false) ->

      if _.isString(value) and !storeAsString
        value = parseInt(value)

      @meta[attr] = value
      @trigger('meta-changed')

    getMeta: (attr) ->
      return @meta[attr]

    hasMeta: (attr) ->
      return attr in _.keys(@meta)

    resetMeta: (page_meta) ->

      @setMeta('total_records', page_meta.total_count)
      @setMeta('page_size', page_meta.limit)
      @setMeta('current_page', (page_meta.offset / page_meta.limit) + 1)
      @setMeta('total_pages', Math.ceil(page_meta.total_count / page_meta.limit) )
      @setMeta('records_in_page', page_meta.records_in_page )

    # ------------------------------------------------------------------------------------------------------------------
    # Pagination functions
    # ------------------------------------------------------------------------------------------------------------------

    resetPageSize: (new_page_size) ->

      if new_page_size == ''
        return

      @setMeta('page_size', new_page_size)
      @setPage(1)

    calculateTotalPages: ->

      total_pages =  Math.ceil(@models.length / @getMeta('page_size'))
      @setMeta('total_pages', total_pages)

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

      # allways the models represent the current page
      return @models

    # page num must be always a number
    setPage: (page_num) ->

      # don't bother if the page requested is greater than the total number of pages
      if page_num > @getMeta('total_pages')
        return

      console.log 'getting page: ', page_num
      base_url = @getMeta('base_url')
      @setMeta('current_page', page_num)
      @url = @getPaginatedURL()
      console.log('Getting page:')
      console.log(page_num)
      console.log('URL')
      console.log(@url)
      @fetch()

    # tells if the current page is the las page
    currentlyOnLastPage: -> @getMeta('current_page') == @getMeta('total_pages')

    # ------------------------------------------------------------------------------------------------------------------
    # Sorting
    # ------------------------------------------------------------------------------------------------------------------
    sortCollection: (comparator) ->

      @setMeta('current_page', 1)
      columns = @getMeta('columns')
      @setupColSorting(columns, comparator)
      @url = @getPaginatedURL()
      console.log('URL')
      console.log(@url)
      @fetch()


    # ------------------------------------------------------------------------------------------------------------------
    # Searching
    # ------------------------------------------------------------------------------------------------------------------
    setSearch: (term, column, type) ->

      # it seems that sometimes materialize makes the event to be fired twice.
      if term == ''
        return

      @setMeta('current_page', 1)
      # create the search term objects if it doesn't exist
      @setMeta('search_terms', {}) unless @getMeta('search_terms')?

      searchTerms = @getMeta('search_terms')
      searchTerms[column] = [type, term]

      @url = @getPaginatedURL()
      console.log('URL')
      console.log(@url)
      @fetch()

    # from all the comparators, returns the one that is being used for sorting.
    # if none is being used for sorting returns undefined
    getCurrentSortingComparator: () ->

      columns = @getMeta('columns')
      sorVal = _.find(columns, (col) -> col.is_sorting != 0 )

      comp = undefined
      comp = sorVal.comparator unless !sorVal?

      return comp


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

      # check if I already have all the results and they are valid
      if @allResults? and @DOWNLOADED_ITEMS_ARE_VALID
        return [jQuery.Deferred().resolve()]

      if $progressElement?
        $progressElement.html Handlebars.compile($('#Handlebars-Common-DownloadColMessages0').html())
          percentage: '0'

      customPageNum = 1
      # 1000 is the maximun page size allowed by the ws
      customPageSize = 1000
      firstURL = @getPaginatedURL(customPageSize, customPageNum)
      baseURL = firstURL.split('/chembl/')[0]
      console.log(firstURL)

      # this is to keep the same strucutre as the function for the elasticsearch collections
      baseDeferred = jQuery.Deferred()
      deferreds = [baseDeferred]
      @allResults = []
      thisView = @

      getPage = (url) ->
        $.get(url).done((response) ->
          itemsKeyName =  _.reject(Object.keys(response), (key) -> key == 'page_meta')[0]
          totalRecords = response.page_meta.total_count

          for item in response[itemsKeyName]
            thisView.allResults.push(item)
          itemsReceived = thisView.allResults.length
          progress = parseInt((itemsReceived / totalRecords) * 100)
          if $progressElement? and (progress % 10) == 0
            $progressElement.html Handlebars.compile($('#Handlebars-Common-DownloadColMessages0').html())
              percentage: progress

          nextUrl = response.page_meta.next
          if nextUrl?
            nextUrl = baseURL + nextUrl
            getPage nextUrl
          else
            baseDeferred.resolve()
        ).fail( (xhr, status, error) ->
          baseDeferred.reject(xhr, status, error)
        )
      getPage(firstURL)

      setValidDownload = $.proxy((-> @DOWNLOADED_ITEMS_ARE_VALID = true; @DOWNLOAD_ERROR_STATE = false), @)
      $.when.apply($, deferreds).done ->
        setValidDownload()
        setTimeout( (()-> $progressElement.html ''), 200)

      baseDeferred.fail (xhr, status, error) ->

        console.log 'xhr ', xhr
        console.log 'status ', status
        console.log 'error ', error

        if $progressElement?
          $progressElement.html 'There was an error while loading the data'

      if $progressElement?

        numDots = 0
        firstWaitTime = 10000
        secondWaitTime = 2000
        generateWaitingToolongMsg = (waitTime) ->


          setTimeout( ( ->
            msg = 'Generating the data' + ( '.' for dot in [0..numDots]).join('')
            numDots++
            if baseDeferred.state() == 'pending'
              $progressElement.html msg
              generateWaitingToolongMsg(secondWaitTime)
          ),waitTime)
        generateWaitingToolongMsg(firstWaitTime)

      return deferreds
