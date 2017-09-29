glados.useNameSpace 'glados.views.PaginatedViews',
  TooltipFunctions:

    initTooltipFunctions: ->

      $itemsContainer = $(@el).find('.BCK-items-container')
      $itemsContainer.mouseleave($.proxy(@destroyAllTooltipsIfNecessary, @))

    destroyAllTooltipsIfNecessary: (event) ->

      $container = $(@el).find('.BCK-items-container')
      mouseX = event.clientX
      mouseY = event.clientY
      glados.Utils.Tooltips.destroyAllTooltipsWhenMouseIsOut($container, mouseX, mouseY)
