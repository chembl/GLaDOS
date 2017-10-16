glados.useNameSpace 'glados.views.PaginatedViews',
  InfiniteCards:

    initAvailablePageSizes: ->
      @AVAILABLE_PAGE_SIZES = [50]
      @currentPageSize = @AVAILABLE_PAGE_SIZES[0]

    wakeUpView: ->
      @currentPageNum = 1
      glados.views.PaginatedViews.PaginatedViewBase.wakeUpView.call(@)

    #-------------------------------------------------------------------------------------------------------------------
    # Zoom
    #-------------------------------------------------------------------------------------------------------------------
    CARD_SIZE_TO_PAGE_SIZE:
      12: 50
      6: 50
      4: 50
      3: 100
      2: 100
      1: 200

    finishZoom: (pageSizeMustBe) ->

      if @currentPageSize != pageSizeMustBe
        @requestPageSizeInCollection(pageSizeMustBe)
      else
        @requestPageInCollection(1)

    renderViewState: ->

      isDefaultZoom = @mustDisableReset()
      mustComplicate = @collection.getMeta('complicate_cards_view')
      @isComplicated = isDefaultZoom and mustComplicate

      if @collection.getMeta('current_page') == 1
        # always clear the infinite container when receiving the first page, to avoid
        # showing results from previous delayed requests.
        @clearContentForInfinite()

        if @hasStructureHighlightingEnabled() or @hasSimilarityMapsEnabled()
            @cleanUpDeferredViewsContainer()

        if @hasCustomElementView()
          @cleanUpCustomItemViewsContainer()

      @fillTemplates()

      @setUpLoadingWaypoint()
      @hidePreloaderIfNoNextItems()

      @fillSelectAllContainer() unless @disableItemsSelection

      if @isCardsZoomEnabled()
        @fillZoomContainer()

      if @hasStructureHighlightingEnabled() or @hasSimilarityMapsEnabled()
        @renderSpecialStructuresToggler()

      @showPaginatedViewContent()

      if @collection.getMeta('fuzzy-results')? and @collection.getMeta('fuzzy-results') == true
        @showSuggestedLabel()
      else
        @hideSuggestedLabel()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)

    sleepView: ->

      @destroyAllWaypoints()
      if @hasCustomElementView()
        @sleepCustomElementviews()

      glados.views.PaginatedViews.PaginatedViewBase.sleepView.call(@)

    # ------------------------------------------------------------------------------------------------------------------
    # Columns initalisation
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Infinite.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Infinite.Additional



