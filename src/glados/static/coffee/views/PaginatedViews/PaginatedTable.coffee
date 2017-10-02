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

