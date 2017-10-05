glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedTable:
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
    # Columns initalisation
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Table.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Table.Additional
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


      for item in @collection.getCurrentPage()

        columnsWithValues = glados.Utils.getColumnsWithValues(visibleColumns, item)
        idValue = glados.Utils.getNestedValue(item.attributes, @collection.getMeta('id_column').comparator)

        templateParams =
          base_check_box_id: idValue
          is_selected: @collection.itemIsSelected(idValue)
          img_url: glados.Utils.getImgURL(columnsWithValues)
          columns: columnsWithValues
          selection_disabled: @disableItemsSelection

        $newItemElem = $(applyTemplate(templateParams))
        $appendTo.append($newItemElem)


#-----------------------------------------------------------------------------------------------------------------------
# Static functions
#-----------------------------------------------------------------------------------------------------------------------
glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell = ($clickedElem) ->

  $clickedLink = $clickedElem
  paramsList = $clickedLink.attr('data-function-paramaters').split(',')
  constantParamsList = $clickedLink.attr('data-function_constant_parameters').split(',')
  $containerElem = $clickedLink.parent()
  $containerElem.removeClass('number-cell')
  $containerElem.addClass('vis-container')
  glados.Utils.fillContentForElement($containerElem, {}, 'Handlebars-Common-MiniHistogramContainer')

  return [paramsList, constantParamsList, $containerElem]

