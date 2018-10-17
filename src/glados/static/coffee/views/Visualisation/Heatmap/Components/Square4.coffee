glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  Square4:

    initSquare4: (mainGContainer) ->

      thisView = @
      
      corner4G = mainGContainer.append('g')
        .attr(@MOVE_X_ATT, @NO)
        .attr(@MOVE_Y_ATT, @NO)
        .attr(@FIXED_TO_LEFT_ATT, @YES)
        .attr(@BASE_WIDTH_ATT, @ROWS_FOOTER_WIDTH)
        .attr(@FIXED_TO_BOTTOM_ATT, @YES)
        .attr(@BASE_HEIGHT_ATT, (@COLS_FOOTER_HEIGHT))

      corner4G.append('rect')
        .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
        .classed('background-rect', true)

      corner4G.scaleSizes = (zoomScale) ->

        corner4G.select('.background-rect')
          .attr('height', (thisView.COLS_FOOTER_HEIGHT * zoomScale))
          .attr('width', (thisView.ROWS_FOOTER_WIDTH * zoomScale))

      @applyZoomAndTranslation(corner4G)
      return corner4G