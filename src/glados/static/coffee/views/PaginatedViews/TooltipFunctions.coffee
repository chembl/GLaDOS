glados.useNameSpace 'glados.views.PaginatedViews',
  TooltipFunctions:

    initTooltipFunctions: ->
      console.log 'TOOLTIP'
      $(@el).mouseout(-> console.log 'MOUSEOUT!')
