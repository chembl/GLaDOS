glados.useNameSpace 'glados.views.PaginatedViews',
  Carousel:
    isCarousel: -> true
    activePage: 1
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

      if clicked.hasClass('disabled') or parseInt(pageNum) == @activePage
        return

#     Going backwards
      beforePage = parseInt(@activePage)
      if parseInt(pageNum) < parseInt(@activePage) or clicked.attr('data-page') == 'previous'
        @activePage = if clicked.hasClass('previous') then parseInt(@activePage) - 1 else pageNum
        @fillPaginators(parseInt(@activePage))
        @animateCards(beforePage, parseInt(@activePage))
        return


#     Going forward
      else
        @activePage = if pageNum == 'next' then parseInt(@activePage) + 1 else pageNum
        if parseInt(@activePage) >= parseInt(currentPage)
          @generatePageQueue(parseInt(currentPage), parseInt(@activePage))
          nextPageToLoad = @pageQueue.shift()
          @requestPageInCollection(nextPageToLoad)

        @fillPaginators(parseInt(@activePage))
        @animateCards(beforePage, parseInt(@activePage))

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

      @fillPaginators(parseInt(@activePage))
      @fillSelectAllContainer() unless @disableItemsSelection
      if @collection.getMeta('total_pages') == 1
        @hidePaginators()
        @hideFooter()

      @activateSelectors()
      @showPaginatedViewContent()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)

    animateCards: (activePage, nextPage) ->
      $elem = $(@el).find '.BCK-items-container'
      $elem.show()
      totalPages = parseInt(@collection.getMeta('total_pages'))
      pxToMove = ($elem.children('.carousel-card').first().outerWidth() * (nextPage - activePage) * @currentPageSize) + 1


      if nextPage <= totalPages or nextPage >= 1
        $elem.animate {
          left: '-=' + pxToMove+ 'px'
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

