# This is a base object for the paginated tables, extend a view in backbone with this object
# to get the functionality for handling the pagination.
glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedViewBase:

    # ------------------------------------------------------------------------------------------------------------------
    # Initialisation
    # ------------------------------------------------------------------------------------------------------------------

    initialize: ->

      @config = arguments[0].config
      @config ?= {}

      # @collection - must be provided in the constructor call
      @include_search_results_highlight = @attributes?.include_search_results_highlight || false
      @type = arguments[0].type
      @customRenderEvents = arguments[0].custom_render_evts
      @renderAtInit = arguments[0].render_at_init
      @disableColumnsSelection = arguments[0].disable_columns_selection
      @disableItemsSelection = arguments[0].disable_items_selection
      @viewID = (new Date()).getTime().toString()

      if @collection.configIsReady()?
        @initColumnsHandler()
      else
        @collection.on(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.CONFIG_FETCHING_STATE_CHANGED,
          @initColumnsHandler, @)

      @initTooltipFunctions()
      @bindCollectionEvents()

      @$zoomControlsContainer = arguments[0].zoom_controls_container
      if @collection.getMeta('custom_default_card_sizes')?
        @DEFAULT_CARDS_SIZES = @collection.getMeta('custom_default_card_sizes')

      if @collection.getMeta('custom_possible_card_sizes_struct')?
        @POSSIBLE_CARD_SIZES_STRUCT = @collection.getMeta('custom_possible_card_sizes_struct')

      @CURRENT_CARD_SIZES =
        small: @DEFAULT_CARDS_SIZES.small
        medium: @DEFAULT_CARDS_SIZES.medium
        large: @DEFAULT_CARDS_SIZES.large

      @$specialStructuresTogglerContainer = arguments[0].special_structures_toggler
      if (@isCards() or @isInfinite()) and (@hasStructureHighlightingEnabled() or @hasSimilarityMapsEnabled())
        @createDeferredViewsContainer()

      if (@isCards() or @isInfinite()) and @hasCustomElementView()
        @createCustomItemViewsContainer()

      @initAvailablePageSizes()
      @initPageNumber()

      @numVisibleColumnsList = []
      if @renderAtInit
        @render()
      else
        @showPreloaderHideOthers()

      @initPageQueue()

    initPageQueue: ->

    bindCollectionEvents: ->

      @collection.on glados.Events.Collections.SELECTION_UPDATED, @selectionChangedHandler, @

      if @customRenderEvents?
        @collection.on @customRenderEvents, @.render, @

      if @isInfinite()
        @collection.on 'sync do-repaint', @.render, @
      else
        @collection.on 'reset sort do-repaint', @render, @
        @collection.on 'request', @showPreloaderHideOthers, @

      @collection.on 'error', @handleError, @


    initColumnsHandler: ->

      if not @collection.configIsReady()
        return

      if @columnsHandler?
        return

      defaultColumns = @getDefaultColumns()
      additionalColumns = @getAdditionalColumns()

      @columnsHandler = new glados.models.paginatedCollections.ColumnsHandler
        default_columns: defaultColumns
        additional_columns: additionalColumns
        include_highlights_column: @include_search_results_highlight

      @columnsHandler.on 'change:exit change:enter', @handleShowHideColumns, @
      @columnsHandler.on glados.models.paginatedCollections.ColumnsHandler.EVENTS.COLUMNS_ORDER_CHANGED,
        @handleColumnsOrderChange, @

      if @isTable()
        @initialiseColumnsModal() unless @disableColumnsSelection

    handleShowHideColumns: ->

    isCards: ->
      return @type == glados.views.PaginatedViews.PaginatedViewFactory.CARDS_TYPE

    isCarousel: ->
      return @type == glados.views.PaginatedViews.PaginatedViewFactory.CAROUSEL_TYPE

    isInfinite: ->
      return @type == glados.views.PaginatedViews.PaginatedViewFactory.INFINITE_TYPE

    isTable: ->
      return @type == glados.views.PaginatedViews.PaginatedViewFactory.TABLE_TYPE

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
      'click .BCK-toggle-select-all': 'toggleSelectAll'
      'click .BCK-select-one-item': 'toggleSelectOneItem'
      'click .BCK-zoom-in': 'zoomIn'
      'click .BCK-zoom-out': 'zoomOut'
      'click .BCK-reset-zoom': 'resetZoom'

    stampViewIDOnEventsTriggerers: ->
      eventTriggererSelectors = ['.page-selector', '.change-page-size', '.sort', '.select-search', '.select-sort',
        '.btn-sort-direction', '.BCK-toggle-select-all', '.BCK-select-one-item', '.BCK-zoom-in', '.BCK-zoom-out',
        '.BCK-reset-zoom', '.headers-table']
      for triggerClass in eventTriggererSelectors
        $elem = $(@el).find(triggerClass)
        @stampViewIDOnElem($elem)

    # this allows to have a paginated view inside another view
    stampViewIDOnElem: ($elem) -> $elem.attr('data-view-id', @viewID)
    eventForThisView: ($elem) ->
      $elem.attr('data-view-id') == @viewID
    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------
    clearContentForInfinite: ->

      @clearContentContainer()
      @renderSortingSelector()
      @fillNumResults()

    render: ->

      if not (@collection.getMeta('data_loaded') or @collection.itemsAreReady())
        return

      # don't force to show content when element is not visible.
      if not $(@el).is(":visible")
        return

      if @checkAndRenderIfNoItems()
        return

      #Make sure I am rendering the correct page
      if (@collection.getMeta('page_size') != @currentPageSize)\
      or (@collection.getMeta('current_page') != @currentPageNum)
        @requestCurrentPage()
        return

      glados.Utils.Tooltips.destroyAllTooltips($(@el))
      @renderViewState()

    renderViewState: ->
      @stampViewIDOnEventsTriggerers()
      @fillTemplates()
      @renderLinkToAllItems() unless not @config.full_list_url?
      @setUpEmbedModal() unless not @config.show_embed_button

    sleepView: ->
      @collection.sleep()
    wakeUpView: ->

      $(@el).show()
      @collection.wakeUp()
      if not @collection.isReady()
        return
      if @checkAndRenderIfNoItems()
        return
      @requestCurrentPage()

    checkAndRenderIfNoItems: ->
      if @collection.length == 0
        @showNoResultsFound()
        return true
      $(@el).find('.preloader-row').removeClass('preloader-row-hidden')
      return false

    showNoResultsFound: ->
      @hidePreloaderOnly()
      @hideHeaderContainer()
      @hideFooterContainer()
      @hideContentContainer()
      @showEmptyMessageContainer()

    # ------------------------------------------------------------------------------------------------------------------
    # Fill templates
    # ------------------------------------------------------------------------------------------------------------------

    clearTemplates: ->
      $(@el).find('.BCK-items-container').empty()

    # fills a template with the contents of the collection's current page
    # it handle the case when the items are shown as list, table, or infinite browser
    fillTemplates: ->

      @initColumnsHandler()
      $elem = $(@el).find('.BCK-items-container')
      visibleColumns = @getVisibleColumns()
      @numVisibleColumnsList.push visibleColumns.length

      for i in [0..$elem.length - 1]
        @sendDataToTemplate $($elem[i]), visibleColumns
      @showHeaderContainer()
      @showFooterContainer()

    getVisibleColumns: -> @columnsHandler.get('visible_columns')
    getAllColumns: -> @columnsHandler.get('all_columns')

    sendDataToTemplate: ($specificElemContainer, visibleColumns, customItemTemplate) ->

      if (@isInfinite() or @isCards()) and not @isComplicated
        templateID = @collection.getMeta('custom_cards_template')
        if @isInfinite()
          infiniteConfig = @collection.getMeta('columns_description').Infinite
          if infiniteConfig.CustomItemTemplate?
            templateID = infiniteConfig.CustomItemTemplate
      # this second way should be the correct way to do it, not changing it for now so I don't have refactor many things
      if customItemTemplate?
        templateID = customItemTemplate
      templateID ?= $specificElemContainer.attr('data-hb-template')
      applyTemplate = Handlebars.compile($('#' + templateID).html())
      $appendTo = $specificElemContainer

      for item in @collection.getCurrentPage()

        [columnsWithValues, highlights] = glados.Utils.getColumnsWithValuesAndHighlights(visibleColumns, item)
        idValue = glados.Utils.getNestedValue(item.attributes, @collection.getMeta('id_column').comparator)

        columnsByComparator = {}
        for column_i in columnsWithValues
          columnsByComparator[column_i.comparator.replace(/[^a-zA-Z0-9]/g, '__')] = column_i

        templateParams =
          base_check_box_id: idValue
          is_selected: @collection.itemIsSelected(idValue)
          img_url: glados.Utils.getImgURL(columnsWithValues)
          columns: columnsWithValues
          highlights: highlights
          selection_disabled: @disableItemsSelection
          columns_by_comparator: columnsByComparator
          static_images_url: glados.Settings.STATIC_IMAGES_URL

        if (@isCards() or @isInfinite() or @isCarousel())
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

          viewConfig =
            invert_trigger_colours: true

          embedURL = glados.ReportCardApp.EMBED_MINI_REPORT_CARD_URL_GENERATOR
            entity_type: item.entityName
            id: idValue
          glados.helpers.EmbedModalsHelper.initEmbedModal($newItemElem, embedURL, viewConfig)

      @fixCardHeight($appendTo)

    fixCardHeight: ($appendTo) ->

      # Remove previous placeholders first, specially useful in infinite
      $appendTo.find('.BCK-Flex-Placeholder').remove()
      # This code completes rows for grids of 2 or 3 columns in the flex box css display
      total_cards = @collection.getCurrentPage().length
      placeholderTemplate = '<div class="BCK-Flex-Placeholder col s{{small_size}} m{{medium_size}} l{{large_size}}" />'
      paramsObj =
        small: @CURRENT_CARD_SIZES.small
        medium_size: @CURRENT_CARD_SIZES.medium
        large_size: @CURRENT_CARD_SIZES.large

      placeholderContent = glados.Utils.getContentFromTemplate( undefined, paramsObj, placeholderTemplate)
      while total_cards % 12 != 0

        $appendTo.append(placeholderContent)
        total_cards++

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

      $selectAllContainer.show()

    fillNumResults: ->
      glados.Utils.fillContentForElement $(@el).find('.num-results'),
        num_results: @collection.getMeta('total_records')

    # ------------------------------------------------------------------------------------------------------------------
    # Local Search
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
    # Sort
    # ------------------------------------------------------------------------------------------------------------------

    sortCollection: (event) ->

      $target = $(event.currentTarget)
      if not @eventForThisView($target)
        return

      @showPaginatedViewPreloader() unless @collection.getMeta('server_side') != true
      sortIcon = $target.find('.sort-icon')
      colID = sortIcon.attr('data-prop-id')

      @triggerCollectionSort(colID)

    triggerCollectionSort: (comparator) ->

      @clearContentContainer()
      @showPaginatedViewPreloader()

      @collection.sortCollection(comparator)

    # ------------------------------------------------------------------------------------------------------------------
    # Preloaders and content
    # ------------------------------------------------------------------------------------------------------------------
    hidePageSizeSelectors: -> $(@el).find('.BCK-select-page-size-container').hide()
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

      @latestPageRendered = undefined
      @latestPageSizeRendered = undefined
      $(@el).find('.BCK-items-container').empty()
      @hideEmptyMessageContainer()
      @showContentContainer()

    showPreloaderOnly: ->
      $preloaderCont = $(@el).find('.BCK-PreloaderContainer')
      $preloaderCont.show()

    hidePreloaderOnly: ->
      $preloaderCont = $(@el).find('.BCK-PreloaderContainer')
      $preloaderRow = $(@el).find('.preloader-row')
      $preloaderCont.hide()
      $preloaderRow.addClass('preloader-row-hidden')

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
        index = $cards.length - pageSize
      wayPointCard = $cards[index]
      # the advancer function requests always the next page
      advancer = $.proxy ->
        #destroy waypoint to avoid issues with triggering more page requests.
        @destroyAllWaypoints()

        # dont' bother if already on last page
        if @collection.currentlyOnLastPage()
          return
        @showPaginatedViewPreloaderAndContent()
        @requestPageInCollection('next')
      , @

      # destroy all waypoints before assigning the new one.
      @destroyAllWaypoints()
      scroll_container = null
      $scroll_containers = $(@el).find('.infinite-scroll-container')
      if $scroll_containers.length == 1
        scroll_container = $scroll_containers[0]

      @waypoint = new Waypoint(
        element: wayPointCard
        context: if scroll_container? then scroll_container else window
        handler: (direction) ->
          if direction == 'down'
            advancer()

      )

    destroyAllWaypoints: -> @waypoint.destroy() unless not @waypoint?
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

      for size in @AVAILABLE_PAGE_SIZES
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
      @hidePreloaderOnly()

    # ------------------------------------------------------------------------------------------------------------------
    # Embed modal
    # ------------------------------------------------------------------------------------------------------------------
    setUpEmbedModal: ->

      urlGenerator = glados.views.PaginatedViews.PaginatedViewFactory.getEmbedURLGeneratorFor(@type)
      glados.helpers.EmbedModalsHelper.initEmbedModalForCollectionView(urlGenerator, @)

    # ------------------------------------------------------------------------------------------------------------------
    # Link to all activities
    # ------------------------------------------------------------------------------------------------------------------
    islinkToOtherEntitiesEnabled: -> @collection.getMeta('enable_activities_link_for_selected_entities') == true

    renderLinkToAllItems: ->

      $linkToAllContainer = $(@el).find('.BCK-LinkToBrowseAllItems')
      glados.Utils.fillContentForElement $linkToAllContainer,
        url: @config.full_list_url
