glados.useNameSpace 'glados.views.PaginatedViews',
  InfiniteCards:

    initAvailablePageSizes: ->
      @AVAILABLE_PAGE_SIZES = [50]
      @currentPageSize = @AVAILABLE_PAGE_SIZES[0]

    wakeUpView: ->
      @currentPageNum = 1
      glados.views.PaginatedViews.PaginatedViewBase.wakeUpView.call(@)

    #-------------------------------------------------------------------------------------------------------------------
    # Zoom
    #-------------------------------------------------------------------------------------------------------------------
    CARD_SIZE_TO_MIN_PAGE_SIZE:
      12: 50
      6: 50
      4: 50
      3: 100
      2: 100
      1: 200

    finishZoom: (minPageSize) ->

      if @currentPageSize < minPageSize
        @requestPageSizeInCollection(minPageSize)
      else
        @requestPageInCollection(1)



