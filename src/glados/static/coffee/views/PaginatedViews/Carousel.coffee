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

      if pageNum != 'next' and pageNum <= currentPage - 1
        return

      nextPage = if pageNum == 'next' then currentPage + 1 else pageNum

      @generatePageQueue(parseInt(currentPage), parseInt(nextPage))
      nextPageToLoad = @pageQueue.shift()
      @requestPageInCollection(nextPageToLoad)

      console.log 'nextPageToLoad: ', nextPageToLoad
      console.log 'Page clicked: ', nextPage
      @collection.setMeta('current_page',nextPage)
      @fillPaginators()
      console.log "CURRENT PAGE", @collection.getMeta 'current_page'


    # function to generate queue
    generatePageQueue: (startPage, endPage) ->
      @pageQueue = (num for num in [(startPage + 1)..(endPage + 1)])
      console.log '@pageQueue: ', @pageQueue

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




    sendDataToTemplate: ($specificElemContainer, visibleColumns) ->
      customTemplateID =  @collection.getMeta('columns_description').Carousel.CustomItemTemplate
      glados.views.PaginatedViews.PaginatedViewBase.sendDataToTemplate.call(@, $specificElemContainer, visibleColumns,
        customTemplateID)
    # ------------------------------------------------------------------------------------------------------------------
    # Columns initalisation
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Carousel.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Carousel.Additional


#      setUpLoadingWaypoint: ->
#
#      $cards = $(@el).find('.BCK-items-container').children()
#
#      # don't bother when there aren't any cards
#      if $cards.length == 0
#        return
#
#      pageSize = @collection.getMeta('page_size')
#      numCards = $cards.length
#
#      if numCards < pageSize
#        index = 0
#      else
#        index = $cards.length - pageSize
#      wayPointCard = $cards[index]
#      # the advancer function requests always the next page
#      advancer = $.proxy ->
#        #destroy waypoint to avoid issues with triggering more page requests.
#        Waypoint.destroyAll()
#        # dont' bother if already on last page
#        if @collection.currentlyOnLastPage()
#          return
#        @showPaginatedViewPreloaderAndContent()
#        @requestPageInCollection('next')
#      , @
#
#      # destroy all waypoints before assigning the new one.
#      Waypoint.destroyAll()
#      scroll_container = null
#      $scroll_containers = $(@el).find('.infinite-scroll-container')
#      if $scroll_containers.length == 1
#        scroll_container = $scroll_containers[0]
#
#      waypoint = new Waypoint(
#        element: wayPointCard
#        context: if scroll_container? then scroll_container else window
#        handler: (direction) ->
#          if direction == 'down'
#            advancer()
#
#      )