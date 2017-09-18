glados.useNameSpace 'glados.views.PaginatedViews',
  PaginationFunctions:

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
      # this is an issue with materialise, it fires 2 times the event, one of which has an empty value
      if new_page_size == ''
        return
      @collection.resetPageSize(new_page_size)



