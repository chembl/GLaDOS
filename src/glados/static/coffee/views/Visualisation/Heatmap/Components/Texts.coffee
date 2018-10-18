glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  Texts:

    TO_LOAD_TEXT: '.'
    LOADING_TEXT: 'Loading...'
    LOADING_TEXT_MICRO: '...'
    fillHeaderText: (d3TextElem, isCol=true) ->
      thisView = @

      propName = if isCol then thisView.currentColLabelProperty.propName else thisView.currentRowLabelProperty.propName
      d3TextElem.text( (d) ->
        if d.load_state == glados.models.Heatmap.ITEM_LOAD_STATES.TO_LOAD
          glados.views.Visualisation.Heatmap.Components.Texts.TO_LOAD_TEXT
        else
          glados.Utils.getNestedValue(d, propName)
      )

      @setHeaderEllipsis(d3TextElem, isCol)

    setHeaderEllipsis: (d3TextElem, isCol=true) ->

      d3ContainerElem = d3.select(d3TextElem.node().parentNode).select('.headers-background-rect')
      @setEllipsisIfOverlaps(d3ContainerElem, d3TextElem, limitByHeight=isCol)

    setAllHeadersEllipsis: (d3Selecion, isCol=true) ->

      thisView = @
      d3Selecion.selectAll('text')
        .each((d)-> thisView.setHeaderEllipsis(d3.select(@), isCol))

    # because normally container and text elem scale at the same rate on zoom, this can be done only once.
    # take this into account if there is a problem later.
    setEllipsisIfOverlaps: (d3ContainerElem, d3TextElem, limitByHeight=false, addFullTextQtip=false, customWidthLimit,
    customTooltipPosition=undefined ) ->

      # remember the rotation!
      if customWidthLimit?
        containerLimit = customWidthLimit
      else

        if limitByHeight
          containerLimit = d3ContainerElem.node().getBBox().height
        else
          textX = d3TextElem.attr('x')
          containerLimit = d3ContainerElem.node().getBBox().width - textX

      textWidth = d3TextElem.node().getBBox().width
      $textElem = $(d3TextElem.node())

      if 0 < containerLimit < textWidth
        text = d3TextElem.text()
        newText = glados.Utils.Text.getTextForEllipsis(text, textWidth, containerLimit)
        d3TextElem.text(newText)

        if addFullTextQtip

          tooltipPosition = customTooltipPosition
          tooltipPosition ?= glados.Utils.Tooltips.getQltipSafePostion($textElem)

          qtipConfig =
            content:
              text: "<div style='padding: 3px'>#{text}</div>"
            position: tooltipPosition
            style:
              classes:'matrix-qtip qtip-light qtip-shadow'

          $textElem.qtip qtipConfig

      else

        if addFullTextQtip
          $textElem.qtip('destroy', true)