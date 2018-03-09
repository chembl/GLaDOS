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
      console.log 'currentPage: ', currentPage
      if not @eventForThisView(clicked)
        return
      # Don't bother if the link was disabled.
      if clicked.hasClass('disabled') or clicked.hasClass('previous')
        return

      @showPaginatedViewPreloader() unless @collection.getMeta('server_side') != true
      pageNum = clicked.attr('data-page')

      if pageNum ='next' or clicked.attr('data-page') > currentPage

      

#      @generatePageQueue: (currentPage, endPage)

      # generate queue and request first

        @requestPageInCollection(pageNum)

    # function to generate queue
    generatePageQueue: (startPage, endPage) ->



    initPageQueue: ->
#      @generatePageQueue(1, 2)

    renderViewState: ->

      isDefaultZoom = @mustDisableReset()
      mustComplicate = @collection.getMeta('complicate_cards_view')
      @isComplicated = isDefaultZoom and mustComplicate

#      @clearContentContainer()

      @fillSelectAllContainer() unless @disableItemsSelection
      @fillPaginators()
      if @collection.getMeta('total_pages') == 1
        @hidePaginators()
        @hideFooter()
      @activateSelectors()
      @showPaginatedViewContent()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)
      #pop page from list
      # get next in queu if any

      # make sure current page is correct
      #@collection.setMeta('current_page', 5)
#      @fillPaginators()

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