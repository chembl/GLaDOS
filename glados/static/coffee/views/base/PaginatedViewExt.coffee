# This is a base object for the paginated tables, extend a view in backbone with this object
# to get the functionality for handling the pagination.
# this way allows to easily handle multiple inheritance in the models.
PaginatedViewExt =

  events:
    'click .page-selector': 'getPage'
    'change .change-page-size': 'changePageSize'
    'click .sort': 'sortCollection'
    'input .search': 'setSearch'


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

