glados.useNameSpace 'glados.views.PaginatedViews',
  TooltipFunctions:

    initTooltipFunctions: ->
      $itemsContainer = $(@el).find('.BCK-items-container')
      $itemsContainer.mouseleave($.proxy(@destroyAllTooltipsIfNecessary, @))

    destroyAllTooltipsIfNecessary: (event) ->

      $itemsContainer = $(@el).find('.BCK-items-container')
      scrollTop = $(window).scrollTop()
      scrollLeft = $(window).scrollLeft()
      itemsContainerOffset = $itemsContainer.offset().top

      containerYUpperLimit =  itemsContainerOffset - scrollTop
      containerYLowerLimit = (itemsContainerOffset + $itemsContainer.height()) - scrollTop
      containerLeftLimit = $itemsContainer.offset().left - scrollLeft
      containerRightLimit = ($itemsContainer.offset().left + $itemsContainer.width()) - scrollLeft

      mouseX = event.clientX
      mouseY = event.clientY

      xIsOut = (mouseX < containerLeftLimit) or (mouseX > containerRightLimit)
      yIsOut = (mouseY < containerYUpperLimit) or (mouseY > containerYLowerLimit)

      if xIsOut or yIsOut
        glados.Utils.Tooltips.destroyAllTooltips($(@el))