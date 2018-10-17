glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  ColsFooter:

    # ------------------------------------------------------------------------------------------------------------------
    # defining positioning and scaling functions
    # ------------------------------------------------------------------------------------------------------------------
    initColsFooter: (mainGContainer) ->

      thisView = @
      colsFooterG = mainGContainer.append('g')
        .attr(@BASE_X_TRANS_ATT, @ROWS_HEADER_WIDTH)
        .attr(@MOVE_X_ATT, @YES)
        .attr(@MOVE_Y_ATT, @NO)
        .attr(@FIXED_TO_BOTTOM_ATT, @YES)
        .attr(@BASE_HEIGHT_ATT, @COLS_FOOTER_HEIGHT)

      colsFooterG.append('rect')
        .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
        .classed('background-rect', true)

      @updateColsFootersForWindow(colsFooterG)

      colsFooterG.positionCols = (zoomScale, transitionDuration=0) ->

        t = colsFooterG.transition().duration(transitionDuration)
        t.selectAll('.vis-column-footer')
          .attr("transform", ((d) -> "translate(" + (thisView.getXCoord(d.currentPosition) * zoomScale) +
          ")rotate(" + (-thisView.COLS_LABELS_ROTATION) + " " + (thisView.getXCoord.rangeBand() * zoomScale) + " 0)" ))

      colsFooterG.assignTexts = (transitionDuration=0) ->

        t = colsFooterG.transition().duration(transitionDuration)
        t.selectAll('.footers-text')
          .text((d) ->
            if not d.loaded
              glados.views.Visualisation.Heatmap.Components.Texts.LOADING_TEXT_MICRO
            else
              glados.Utils.getNestedValue(d, thisView.currentColSortingProperty.propName)
        )

      colsFooterG.scaleSizes = (zoomScale) ->

        colsFooterG.select('.background-rect')
          .attr('height', (thisView.COLS_FOOTER_HEIGHT * zoomScale))
          .attr('width', (thisView.COLS_HEADER_WIDTH * zoomScale))

        colsFooterG.positionCols(zoomScale)

        colsFooterG.selectAll('.footers-background-rect')
          .attr('height', (thisView.COLS_FOOTER_HEIGHT * zoomScale))
          .attr('width', (thisView.getXCoord.rangeBand() * zoomScale))

        colsFooterG.selectAll('.footers-divisory-line')
          .attr('x1', (thisView.getXCoord.rangeBand() * zoomScale))
          .attr('y1',0)
          .attr('x2', (thisView.getXCoord.rangeBand() * zoomScale))
          .attr('y2', (thisView.COLS_FOOTER_HEIGHT * zoomScale) )

        colsFooterG.selectAll('.footers-text')
          .attr("y", (-thisView.getXCoord.rangeBand() * (1/3) * zoomScale) )
          .attr('style', 'font-size:' + (thisView.BASE_LABELS_SIZE * zoomScale) + 'px;')


      @applyZoomAndTranslation(colsFooterG)
      colsFooterG.assignTexts()

      return colsFooterG

    # ------------------------------------------------------------------------------------------------------------------
    # update according to window
    # ------------------------------------------------------------------------------------------------------------------
    updateColsFootersForWindow: (colsFooterG) ->

      thisView = @
      colsInWindow = @COLS_IN_WINDOW

      # generate footer links for window
      for colObj in colsInWindow
        if colObj.loaded
          thisView.model.getColFooterLink(colObj.id)

      colsFooters = colsFooterG.selectAll(".vis-column-footer")
        .data(colsInWindow, (d) -> d.id)

      colsFooters.exit().remove()
      colsFootersEnter = colsFooters.enter()
        .append("g")
        .classed('vis-column-footer', true)

      colsFootersEnter.append('rect')
        .style('fill', 'none')
        .classed('footers-background-rect', true)

      colsFootersEnter.append('line')
        .style('stroke-width', @GRID_STROKE_WIDTH)
        .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .classed('footers-divisory-line', true)

      colsFootersEnter.append('text')
        .classed('footers-text', true)
        .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
        .attr('transform', 'rotate(90)')
        .attr('id', (d) -> thisView.COL_FOOTER_TEXT_BASE_ID + d.id )
#        .on('click', thisView.handleColFooterClick)