glados.useNameSpace 'glados.views.PaginatedViews',
  InfiniteCards:

    initAvailablePageSizes: ->
      @AVAILABLE_PAGE_SIZES = [6, 12, 24, 48, 96]
      @currentPageSize = @AVAILABLE_PAGE_SIZES[2]