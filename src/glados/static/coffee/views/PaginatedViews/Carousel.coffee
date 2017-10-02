glados.useNameSpace 'glados.views.PaginatedViews',
  Carousel:

    initAvailablePageSizes: ->

      @AVAILABLE_PAGE_SIZES = (size for key, size of glados.Settings.DEFAULT_CAROUSEL_SIZES)
      @currentPageSize = glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]
      console.log 'CURRENT PAGE SIZE: ', @currentPageSize

      f = (newPageSize) ->
        @currentPageSize = newPageSize
        @collection.resetPageSize(newPageSize)

      resetPageSizeProxy = $.proxy(f, @)
      $(window).resize ->
        if GlobalVariables.CURRENT_SCREEN_TYPE_CHANGED
          resetPageSizeProxy glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]

    renderViewState: ->

      isDefaultZoom = @mustDisableReset()
      mustComplicate = @collection.getMeta('complicate_cards_view')
      @isComplicated = isDefaultZoom and mustComplicate

      @clearContentContainer()
      @fillTemplates()

      @fillSelectAllContainer() unless @disableItemsSelection
      @fillPaginators()
      @activateSelectors()
      @showPaginatedViewContent()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)