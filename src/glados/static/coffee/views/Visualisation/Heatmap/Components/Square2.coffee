glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  Square2:

    initSquare2: (mainGContainer) ->

      thisView = @

      corner2G = mainGContainer.append('g')
        .attr(@BASE_Y_TRANS_ATT, 0)
        .attr(@MOVE_X_ATT, @NO)
        .attr(@MOVE_Y_ATT, @NO)
        .attr(@FIXED_TO_LEFT_ATT, @YES)
        .attr(@BASE_WIDTH_ATT, @ROWS_FOOTER_WIDTH)
        .classed('square2-g', true)

      corner2G.append('rect')
        .style('fill', 'none')
      corner2G.append('polygon')
        .classed('divider-triangle', true)
      corner2G.append('line')
        .classed('diagonal-line', true)
        .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)

      corner2G.append('text')
        .classed('rows-sort-text', true)

      corner2G.assignTexts = ->

        d3TextElem = corner2G.select('.rows-sort-text')
          .text(thisView.currentRowSortingProperty.label + ':')
        widthLimit = d3TextElem.attr('data-text-width-limit')

        customTooltipPosition =
          my: 'top right'
          at: 'bottom left'

        thisView.setEllipsisIfOverlaps(d3ContainerElem=undefined, d3TextElem, limitByHeight=false, addFullTextQtip=true,
          widthLimit, customTooltipPosition)

      SQ2_triangleAlpha = 90 - thisView.COLS_LABELS_ROTATION
      SQ2_triangleAlphaRad = glados.Utils.getRadiansFromDegrees(SQ2_triangleAlpha)
      SQ2_tanTirangleAlhpa = Math.tan(SQ2_triangleAlphaRad)

      corner2G.scaleSizes = (zoomScale) ->

        currentContainerHeight = thisView.COLS_HEADER_HEIGHT * zoomScale
        currentContainerWidth = thisView.ROWS_FOOTER_WIDTH * zoomScale

        corner2G.select('rect')
          .attr('height', currentContainerHeight)
          .attr('width', currentContainerWidth)

        triangleHeight = thisView.ROWS_FOOTER_WIDTH * SQ2_tanTirangleAlhpa
        triangleTop = zoomScale * (thisView.COLS_HEADER_HEIGHT - triangleHeight)
        trianglePoints = [
          {
            x: 0
            y: currentContainerHeight
          }
          {
            x: currentContainerWidth
            y: triangleTop
          }
          {
            x: currentContainerWidth
            y: currentContainerHeight
          }
        ]

        pointsString = ("#{p.x},#{p.y}" for p in trianglePoints).join(' ')
        corner2G.select('.divider-triangle')
          .attr('points', pointsString)

        corner2G.select('.diagonal-line')
          .attr('x1', 0)
          .attr('y1', currentContainerHeight)
          .attr('x2', currentContainerWidth)
          .attr('y2', triangleTop)

        # https://drive.google.com/file/d/1rEg1YNxzR6cB2upjRf7PtoIk08tyLapg/view?usp=sharing
        tY = (3/2) * thisView.LABELS_PADDING
        textY = (thisView.COLS_HEADER_HEIGHT + tY) * zoomScale
        tX = tY / SQ2_tanTirangleAlhpa
        textX = (tX + 2) * zoomScale # add a small padding because tX is always bound to triangle
        # The final textX or textY values need to take into account the current zoom scale

        triangleHyp = Math.sqrt(Math.pow(triangleHeight, 2) + Math.pow(currentContainerWidth, 2))
        textWidthLimit = triangleHyp - (2 * textX)

        corner2G.select('.rows-sort-text')
          .attr('x', textX)
          .attr('y', textY)
          .attr('data-text-width-limit', textWidthLimit)

        corner2G.select('.rows-sort-text')
          .attr('style', 'font-size:' + ( (4/5) * thisView.BASE_LABELS_SIZE * zoomScale) + 'px;')
          .attr('transform', "rotate(#{-SQ2_triangleAlpha}, 0, #{thisView.COLS_HEADER_HEIGHT * zoomScale})")

      @applyZoomAndTranslation(corner2G)
      corner2G.assignTexts()


      return corner2G