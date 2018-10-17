glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  Square1:

    initSquare1: (mainGContainer) ->

      thisView = @
      corner1G = mainGContainer.append('g')
        .attr(@BASE_X_TRANS_ATT, 0)
        .attr(@BASE_Y_TRANS_ATT, 0)
        .attr(@MOVE_X_ATT, @NO)
        .attr(@MOVE_Y_ATT, @NO)

      corner1G.append('rect')
        .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
        .classed('background-rect', true)

      corner1G.append('line')
        .style('stroke-width', @GRID_STROKE_WIDTH)
        .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .classed('diagonal-line', true)


      corner1G.append('text')
        .text(@NUM_COLUMNS + ' ' + @config.cols_entity_name)
        .classed('columns-text', true)
        .attr('text-anchor', 'middle')
#        .on('click', -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(thisView.model.getLinkToAllColumns()))

      corner1G.append('text')
        .text(@NUM_ROWS + ' ' + @config.rows_entity_name)
        .classed('rows-text', true)
        .attr('text-anchor', 'middle')

      corner1G.textRotationAngle = glados.Utils.getDegreesFromRadians(Math.atan(@COLS_HEADER_HEIGHT / @ROWS_HEADER_WIDTH))

      corner1G.scaleSizes = (zoomScale) ->

        corner1G.select('.background-rect')
          .attr('height', thisView.COLS_HEADER_HEIGHT * zoomScale)
          .attr('width', thisView.ROWS_HEADER_WIDTH * zoomScale)

        corner1G.select('.diagonal-line')
          .attr('x2', thisView.ROWS_HEADER_WIDTH * zoomScale)
          .attr('y2', thisView.COLS_HEADER_HEIGHT * zoomScale)

        corner1G.select('.columns-text')
          .attr('style', 'font-size:' + (thisView.BASE_LABELS_SIZE * zoomScale) + 'px;')
          .attr('transform', 'translate(' + (thisView.ROWS_HEADER_WIDTH * 2/3) * zoomScale + ',' +
            (thisView.COLS_HEADER_HEIGHT / 2) * zoomScale + ')' + 'rotate(' + corner1G.textRotationAngle + ' 0 0)')

        corner1G.select('.rows-text')
          .attr('style', 'font-size:' + (thisView.BASE_LABELS_SIZE * zoomScale) + 'px;')
          .attr('transform', 'translate(' + (thisView.ROWS_HEADER_WIDTH / 2) * zoomScale + ',' +
            (thisView.COLS_HEADER_HEIGHT * 2/3) * zoomScale + ')' + 'rotate(' + corner1G.textRotationAngle + ' 0 0)')

      @applyZoomAndTranslation(corner1G)

      return corner1G