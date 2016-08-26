# This class implements the pagination, sorting and searching for a collection
# extend it to get a collection with the extra capabilities
PaginatedCollection = Backbone.Collection.extend

  setMeta: (attr, value) ->

    if _.isString(value)
      value = parseInt(value)

    @meta[attr] = value
    @trigger('meta-changed')

  getMeta: (attr) ->
    return @meta[attr]

  resetPageSize: (new_page_size) ->

    if @getMeta('server_side') == true
      @resetPageSizeSS(new_page_size)
    else
      @resetPageSizeC(new_page_size)

  # assuming that I have all the records.
  # Meta data is:
  #  server_side -- true if you expect that each page is fetched on demand by the server.
  #  total_records
  #  current_page
  #  total_pages
  #  records_in_page -- How many records are in the current page
  #  sorting data per column.
  #
  resetMeta: (page_meta) ->

    if @getMeta('server_side') == true
      @resetMetaSS(page_meta)
    else
      @resetMetaC()

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

    if @getMeta('server_side') == true
      @getCurrentPageSS()
    else
      @getCurrentPageC()

  # page num must be always a number
  setPage: (page_num) ->

    # don't bother if the page requested is greater than the total number of pages
    if page_num > @getMeta('total_pages')
      return

    if @getMeta('server_side') == true
      @setPageSS(page_num)
    else
      @setPageC(page_num)

  sortCollection: (comparator) ->

    if @getMeta('server_side') == true
      @sortCollectionSS(comparator)
    else
      @sortCollectionC(comparator)


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

  # sets the term to search in the collection
  # when the collection is server side, the corresponding column is required.
  # This is because the web services don't provide a search with OR
  # for client side, it can be null, but for example for server side
  # for chembl25, term will be 'chembl25', column will be 'molecule_chembl_id'
  setSearch: (term, column)->

    if @getMeta('server_side') == true
      @setSearchSS(term, column)
    else
      @setSearchC(term)

  # from all the comparators, returns the one that is being used for sorting.
  # if none is being used for sorting returns undefined
  getCurrentSortingComparator: () ->

    columns = @getMeta('columns')
    sorVal = _.find(columns, (col) -> col.is_sorting != 0 )

    comp = undefined
    comp = sorVal.comparator unless !sorVal?

    return comp


  # ------------------------------------------------------------
  # -- Client Side!!!
  # ------------------------------------------------------------

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


  resetMetaC: ->

    @setMeta('total_records', @models.length)
    @setMeta('current_page', 1)
    @calculateTotalPages()
    @calculateHowManyInCurrentPage()
    @resetSortData()
    @resetSearchStruct()

  getCurrentPageC: ->

    page_size = @getMeta('page_size')
    current_page = @getMeta('current_page')
    records_in_page = @getMeta('records_in_page')

    start = (current_page - 1) * page_size
    end = start + records_in_page

    to_show = @models[start..end]
    @setMeta('to_show', to_show)

    return to_show

  setPageC: (page_num) ->

    @setMeta('current_page', page_num)
    @trigger('do-repaint')

  resetPageSizeC: (new_page_size) ->

    if new_page_size == ''
      return

    @setMeta('page_size', new_page_size)
    @setMeta('current_page', 1)
    @calculateTotalPages()
    @calculateHowManyInCurrentPage()
    @trigger('do-repaint')

  sortCollectionC: (comparator) ->

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

  setSearchC: (term) ->

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

  # ------------------------------------------------------------
  # -- Server Side!!!
  # ------------------------------------------------------------

  resetMetaSS: (page_meta) ->

    @setMeta('total_records', page_meta.total_count)
    @setMeta('page_size', page_meta.limit)
    @setMeta('current_page', (page_meta.offset / page_meta.limit) + 1)
    @setMeta('total_pages', Math.ceil(page_meta.total_count / page_meta.limit) )
    @setMeta('records_in_page', page_meta.records_in_page )

  getCurrentPageSS: ->

    # allways the models represent the current page
    return @models

  setPageSS: (page_num) ->

    base_url = @getMeta('base_url')
    @setMeta('current_page', page_num)
    @url = @getPaginatedURL()
    console.log('Getting page:')
    console.log(page_num)
    console.log('URL')
    console.log(@url)
    @fetch()

  getPaginatedURL: () ->

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


    searchParts = []
    for column, term of searchTerms
      params.push(column + "__contains=" + term) unless term == ''
      searchParts.push(column + "__contains=" + term) unless term == ''

    full_url = url + '?' + params.join('&')

    return full_url

  resetPageSizeSS: (new_page_size) ->

    if new_page_size == ''
      return

    @setMeta('page_size', new_page_size)
    @setPage(1)

  sortCollectionSS: (comparator) ->

    @setMeta('current_page', 1)
    columns = @getMeta('columns')
    @setupColSorting(columns, comparator)
    @url = @getPaginatedURL()
    console.log('URL')
    console.log(@url)
    @fetch()

  setSearchSS: (term, column) ->

    @setMeta('current_page', 1)
    # create the search term objects if it doesn't exist
    @setMeta('search_terms', {}) unless @getMeta('search_terms')?

    searchTerms = @getMeta('search_terms')
    searchTerms[column] = term

    @url = @getPaginatedURL()
    console.log('URL')
    console.log(@url)
    @fetch()

