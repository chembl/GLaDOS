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
    # Columns initalisation
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Table.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Table.Additional
    # ------------------------------------------------------------------------------------------------------------------
    # Add Remove Columns
    # ------------------------------------------------------------------------------------------------------------------
    initialiseColumnsModal: ->

      console.log 'creating SH MODAL'
      $modalContainer = $(@el).find('.BCK-show-hide-columns-container')

      if $modalContainer.length == 0
        return

      allColumns = _.union(@collection.getMeta('columns'), @collection.getMeta('additional_columns'))

      glados.Utils.fillContentForElement $modalContainer,
        all_selected: true
        modal_id: $(@el).attr('id') + '-select-columns-modal'
        random_num: (new Date()).getTime()
        all_columns: allColumns


      $(@el).find('.modal').modal()

    showHideColumn: (event) ->

      console.log 'SHOW HIDE COLUMN'
      $checkbox = $(event.currentTarget)
      colComparator = $checkbox.attr('data-comparator')
      isChecked = $checkbox.is(':checked')

      allColumns = _.union(@collection.getMeta('columns'), @collection.getMeta('additional_columns'))

      if colComparator == 'SELECT-ALL'
        for col in allColumns
          col.show = isChecked
      else
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

