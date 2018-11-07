glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  ColsHeaderContainer:

    initColsHeadersEvents: ->

      thisView = @
      @model.on(glados.models.Heatmap.EVENTS.VISUAL_WINDOW.COLS_HEADERS_UPDATED, ->

        if thisView.colsHeaderG?
          thisView.updateColsHeadersForWindow(thisView.colsHeaderG, stateChanged=true)
          thisView.handleZoom(ignoreActivation=true)

      )

    # ------------------------------------------------------------------------------------------------------------------
    # defining positioning and scaling functions for the cols headers
    # ------------------------------------------------------------------------------------------------------------------
    initColsHeaderContainer: (mainGContainer) ->

      thisView = @
      colsHeaderG = mainGContainer.append('g')
        .attr(@BASE_X_TRANS_ATT, @ROWS_HEADER_WIDTH)
        .attr(@BASE_Y_TRANS_ATT, 0)
        .attr(@MOVE_X_ATT, @YES)
        .attr(@MOVE_Y_ATT, @NO)
        .classed('BCK-ColsHeaderG', true)

      colsHeaderG.append('rect')
        .attr('height', @COLS_HEADER_HEIGHT)
        .attr('width', @RANGE_X_END)
        .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
        .classed('background-rect', true)

      colsHeadersEnter = @updateColsHeadersForWindow(colsHeaderG)

      colsHeaderG.positionCols = (zoomScale, transitionDuration=0) ->

        t = colsHeaderG.transition().duration(transitionDuration)
        t.selectAll('.vis-column')
          .attr("transform", ((d) -> "translate(" + (thisView.getXCoord(d.currentPosition) * zoomScale) +
          ")rotate(" + thisView.COLS_LABELS_ROTATION + " " + (thisView.getXCoord.rangeBand() * zoomScale) +
          " " + (thisView.COLS_HEADER_HEIGHT * zoomScale) + ")" ))

      colsHeaderG.scaleSizes = (zoomScale) ->

        colsHeaderG.select('.background-rect')
          .attr('height', thisView.COLS_HEADER_HEIGHT * zoomScale)
          .attr('width', thisView.COLS_HEADER_WIDTH * zoomScale)

        colsHeaderG.positionCols(zoomScale)

        colsHeaderG.selectAll('.headers-background-rect')
          .attr('height', (thisView.COLS_HEADER_HEIGHT * zoomScale) )
          .attr('width', (thisView.getXCoord.rangeBand() * zoomScale))

        colsHeaderG.selectAll('.headers-divisory-line')
          .attr('x1', (thisView.getXCoord.rangeBand() * zoomScale))
          .attr('y1', (thisView.COLS_HEADER_HEIGHT * zoomScale))
          .attr('x2', (thisView.getXCoord.rangeBand() * zoomScale))
          .attr('y2', 0)

        colsHeaderG.selectAll('.headers-text')
          .attr("y", (thisView.getXCoord.rangeBand() * (2/3) * zoomScale ) )
          .attr('x', (-thisView.COLS_HEADER_HEIGHT * zoomScale))
          .attr('style', 'font-size:' + (thisView.BASE_LABELS_SIZE * zoomScale) + 'px;')


      @applyZoomAndTranslation(colsHeaderG)
      @setAllHeadersEllipsis(colsHeadersEnter, isCol=true)
      @initColsHeadersEvents()

      return colsHeaderG

    # ------------------------------------------------------------------------------------------------------------------
    # update cols headers according to window
    # ------------------------------------------------------------------------------------------------------------------
    updateColsHeadersForWindow: (colsHeaderG, stateChanged=false) ->

      thisView = @
      colsInWindow = @COLS_IN_WINDOW

      for colObj in colsInWindow
        if colObj.load_state == glados.models.Heatmap.ITEM_LOAD_STATES.LOADED
          thisView.model.getColHeaderLink(colObj.id)

      if stateChanged
        colsHeaders = colsHeaderG.selectAll(".vis-column")
        .data([])
        colsHeaders.exit().remove()

      colsHeaders = colsHeaderG.selectAll(".vis-column")
        .data(colsInWindow, (d) -> d.id)

      colsHeadersExit = colsHeaders.exit()
      colsHeadersExit.remove()
      colsHeadersEnter = colsHeaders.enter()
        .append("g")
        .classed('vis-column', true)

      if stateChanged
        colsHeadersToUpdate = colsHeaders
      else
        colsHeadersToUpdate = colsHeadersEnter

      colsHeadersToUpdate.append('rect')
        .style('fill', 'none')
        .style('fill-opacity', 0.5)
        .classed('headers-background-rect', true)

      colsHeadersToUpdate.append('line')
        .style('stroke-width', @GRID_STROKE_WIDTH)
        .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .classed('headers-divisory-line', true)

#      if @config.cols_entity_name == 'Targets'
#        setUpColTooltip = @generateTooltipFunction('Target', @, isCol=true)
#      else
#        setUpColTooltip = @generateTooltipFunction('Compound', @, isCol=true)

      colsHeadersToUpdate.append('text')
        .classed('headers-text', true)
        .attr('transform', 'rotate(-90)')
        .attr('text-decoration', 'underline')
        .attr('cursor', 'pointer')
        .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
#        .on('mouseover', setUpColTooltip)
        .each((d)-> thisView.fillHeaderText(d3.select(@)))
        .attr('id', (d) -> thisView.COL_HEADER_TEXT_BASE_ID + d.id)
#        .on('click', thisView.handleColHeaderClick)

      return colsHeadersToUpdate