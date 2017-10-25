glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedTable:

    # ------------------------------------------------------------------------------------------------------------------
    # Initalisation
    # ------------------------------------------------------------------------------------------------------------------
    bindCollectionEvents: ->

      @collection.on glados.Events.Collections.SELECTION_UPDATED, @selectionChangedHandler, @
      @collection.on 'reset sort', @render, @
      @collection.on 'request', @showPreloaderHideOthers, @
      @collection.on 'error', @handleError, @

    # ------------------------------------------------------------------------------------------------------------------
    # rendering
    # ------------------------------------------------------------------------------------------------------------------
    renderViewState: ->

      @clearContentContainer()
      @fillTemplates()

      @fillSelectAllContainer() unless @disableItemsSelection
      @fillPaginators()
      @fillPageSizeSelectors()
      @activateSelectors()
      @showPaginatedViewContent()

      if @collection.getMeta('fuzzy-results')? and @collection.getMeta('fuzzy-results') == true
        @showSuggestedLabel()
      else
        @hideSuggestedLabel()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)

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

      $modalContainer = $(@el).find('.BCK-show-hide-columns-container')

      new glados.views.PaginatedViews.ColumnsHandling.ColumnsHandlerView
        model: @columnsHandler
        el: $modalContainer

      $modalContainer.find('.modal').modal()

    # ------------------------------------------------------------------------------------------------------------------
    # Fill Templates
    # ------------------------------------------------------------------------------------------------------------------
    fillTemplates: ->


      $elem = $(@el).find('.BCK-items-container')
      allColumns = @getAllColumns()
      @numVisibleColumnsList.push allColumns.length

      if @collection.length > 0
        for i in [0..$elem.length - 1]
          @sendDataToTemplate $($elem[i]), allColumns
        @bindFunctionLinks()
        @showHeaderContainer()
        @showFooterContainer()
        @checkIfTableNeedsToScroll()
      else
        @hideHeaderContainer()
        @hideFooterContainer()
        @hideContentContainer()
        @showEmptyMessageContainer()

    sendDataToTemplate: ($specificElemContainer, visibleColumns) ->

      templateID = $specificElemContainer.attr('data-hb-template')
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

      @appendHTMLElements(visibleColumns, $appendTo, applyTemplate)

    appendHTMLElements: (columns, $appendTo, applyTemplateTo) ->

      for item in @collection.getCurrentPage()

        columnsWithValues = glados.Utils.getColumnsWithValues(columns, item)
        idValue = glados.Utils.getNestedValue(item.attributes, @collection.getMeta('id_column').comparator)

        templateParams =
          base_check_box_id: idValue
          is_selected: @collection.itemIsSelected(idValue)
          img_url: glados.Utils.getImgURL(columnsWithValues)
          columns: columnsWithValues
          selection_disabled: @disableItemsSelection

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

          # delay this to wait for
          @setUpTableHeaderPinner($specificElemContainer)
          $specificElemContainer.attr('data-header-pinner-setup', true)

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

#-----------------------------------------------------------------------------------------------------------------------
# Static functions
#-----------------------------------------------------------------------------------------------------------------------
glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell = ($clickedElem, isDataVis=true) ->

  $clickedLink = $clickedElem
  paramsList = $clickedLink.attr('data-function-paramaters').split(',')
  constantParamsList = $clickedLink.attr('data-function_constant_parameters').split(',')
  $containerElem = $clickedLink.parent()

  if isDataVis
    $containerElem.removeClass('number-cell')
    $containerElem.addClass('vis-container')
    glados.Utils.fillContentForElement($containerElem, {}, 'Handlebars-Common-MiniHistogramContainer')

  return [paramsList, constantParamsList, $containerElem]

