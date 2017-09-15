# This is a base object for the paginated tables, extend a view in backbone with this object
# to get the functionality for handling the pagination.
# this way allows to easily handle multiple inheritance in the models.
glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedView: Backbone.View\
    .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
    .extend(glados.views.PaginatedViews.CardZoomFunctions)\
    .extend(glados.views.PaginatedViews.ItemViewsFunctions).extend

      # ------------------------------------------------------------------------------------------------------------------
      # Initialisation
      # ------------------------------------------------------------------------------------------------------------------
      POSSIBLE_CARD_SIZES_STRUCT:
        1:
          previous: 1
          next: 2
        2:
          previous: 1
          next: 3
        3:
          previous: 2
          next: 4
        4:
          previous: 3
          next: 6
        6:
          previous: 4
          next: 12
        12:
          previous: 6
          next: 12

      getPreviousSize: (currentSize) -> @POSSIBLE_CARD_SIZES_STRUCT[currentSize].previous
      getNextSize: (currentSize) -> @POSSIBLE_CARD_SIZES_STRUCT[currentSize].next

      DEFAULT_CARDS_SIZES:
        small: 12
        medium: 6
        large: 3

      initialize: () ->
        # @collection - must be provided in the constructor call
        @type = arguments[0].type
        @customRenderEvents = arguments[0].custom_render_evts
        @renderAtInit = arguments[0].render_at_init
        @disableColumnsSelection = arguments[0].disable_columns_selection
        @disableItemsSelection = arguments[0].disable_items_selection

        @collection.on glados.Events.Collections.SELECTION_UPDATED, @selectionChangedHandler, @

        if @customRenderEvents?
          @collection.on @customRenderEvents, @.render, @
        else if @isInfinite()
          @collection.on 'sync do-repaint', @.render, @
        else
          @collection.on 'reset sort', @render, @
          @collection.on 'request', @showPreloaderHideOthers, @

        @collection.on 'error', @handleError, @

        @$zoomControlsContainer = arguments[0].zoom_controls_container
        if @collection.getMeta('custom_default_card_sizes')?
          @DEFAULT_CARDS_SIZES = @collection.getMeta('custom_default_card_sizes')

        @CURRENT_CARD_SIZES =
          small: @DEFAULT_CARDS_SIZES.small
          medium: @DEFAULT_CARDS_SIZES.medium
          large: @DEFAULT_CARDS_SIZES.large

        @$specialStructuresTogglerContainer = arguments[0].special_structures_toggler
        if (@isCards() or @isInfinite()) and (@hasStructureHighlightingEnabled() or @hasSimilarityMapsEnabled())
          @createDeferredViewsContainer()

        if (@isCards() or @isInfinite()) and @hasCustomElementView()
          @createCustomItemViewsContainer()

        @numVisibleColumnsList = []
        if @renderAtInit
          @render()


      isCards: ()->
        return @type == glados.views.PaginatedViews.PaginatedView.CARDS_TYPE

      isCarousel: ()->
        return @type == glados.views.PaginatedViews.PaginatedView.CAROUSEL_TYPE

      isInfinite: ()->
        return @type == glados.views.PaginatedViews.PaginatedView.INFINITE_TYPE

      isTable: ()->
        return @type == glados.views.PaginatedViews.PaginatedView.TABLE_TYPE

      # ------------------------------------------------------------------------------------------------------------------
      # events
      # ------------------------------------------------------------------------------------------------------------------
      events:
        'click .page-selector': 'getPageEvent'
        'change .change-page-size': 'changePageSize'
        'click .sort': 'sortCollection'
        'input .search': 'setSearch'
        'change select.select-search' : 'setSearch'
        'change .select-sort': 'sortCollectionFormSelect'
        'click .btn-sort-direction': 'changeSortOrderInf'
        'click .BCK-show-hide-column': 'showHideColumn'
        'click .BCK-toggle-select-all': 'toggleSelectAll'
        'click .BCK-select-one-item': 'toggleSelectOneItem'
        'click .BCK-zoom-in': 'zoomIn'
        'click .BCK-zoom-out': 'zoomOut'
        'click .BCK-reset-zoom': 'resetZoom'

      # ------------------------------------------------------------------------------------------------------------------
      # Selection
      # ------------------------------------------------------------------------------------------------------------------
      toggleSelectAll: ->
        @collection.toggleSelectAll()

      toggleSelectOneItem: (event) ->

        #for id structure the elem id must always be in the third position
        elemID = $(event.currentTarget).attr('id').split('-')[2]
        @collection.toggleSelectItem(elemID)

      selectionChangedHandler: (action, detail)->

        if action == glados.Events.Collections.Params.ALL_SELECTED

          $(@el).find('.BCK-toggle-select-all,.BCK-select-one-item').prop('checked', true)

        else if action == glados.Events.Collections.Params.ALL_UNSELECTED

          $(@el).find('.BCK-toggle-select-all,.BCK-select-one-item').prop('checked', false)

        else if action == glados.Events.Collections.Params.SELECTED

          endingID = detail + '-select'
          $(@el).find('[id$=' + endingID + ']').prop('checked', true)

        else if action == glados.Events.Collections.Params.UNSELECTED

          endingID = detail + '-select'
          $(@el).find('[id$=' + endingID + ']').prop('checked', false)
          $(@el).find('.BCK-toggle-select-all').prop('checked', false)

        else if action == glados.Events.Collections.Params.BULK_SELECTED

          for itemID in detail
            endingID = itemID + '-select'
            $(@el).find('[id$=' + endingID + ']').prop('checked', true)

      # ------------------------------------------------------------------------------------------------------------------
      # Render
      # ------------------------------------------------------------------------------------------------------------------
      clearContentForInfinite: ->

        @clearContentContainer()
        @renderSortingSelector()
        @fillNumResults()

      render: ->

        if not @collection.getMeta('data_loaded')
          return

        # don't force to show content when element is not visible.
        if not $(@el).is(":visible")
          return

        isDefault = @mustDisableReset()
        mustComplicate = @collection.getMeta('complicate_cards_view')
        @isComplicated = isDefault and mustComplicate

        if @isInfinite() and @collection.getMeta('current_page') == 1
          # always clear the infinite container when receiving the first page, to avoid
          # showing results from previous delayed requests.
          @clearContentForInfinite()

          if @hasStructureHighlightingEnabled() or @hasSimilarityMapsEnabled()
              @cleanUpDeferredViewsContainer()

          if @hasCustomElementView()
            @cleanUpCustomItemViewsContainer()

        else if not @isInfinite()
          @clearContentContainer()

          if @isCards()

            if @hasStructureHighlightingEnabled() or @hasSimilarityMapsEnabled()
              @cleanUpDeferredViewsContainer()

            if @hasCustomElementView()
              @cleanUpCustomItemViewsContainer()

        @fillTemplates()

        if @isInfinite()
          @setUpLoadingWaypoint()
          @hidePreloaderIfNoNextItems()

        @fillSelectAllContainer() unless @disableItemsSelection

        if (@isCards() or @isInfinite()) and @isCardsZoomEnabled()
          @fillZoomContainer()

        if (@isCards() or @isInfinite()) and (@hasStructureHighlightingEnabled() or @hasSimilarityMapsEnabled())
          @renderSpecialStructuresToggler()

        @fillPaginators()
        @fillPageSizeSelectors()
        @activateSelectors()
        @showPaginatedViewContent()

        @initialiseColumnsModal() unless @disableColumnsSelection

        if @collection.getMeta('fuzzy-results')? and @collection.getMeta('fuzzy-results') == true
          @showSuggestedLabel()
        else
          @hideSuggestedLabel()

      sleepView: ->
        # destroy loading waypoints when I sleep to avoid triggering next pages when hidden
        if @isInfinite()
          @destroyAllWaypoints()

      wakeUpView: ->
        @collection.setPage(1)

      # ------------------------------------------------------------------------------------------------------------------
      # Fill templates
      # ------------------------------------------------------------------------------------------------------------------

      clearTemplates: ->
        $(@el).find('.BCK-items-container').empty()

      # fills a template with the contents of the collection's current page
      # it handle the case when the items are shown as list, table, or infinite browser
      fillTemplates: ->

        $elem = $(@el).find('.BCK-items-container')
        visibleColumns = @getVisibleColumns()
        @numVisibleColumnsList.push visibleColumns.length

        if @collection.length > 0
          for i in [0..$elem.length - 1]
            @sendDataToTemplate $($elem[i]), visibleColumns
          @bindFunctionLinks()
          @showHeaderContainer()
          @showFooterContainer()
          @checkIfTableNeedsToScroll()
        else
          @hideHeaderContainer()
          @hideFooterContainer()
          @hideContentContainer()
          @showEmptyMessageContainer()

      bindFunctionLinks: ->
        $linksToBind = $(@el).find('.BCK-items-container .BCK-function-link')
        visibleColumnsIndex = _.indexBy(@getVisibleColumns(), 'function_key')
        $linksToBind.each (i, link) ->
          $currentLink = $(@)
          alreadyBound = $currentLink.attr('data-already-function-bound')?
          if not alreadyBound
            functionKey = $currentLink.attr('data-function-key')
            functionToBind = visibleColumnsIndex[functionKey].on_click
            $currentLink.click functionToBind
            executeOnRender = visibleColumnsIndex[functionKey].execute_on_render
            if executeOnRender
              $currentLink.click()
            $currentLink.attr('data-already-function-bound', 'yes')

      getVisibleColumns: ->

        columns = []
        # use special configuration config for cards if available
        if (@isCards() or @isInfinite()) and @collection.getMeta('columns_card').length > 0
          if @isComplicated
            columns = _.filter(@collection.getMeta('complicate_card_columns'), -> true)
          else
            columns = _.filter(@collection.getMeta('columns_card'), -> true)
        else
          defaultVisibleColumns = _.filter(@collection.getMeta('columns'), (col) -> col.show)
          additionalVisibleColumns = _.filter(@collection.getMeta('additional_columns'), (col) -> col.show)
          columns = _.union(defaultVisibleColumns, additionalVisibleColumns)

        contextualProperties = @collection.getMeta('contextual_properties')
        contextualProperties ?= []
        for prop in contextualProperties
          columns.push(prop)

        return columns

      sendDataToTemplate: ($specificElemContainer, visibleColumns) ->

        if (@isInfinite() or @isCards()) and not @isComplicated
          templateID = @collection.getMeta('custom_cards_template')
        templateID ?= $specificElemContainer.attr('data-hb-template')
        applyTemplate = Handlebars.compile($('#' + templateID).html())
        $appendTo = $specificElemContainer

        # if it is a table, add the corresponding header
        if $specificElemContainer.is('table')

          header_template = $('#' + $specificElemContainer.attr('data-hb-header-template'))
          header_row_cont = Handlebars.compile( header_template.html() )
            base_check_box_id: @getBaseSelectAllCheckBoxID()
            all_items_selected: @collection.getMeta('all_items_selected') and not @collection.thereAreExceptions()
            columns: visibleColumns
            selection_disabled: @disableItemsSelection

          $specificElemContainer.append($(header_row_cont))
          # make sure that the rows are appended to the tbody, otherwise the striped class won't work
          $specificElemContainer.append($('<tbody>'))
          $specificElemContainer.append($('<tbody>'))


        for item in @collection.getCurrentPage()

          columnsWithValues = glados.Utils.getColumnsWithValues(visibleColumns, item)
          idValue = glados.Utils.getNestedValue(item.attributes, @collection.getMeta('id_column').comparator)

          templateParams =
            base_check_box_id: idValue
            is_selected: @collection.itemIsSelected(idValue)
            img_url: glados.Utils.getImgURL(columnsWithValues)
            columns: columnsWithValues
            selection_disabled: @disableItemsSelection

          if (@isCards() or @isInfinite())
            templateParams.small_size = @CURRENT_CARD_SIZES.small
            templateParams.medium_size = @CURRENT_CARD_SIZES.medium
            templateParams.large_size = @CURRENT_CARD_SIZES.large

          $newItemElem = $(applyTemplate(templateParams))
          $appendTo.append($newItemElem)

          if (@isCards() or @isInfinite())

            if @hasCustomElementView() and not @isComplicated
              model =  @collection.get(idValue)
              @createCustomElementView(model, $newItemElem)

            if templateParams.img_url? and (@hasStructureHighlightingEnabled() or @hasSimilarityMapsEnabled())
              @createDeferredView(model, $newItemElem)

        @fixCardHeight($appendTo)

      checkIfTableNeedsToScroll: ->

        $specificElemContainer = $(@el).find('.BCK-items-container')

        if not $specificElemContainer.is(":visible")
          return

         # After adding everything, if the element is a table I now set up the top scroller
        # also set up the automatic header fixation
        if $specificElemContainer.is('table') and $specificElemContainer.hasClass('scrollable')

          $topScrollerDummy = $(@el).find('.BCK-top-scroller-dummy')
          containerWidth = $specificElemContainer.parent().width()
          tableWidth = $specificElemContainer.width()
          $topScrollerDummy.width(tableWidth)

          if $specificElemContainer.hasClass('scrolling')

            $specificElemContainer.removeClass('scrolling')
            $specificElemContainer.css('display', 'table')
            currentContainer = $specificElemContainer
            f = $.proxy(@checkIfTableNeedsToScroll, @)
            setTimeout((-> f(currentContainer)), glados.Settings.RESPONSIVE_REPAINT_WAIT)
            return

          else
            hasToScroll = tableWidth > containerWidth

          if hasToScroll and GlobalVariables.CURRENT_SCREEN_TYPE != GlobalVariables.SMALL_SCREEN
            $specificElemContainer.addClass('scrolling')
            $specificElemContainer.css('display', 'block')
            $topScrollerDummy.height(1)
          else
            $specificElemContainer.removeClass('scrolling')
            $specificElemContainer.css('display', 'table')
            $topScrollerDummy.height(0)

          # bind the scroll functions if not done yet
          if !$specificElemContainer.attr('data-scroll-setup')

            @setUpTopTableScroller($specificElemContainer)
            $specificElemContainer.attr('data-scroll-setup', true)

          # now set up tha header fixation
          if !$specificElemContainer.attr('data-header-pinner-setup')

            # delay this to wait for
            @setUpTableHeaderPinner($specificElemContainer)
            $specificElemContainer.attr('data-header-pinner-setup', true)


      fixCardHeight: ($appendTo) ->

        if @isInfinite()
          $cards = $(@el).find('.BCK-items-container').children()
          $cards.height $(_.max($cards, (card) -> $(card).height())).height() + 'px'
        else if @isCards()
          # This code completes rows for grids of 2 or 3 columns in the flex box css display
          total_cards = @collection.getCurrentPage().length
          placeholderTemplate = '<div class="col s{{small_size}} m{{medium_size}} l{{large_size}}" />'
          paramsObj =
            small: @CURRENT_CARD_SIZES.small
            medium_size: @CURRENT_CARD_SIZES.medium
            large_size: @CURRENT_CARD_SIZES.large

          placeholderContent = glados.Utils.getContentFromTemplate( undefined, paramsObj, placeholderTemplate)
          while total_cards % 12 != 0

            $appendTo.append(placeholderContent)
            total_cards++

      # ------------------------------------------------------------------------------------------------------------------
      # Table scroller
      # ------------------------------------------------------------------------------------------------------------------
      # this sets up dor a table the additional scroller on top of the table
      setUpTopTableScroller: ($table) ->

        $scrollContainer = $(@el).find('.BCK-top-scroller-container')
        $scrollContainer.scroll( -> $table.scrollLeft($scrollContainer.scrollLeft()))
        $table.scroll( -> $scrollContainer.scrollLeft($table.scrollLeft()))


      # ------------------------------------------------------------------------------------------------------------------
      # Table header pinner
      # ------------------------------------------------------------------------------------------------------------------
      setUpTableHeaderPinner: ($table) ->

        #use the top scroller to trigger the pin
        $scrollContainer = $(@el).find('.BCK-top-scroller-container')
        $firstTableRow = $table.find('tr').first()

        $win = $(window)
        topTrigger = $scrollContainer.offset().top

        pinUnpinTableHeader = ->

          # don't bother if table is not shown
          if !$table.is(":visible")
            return

          #TODO: complete this function!

        $win.scroll _.throttle(pinUnpinTableHeader, 200)

      fillPaginators: ->

        $elem = $(@el).find('.BCK-paginator-container')
        if $elem.length == 0
          return
        template = $('#' + $elem.attr('data-hb-template'))

        current_page = @collection.getMeta('current_page')
        records_in_page = @collection.getMeta('records_in_page')
        page_size = @collection.getMeta('page_size')
        num_pages = @collection.getMeta('total_pages')

        first_record = (current_page - 1) * page_size
        last_page = first_record + records_in_page

        # this sets the window for showing the pages
        show_previous_ellipsis = false
        show_next_ellipsis = false
        if num_pages <= 5
          first_page_to_show = 1
          last_page_to_show = num_pages
        else if current_page + 2 <= 5
          first_page_to_show = 1
          last_page_to_show = 5
          show_next_ellipsis = true
        else if current_page + 2 < num_pages
          first_page_to_show = current_page - 2
          last_page_to_show = current_page + 2
          show_previous_ellipsis = true
          show_next_ellipsis = true
        else
          first_page_to_show = num_pages - 4
          last_page_to_show = num_pages
          show_previous_ellipsis = true

        pages = (num for num in [first_page_to_show..last_page_to_show])

        $elem.html Handlebars.compile(template.html())
          pages: pages
          records_showing: (first_record+1) + '-' + last_page
          total_records: @collection.getMeta('total_records')
          show_next_ellipsis: show_next_ellipsis
          show_previous_ellipsis: show_previous_ellipsis

        @activateCurrentPageButton()
        @enableDisableNextLastButtons()

      getBaseSelectAllCheckBoxID: ->

        baseCheckBoxID = $(@el).attr('id')
        # Parent element should always have an id, if for some reason it hasn't we generate a random number for the id
        # we need this to avoid conflicts with other tables on the page that will have also a header and a "select all"
        # option
        if !baseCheckBoxID?
          baseCheckBoxID = Math.floor((Math.random() * 1000) + 1)

        return baseCheckBoxID


      fillSelectAllContainer: ->
        $selectAllContainer = $(@el).find('.BCK-selectAll-container')
        if $selectAllContainer.length == 0
          return
        glados.Utils.fillContentForElement $selectAllContainer,
          base_check_box_id: @getBaseSelectAllCheckBoxID()
          all_items_selected: @collection.getMeta('all_items_selected') and not @collection.thereAreExceptions()

      fillNumResults: ->
        glados.Utils.fillContentForElement $(@el).find('.num-results'),
          num_results: @collection.getMeta('total_records')

      getPageEvent: (event) ->

        clicked = $(event.currentTarget)

        # Don't bother if the link was disabled.
        if clicked.hasClass('disabled')
          return

        @showPaginatedViewPreloader() unless @collection.getMeta('server_side') != true

        pageNum = clicked.attr('data-page')
        @requestPageInCollection(pageNum)


      requestPageInCollection: (pageNum) ->

        currentPage = @collection.getMeta('current_page')
        totalPages = @collection.getMeta('total_pages')

        if pageNum == "previous"
          pageNum = currentPage - 1
        else if pageNum == "next"
          pageNum = currentPage + 1

        # Don't bother if the user requested is greater than the max number of pages
        if pageNum > totalPages
          return

        @collection.setPage(pageNum)


      enableDisableNextLastButtons: ->

        current_page = parseInt(@collection.getMeta('current_page'))
        total_pages = parseInt(@collection.getMeta('total_pages'))

        if current_page == 1
          $(@el).find("[data-page='previous']").addClass('disabled')
        else
          $(@el).find("[data-page='previous']").removeClass('disabled')

        if current_page == total_pages
          $(@el).find("[data-page='next']").addClass('disabled')
        else
          $(@el).find("[data-page='next']").removeClass('disabled')

      activateCurrentPageButton: ->

        current_page = @collection.getMeta('current_page')
        $(@el).find('.page-selector').removeClass('active')
        $(@el).find("[data-page=" + current_page + "]").addClass('active')

      changePageSize: (event) ->

        @showPaginatedViewPreloader() unless @collection.getMeta('server_side') != true
        selector = $(event.currentTarget)
        new_page_size = selector.val()
        # this is an issue with materialise, it fires 2 times the event, one of which has an empty value
        if new_page_size == ''
          return
        @collection.resetPageSize(new_page_size)

      # ------------------------------------------------------------------------------------------------------------------
      # Search
      # ------------------------------------------------------------------------------------------------------------------
      setSearch: _.debounce( (event) ->

        $searchInput = $(event.currentTarget)
        term = $searchInput.val()
        # if the collection is client side the column and data type will be undefined and will be ignored.
        column = $searchInput.attr('data-column')
        type = $searchInput.attr('data-column-type')

        @triggerSearch(term, column, type)

      , glados.Settings['SEARCH_INPUT_DEBOUNCE_TIME'])

      # this closes the function setNumeric search with a jquery element, the idea is that
      # you can get the attributes such as the column for the search, and min and max values
      # from the jquery element
      setNumericSearchWrapper: ($elem) ->

        ctx = @
        setNumericSearch = _.debounce( (values, handle) ->

          term =  values.join(',')
          column = $elem.attr('data-column')
          type = $elem.attr('data-column-type')

          ctx.triggerSearch(term, column, type)
        , glados.Settings['SEARCH_INPUT_DEBOUNCE_TIME'])


        return setNumericSearch


      triggerSearch:  (term, column, type) ->

        @clearContentContainer()
        @showPaginatedViewPreloader()

        @collection.setSearch(term, column, type)

      # ------------------------------------------------------------------------------------------------------------------
      # Add Remove Columns
      # ------------------------------------------------------------------------------------------------------------------
      initialiseColumnsModal: ->

        $modalContainer = $(@el).find('.BCK-show-hide-columns-container')

        if $modalContainer.length == 0
          return

        glados.Utils.fillContentForElement $modalContainer,
          modal_id: $(@el).attr('id') + '-select-columns-modal'
          columns: @collection.getMeta('columns')
          additional_columns: @collection.getMeta('additional_columns')

        $(@el).find('.modal').modal()

      showHideColumn: (event) ->

        $checkbox = $(event.currentTarget)
        colComparator = $checkbox.attr('data-comparator')
        isChecked = $checkbox.is(':checked')

        allColumns = _.union(@collection.getMeta('columns'), @collection.getMeta('additional_columns'))
        changedColumn = _.find(allColumns, (col) -> col.comparator == colComparator)
        changedColumn.show = isChecked
        @clearTemplates()
        @fillTemplates()

      # ------------------------------------------------------------------------------------------------------------------
      # Sort
      # ------------------------------------------------------------------------------------------------------------------

      sortCollection: (event) ->

        @showPaginatedViewPreloader() unless @collection.getMeta('server_side') != true
        sortIcon = $(event.currentTarget).find('.sort-icon')
        comparator = sortIcon.attr('data-comparator')

        @triggerCollectionSort(comparator)

      triggerCollectionSort: (comparator) ->

        @clearContentContainer()
        @showPaginatedViewPreloader()

        @collection.sortCollection(comparator)

      # ------------------------------------------------------------------------------------------------------------------
      # Preloaders and content
      # ------------------------------------------------------------------------------------------------------------------
      showSuggestedLabel: () ->
        suggestedLabel = $(@el).find('.BCK-SuggestedLabel')
        suggestedLabel.show()

      hideSuggestedLabel: () ->
        suggestedLabel = $(@el).find('.BCK-SuggestedLabel')
        suggestedLabel.hide()

      showPaginatedViewContent: ->

        $preloaderCont = $(@el).find('.BCK-PreloaderContainer')
        $contentCont =  $(@el).find('.BCK-items-container')

        $preloaderCont.hide()
        $contentCont.show()

      showPaginatedViewPreloader: ->

        $preloaderCont = $(@el).find('.BCK-PreloaderContainer')
        $contentCont =  $(@el).find('.BCK-items-container')

        $preloaderCont.show()
        $contentCont.hide()

      # show the preloader making sure the content is also visible, useful for the infinite browser
      showPaginatedViewPreloaderAndContent: ->

        $preloaderCont = $(@el).find('.BCK-PreloaderContainer')
        $contentCont =  $(@el).find('.BCK-items-container')

        $preloaderCont.show()
        $contentCont.show()

      clearContentContainer: ->
        $(@el).find('.BCK-items-container').empty()
        @hideEmptyMessageContainer()
        @showContentContainer()

      showPreloaderOnly: ->
        $preloaderCont = $(@el).find('.BCK-PreloaderContainer')
        $preloaderCont.show()

      hidePreloaderOnly: ->
        $preloaderCont = $(@el).find('.BCK-PreloaderContainer')
        $preloaderCont.hide()

      showHeaderContainer: ->
        $headerRow = $(@el).find('.BCK-header-container,.BCK-top-scroller-container')
        $headerRow.show()

      hideHeaderContainer: ->
        $headerRow = $(@el).find('.BCK-header-container,.BCK-top-scroller-container')
        $headerRow.hide()

      hideFooterContainer: ->
        $headerRow = $(@el).find('.BCK-footer-container')
        $headerRow.hide()

      showFooterContainer: ->
        $headerRow = $(@el).find('.BCK-footer-container')
        $headerRow.show()

      hideContentContainer: ->
        $headerRow = $(@el).find('.BCK-items-container')
        $headerRow.hide()

      showContentContainer: ->
        $headerRow = $(@el).find('.BCK-items-container')
        $headerRow.show()

      hideEmptyMessageContainer: ->
        $headerRow = $(@el).find('.BCK-EmptyListMessage')
        $headerRow.hide()

      showEmptyMessageContainer: ->
        $headerRow = $(@el).find('.BCK-EmptyListMessage')
        $headerRow.show()

      showPreloaderHideOthers: ->
        @showPreloaderOnly()
        @hideHeaderContainer()
        @hideContentContainer()
        @hideEmptyMessageContainer()
        @hideFooterContainer()
        @hideSuggestedLabel()


      # ------------------------------------------------------------------------------------------------------------------
      # Infinite Browser
      # ------------------------------------------------------------------------------------------------------------------

      showNumResults: ->

        $(@el).children('.num-results').show()

      hideNumResults: ->

        $(@el).children('.num-results').hide()


      setUpLoadingWaypoint: ->

        $cards = $(@el).find('.BCK-items-container').children()

        # don't bother when there aren't any cards
        if $cards.length == 0
          return

        pageSize = @collection.getMeta('page_size')
        numCards = $cards.length

        if numCards < pageSize
          index = 0
        else
          index = $cards.length - @collection.getMeta('page_size')

        wayPointCard = $cards[index]
        # the advancer function requests always the next page
        advancer = $.proxy ->
          #destroy waypoint to avoid issues with triggering more page requests.
          Waypoint.destroyAll()
          # dont' bother if already on last page
          if @collection.currentlyOnLastPage()
            return
          @showPaginatedViewPreloaderAndContent()
          @requestPageInCollection('next')
        , @

        # destroy all waypoints before assigning the new one.
        Waypoint.destroyAll()

        waypoint = new Waypoint(
          element: wayPointCard
          handler: (direction) ->

            if direction == 'down'
              advancer()

        )

      destroyAllWaypoints: -> Waypoint.destroyAll()
      # checks if there are more page and hides the preloader if there are no more.
      hidePreloaderIfNoNextItems: ->

        if @collection.currentlyOnLastPage()
          @hidePreloaderOnly()

      # ------------------------------------------------------------------------------------------------------------------
      # sort selector
      # ------------------------------------------------------------------------------------------------------------------

      renderSortingSelector: ->

        $selectSortContainer = $(@el).find('.select-sort-container')
        if $selectSortContainer.length == 0
          return
        $selectSortContainer.empty()

        $template = $('#' + $selectSortContainer.attr('data-hb-template'))
        columns = @collection.getMeta('columns')

        col_comparators = _.map(columns, (col) -> {comparator: col.comparator, selected: col.is_sorting != 0})
        one_selected = _.reduce(col_comparators, ((a, b) -> a.selected or b.selected), 0 )

        $selectSortContainer.html Handlebars.compile( $template.html() )
          columns: col_comparators
          one_selected: one_selected

        $btnSortDirectionContainer = $(@el).find('.btn-sort-direction-container')
        if $btnSortDirectionContainer.length == 0
          return
        $btnSortDirectionContainer.empty()

        $template = $('#' + $btnSortDirectionContainer.attr('data-hb-template'))


        # relates the sort direction with a class and a text for the template
        sortClassAndText =
          '-1': {sort_class: 'fa-sort-desc', text: 'Desc'},
          '0': {sort_class: 'fa-sort', text: ''},
          '1': {sort_class: 'fa-sort-asc', text: 'Asc'}

        currentSortDirection = _.reduce(_.pluck(columns, 'is_sorting'), ((a, b) -> a + b), 0)
        currentProps = sortClassAndText[currentSortDirection.toString()]

        $btnSortDirectionContainer.html Handlebars.compile( $template.html() )
          sort_class:  currentProps.sort_class
          text: currentProps.text
          disabled: currentSortDirection == 0


      sortCollectionFormSelect: (event) ->

        @showPaginatedViewPreloader()

        selector = $(event.currentTarget)
        comparator = selector.val()

        if comparator == ''
          return

        @triggerCollectionSort(comparator)

      changeSortOrderInf: ->

        comp = @collection.getCurrentSortingComparator()
        if comp?
          @triggerCollectionSort(comp)


      # ------------------------------------------------------------------------------------------------------------------
      # Page selector
      # ------------------------------------------------------------------------------------------------------------------

      fillPageSizeSelectors: ->

        $elem = $(@el).find('.BCK-select-page-size-container')
        if $elem.length == 0
          return
        $contentTemplate = $('#' + $elem.attr('data-hb-template'))

        currentPageSize = @collection.getMeta('page_size')
        pageSizesItems = []

        for size in @collection.getMeta('available_page_sizes')
          item = {}
          item.number = size
          item.is_selected = currentPageSize == size
          pageSizesItems.push(item)

        $elem.html Handlebars.compile( $contentTemplate.html() )
          items: pageSizesItems

      activateSelectors: ->

        $(@el).find('select').material_select()

      # ------------------------------------------------------------------------------------------------------------------
      # Error handling
      # ------------------------------------------------------------------------------------------------------------------
      handleError: (model, jqXHR, options) ->

        $errorMessagesContainer = $(@el).find('.BCK-ErrorMessagesContainer')
        $errorMessagesContainer.html glados.Utils.ErrorMessages.getCollectionErrorContent(jqXHR)
        $errorMessagesContainer.show()


# ----------------------------------------------------------------------------------------------------------------------
# Class Context
# ----------------------------------------------------------------------------------------------------------------------

glados.views.PaginatedViews.PaginatedView.CARDS_TYPE = 'CARDS_TYPE'
glados.views.PaginatedViews.PaginatedView.CAROUSEL_TYPE = 'CAROUSEL_TYPE'
glados.views.PaginatedViews.PaginatedView.INFINITE_TYPE = 'INFINITE_TYPE'
glados.views.PaginatedViews.PaginatedView.TABLE_TYPE = 'TABLE_TYPE'

glados.views.PaginatedViews.PaginatedView.getNewCardsPaginatedView = (collection, el, customRenderEvents)->
  return new glados.views.PaginatedViews.PaginatedView
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedView.CARDS_TYPE
    custom_render_evts: customRenderEvents

glados.views.PaginatedViews.PaginatedView.getNewInfinitePaginatedView = (collection, el, customRenderEvents)->
  return new glados.views.PaginatedViews.PaginatedView
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedView.INFINITE_TYPE
    custom_render_evts: customRenderEvents

glados.views.PaginatedViews.PaginatedView.getNewTablePaginatedView = (collection, el, customRenderEvents,
  disableColumnsSelection=false, disableItemSelection=true)->
  return new glados.views.PaginatedViews.PaginatedView
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedView.TABLE_TYPE
    custom_render_evts: customRenderEvents
    disable_columns_selection: disableColumnsSelection
    disable_items_selection: disableItemSelection


glados.views.PaginatedViews.PaginatedView.getTypeConstructor = (pagViewType)->
  tmp_constructor = ()->
    arguments[0].type = pagViewType
    glados.views.PaginatedViews.PaginatedView.apply(@, arguments)
  tmp_constructor.prototype = glados.views.PaginatedViews.PaginatedView.prototype
  return tmp_constructor

glados.views.PaginatedViews.PaginatedView.getCardsConstructor = ()->
  return glados.views.PaginatedViews.PaginatedView\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedView.CARDS_TYPE)

glados.views.PaginatedViews.PaginatedView.getTableConstructor = ()->
  return glados.views.PaginatedViews.PaginatedView\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedView.TABLE_TYPE)

glados.views.PaginatedViews.PaginatedView.getInfiniteConstructor = ()->
  return glados.views.PaginatedViews.PaginatedView\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedView.INFINITE_TYPE)
