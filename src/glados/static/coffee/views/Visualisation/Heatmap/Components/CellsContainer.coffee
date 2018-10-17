glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  CellsContainer:

    # ------------------------------------------------------------------------------------------------------------------
    # defining positioning and scaling functions to the cells
    # ------------------------------------------------------------------------------------------------------------------
    initCellsContainer: (mainGContainer, matrix)->

      thisView = @

      cellsContainerG = mainGContainer.append('g')
        .attr('data-section-name', 'cellsContainerG')
        .attr(@BASE_X_TRANS_ATT, @ROWS_HEADER_WIDTH)
        .attr(@BASE_Y_TRANS_ATT, @COLS_HEADER_HEIGHT)
        .attr(@MOVE_X_ATT, @YES)
        .attr(@MOVE_Y_ATT, @YES)
        .classed('cells-container-g', true)

      cellsContainerG.append('rect')
        .style("fill", glados.Settings.VIS_COLORS.WHITE)
        .classed('background-rect', true)

      @updateCellsForWindow(cellsContainerG)

      cellsContainerG.positionRows = (zoomScale, transitionDuration=0 ) ->

        if transitionDuration == 0
          cellsContainerG.selectAll(".vis-cell")
            .attr("y", (d) ->
              (thisView.getYCoord(matrix.rows_index[d.row_id].currentPosition) + thisView.CELLS_PADDING) * zoomScale
            )
        else
          t = cellsContainerG.transition().duration(transitionDuration)
          t.selectAll(".vis-cell")
            .attr("y", (d) -> (thisView.getYCoord(matrix.rows_index[d.row_id].currentPosition) + thisView.CELLS_PADDING) * zoomScale)

      cellsContainerG.positionCols = (zoomScale, transitionDuration=0 ) ->

        if transitionDuration == 0
          cellsContainerG.selectAll(".vis-cell")
          .attr("x", (d) -> (thisView.getXCoord(matrix.columns_index[d.col_id].currentPosition) + thisView.CELLS_PADDING) * zoomScale)
        else
          t = cellsContainerG.transition().duration(transitionDuration)
          t.selectAll(".vis-cell")
            .attr("x", (d) -> (thisView.getXCoord(matrix.columns_index[d.col_id].currentPosition) + thisView.CELLS_PADDING) * zoomScale)

      cellsContainerG.scaleSizes = (zoomScale) ->

        cellsContainerG.select('.background-rect')
          .attr('height', (thisView.ROWS_HEADER_HEIGHT * zoomScale))
          .attr('width', (thisView.COLS_HEADER_WIDTH * zoomScale))

        cellsContainerG.selectAll('.grid-horizontal-line')
          .attr("x1", -> (thisView.getXCoord(thisView.WINDOW.min_col_num) * zoomScale))
          .attr("y1", (d) -> (thisView.getYCoord(d + thisView.WINDOW.min_row_num) * zoomScale))
          .attr("y2", (d) -> (thisView.getYCoord(d + thisView.WINDOW.min_row_num) * zoomScale) )
          .attr("x2", (thisView.COLS_HEADER_WIDTH * zoomScale))

        cellsContainerG.selectAll('.grid-vertical-line')
          .attr("x1", (d) -> (thisView.getXCoord(d + thisView.WINDOW.min_col_num) * zoomScale))
          .attr("y1", -> (thisView.getXCoord(thisView.WINDOW.min_row_num) * zoomScale))
          .attr("x2", (d) -> (thisView.getXCoord(d + thisView.WINDOW.min_col_num) * zoomScale))
          .attr("y2", (thisView.ROWS_HEADER_HEIGHT * zoomScale))

        cellsContainerG.positionRows(zoomScale)
        cellsContainerG.positionCols(zoomScale)

        cellsContainerG.selectAll(".vis-cell")
          .attr("width", (thisView.getXCoord.rangeBand() - 2 * thisView.CELLS_PADDING) * zoomScale)
          .attr("height", (thisView.getYCoord.rangeBand() - 2 * thisView.CELLS_PADDING) * zoomScale)

      @applyZoomAndTranslation(cellsContainerG)
      @colourCells()
      return cellsContainerG
    # ------------------------------------------------------------------------------------------------------------------
    # cell colouring
    # ------------------------------------------------------------------------------------------------------------------
    fillColour: (d) ->

      propValue = d[@currentPropertyColour.propName]

      if not propValue?

        return glados.Settings.VISUALISATION_GRID_NO_DATA

      @getCellColour(d[@currentPropertyColour.propName])

    colourCells: (transitionDuration=0)->

      cellsContainerG = @cellsContainerG
      if not @currentPropertyColour.colourScale?

        maxValCheatName = 'cell_max_' + @currentPropertyColour.propName
        minValCheatName = 'cell_min_' + @currentPropertyColour.propName
        maxValCheat = @model.get('matrix')[maxValCheatName]
        minValCheat = @model.get('matrix')[minValCheatName]

        if maxValCheat? and minValCheat?
          @currentPropertyColour.domain = [minValCheat, maxValCheat]

        if not @currentPropertyColour.domain?

          colourValues = @model.getValuesListForProperty(@currentPropertyColour.propName)
          glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(@currentPropertyColour,
            colourValues)

        glados.models.visualisation.PropertiesFactory.generateColourScale(@currentPropertyColour)

      @getCellColour = @currentPropertyColour.colourScale

      t = cellsContainerG.transition().duration(transitionDuration)
      # Random colours for when they activate the easter egg
      gladosColour = (d, i) ->
        seed = glados.Utils.getRadiansFromDegrees(i)
        return  "#" + (Math.round(Math.abs(Math.sin(seed)) * 0xFFFFFF)).toString(16)

      if @GLADOS_SUMMONED
        t.selectAll(".vis-cell")
          .style("fill", gladosColour)
      else
        t.selectAll(".vis-cell")
          .style("fill", @fillColour.bind(@))

      @$legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
      glados.Utils.renderLegendForProperty(@currentPropertyColour, undefined, @$legendContainer,
        enableSelection=false)

    # ------------------------------------------------------------------------------------------------------------------
    # update of cells according to window
    # ------------------------------------------------------------------------------------------------------------------
    updateCellsForWindow: (cellsContainerG) ->

      thisView = @
      cellsInWindow = @CELLS_IN_WINDOW
      rowsInWindow = @ROWS_IN_WINDOW
      colsInWindow = @COLS_IN_WINDOW

      # -------------------------------------------------------------------------------
      # horizontal rectangles
      # -------------------------------------------------------------------------------
      if rowsInWindow.length <= 1
        horizontalLinesData = []
      else
        horizontalLinesData = [1..rowsInWindow.length-1]

      horizontalLines = cellsContainerG.selectAll('.grid-horizontal-line')
        .data(horizontalLinesData)

      horizontalLines.exit().remove()
      horizontalLinesEnter = horizontalLines.enter()
        .append("line")
        .classed('grid-horizontal-line', true)
        .style("stroke", glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .style('stroke-width', @GRID_STROKE_WIDTH)

      # -------------------------------------------------------------------------------
      # Vertical Lines
      # -------------------------------------------------------------------------------
      if colsInWindow.length <= 1
        verticalLinesData = []
      else
        verticalLinesData = [1..colsInWindow.length-1]

      verticalLines = cellsContainerG.selectAll('.grid-vertical-line')
        .data(verticalLinesData)

      verticalLines.exit().remove()

      verticalLinesEnter = verticalLines.enter()
        .append("line")
        .classed('grid-vertical-line', true)
        .attr("stroke", glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .attr('stroke-width', @GRID_STROKE_WIDTH)
      # -------------------------------------------------------------------------------
      # Cells
      # -------------------------------------------------------------------------------
      cells = cellsContainerG.selectAll(".vis-cell")
        .data(cellsInWindow, (d) -> d.id)

      cells.exit().remove()
      cellsEnter = cells.enter()
        .append("rect")
        .classed('vis-cell', true)
        .attr('stroke-width', @GRID_STROKE_WIDTH)
        .on('mouseover', $.proxy(@emphasizeFromCellHover, @))
        .on('mouseout', $.proxy(@deEmphasizeFromCellHover, @))
        .on('click', (d) -> thisView.showCellTooltip($(@), d))

    #-------------------------------------------------------------------------------------------------------------------
    # Cell Hovering
    #-------------------------------------------------------------------------------------------------------------------
    emphasizeFromCellHover: (d) -> @applyEmphasisFromCellHover(d)

    deEmphasizeFromCellHover: (d) -> @applyEmphasisFromCellHover(d, false)

    applyEmphasisFromCellHover: (d, hasEmphasis=true) ->

      colHeaderTextElem = d3.select('#' + @COL_HEADER_TEXT_BASE_ID + d.col_id)
      colHeaderTextElem.classed('emphasis', hasEmphasis)

      rowHeaderTextElem = d3.select('#' + @ROW_HEADER_TEXT_BASE_ID + d.row_id)
      rowHeaderTextElem.classed('emphasis', hasEmphasis)

      colFooterTextElem = d3.select('#' + @COL_FOOTER_TEXT_BASE_ID + d.col_id)
      colFooterTextElem.classed('emphasis', hasEmphasis)

      rowFooterTextElem = d3.select('#' + @ROW_FOOTER_TEXT_BASE_ID + d.row_id)
      rowFooterTextElem.classed('emphasis', hasEmphasis)


