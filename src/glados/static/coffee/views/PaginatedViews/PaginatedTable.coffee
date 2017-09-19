glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedTable:

    initAvailablePageSizes: ->
      
      @AVAILABLE_PAGE_SIZES = [5, 10, 20, 50, 100]