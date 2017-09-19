glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedCards:

    initAvailablePageSizes: ->
      @AVAILABLE_PAGE_SIZES = [6, 12, 24, 48, 96, 192]
      @currentPageSize = @AVAILABLE_PAGE_SIZES[2]

    #-------------------------------------------------------------------------------------------------------------------
    # Zoom
    #-------------------------------------------------------------------------------------------------------------------
    CARD_SIZE_TO_MIN_PAGE_SIZE:
      12: 6
      6: 6
      4: 12
      3: 24
      2: 96
      1: 192

    finishZoom: (minPageSize) ->

      if @currentPageSize < minPageSize
        @requestPageSizeInCollection(minPageSize)
      else
        @render()