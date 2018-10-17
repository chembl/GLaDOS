glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  Square3:

    initSquare3: (mainGContainer) ->

      thisView = @

      corner3G = mainGContainer.append('g')
        .attr(@BASE_X_TRANS_ATT, 0)
        .attr(@MOVE_X_ATT, @NO)
        .attr(@MOVE_Y_ATT, @NO)
        .attr(@FIXED_TO_BOTTOM_ATT, @YES)
        .attr(@BASE_HEIGHT_ATT, @COLS_FOOTER_HEIGHT)

      corner3G.append('rect')
        .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
        .classed('background-rect', true)

      corner3G.append('text')
        .attr('x', thisView.LABELS_PADDING)
        .attr('y', thisView.getYCoord.rangeBand())
        .classed('cols-sort-text', true)

      corner3G.assignTexts = ->

        colsSortText = corner3G.select('.cols-sort-text')
          .text(thisView.currentColSortingProperty.label + ':')
        backgroundRect = corner3G.select('.background-rect')

        thisView.setEllipsisIfOverlaps(backgroundRect, colsSortText, limitByHeight=false, addFullTextQtip=true)

      corner3G.scaleSizes = (zoomScale) ->

        corner3G.select('.background-rect')
          .attr('height', (thisView.COLS_FOOTER_HEIGHT * zoomScale))
          .attr('width', (thisView.ROWS_HEADER_WIDTH * zoomScale))

        corner3G.select('.cols-sort-text')
          .attr('style', 'font-size:' + ((4/5) * thisView.BASE_LABELS_SIZE * zoomScale) + 'px;')

      @applyZoomAndTranslation(corner3G)
      corner3G.assignTexts()

      return corner3G