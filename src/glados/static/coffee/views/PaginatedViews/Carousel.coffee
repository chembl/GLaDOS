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

    bindCollectionEvents: ->
      @collection.on glados.Events.Collections.SELECTION_UPDATED, @selectionChangedHandler, @

      if @customRenderEvents?
        @collection.on @customRenderEvents, @.render, @

      @collection.on 'reset sort do-repaint', @render, @
      @collection.on 'error', @handleError, @

    getPageEvent: (event) ->
      clicked = $(event.currentTarget)
      currentPage = @collection.getMeta('current_page')
      pageNum = clicked.attr('data-page')

      if not @eventForThisView(clicked)
        return

      if clicked.hasClass('disabled')
        return

      if parseInt(pageNum) == parseInt(currentPage) - 1
        console.log 'Clicked same page: do nothing'
        return

#     Going backwards (collection is one page ahead of paginator number)
      if parseInt(pageNum) < parseInt(currentPage) - 1 or clicked.attr('data-page') == 'previous'
        console.log 'Go back'
        paginatorPage = if clicked.hasClass('previous') then parseInt(currentPage) - 2 else parseInt(pageNum)
        console.log 'GOING BACK TO PAGE: ', paginatorPage
#        @animateCards(currentPage, paginatorPage)

#        @fillPaginators(customPag)
        return

#     Going forward
      nextPage = if pageNum == 'next' then currentPage else pageNum
      @generatePageQueue(parseInt(currentPage), parseInt(nextPage))
      nextPageToLoad = @pageQueue.shift()
      #if next page is > collection current Page
      @requestPageInCollection(nextPageToLoad)
#      @fillPaginators(nextPage)
#      @animateCards(currentPage, nextPage)

    generatePageQueue: (startPage, endPage) ->
      @pageQueue = (num for num in [(startPage + 1)..(endPage + 1)])

    initPageQueue: ->
      @pageQueue = [2]

    renderViewState: ->
      isDefaultZoom = @mustDisableReset()
      mustComplicate = @collection.getMeta('complicate_cards_view')
      @isComplicated = isDefaultZoom and mustComplicate

      nextPageToLoad = @pageQueue.shift()

      if nextPageToLoad?
        @requestPageInCollection(nextPageToLoad)

      @fillPaginators(@collection.getMeta('current_page') - 1)
      @fillSelectAllContainer() unless @disableItemsSelection
      if @collection.getMeta('total_pages') == 1
        @hidePaginators()
        @hideFooter()

      @activateSelectors()
      @showPaginatedViewContent()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)

    animateCards: (currentPage, nextPage) ->

      $elem = $(@el).find '.BCK-items-container'
      $elem.show()
      pxToMove = $elem.children('.carousel-card').first().width() * (nextPage - currentPage + 1) * @currentPageSize
      $elem.animate {
        left: '-=' + pxToMove + 'px'
      }

    sendDataToTemplate: ($specificElemContainer, visibleColumns) ->
      customTemplateID =  @collection.getMeta('columns_description').Carousel.CustomItemTemplate
      glados.views.PaginatedViews.PaginatedViewBase.sendDataToTemplate.call(@, $specificElemContainer, visibleColumns,
        customTemplateID)
    # ------------------------------------------------------------------------------------------------------------------
    # Columns initalisation
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Carousel.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Carousel.Additional

