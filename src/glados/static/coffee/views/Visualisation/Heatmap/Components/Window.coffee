glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  Window:

    unsetWindow: ->

      @PREVIOUS_WINDOW = null
      @WINDOW = null
      @COLS_IN_WINDOW = null
      @ROWS_IN_WINDOW = null
      @CELLS_IN_WINDOW = null


    # Diagram: https://drive.google.com/file/d/0BzECtlZ_ur1CVkRJc2ZZcE1ncnM/view?usp=sharing
    calculateCurrentWindow: (zoomScale=1, translateX=0, translateY=0, forceSectionsUpdate=false) ->

      console.log 'CALCULATE CURRENT WINDOW'
      C = -@COLS_HEADER_HEIGHT - @COLS_FOOTER_HEIGHT
      E2 = @VISUALISATION_HEIGHT + (C * zoomScale)
      D = -@ROWS_HEADER_WIDTH - @ROWS_FOOTER_WIDTH
      E3 = @VISUALISATION_WIDTH + (D * zoomScale)

      winX = -translateX * zoomScale
      winX = if winX < 0 then 0 else winX
      winY = -translateY * zoomScale
      winY = if winY < 0 then 0 else winY
      winW = E3
      winH = E2

      #https://drive.google.com/file/d/0BzECtlZ_ur1CMjNkbExYQU5BMW8/view?usp=sharing
      minRowNum = Math.floor(winY / (@SIDE_SIZE * zoomScale))
      maxRowNum = Math.floor((winH + winY) / (@SIDE_SIZE * zoomScale))
      minColNum = Math.floor(winX / (@SIDE_SIZE * zoomScale))
      maxColNum = Math.floor((winW + winX) / (@SIDE_SIZE * zoomScale))

      windowChanged = false
      if not @PREVIOUS_WINDOW?
        windowChanged = true
      else if @PREVIOUS_WINDOW.min_row_num != minRowNum
        windowChanged = true
      else if @PREVIOUS_WINDOW.max_row_num != maxRowNum
        windowChanged = true
      else if @PREVIOUS_WINDOW.min_col_num != minColNum
        windowChanged = true
      else if @PREVIOUS_WINDOW.max_col_num != maxColNum
        windowChanged = true

      @WINDOW =
        win_x: winX
        win_y: winY
        win_W: winW
        win_H: winH
        min_row_num: minRowNum
        max_row_num: maxRowNum
        min_col_num: minColNum
        max_col_num: maxColNum
        window_changed: windowChanged

      @PREVIOUS_WINDOW = @WINDOW

      windowIsUndefined = not @COLS_IN_WINDOW? and not @ROWS_IN_WINDOW? and not @CELLS_IN_WINDOW?

      if @WINDOW.window_changed or forceSectionsUpdate or windowIsUndefined
        @COLS_IN_WINDOW = @getColsInWindow()
        @ROWS_IN_WINDOW = @getRowsInWindow()
        @CELLS_IN_WINDOW = @getCellsInWindow()
        @informWindowLimitsIfTouchingBorder()

    getColsInWindow: ->

      minColNum = @WINDOW.min_col_num
      maxColNum = @WINDOW.max_col_num
      colsList = @model.get('matrix').columns
      if colsList.length == 0
        return []
      else
        end = if maxColNum >= colsList.length then colsList.length - 1 else maxColNum - 1
        start = if minColNum >= colsList.length then end - 1 else minColNum
        return colsList[start..end]

      return (colsIndex[i] for i in [start..end])

    getRowsInWindow: ->

      minRowNum = @WINDOW.min_row_num
      maxRowNum = @WINDOW.max_row_num
      rowsList = @model.get('matrix').rows
      if rowsList.length == 0
        return []
      else
        end = if maxRowNum >= rowsList.length then rowsList.length - 1 else maxRowNum - 1
        start = if minRowNum >= rowsList.length then end - 1 else minRowNum
        return rowsList[start..end]

    getCellsInWindow: ->

      return []
      rowsInWindow = @ROWS_IN_WINDOW
      colsInWindow = @COLS_IN_WINDOW

      links = @model.get('matrix').links

      cellsInWindow = []
      for row in rowsInWindow
        rowOIndex = row.originalIndex

        rowContent = links[rowOIndex]
        if not rowContent?
          continue

        for col in colsInWindow
          colOIndex = col.originalIndex

          cellObj = rowContent[colOIndex]
          if cellObj?
            cellsInWindow.push cellObj

      return cellsInWindow

    # ------------------------------------------------------------------------------------------------------------------
    # Events binding
    # ------------------------------------------------------------------------------------------------------------------
    initWindowUpdateEvents: ->

      thisView = @
      @model.on(glados.models.Heatmap.EVENTS.VISUAL_WINDOW.ITEMS_STATE_UPDATED, ->
        console.log 'CCC REACTING TO EVENT'
        thisView.handleZoom(ignoreActivation=true, forceSectionsUpdate=true, stateChanged=true)
      )

    # ------------------------------------------------------------------------------------------------------------------
    # Communication with model
    # ------------------------------------------------------------------------------------------------------------------
    informVisualWindowLimitsToModel: ->

      console.log 'BBB informVisualWindowLimitsToModel '
      console.log @WINDOW

      minItemX = @WINDOW.min_col_num + 1
      maxItemX = @WINDOW.max_col_num + 1
      minItemY = @WINDOW.min_row_num + 1
      maxItemY = @WINDOW.max_row_num + 1
      @model.informVisualWindowLimits(glados.models.Heatmap.AXES_NAMES.X_AXIS, minItemX, maxItemX)
      @model.informVisualWindowLimits(glados.models.Heatmap.AXES_NAMES.Y_AXIS, minItemY, maxItemY)

    # informs the window limits only if the visual window is touching the current frontiers
    informWindowLimitsIfTouchingBorder: ->

      console.log 'BBB informWindowLimitsIfTouchingBorder '
      console.log @WINDOW

      minItemX = @WINDOW.min_col_num + 1
      maxItemX = @WINDOW.max_col_num + 1
      minItemY = @WINDOW.min_row_num + 1
      maxItemY = @WINDOW.max_row_num + 1

      loadWindowStruct = @model.get('load_window_struct')
      console.log 'loadWindowStruct: ', loadWindowStruct
      minStartX = loadWindowStruct[glados.models.Heatmap.AXES_PROPERTY_NAMES.X_AXIS].min_start
      touchingLeft = (not minStartX?) or (1 < minItemX <= minStartX)
      console.log 'BBB minItemX: ', minItemX
      console.log 'BBB minStartX: ', minStartX
      console.log 'BBB touchingLeft: ', touchingLeft
      maxEndX = loadWindowStruct[glados.models.Heatmap.AXES_PROPERTY_NAMES.X_AXIS].max_end
      touchingRight = (not maxEndX?) or (maxEndX < maxItemX <= @NUM_COLUMNS )
      console.log 'BBB maxItemX: ', maxItemX
      console.log 'BBB maxEndX: ', maxEndX
      console.log 'BBB touchingRight: ', touchingRight
      minStartY = loadWindowStruct[glados.models.Heatmap.AXES_PROPERTY_NAMES.Y_AXIS].min_start
      touchingTop = (not minStartY?) or (1 < minItemY <= minStartY)
      console.log 'BBB minItemY: ', minItemY
      console.log 'BBB minStartY: ', minStartY
      console.log 'BBB touchingTop: ', touchingTop
      maxEndY = loadWindowStruct[glados.models.Heatmap.AXES_PROPERTY_NAMES.Y_AXIS].max_end
      touchingBottom = (not maxEndY?) or (maxEndY < maxItemY <= @NUM_ROWS)
      console.log 'BBB maxItemY: ', maxItemY
      console.log 'BBB maxEndY: ', maxEndY
      console.log 'BBB touchingBottom: ', touchingBottom

      touchingBorder = touchingLeft or touchingRight or touchingTop or touchingBottom
      if touchingBorder
        console.log 'BBB touching border!!!'
        console.log 'BBB loadWindowStruct', loadWindowStruct
        @informVisualWindowLimitsToModel()


