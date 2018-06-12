glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedTable:

    # ------------------------------------------------------------------------------------------------------------------
    # Initalisation
    # ------------------------------------------------------------------------------------------------------------------
    bindCollectionEvents: ->

      @collection.on glados.Events.Collections.SELECTION_UPDATED, @selectionChangedHandler, @
      @collection.on 'reset sort do-repaint', @render, @
      @collection.on 'request', @showPreloaderHideOthers, @
      @collection.on 'error', @handleError, @

    # ------------------------------------------------------------------------------------------------------------------
    # pageSizes
    # ------------------------------------------------------------------------------------------------------------------
    initAvailablePageSizes: ->
      customDefaultPageSizes = @collection.getMeta('columns_description').Table.custom_page_sizes
      if customDefaultPageSizes?
        @AVAILABLE_PAGE_SIZES = customDefaultPageSizes
      glados.views.PaginatedViews.PaginationFunctions.initAvailablePageSizes.call(@)

    # ------------------------------------------------------------------------------------------------------------------
    # rendering
    # ------------------------------------------------------------------------------------------------------------------
    renderViewState: ->


      @clearContentContainer()
      @fillSelectAllContainer() unless @disableItemsSelection
      if @disableItemsSelection
        @removeSelectAllContainer()

      @fillPaginators()
      if @collection.getMeta('total_pages') == 1
        @hidePaginators()
        @hideFooter()
      if @collection.getMeta('total_records') == 1
        @hideHeaderContainer()
      else
        @fillPageSizeSelectors()
        @activateSelectors()
        @showHeaderContainer()
        @showFooterContainer()

      @showPaginatedViewContent()

      if @collection.getMeta('fuzzy-results')? and @collection.getMeta('fuzzy-results') == true
        @showSuggestedLabel()
      else
        @hideSuggestedLabel()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)


    removeSelectAllContainer: ->
      $selectAllContainer = $(@el).find('.BCK-selectAll-container')
      $selectAllContainer.hide()


    # ------------------------------------------------------------------------------------------------------------------
    # Columns handling
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Table.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Table.Additional

    handleShowHideColumns: ->

      exitColsComparators = @columnsHandler.get('exit')
      for comparator in exitColsComparators

        $(@el).find('th[data-comparator="' + comparator + '"]').addClass('hidden_header')
        $(@el).find('td[data-comparator="' + comparator + '"]').addClass('hidden_cell')
        $(@el).find('.collection-item div[data-comparator="' + comparator + '"]').addClass('hidden_list_prop')

      enterColsComparators = @columnsHandler.get('enter')
      for comparator in enterColsComparators

        $(@el).find('th[data-comparator="' + comparator + '"]').removeClass('hidden_header')
        $(@el).find('td[data-comparator="' + comparator + '"]').removeClass('hidden_cell')
        $(@el).find('.collection-item div[data-comparator="' + comparator + '"]').removeClass('hidden_list_prop')

      @bindFunctionLinks()
      @checkIfTableNeedsToScroll()

    handleColumnsOrderChange: ->

      columnsIndex = @columnsHandler.get('columns_index')

      $headersRow = $(@el).find('.BCK-headers-row')
      $headers = $(@el).find('.BCK-sortable-pag-table-header')

      compareFunction = (a, b) ->

        comparatorA = $(a).attr('data-comparator')
        comparatorB = $(b).attr('data-comparator')

        positionA = columnsIndex[comparatorA].position
        positionB = columnsIndex[comparatorB].position

        return positionA - positionB

      $headers.sort compareFunction
      $headersRow.append($headers)

      $itemsRows = $(@el).find('tr.BCK-items-row')
      $itemsRows.each ->
        $currentRow = $(@)
        $cells = $currentRow.find('td.BCK-sortable-pag-table-cell')
        $cells.sort compareFunction
        $currentRow.append $cells

      $listItems = $(@el).find('li.BCK-items-li')
      $listItems.each ->
        $currentItem = $(@)
        $divs = $currentItem.find('div.BCK-sortable-pag-list-prop')
        $divs.sort compareFunction
        $currentItem.append $divs


    # ------------------------------------------------------------------------------------------------------------------
    # Add Remove Columns
    # ------------------------------------------------------------------------------------------------------------------
    initialiseColumnsModal: ->

      now = Date.now()
      modalID = @collection.getMeta('id_name') + 'show-hide-columns-modal' + now

      glados.Utils.fillContentForElement $(@el).find('.BCK-ModalTrigger'),
        modal_id: modalID

      templateParams =
        modal_id: modalID

      $('#BCK-GeneratedModalsContainer').append($(glados.Utils.getContentFromTemplate(
        'Handlebars-Common-EditFiltersModal', templateParams)))

      $modalContentContainer = $("##{modalID}")

      new glados.views.PaginatedViews.ColumnsHandling.ColumnsHandlerView
        model: @columnsHandler
        el: $modalContentContainer
        modal_id: modalID

      $modalContentContainer.modal()

    # ------------------------------------------------------------------------------------------------------------------
    # Fill Templates
    # ------------------------------------------------------------------------------------------------------------------
    fillTemplates: ->

      $elem = $(@el).find('.BCK-items-container')

      if @collection.getMeta('columns_description').Table.remove_striping
        $elem.removeClass('striped')

      allColumns = @getAllColumns()
      @numVisibleColumnsList.push allColumns.length
      # this is a workaround to the problem
      for col in allColumns
        if col.table_cell_width_medium? and GlobalVariables.CURRENT_SCREEN_TYPE == glados.Settings.MEDIUM_SCREEN
          col.table_cell_width = col.table_cell_width_medium

      for i in [0..$elem.length - 1]
        @sendDataToTemplate $($elem[i]), allColumns
      @bindFunctionLinks()
      @checkIfTableNeedsToScroll()
      if @pinUnpinTableHeader?
         @pinUnpinTableHeader()
      if @scrollTableHeader?
        @scrollTableHeader()


    sendDataToTemplate: ($specificElemContainer, visibleColumns) ->
      if @shouldIgnoreContentChangeRequestWhileStreaming()
        return

      templateID = $specificElemContainer.attr('data-hb-template')
      applyTemplate = Handlebars.compile($('#' + templateID).html())
      $appendTo = $specificElemContainer

      # if it is a table, add the corresponding header
      if $specificElemContainer.is('table')

        header_template = $('#' + $specificElemContainer.attr('data-hb-header-template'))
        header_row_cont = Handlebars.compile( header_template.html() )
          base_check_box_id: @getBaseSelectAllCheckBoxID()
          all_items_selected: @collection.getMeta('all_items_selected') and not @collection.thereAreExceptions()
          columns: (_.extend(col, {view_id: @viewID}) for col in visibleColumns)
          selection_disabled: @disableItemsSelection

        $specificElemContainer.append($(header_row_cont))
        # make sure that the rows are appended to the tbody, otherwise the striped class won't work
        $specificElemContainer.append($('<tbody>'))
        $specificElemContainer.append($('<tbody>'))

      @appendHTMLElements(visibleColumns, $appendTo, applyTemplate)

    appendHTMLElements: (columns, $appendTo, applyTemplateTo) ->

      for item in @collection.getCurrentPage()

        [columnsWithValues, highlights] = glados.Utils.getColumnsWithValuesAndHighlights(columns, item)
        idValue = glados.Utils.getNestedValue(item.attributes, @collection.getMeta('id_column').comparator)

        conditionalRowFormatFunc = @collection.getMeta('columns_description').Table.ConditionalRowFormatting
        conditionalFormat = undefined
        if conditionalRowFormatFunc?
          conditionalFormat = conditionalRowFormatFunc(item)

        templateParams =
          base_check_box_id: idValue
          is_selected: @collection.itemIsSelected(idValue)
          img_url: glados.Utils.getImgURL(columnsWithValues)
          columns: columnsWithValues
          highlights: highlights
          selection_disabled: @disableItemsSelection
          conditional_format: conditionalFormat

        $newItemElem = $(applyTemplateTo(templateParams))
        $appendTo.append($newItemElem)

    bindFunctionLinks: ->

      $linksToBind = $(@el).find('.BCK-items-container .BCK-function-link')
      functionColumnsIndex = _.indexBy(@getAllColumns(), 'function_key')
      $linksToBind.each (i, link) ->

        $currentLink = $(@)
        if not $currentLink.is(":visible")
          return

        alreadyBound = $currentLink.attr('data-already-function-bound')?
        if not alreadyBound

          functionKey = $currentLink.attr('data-function-key')
          functionToBind = functionColumnsIndex[functionKey].on_click
          $currentLink.click functionToBind

          removeAfterClick = functionColumnsIndex[functionKey].remove_link_after_click
          if removeAfterClick
            $currentLink.click -> $(@).remove()

          executeOnRender = functionColumnsIndex[functionKey].execute_on_render

          if executeOnRender
            $currentLink.click()

          $currentLink.attr('data-already-function-bound', 'yes')

    # ------------------------------------------------------------------------------------------------------------------
    # Table scroller
    # ------------------------------------------------------------------------------------------------------------------
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
          @setUpTableHeaderPinner($specificElemContainer)
          $specificElemContainer.attr('data-header-pinner-setup', true)
        @pinUnpinTableHeader()
        @scrollTableHeader()


    # this sets up dor a table the additional scroller on top of the table
    setUpTopTableScroller: ($table) ->

      $scrollContainer = $(@el).find('.BCK-top-scroller-container')
      $scrollContainer.scroll( -> $table.scrollLeft($scrollContainer.scrollLeft()))
      $table.scroll( -> $scrollContainer.scrollLeft($table.scrollLeft()))


    # ------------------------------------------------------------------------------------------------------------------
    # Table header pinner
    # ------------------------------------------------------------------------------------------------------------------
    setUpTableHeaderPinner: ($table) ->
      $win = $(window)
      $table.data('data-state', 'no-pinned')

      scrollTableHeader = ->
        $table = $(@el).find('table.BCK-items-container')
        $pinnedHeader = $table.find('.pinned-header').first()
        $pinnedHeader.offset({left: $table.offset().left - $table.scrollLeft()})

      pinUnpinTableHeader = ->

        if !$table.is(":visible")
          return

        $win = $(window)
        $table = $(@el).find('table.BCK-items-container')
        $originalHeader = $table.find('#sticky-header').first()
        $clonedHeader = $originalHeader.clone().addClass('pinned-header').attr('id','clonedHeader')
        scroll = $win.scrollTop()
        topTrigger = $originalHeader.offset().top
        bottomTrigger = $table.find('.BCK-items-row').last().offset().top
        searchBarHeight = $('#chembl-header-container.pinned').find('.chembl-header').height()

        if scroll >= topTrigger  -  searchBarHeight and scroll < bottomTrigger
          @scrollTableHeader()
          $table.data('data-state','pinned')
        else
          $table.data('data-state', 'no-pinned')

        if $table.data('data-state') == 'pinned'
          $clonedHeader.height($originalHeader.height())
          $clonedHeader.width($originalHeader.width())

          originalWidths = []
          $originalHeader.find('.BCK-headers-row').first().children('th').each( ->
           originalWidths.push($(@).width())
          )

          $clonedHeader.find('.BCK-headers-row').first().children('th').each( (i) ->
            $(@).width(originalWidths[i] + 9.5)
          )

          if $table.find('.pinned-header').length == 0
            $table.prepend($clonedHeader)
        else
          $table.find('.pinned-header').first().remove()

      @pinUnpinTableHeader = $.proxy(pinUnpinTableHeader, @)
      @scrollTableHeader = $.proxy(scrollTableHeader, @)

      $win.scroll(@pinUnpinTableHeader)
      $table.scroll(@scrollTableHeader)

      $win.resize(@pinUnpinTableHeader)
      $win.resize(@scrollTableHeader)

#-----------------------------------------------------------------------------------------------------------------------
# Static functions
#-----------------------------------------------------------------------------------------------------------------------
glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell = ($clickedElem, isDataVis=true) ->

  $clickedLink = $clickedElem
  paramsList = $clickedLink.attr('data-function-paramaters').split(',')
  constantParamsList = $clickedLink.attr('data-function_constant_parameters').split(',')
  objectParameter = $clickedElem.attr('data-function_object_parameter')
  $containerElem = $clickedLink.parent()

  if isDataVis
    $containerElem.removeClass('number-cell')
    $containerElem.addClass('vis-container')
    glados.Utils.fillContentForElement($containerElem, {}, 'Handlebars-Common-MiniHistogramContainer')

  return [paramsList, constantParamsList, $containerElem, objectParameter]

