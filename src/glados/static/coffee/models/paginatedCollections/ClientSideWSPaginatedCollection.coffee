glados.useNameSpace 'glados.models.paginatedCollections',

  # --------------------------------------------------------------------------------------------------------------------
  # This class implements the pagination, sorting and searching for a CLIENT SIDE collection using the Web Services
  # extend it to get a collection with the extra capabilities
  # a Client Side collection means that all the information is in the client all the time. it is downloaded in one single
  # call, the pagination is made by limiting the access to the collection items
  # --------------------------------------------------------------------------------------------------------------------
  ClientSideWSPaginatedCollection: Backbone.Collection.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Metadata Handlers
    # ------------------------------------------------------------------------------------------------------------------
    # Meta data is:
    #  total_records
    #  current_page
    #  total_pages
    #  records_in_page -- How many records are in the current page
    #  sorting data per column.
    #
    setMeta: (attr, value, storeAsString) ->

      if _.isString(value) and !storeAsString
        value = parseInt(value)

      @meta[attr] = value
      @trigger('meta-changed')

    getMeta: (attr) ->
      return @meta[attr]

    resetMeta: ->

      @setMeta('total_records', @models.length)
      @setMeta('current_page', 1)
      @calculateTotalPages()
      @calculateHowManyInCurrentPage()
      @resetSortData()
      @resetSearchStruct()

    # ------------------------------------------------------------------------------------------------------------------
    # Pagination
    # ------------------------------------------------------------------------------------------------------------------

    resetPageSize: (new_page_size) ->

      if new_page_size == ''
        return

      @setMeta('page_size', new_page_size)
      @setMeta('current_page', 1)
      @calculateTotalPages()
      @calculateHowManyInCurrentPage()
      @trigger('do-repaint')

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

      page_size = @getMeta('page_size')
      current_page = @getMeta('current_page')
      records_in_page = @getMeta('records_in_page')

      start = (current_page - 1) * page_size
      end = start + records_in_page

      to_show = @models[start..end]
      @setMeta('to_show', to_show)

      return to_show

    setPage: (page_num) ->

      # don't bother if the page requested is greater than the total number of pages
      if page_num > @getMeta('total_pages')
        return

      @setMeta('current_page', page_num)
      @trigger('do-repaint')

    sortCollection: (comparator) ->

      @comparator = comparator
      columns = @getMeta('columns')
      is_descending = @setupColSorting(columns, comparator)

      # check if sorting is descending
      if is_descending
        @sort({silent: true})
        @models = @models.reverse()
        @trigger('sort')
      else
        @sort()

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

    # from all the comparators, returns the one that is being used for sorting.
    # if none is being used for sorting returns undefined
    getCurrentSortingComparator: ->

      columns = @getMeta('columns')
      sorVal = _.find(columns, (col) -> col.is_sorting != 0 )

      comp = undefined
      comp = sorVal.comparator unless !sorVal?

      return comp

    # tells if the current page is the last page
    currentlyOnLastPage: ->

      @getMeta('current_page') == @getMeta('total_pages')

    # ------------------------------------------------------------------------------------------------------------------
    # Search
    # ------------------------------------------------------------------------------------------------------------------
    setSearch: (term) ->

      @setMeta('force_show', true)
      term = term.toUpperCase()
      original_models = @getMeta('original_models')

      search_dict = @getMeta('search_dict')
      keys = Object.keys(search_dict)

      answer = []

      for key in keys

        model = search_dict[key]
        model.set('show', key.indexOf(term) != -1)

      new_models = _.filter(original_models, (item) -> item.get('show') )

      @models = new_models
      @reset(new_models)

    resetSearchStruct: ->

      # only set this once, when the collection is fresh from server
      if !@getMeta('original_models')?
        @setMeta('original_models', @models)

        search_dict = {}
        for model in @models

          # very simple search to see if it works for now
          full_search_str = ''
          for comparator in _.pluck(@getMeta('columns'), 'comparator')
            full_search_str += ' ' + model.get(comparator)

          # this will end up ignoring duplicate rows
          search_dict[full_search_str.toUpperCase()] = model

        @setMeta('search_dict', search_dict)