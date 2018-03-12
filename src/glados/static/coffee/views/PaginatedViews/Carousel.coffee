glados.useNameSpace 'glados.views.PaginatedViews',
  Carousel:

    initAvailablePageSizes: ->

      if @config.custom_available_page_sizes?
        @AVAILABLE_PAGE_SIZES = @config.custom_available_page_sizes
        @currentPageSize = @AVAILABLE_PAGE_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]

      if @config.custom_card_sizes?
        @CURRENT_CARD_SIZES = @config.custom_card_sizes

      else
        @AVAILABLE_PAGE_SIZES ?= (size for key, size of glados.Settings.DEFAULT_CAROUSEL_SIZES)
        @currentPageSize = glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]

      f = (newPageSize) ->
        @currentPageSize = newPageSize
        @collection.resetPageSize(newPageSize)

      resetPageSizeProxy = $.proxy(f, @)
      thisView = @
      $(window).resize ->
        if GlobalVariables.CURRENT_SCREEN_TYPE_CHANGED
          if thisView.config.custom_available_page_sizes?
            resetPageSizeProxy thisView.AVAILABLE_PAGE_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]
          else
            resetPageSizeProxy glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]

    getPageEvent: (event) ->
      clicked = $(event.currentTarget)
      currentPage = @collection.getMeta('current_page')
      pageNum = clicked.attr('data-page')


      if not @eventForThisView(clicked)
        return
      # Don't bother if the link was disabled.
      if clicked.hasClass('disabled') or clicked.hasClass('previous')
        return

      if pageNum != 'next' and pageNum <= currentPage
        return

      nextPage = if pageNum == 'next' then currentPage + 1 else pageNum

      @generatePageQueue(parseInt(currentPage), parseInt(nextPage))
      nextPageToLoad = @pageQueue.shift()
      @requestPageInCollection(nextPageToLoad)

    # function to generate queue
    generatePageQueue: (startPage, endPage) ->
      @pageQueue = (num for num in [(startPage + 1)..(endPage + 1)])


    initPageQueue: ->
      @pageQueue = [2]
      @renderedPages = [1, 2]
      console.log '@pageQueue: ', @pageQueue
      console.log '@renderedPages: ', @renderedPages
#      @collection.setMeta('current_page', 1)
#      @fillPaginators()

    renderViewState: ->
      console.log 'RENDER STATE VIEW; PAGE: ', @collection.getMeta('current_page')

      isDefaultZoom = @mustDisableReset()
      mustComplicate = @collection.getMeta('complicate_cards_view')
      @isComplicated = isDefaultZoom and mustComplicate

      @fillSelectAllContainer() unless @disableItemsSelection
      @fillPaginators()
      if @collection.getMeta('total_pages') == 1
        @hidePaginators()
        @hideFooter()
      @activateSelectors()
      @showPaginatedViewContent()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)
      nextPageToLoad = @pageQueue.shift()
#      console.log '@pageQueue: ', nextPageToLoad
      if nextPageToLoad?
        @requestPageInCollection(nextPageToLoad)
#        @collection.setMeta('current_page', nextPageToLoad - 1)
      currentPage = @collection.getMeta('current_page')
      @collection.setMeta('current_page', currentPage - 1 )
#      console.log 'SET CURRENT PAGE: '

      @fillPaginators()

    sendDataToTemplate: ($specificElemContainer, visibleColumns) ->
      customTemplateID =  @collection.getMeta('columns_description').Carousel.CustomItemTemplate
      glados.views.PaginatedViews.PaginatedViewBase.sendDataToTemplate.call(@, $specificElemContainer, visibleColumns,
        customTemplateID)
    # ------------------------------------------------------------------------------------------------------------------
    # Columns initalisation
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Carousel.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Carousel.Additional