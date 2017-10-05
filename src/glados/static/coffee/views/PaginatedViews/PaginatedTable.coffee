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

