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

      if clicked.hasClass('disabled')
        return


      if pageNum <= currentPage - 1 or clicked.attr('data-page') == 'previous'
#        paginatorPage = if clicked.hasClass('previous') then currentPage - 1 else pageNum
#        @collection.setMeta('current_page', paginatorPage)
#        @fillPaginators()
        return

      nextPage = if pageNum == 'next' then currentPage else pageNum

      @generatePageQueue(parseInt(currentPage), parseInt(nextPage))
      nextPageToLoad = @pageQueue.shift()
      @requestPageInCollection(nextPageToLoad)

      @collection.setMeta('current_page',nextPage)
      @fillPaginators()
      @animateCards()

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
        @collection.setMeta('current_page', nextPageToLoad - 1)
        @fillPaginators()

      @fillSelectAllContainer() unless @disableItemsSelection
      if @collection.getMeta('total_pages') == 1
        @hidePaginators()
        @hideFooter()
      @activateSelectors()
      @showPaginatedViewContent()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)

    animateCards: ->
      console.log 'ANIMATE CARDS'
      $elem = $(@el).find '.BCK-items-container'
#      cardsToMove = $elem.children '.carousel-card:lt(6)'
#      cardsToMove.addClass '.animated-card'
      $elem.css "background-color",  "red"
      $elem.animate {
        "transform" : "translate(50px,100px)"
      }

#      cardsToMove.animate({"transform" :"translate(-50px,0)"})


    sendDataToTemplate: ($specificElemContainer, visibleColumns) ->
      customTemplateID =  @collection.getMeta('columns_description').Carousel.CustomItemTemplate
      glados.views.PaginatedViews.PaginatedViewBase.sendDataToTemplate.call(@, $specificElemContainer, visibleColumns,
        customTemplateID)
    # ------------------------------------------------------------------------------------------------------------------
    # Columns initalisation
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Carousel.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Carousel.Additional

