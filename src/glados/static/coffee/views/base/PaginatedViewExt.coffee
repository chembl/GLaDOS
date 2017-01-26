# This is a base object for the paginated tables, extend a view in backbone with this object
# to get the functionality for handling the pagination.
# this way allows to easily handle multiple inheritance in the models.
PaginatedViewExt =

  events:
    'click .page-selector': 'getPageEvent'
    'change .change-page-size': 'changePageSize'
    'click .sort': 'sortCollection'
    'input .search': 'setSearch'
    'change select.select-search' : 'setSearch'
    'change .select-sort': 'sortCollectionFormSelect'
    'click .btn-sort-direction': 'changeSortOrderInf'

  # fills a template with the contents of the collection's current page
  # it handle the case when the items are shown as list, table, or infinite browser
  fillTemplates: ->

    $elem = $(@el).find('.BCK-items-container')

    if @collection.length > 0
      for i in [0..$elem.length - 1]
        @sendDataToTemplate $($elem[i])
      @showFooterContainer()
    else
      @hideHeaderContainer()
      @hideFooterContainer()
      @hideContentContainer()
      @showEmptyMessageContainer()

  sendDataToTemplate: ($specificElem) ->

    $item_template = $('#' + $specificElem.attr('data-hb-template'))
    $append_to = $specificElem
    # if it is a table, add the corresponding header
    if $specificElem.is('table')

      header_template = $('#' + $specificElem.attr('data-hb-header-template'))
      header_row_cont = Handlebars.compile( header_template.html() )
        columns: @collection.getMeta('columns')

      $specificElem.append($(header_row_cont))
      # make sure that the rows are appended to the tbody, otherwise the striped class won't work
      $specificElem.append($('<tbody>'))
    for item in @collection.getCurrentPage()


      img_url = ''
      # handlebars only allow very simple logic, we have to help the template here and
      # give it everything as ready as possible
      columnsWithValues = @collection.getMeta('columns').map (col) ->
        col['value'] = item.get(col.comparator)
        col['has_link'] = _.has(col, 'link_base')
        col['link_url'] = item.get(col['link_base']) unless !col['has_link']
        if _.has(col, 'image_base_url')
          img_url = item.get(col['image_base_url'])
        if _.has(col, 'custom_field_template')
          col['custom_html'] = Handlebars.compile(col['custom_field_template'])
            val: col['value']

      new_item_cont = Handlebars.compile( $item_template.html() )
        img_url: img_url
        columns: @collection.getMeta('columns')

      $append_to.append($(new_item_cont))

    if not $specificElem.is('table')
      # JavaScript rendering can take a while to update the correct height of the cards
      # Timeout zero will let other code execute while this waits on that code to setup
      # correctly the height of each card
      setTimeout(
        ()->
          max_h = 0
          $cards = $append_to.find('.card')
          $cards.each(
            (index, elem)->
              max_h = Math.max(max_h, $(elem).height())
          )
          console.log("MAX HEIGHT : "+max_h)
          $cards.height(max_h)
        , 0
      )


  fillPaginators: ->

    $elem = $(@el).find('.BCK-paginator-container')
    template = $('#' + $elem.attr('data-hb-template'))

    current_page = @collection.getMeta('current_page')
    records_in_page = @collection.getMeta('records_in_page')
    page_size = @collection.getMeta('page_size')
    num_pages = @collection.getMeta('total_pages')

    first_record = (current_page - 1) * page_size
    last_page = first_record + records_in_page

    # this sets the window for showing the pages
    show_previous_ellipsis = false
    show_next_ellipsis = false
    if num_pages <= 5
      first_page_to_show = 1
      last_page_to_show = num_pages
    else if current_page + 2 <= 5
      first_page_to_show = 1
      last_page_to_show = 5
      show_next_ellipsis = true
    else if current_page + 2 < num_pages
      first_page_to_show = current_page - 2
      last_page_to_show = current_page + 2
      show_previous_ellipsis = true
      show_next_ellipsis = true
    else
      first_page_to_show = num_pages - 4
      last_page_to_show = num_pages
      show_previous_ellipsis = true

    pages = (num for num in [first_page_to_show..last_page_to_show])

    $elem.html Handlebars.compile(template.html())
      pages: pages
      records_showing: (first_record+1) + '-' + last_page
      total_records: @collection.getMeta('total_records')
      show_next_ellipsis: show_next_ellipsis
      show_previous_ellipsis: show_previous_ellipsis

    @activateCurrentPageButton()
    @enableDisableNextLastButtons()

  fillNumResults: ->
    $elem = $(@el).find('.num-results')
    $template = $('#' + $elem.attr('data-hb-template'))

    $elem.html Handlebars.compile($template.html())
      num_results: @collection.getMeta('total_records')

    console.log @collection.getMeta('total_records')


  getPageEvent: (event) ->

    clicked = $(event.currentTarget)

    # Don't bother if the link was disabled.
    if clicked.hasClass('disabled')
      return

    @showPaginatedViewPreloader() unless @collection.getMeta('server_side') != true

    pageNum = clicked.attr('data-page')
    @requestPageInCollection(pageNum)


  requestPageInCollection: (pageNum) ->

    currentPage = @collection.getMeta('current_page')
    totalPages = @collection.getMeta('total_pages')

    if pageNum == "previous"
      pageNum = currentPage - 1
    else if pageNum == "next"
      pageNum = currentPage + 1

    # Don't bother if the user requested is greater than the max number of pages
    if pageNum > totalPages
      return

    @collection.setPage(pageNum)


  enableDisableNextLastButtons: ->

    current_page = parseInt(@collection.getMeta('current_page'))
    total_pages = parseInt(@collection.getMeta('total_pages'))

    if current_page == 1
      $(@el).find("[data-page='previous']").addClass('disabled')
    else
      $(@el).find("[data-page='previous']").removeClass('disabled')

    if current_page == total_pages
      $(@el).find("[data-page='next']").addClass('disabled')
    else
      $(@el).find("[data-page='next']").removeClass('disabled')

  activateCurrentPageButton: ->

    current_page = @collection.getMeta('current_page')
    $(@el).find('.page-selector').removeClass('active')
    $(@el).find("[data-page=" + current_page + "]").addClass('active')

  changePageSize: (event) ->

    @showPaginatedViewPreloader() unless @collection.getMeta('server_side') != true
    selector = $(event.currentTarget)
    new_page_size = selector.val()
    @collection.resetPageSize(new_page_size)

  #--------------------------------------------------------------------------------------
  # Search
  #--------------------------------------------------------------------------------------
  setSearch: _.debounce( (event) ->

    $searchInput = $(event.currentTarget)
    term = $searchInput.val()
    # if the collection is client side the column and data type will be undefined and will be ignored.
    column = $searchInput.attr('data-column')
    type = $searchInput.attr('data-column-type')

    @triggerSearch(term, column, type)

  , glados.Settings['SEARCH_INPUT_DEBOUNCE_TIME'])

  # this closes the function setNumeric search with a jquery element, the idea is that
  # you can get the attributes such as the column for the search, and min and max values
  # from the jquery element
  setNumericSearchWrapper: ($elem) ->

    ctx = @
    setNumericSearch = _.debounce( (values, handle) ->

      term =  values.join(',')
      column = $elem.attr('data-column')
      type = $elem.attr('data-column-type')

      ctx.triggerSearch(term, column, type)
    , glados.Settings['SEARCH_INPUT_DEBOUNCE_TIME'])


    return setNumericSearch


  triggerSearch:  (term, column, type) ->

    @clearContentContainer()
    @showPaginatedViewPreloader()

    @collection.setSearch(term, column, type)
  #--------------------------------------------------------------------------------------
  # Sort
  #--------------------------------------------------------------------------------------

  sortCollection: (event) ->

    @showPaginatedViewPreloader() unless @collection.getMeta('server_side') != true
    order_icon = $(event.currentTarget)
    comparator = order_icon.attr('data-comparator')

    @triggerCollectionSort(comparator)

  triggerCollectionSort: (comparator) ->

    @clearContentContainer()
    @showPaginatedViewPreloader()

    @collection.sortCollection(comparator)

  #--------------------------------------------------------------------------------------
  # Preloaders and content
  #--------------------------------------------------------------------------------------
  showPaginatedViewContent: ->

    $preloaderCont = $(@el).find('.BCK-PreoladerContainer')
    $contentCont =  $(@el).find('.BCK-items-container')

    $preloaderCont.hide()
    $contentCont.show()

  showPaginatedViewPreloader: ->

    $preloaderCont = $(@el).find('.BCK-PreoladerContainer')
    $contentCont =  $(@el).find('.BCK-items-container')

    $preloaderCont.show()
    $contentCont.hide()

  # show the preloader making sure the content is also visible, useful for the infinite browser
  showPaginatedViewPreloaderAndContent: ->

    $preloaderCont = $(@el).find('.BCK-PreoladerContainer')
    $contentCont =  $(@el).find('.BCK-items-container')

    $preloaderCont.show()
    $contentCont.show()

  clearContentContainer: ->
    $(@el).find('.BCK-items-container').empty()
    @hideEmptyMessageContainer()
    @showContentContainer()

  hidePreloaderOnly: ->
    $preloaderCont = $(@el).find('.BCK-PreoladerContainer')
    $preloaderCont.hide()

  hideHeaderContainer: ->
    $headerRow = $(@el).find('.BCK-header-container')
    $headerRow.hide()

  hideFooterContainer: ->
    $headerRow = $(@el).find('.BCK-footer-container')
    $headerRow.hide()

  showFooterContainer: ->
    $headerRow = $(@el).find('.BCK-footer-container')
    $headerRow.show()

  hideContentContainer: ->
    $headerRow = $(@el).find('.BCK-items-container')
    $headerRow.hide()

  showContentContainer: ->
    $headerRow = $(@el).find('.BCK-items-container')
    $headerRow.show()

  hideEmptyMessageContainer: ->
    $headerRow = $(@el).find('.BCK-EmptyListMessage')
    $headerRow.hide()

  showEmptyMessageContainer: ->
    $headerRow = $(@el).find('.BCK-EmptyListMessage')
    $headerRow.show()


  #--------------------------------------------------------------------------------------
  # Infinite Browser
  #--------------------------------------------------------------------------------------
  showControls: ->
    $(@el).find('.controls').removeClass('hide')

  showNumResults: ->

    $(@el).children('.num-results').show()

  hideNumResults: ->

    $(@el).children('.num-results').hide()


  setUpLoadingWaypoint: ->

    $cards = $('.BCK-items-container').children()

    # don't bother when there aren't any cards
    if $cards.length == 0
      return

    $middleCard = $cards[Math.floor($cards.length / 4)]

    # the advancer function requests always the next page
    advancer = $.proxy ->
      #destroy waypoint to avoid issues with triggering more page requests.
      Waypoint.destroyAll()
      # dont' bother if already on last page
      if @collection.currentlyOnLastPage()
        return
      @showPaginatedViewPreloaderAndContent()
      @requestPageInCollection('next')
    , @

    # destroy all waypoints before assigning the new one.
    Waypoint.destroyAll()

    waypoint = new Waypoint(
      element: $middleCard
      handler: (direction) ->

        if direction == 'down'
          advancer()

    )

  # checks if there are more page and hides the preloader if there are no more.
  hidePreloaderIfNoNextItems: ->

    if @collection.currentlyOnLastPage()
      @hidePreloaderOnly()

  #--------------------------------------------------------------------------------------
  # sort selector
  #--------------------------------------------------------------------------------------

  renderSortingSelector: ->

    $selectSortContainer = $(@el).find('.select-sort-container')
    $selectSortContainer.empty()

    $template = $('#' + $selectSortContainer.attr('data-hb-template'))
    columns = @collection.getMeta('columns')

    col_comparators = _.map(columns, (col) -> {comparator: col.comparator, selected: col.is_sorting != 0})
    one_selected = _.reduce(col_comparators, ((a, b) -> a.selected or b.selected), 0 )

    $selectSortContainer.html Handlebars.compile( $template.html() )
      columns: col_comparators
      one_selected: one_selected

    $btnSortDirectionContainer = $(@el).find('.btn-sort-direction-container')
    $btnSortDirectionContainer.empty()

    $template = $('#' + $btnSortDirectionContainer.attr('data-hb-template'))


    # relates the sort direction with a class and a text for the template
    sortClassAndText =
      '-1': {sort_class: 'fa-sort-desc', text: 'Desc'},
      '0': {sort_class: 'fa-sort', text: ''},
      '1': {sort_class: 'fa-sort-asc', text: 'Asc'}

    currentSortDirection = _.reduce(_.pluck(columns, 'is_sorting'), ((a, b) -> a + b), 0)
    currentProps = sortClassAndText[currentSortDirection.toString()]

    $btnSortDirectionContainer.html Handlebars.compile( $template.html() )
      sort_class:  currentProps.sort_class
      text: currentProps.text
      disabled: currentSortDirection == 0


  sortCollectionFormSelect: (event) ->

    @showPaginatedViewPreloader()

    selector = $(event.currentTarget)
    comparator = selector.val()

    if comparator == ''
      return

    @triggerCollectionSort(comparator)

  changeSortOrderInf: ->

    comp = @collection.getCurrentSortingComparator()
    if comp?
      @triggerCollectionSort(comp)

  #--------------------------------------------------------------------------------------
  # Page selector
  #--------------------------------------------------------------------------------------

  fillPageSelectors: ->

    $elem = $(@el).find('.BCK-select-page-size-container')
    $contentTemplate = $('#' + $elem.attr('data-hb-template'))

    currentPageSize = @collection.getMeta('page_size')
    pageSizesItems = []

    for size in @collection.getMeta('available_page_sizes')
      item = {}
      item.number = size
      item.is_selected = currentPageSize == size
      pageSizesItems.push(item)

    $elem.html Handlebars.compile( $contentTemplate.html() )
      items: pageSizesItems

  activateSelectors: ->

    $(@el).find('select').material_select()

