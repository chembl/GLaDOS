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

      @initialiseColumnsModal() unless @disableColumnsSelection

      if @collection.getMeta('fuzzy-results')? and @collection.getMeta('fuzzy-results') == true
        @showSuggestedLabel()
      else
        @hideSuggestedLabel()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)

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

