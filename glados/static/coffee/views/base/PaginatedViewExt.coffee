# This is a base object for the paginated tables, extend a view in backbone with this object
# to get the functionality for handling the pagination.
# this way allows to easily handle multiple inheritance in the models.
PaginatedViewExt =

  events:
    'click .page-selector': 'getPage'
    'change .change-page-size': 'changePageSize'
    'click .sort': 'sortCollection'
    'input .search': 'setSearch'

  fill_template: (elem_id) ->

    elem = $(@el).find('#' + elem_id)
    template = $('#' + elem.attr('data-hb-template'))

    if elem.is('table')

      header_template = $('#' + elem.attr('data-hb-template-2'))
      header_row_cont = Handlebars.compile( header_template.html() )
        columns: @collection.getMeta('columns')

      elem.append($(header_row_cont))

    for item in @collection.getCurrentPage()

      columns_val = @collection.getMeta('columns').map (col) ->
        col['value'] = item.get(col.comparator)
        col['has_link'] = col.link_base?
        col['link_url'] = col['link_base'].replace('$$$', col['value']) unless !col['has_link']

      new_row_cont = Handlebars.compile( template.html() )
        columns: @collection.getMeta('columns')

      elem.append($(new_row_cont))

  fillPaginator: (elem_id) ->

    elem = $(@el).find('#' + elem_id)
    template = $('#' + elem.attr('data-hb-template'))

    current_page = @collection.getMeta('current_page')
    records_in_page = @collection.getMeta('records_in_page')
    page_size = @collection.getMeta('page_size')
    num_pages = @collection.getMeta('total_pages')

    first_record = (current_page - 1) * page_size
    last_page = first_record + records_in_page

    # this sets the window for showing the pages
    show_previous_ellipsis = false
    show_next_ellipsis = false
    if num_pages < 5
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

    elem.html Handlebars.compile(template.html())
      pages: pages
      records_showing: first_record + '-' + last_page
      total_records: @collection.getMeta('total_records')
      show_next_ellipsis: show_next_ellipsis
      show_previous_ellipsis: show_previous_ellipsis

    @activateCurrentPageButton()
    @enableDisableNextLastButtons()

  getPage: (event) ->

    clicked = $(event.currentTarget)

    # Don't bother if the link was disabled.
    if clicked.hasClass('disabled')
      return

    requested_page_num = clicked.attr('data-page')
    current_page = @collection.getMeta('current_page')

    # Don't bother if the user requested the same page as the current one
    if current_page == requested_page_num
      return

    if requested_page_num == "previous"
      requested_page_num = current_page - 1
    else if requested_page_num == "next"
      requested_page_num = current_page + 1

    @collection.setPage(requested_page_num)

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

    selector = $(event.currentTarget)
    new_page_size = selector.val()
    @collection.resetPageSize(new_page_size)

  setSearch: ->
    console.log('search!!')

  sortCollection: (event) ->
    order_icon = $(event.currentTarget)
    comparator = order_icon.attr('data-comparator')
    @collection.sortCollection(comparator)

  activatePageSelector: ->
    $('select').material_select();
