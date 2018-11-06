glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  RowsHeaderContainer:

    initRowHeadersEvents: ->

      thisView = @
      @model.on(glados.models.Heatmap.EVENTS.VISUAL_WINDOW.ROWS_HEADERS_UPDATED, ->

        if thisView.rowsHeaderG?
          thisView.updateRowsHeadersForWindow(thisView.rowsHeaderG, stateChanged=true)

      )
    # ------------------------------------------------------------------------------------------------------------------
    # defining positioning and scaling functions for the rows headers
    # ------------------------------------------------------------------------------------------------------------------
    initRowsHeaderContainer: (mainGContainer) ->

      thisView = @

      rowsHeaderG = mainGContainer.append('g')
        .attr(@BASE_X_TRANS_ATT, 0)
        .attr(@BASE_Y_TRANS_ATT, @COLS_HEADER_HEIGHT)
        .attr(@MOVE_X_ATT, @NO)
        .attr(@MOVE_Y_ATT, @YES)

      rowsHeaderG.append('rect')
        .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
        .classed('background-rect', true)

      rowHeadersEnter = @updateRowsHeadersForWindow(rowsHeaderG)

      rowsHeaderG.positionRows = (zoomScale, transitionDuration=0 ) ->

        t = rowsHeaderG.transition().duration(transitionDuration)
        t.selectAll('.vis-row')
          .attr('transform', (d) -> "translate(0, " + (thisView.getYCoord(d.currentPosition) * zoomScale) + ")")

      rowsHeaderG.scaleSizes = (zoomScale) ->

        rowsHeaderG.select('.background-rect')
          .attr('height', (thisView.ROWS_HEADER_HEIGHT * zoomScale))
          .attr('width', (thisView.ROWS_HEADER_WIDTH * zoomScale))

        rowsHeaderG.positionRows(zoomScale)

        rowsHeaderG.selectAll('.headers-background-rect')
          .attr('height', (thisView.getYCoord.rangeBand() * zoomScale))
          .attr('width', (thisView.ROWS_HEADER_WIDTH * zoomScale))

        rowsHeaderG.selectAll('.headers-text')
          .attr('x', (thisView.LABELS_PADDING * zoomScale))
          .attr("y", (thisView.getYCoord.rangeBand() * (2/3) * zoomScale) )
          .attr('style', 'font-size:' + (thisView.BASE_LABELS_SIZE * zoomScale ) + 'px;')

      @applyZoomAndTranslation(rowsHeaderG)
      @setAllHeadersEllipsis(rowHeadersEnter, isCol=false)
      @initRowHeadersEvents()

      return rowsHeaderG

    # ------------------------------------------------------------------------------------------------------------------
    # update rows headers according to window
    # ------------------------------------------------------------------------------------------------------------------
    updateRowsHeadersForWindow: (rowsHeaderG, stateChanged=false) ->

      console.log 'updateRowsHeadersForWindow'
      thisView = @
      rowsInWindow = @ROWS_IN_WINDOW
      for rowObj in rowsInWindow
        if rowObj.load_state == glados.models.Heatmap.ITEM_LOAD_STATES.LOADED
          thisView.model.getRowHeaderLink(rowObj.id)

      rowHeaders = rowsHeaderG.selectAll('.vis-row')
        .data(rowsInWindow, (d) -> d.id)

      rowHeaders.exit().remove()
      rowHeadersEnter = rowHeaders.enter()
        .append('g').attr('class', 'vis-row')

      if stateChanged
        rowHeadersToUpdate = rowHeaders
      else
        rowHeadersToUpdate = rowHeadersEnter

      rowHeadersToUpdate.append('rect')
        .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
        .style('stroke-width', @GRID_STROKE_WIDTH)
        .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .classed('headers-background-rect', true)

#      if @config.rows_entity_name == 'Compounds'
#        setUpRowTooltip = @generateTooltipFunction('Compound', @, isCol=false)
#      else
#        setUpRowTooltip = @generateTooltipFunction('Target', @, isCol=false)

      rowHeadersToUpdate.append('text')
        .classed('headers-text', true)
        .each((d)-> thisView.fillHeaderText(d3.select(@), isCol=false))
        .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
#        .on('mouseover', setUpRowTooltip)
        .attr('id', (d) -> thisView.ROW_HEADER_TEXT_BASE_ID + d.id)
#        .on('click', thisView.handleRowHeaderClick)

      return rowHeadersToUpdate
