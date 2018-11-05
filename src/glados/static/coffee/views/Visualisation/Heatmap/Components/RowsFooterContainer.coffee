glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  RowsFooterContainer:

    # ------------------------------------------------------------------------------------------------------------------
    # defining positioning and scaling functions
    # ------------------------------------------------------------------------------------------------------------------
    initRowsFooterContainer: (mainGContainer) ->

      thisView = @

      rowsFooterG = mainGContainer.append('g')
        .attr(@BASE_Y_TRANS_ATT, @COLS_HEADER_HEIGHT)
        .attr(@MOVE_X_ATT, @NO)
        .attr(@MOVE_Y_ATT, @YES)
        .attr(@FIXED_TO_LEFT_ATT, @YES)
        .attr(@BASE_WIDTH_ATT, @ROWS_FOOTER_WIDTH)

      rowsFooterG.append('rect')
        .style('fill', 'none')
        .classed('background-rect', true)

      @updateRowsFootersForWindow(rowsFooterG)

      rowsFooterG.assignTexts = (transitionDuration=0) ->

        t = rowsFooterG.transition().duration(transitionDuration)
        t.selectAll('.footers-text')
          .text((d) ->
            if d.load_state == glados.models.Heatmap.ITEM_LOAD_STATES.TO_LOAD
              glados.views.Visualisation.Heatmap.Components.Texts.TO_LOAD_TEXT
            else if d.load_state == glados.models.Heatmap.ITEM_LOAD_STATES.LOADING
              glados.views.Visualisation.Heatmap.Components.Texts.LOADING_TEXT_MICRO
            else
              glados.Utils.getNestedValue(d, thisView.currentRowSortingProperty.propName)
        )

      rowsFooterG.positionRows = (zoomScale, transitionDuration=0 ) ->

        t = rowsFooterG.transition().duration(transitionDuration)
        t.selectAll('.vis-row-footer')
          .attr('transform', (d) -> "translate(0, " + (thisView.getYCoord(d.currentPosition) * zoomScale) + ")" )

      rowsFooterG.scaleSizes = (zoomScale) ->

        rowsFooterG.select('.background-rect')
          .attr('height', (thisView.ROWS_HEADER_HEIGHT * zoomScale))
          .attr('width', (thisView.ROWS_FOOTER_WIDTH * zoomScale))

        rowsFooterG.positionRows(zoomScale)
        rowsFooterG.assignTexts()

        rowsFooterG.selectAll('.footers-background-rect')
          .attr('height', (thisView.getYCoord.rangeBand() * zoomScale))
          .attr('width', (thisView.ROWS_FOOTER_WIDTH * zoomScale))

        rowsFooterG.selectAll('.footers-text')
          .attr('x', ((thisView.ROWS_FOOTER_WIDTH - thisView.LABELS_PADDING) * zoomScale))
          .attr("y", (thisView.getYCoord.rangeBand() * (2/3) * zoomScale) )
          .attr('style', 'font-size:' + (thisView.BASE_LABELS_SIZE * zoomScale ) + 'px;')

      @applyZoomAndTranslation(rowsFooterG)

      return rowsFooterG


    # ------------------------------------------------------------------------------------------------------------------
    # update according to window
    # ------------------------------------------------------------------------------------------------------------------
    updateRowsFootersForWindow: (rowsFooterG) ->

      thisView = @
      rowsInWindow = @ROWS_IN_WINDOW
      # generate footer links for window
      for rowObj in rowsInWindow
        if rowObj.load_state == glados.models.Heatmap.ITEM_LOAD_STATES.LOADED
          thisView.model.getRowFooterLink(rowObj.id)

      rowFooters = rowsFooterG.selectAll('.vis-row-footer')
        .data(rowsInWindow, (d) -> d.id)

      rowFooters.exit().remove()
      rowFootersEnter = rowFooters.enter()
        .append('g').attr('class', 'vis-row-footer')

      rowFootersEnter.append('rect')
        .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
        .style('stroke-width', @GRID_STROKE_WIDTH)
        .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .classed('footers-background-rect', true)

      rowFootersEnter.append('text')
        .classed('footers-text', true)
        .attr('text-anchor', 'end')
        .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
        .attr('id', (d) -> thisView.ROW_FOOTER_TEXT_BASE_ID + d.id)
#        .on('click', thisView.handleRowFooterClick )