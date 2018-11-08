glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  ZoomAndTranslation:

    initZoom: (mainGContainer) ->

      @ZOOM_STEP = 0.1
      @zoom = d3.behavior.zoom()
        .scaleExtent([@MIN_ZOOM, @MAX_ZOOM])
        .on("zoom", @handleZoom.bind(@))
        .on('zoomstart', @handleZoomStart.bind(@))
        .on('zoomend', @handleZoomEnd.bind(@))
        .scale(@zoomScale)
        .translate([0, 0])

      mainGContainer.call @zoom

    #-------------------------------------------------------------------------------------------------------------------
    # Initial Zoom Calculation
    #-------------------------------------------------------------------------------------------------------------------
    # Diagrams:
    # https://drive.google.com/file/d/0BzECtlZ_ur1Ca0M4UllLdmNlMkU/view?usp=sharing
    # https://drive.google.com/file/d/0BzECtlZ_ur1Cc0JoWkpVSWtKWGc/view?usp=sharing
    # Calculator:
    # https://docs.google.com/spreadsheets/d/1vg6JNcZcwo4uwR0zj3iWm8d-8jJaw4AVEZSeP7wZBO4/edit?usp=sharing
    calculateInitialZoom: (numColumns, numRows) ->

      baseMatrixWidth = @SIDE_SIZE * numColumns
      baseMatrixHeight = @SIDE_SIZE * numRows

      zoom = 0
      zoomIsAcceptable = true
      zoomIncrement = 0.05

      while (zoomIsAcceptable)

        newZoom = zoom + zoomIncrement

        B = -@ROWS_HEADER_WIDTH - baseMatrixWidth - @ROWS_FOOTER_WIDTH
        E1 = @VISUALISATION_WIDTH + (B * newZoom)
        C = -@COLS_HEADER_HEIGHT - @COLS_FOOTER_HEIGHT
        E2 = @VISUALISATION_HEIGHT + (C * newZoom)
        D = -@ROWS_HEADER_WIDTH - @ROWS_FOOTER_WIDTH
        E3 = @VISUALISATION_WIDTH + (D * newZoom)
        E = -@COLS_FOOTER_HEIGHT - baseMatrixHeight - @COLS_HEADER_HEIGHT
        E4 = @VISUALISATION_HEIGHT + (E * newZoom)

        A1 = E1 * (E2 - E4)
        A2 = E4 * E3
        A = A1 + A2
        zoomIsAcceptable = A1 > 0 and A2 > 0
        if zoomIsAcceptable
          zoom += zoomIncrement

      return zoom

    #-------------------------------------------------------------------------------------------------------------------
    # Zoom and translation Handling
    #-------------------------------------------------------------------------------------------------------------------
    applyZoomAndTranslation: (elem, translateX=0, translateY=0, zoomScale=1) ->

      elem.scaleSizes(zoomScale) unless not elem.scaleSizes?

      moveX = elem.attr(@MOVE_X_ATT)
      moveY = elem.attr(@MOVE_Y_ATT)
      translateX = 0 if moveX == @NO
      translateY = 0 if moveY == @NO
      fixedToLeft = elem.attr(@FIXED_TO_LEFT_ATT) == @YES
      fixedToBottom = elem.attr(@FIXED_TO_BOTTOM_ATT) == @YES

      if fixedToLeft
        baseWidth = elem.attr(@BASE_WIDTH_ATT)
        newTransX = @VISUALISATION_WIDTH - (baseWidth * zoomScale)
      else
        newTransX = (parseFloat(elem.attr(@BASE_X_TRANS_ATT)) + translateX) * zoomScale

      if fixedToBottom
        baseHeight = elem.attr(@BASE_HEIGHT_ATT)
        newTransY = @VISUALISATION_HEIGHT - (baseHeight * zoomScale)
      else
        newTransY = (parseFloat(elem.attr(@BASE_Y_TRANS_ATT)) + translateY) * zoomScale


      elem.attr('transform', 'translate(' + newTransX + ',' + newTransY + ')')

    handleZoomStart: ->

        if not @ZOOM_ACTIVATED
          return

#        @cellsContainerG.classed('grabbing', true)

    handleZoomEnd: ->

      if not @ZOOM_ACTIVATED
        return

#      @cellsContainerG.classed('grabbing', false)

    handleZoom: (ingoreActivation=false, forceSectionsUpdate=false, stateChanged=false) ->

      if not @ZOOM_ACTIVATED and not ingoreActivation
        return

      @destroyAllTooltips()
      @translateX = @zoom.translate()[0]
      @translateY = @zoom.translate()[1]
      @zoomScale = @zoom.scale()
      @calculateCurrentWindow(@zoomScale, @translateX, @translateY, forceSectionsUpdate)
      if @WINDOW.window_changed or forceSectionsUpdate
        console.log 'WINDOW CHANGED!!!'
        colsHeadersEnter = @updateColsHeadersForWindow(@colsHeaderG, stateChanged)
        @updateColsFootersForWindow(@colsFooterG, stateChanged)
        @colsFooterG.assignTexts()
        rowHeadersEnter = @updateRowsHeadersForWindow(@rowsHeaderG)
        @updateRowsFootersForWindow(@rowsFooterG)
        @rowsFooterG.assignTexts()
#        @updateCellsForWindow(@cellsContainerG)
#        @colourCells()

      console.log 'handle zoom'
      console.log 'translateX: ', @translateX
      console.log 'translateY: ', @translateY
      console.log @zoomScale

      @applyZoomAndTranslation(@corner1G, @translateX, @translateY, @zoomScale)
      @applyZoomAndTranslation(@colsHeaderG, @translateX, @translateY, @zoomScale)
      @applyZoomAndTranslation(@corner2G, @translateX, @translateY, @zoomScale)
      @applyZoomAndTranslation(@rowsHeaderG, @translateX, @translateY, @zoomScale)
#      @applyZoomAndTranslation(@cellsContainerG, @translateX, @translateY, @zoomScale)
      @applyZoomAndTranslation(@rowsFooterG, @translateX, @translateY, @zoomScale)
      @applyZoomAndTranslation(@corner3G, @translateX, @translateY, @zoomScale)
      @applyZoomAndTranslation(@colsFooterG, @translateX, @translateY, @zoomScale)
      @applyZoomAndTranslation(@corner4G, @translateX, @translateY, @zoomScale)

      # after adding elems to window, I need to check again for ellipsis
      if @WINDOW.window_changed or forceSectionsUpdate
        @setAllHeadersEllipsis(rowHeadersEnter, isCol=false)
        @setAllHeadersEllipsis(colsHeadersEnter, isCol=true)

      $zoomOutBtn = $(@el).find(".BCK-zoom-out-btn")
      if @zoomScale <= @MIN_ZOOM
        $zoomOutBtn.addClass('disabled')
      else
        $zoomOutBtn.removeClass('disabled')

      $zoomInBtn = $(@el).find(".BCK-zoom-in-btn")
      if @zoomScale >= @MAX_ZOOM
        $zoomInBtn.addClass('disabled')
      else
        $zoomInBtn.removeClass('disabled')

    resetZoom: ->

      console.log 'reseting zoom'
      console.log 'INITIAL_ZOOM:', @INITIAL_ZOOM
      @zoom.scale(@INITIAL_ZOOM)
      @zoom.translate([0, 0])
      @handleZoom(ingoreActivation=true, forceSectionsUpdate=true, stateChanged=true)



