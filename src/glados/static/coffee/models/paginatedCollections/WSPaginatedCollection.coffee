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
      @url = @getPaginatedURL()

    getPaginatedURL: ->

      url = @getMeta('base_url')
      page_num = @getMeta('current_page')
      page_size = @getMeta('page_size')
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

    setMeta: (attr, value, storeAsString) ->

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

      if total_pages == 1
        @setMeta('records_in_page', total_records )
      else if current_page == total_pages
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
    currentlyOnLastPage: ->

      @getMeta('current_page') == @getMeta('total_pages')

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

    resetSortData: ->

      @comparator = undefined
      columns = @getMeta('columns')
      for col in columns
        col.is_sorting = 0
        col.sort_class = 'fa-sort'

    # organises the information of the columns that are going to be sorted.
    # returns true if the sorting needs to be descending, false otherwise.
    setupColSorting: (columns, comparator) ->

      is_descending = false

      for col in columns

        # set is_sorting attribute for the comparator column
        if col.comparator == comparator

          col.is_sorting = switch col.is_sorting
            when 0 then 1
            else -col.is_sorting

          is_descending = col.is_sorting == -1

        else
        # for the rest of the columns is zero
          col.is_sorting = 0

        # now set the class for font-awesome
        # this was the simplest way I found to do it, handlebars doesn't provide a '==' expression

        col.sort_class = switch col.is_sorting
          when -1 then 'fa-sort-desc'
          when 0 then 'fa-sort'
          when 1 then 'fa-sort-asc'

      return is_descending


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

