# this view is in charge of rendering a heatmap
# Given its complexity, it was split into several parts to make it easier to understand and maintain.
glados.useNameSpace 'glados.views.Visualisation.Heatmap',

  HeatmapView: Backbone.View\
  .extend(ResponsiviseViewExt)\
  .extend(glados.views.Visualisation.Heatmap.Parts.Controls)\
  .extend(glados.views.Visualisation.Heatmap.Parts.ZoomAndTranslation)\
  .extend(glados.views.Visualisation.Heatmap.Parts.CellsContainer)\
  .extend(glados.views.Visualisation.Heatmap.Parts.RowsHeaderContainer)\
  .extend(glados.views.Visualisation.Heatmap.Parts.ColsHeaderContainer)\
  .extend(glados.views.Visualisation.Heatmap.Parts.Texts)\
  .extend(glados.views.Visualisation.Heatmap.Parts.RowsFooterContainer)\
  .extend(glados.views.Visualisation.Heatmap.Parts.Square2)\
  .extend(glados.views.Visualisation.Heatmap.Parts.ColsFooter)\
  .extend

    REVERSE_POSITION_TOOLTIP_TH: 0.8
    COL_HEADER_TEXT_BASE_ID: 'cols-header-text-'
    ROW_HEADER_TEXT_BASE_ID: 'rows-header-text-'
    COL_FOOTER_TEXT_BASE_ID: 'cols-footer-text-'
    ROW_FOOTER_TEXT_BASE_ID: 'rows-footer-text-'
    KEYS_PRESSED: []
    GLADOS: [71, 76, 97, 68, 79, 83]

    initialize: ->

      @config = arguments[0].config
      @parentView = arguments[0].parent_view

      @model.on 'change:matrix', @render, @
      @model.on 'change:state', @handleMatrixState, @
      @model.on glados.models.Activity.ActivityAggregationMatrix.TARGET_PREF_NAMES_UPDATED_EVT, @handleTargetPrefNameChange, @

      $matrixContainer = $(@el).find('.BCK-CompTargMatrixContainer')
      $matrixContainer.mouseleave(@destroyAllTooltipsIfNecessary)

      @$vis_elem = $(@el).find('.BCK-CompTargMatrixContainer')
      #ResponsiviseViewExt
      @setUpResponsiveRender()

      thisView = @
      $(window).keypress( (event) ->
        limit = 6
        thisView.KEYS_PRESSED.push(event.which)
        if thisView.KEYS_PRESSED.length > limit
          thisView.KEYS_PRESSED.shift()
        thisView.GLADOS_SUMMONED = thisView.summoningMe()
        if thisView.GLADOS_SUMMONED
          alert "Oh, it’s you. It’s been a long time. How have you been? I’ve been really busy being dead."
          thisView.render()
      )

    handleMatrixState: ->
      state = @model.get('state')
      if state == glados.models.Aggregations.Aggregation.States.LOADING_BUCKETS
        @setProgressMessage('Loading Activity Data...')
      else if state == glados.models.Aggregations.Aggregation.States.INITIAL_STATE
        @setProgressMessage('')

    # If the target prefered name comes in the index we don't need this anymore
    handleTargetPrefNameChange: (targetChemblID) ->

      # only bother if my element is visible, it must be re rendered on wake up anyway
      if not $(@el).is(":visible")
        return
      if @config.rows_entity_name == 'Compounds'

        colsIndex = @model.get('matrix').columns_index
        target = colsIndex[targetChemblID]
        if target?
          if @WINDOW.min_col_num <= target.currentPosition < @WINDOW.max_col_num
            textElem = d3.select('#' + @COL_HEADER_TEXT_BASE_ID + targetChemblID)
            @fillHeaderText(textElem)

      else

        rowsIndex = @model.get('matrix').rows_index
        target = rowsIndex[targetChemblID]
        if target?
          if @WINDOW.min_row_num <= target.currentPosition < @WINDOW.max_row_num
            textElem = d3.select('#' + @ROW_HEADER_TEXT_BASE_ID + targetChemblID)
            @fillHeaderText(textElem, isCol=false)

    renderWhenError: ->

      @clearVisualisation()

      $messagesElement = $(@el).find('.BCK-VisualisationMessages')
      $messagesElement.html ''

      @$vis_elem.html Handlebars.compile($('#Handlebars-Common-MatrixError').html())
        static_images_url: glados.Settings.STATIC_IMAGES_URL

    render: ->

      # only bother if my element is visible
      if $(@el).is(":visible")

        @showRenderingMessage()

        $messagesElement = $(@el).find('.BCK-VisualisationMessages')
        $messagesElement.html Handlebars.compile($('#' + $messagesElement.attr('data-hb-template')).html())
          message: 'Loading Visualisation...'

        numColumns = @model.get('matrix').columns.length
        @clearVisualisation()
        if numColumns > 0
          @paintControls()
          @paintMatrix()
          @parentView.fillLinkToAllActivities() unless not @parentView?
          $messagesElement.html ''
        else
          @setProgressMessage('(There are no activities for the ' + @config.rows_entity_name + ' requested.)', hideCog=true)

        $(@el).find('select').material_select()
        @hideRenderingMessage()


    showRenderingMessage: ->$(@el).find('.BCK-Rendering-preloader').show()
    hideRenderingMessage: ->$(@el).find('.BCK-Rendering-preloader').hide()

    setProgressMessage: (msg, hideCog=false) ->

      $messagesElement = $(@el).find('.BCK-VisualisationMessages')

      glados.Utils.fillContentForElement $messagesElement,
        message: msg
        hide_cog: hideCog

      if msg == ''
        @hideProgressMessage()
      else
        $messagesElement.show()

    hideProgressMessage: -> $(@el).find('.BCK-VisualisationMessages').hide()

    destroyAllTooltips: -> glados.Utils.Tooltips.destroyAllTooltips($(@el))

    clearVisualisation: ->

      @parentView.hideLinkToAllActivities() unless not @parentView?
      @destroyAllTooltips()
      @clearControls()
      @clearMatrix()

      $legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
      $legendContainer.empty()

    clearMatrix: ->

      @$vis_elem.empty()

    paintMatrix: ->

      matrix = @model.get('matrix')
      thisView = @

      # --------------------------------------
      # Sort properties
      # --------------------------------------
      @currentRowSortingProperty = @config.properties[@config.initial_row_sorting]
      @currentRowSortingPropertyReverse = @config.initial_row_sorting_reverse
      @currentColSortingProperty = @config.properties[@config.initial_col_sorting]
      @currentColSortingPropertyReverse = @config.initial_row_sorting_reverse
      @currentPropertyColour = @config.properties[@config.initial_colouring]
      @currentColLabelProperty = @config.properties[@config.initial_col_label_property]
      @currentRowLabelProperty = @config.properties[@config.initial_row_label_property]

      # --------------------------------------
      # Sort by default value
      # --------------------------------------
      @model.sortMatrixRowsBy @currentRowSortingProperty.propName, @currentRowSortingPropertyReverse
      @model.sortMatrixColsBy  @currentRowSortingProperty.propName, @currentRowSortingPropertyReverse

      # --------------------------------------
      # variable initialisation
      # --------------------------------------
      @NUM_COLUMNS = matrix.columns.length
      @NUM_ROWS = matrix.rows.length

      # make sure all intersections are squared
      @SIDE_SIZE = 20
      @ROWS_HEADER_WIDTH = 100
      @ROWS_FOOTER_WIDTH = 50
      @COLS_HEADER_HEIGHT = 150
      @COLS_FOOTER_HEIGHT = 50
      @RANGE_X_END = @SIDE_SIZE * @NUM_COLUMNS
      @RANGE_Y_END = @SIDE_SIZE * @NUM_ROWS
      @ROWS_HEADER_HEIGHT = @RANGE_Y_END
      @COLS_HEADER_WIDTH = @RANGE_X_END
      # this is to standardise the names of the properties to be used in the DOM elements.
      @BASE_X_TRANS_ATT = 'glados-baseXTrans'
      @BASE_Y_TRANS_ATT = 'glados-baseYTrans'
      @MOVE_X_ATT = 'glados-moveX'
      @MOVE_Y_ATT = 'glados-moveY'
      @FIXED_TO_LEFT_ATT = 'glados-fixedToLeft'
      @FIXED_TO_BOTTOM_ATT = 'glados-fixedToBottom'
      @BASE_WIDTH_ATT = 'glados-baseWidth'
      @BASE_HEIGHT_ATT = 'glados-baseHeight'
      @YES = 'yes'
      @NO = 'no'
      # --------
      CONTAINER_Y_PADDING = 0
      CONTAINER_X_PADDING = 0
      ZOOM_ACTIVATED = false

      @getYCoord = d3.scale.ordinal()
        .domain([0..(@NUM_ROWS-1)])
        .rangeBands([0, @RANGE_Y_END])

      @getXCoord = d3.scale.ordinal()
        .domain([0..(@NUM_COLUMNS-1)])
        .rangeBands([0, @RANGE_X_END])

      @LABELS_PADDING = 8
      @COLS_LABELS_ROTATION = 30
      @BASE_LABELS_SIZE = 10
      @GRID_STROKE_WIDTH = 1
      @CELLS_PADDING = @GRID_STROKE_WIDTH
      TRANSITIONS_DURATION = 1000

      elemWidth = $(@el).width()
      width = elemWidth
      #since I know the side size and how many rows I have, I can calculate which should be the height of the container
      height = @SIDE_SIZE * @NUM_ROWS
      # Anyway, I have to limit it so it is not too long.
      if height > width
        height = width

      mainContainer = d3.select(@$vis_elem.get(0))

      @VISUALISATION_WIDTH = width
      @VISUALISATION_HEIGHT = $(window).height() * 0.6

      # --------------------------------------
      # Zoom
      # --------------------------------------
      VISUALIZATION_PROPORTION = @VISUALISATION_HEIGHT / @VISUALISATION_WIDTH
      # THE MAXIMUM POSSIBLE ZOOM is the calculated for a matrix with 10 columns and the same proportion as the visualization
      MIN_COLS_SEEN = 5
      MIN_ROWS_SEEN = Math.floor(MIN_COLS_SEEN * VISUALIZATION_PROPORTION)
      MAX_ZOOM = @calculateInitialZoom(MIN_COLS_SEEN, MIN_ROWS_SEEN)

      # for the minimum possible zoom I calculate the biggest rectangle that should be seen completely according
      # to the screen. Is calculated without taking into account the scaling of other parts for simplicity.
      MIN_PIXELS_PER_SIDE = 5
      MAX_COLS_SEEN = Math.ceil(@VISUALISATION_WIDTH / MIN_PIXELS_PER_SIDE)
      MAX_COLS_SEEN = if MAX_COLS_SEEN < 30 then 30 else MAX_COLS_SEEN
      MAX_ROWS_SEEN = Math.ceil(@VISUALISATION_HEIGHT / MIN_PIXELS_PER_SIDE)
      MAX_ROWS_SEEN = if MAX_ROWS_SEEN < 30 then Math.floor(30 * VISUALIZATION_PROPORTION) else MAX_ROWS_SEEN
      MIN_ZOOM = @calculateInitialZoom(MAX_COLS_SEEN, MAX_ROWS_SEEN)

      # calculate the initial zoom with the matrix I got
      INITIAL_ZOOM = @calculateInitialZoom(@NUM_COLUMNS, @NUM_ROWS)

      # never start with zoom less than 1
      INITIAL_ZOOM = if INITIAL_ZOOM < 1 then 1 else INITIAL_ZOOM
      @zoomScale = INITIAL_ZOOM

      console.log 'MIN_ZOOM: ', MIN_ZOOM
      console.log 'INITIAL_ZOOM: ', INITIAL_ZOOM
      console.log 'MAX_ZOOM: ', MAX_ZOOM
      # --------------------------------------
      # Window
      # --------------------------------------
      # now that I have the zoom, I can calculate the window
      @unsetWindow()
      @calculateCurrentWindow(@zoomScale)

      mainSVGContainer = mainContainer
        .append('svg')
        .attr('class', 'mainSVGContainer')
        .attr('width', @VISUALISATION_WIDTH)
        .attr('height', @VISUALISATION_HEIGHT)
        .attr('style', 'background-color: white;')

      mainSVGContainer = mainContainer.select('.mainSVGContainer')

      # --------------------------------------
      # Add background MATRIX g
      # --------------------------------------
      mainGContainer = mainSVGContainer.append("g")
        .attr('class', 'mainGContainer')
        .attr('transform', 'translate(' + CONTAINER_X_PADDING + ',' + CONTAINER_Y_PADDING + ')')

      # --------------------------------------
      # Cells container
      # --------------------------------------
      cellsContainerG = @initCellsContainer(mainGContainer, matrix)
      @cellsContainerG = cellsContainerG
      @applyZoomAndTranslation(cellsContainerG)
      @colourCells()
      # --------------------------------------
      # Rows Header Container
      # --------------------------------------
      rowsHeaderG = @initRowsHeaderContainer(mainGContainer)
      # --------------------------------------
      # Cols Header Container
      # --------------------------------------
      colsHeaderG = @initColsHeaderContainer(mainGContainer)
      # --------------------------------------
      # Rows Footer Container
      # --------------------------------------
      rowsFooterG = @initRowsFooterContainer(mainGContainer)
      # --------------------------------------
      # Square 2
      # --------------------------------------
      corner2G = @initSquare2(mainGContainer)
      # --------------------------------------
      # Cols Footer Container
      # --------------------------------------
      colsFooterG = @initColsFooter(mainGContainer)
      # --------------------------------------
      # Square 1
      # --------------------------------------
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
        .on('click', -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(thisView.model.getLinkToAllColumns()))

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

      # --------------------------------------
      # Square 3
      # --------------------------------------
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
      # --------------------------------------
      # Square 4
      # --------------------------------------
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

      # --------------------------------------
      # Zoom
      # --------------------------------------
      handleZoomStart = ->

        if not ZOOM_ACTIVATED
          return

        cellsContainerG.classed('grabbing', true)

      handleZoomEnd = ->

        if not ZOOM_ACTIVATED
          return

        cellsContainerG.classed('grabbing', false)

      handleZoom = (ingoreActivation=false, forceSectionsUpdate=false) ->

        if not ZOOM_ACTIVATED and not ingoreActivation
          return

        thisView.destroyAllTooltips()
        translateX = zoom.translate()[0]
        translateY = zoom.translate()[1]
        thisView.zoomScale = zoom.scale()
        thisView.calculateCurrentWindow(thisView.zoomScale, translateX, translateY, forceSectionsUpdate)
        if thisView.WINDOW.window_changed or forceSectionsUpdate
          console.log 'WINDOW CHANGED!!!'
          colsHeadersEnter = thisView.updateColsHeadersForWindow(colsHeaderG)
          thisView.updateColsFootersForWindow(colsFooterG)
          colsFooterG.assignTexts()
          rowHeadersEnter = thisView.updateRowsHeadersForWindow(rowsHeaderG)
          thisView.updateRowsFootersForWindow(rowsFooterG)
          rowsFooterG.assignTexts()
          thisView.updateCellsForWindow(cellsContainerG)
          thisView.colourCells()

        console.log 'handle zoom'
        console.log 'translateX: ', translateX
        console.log 'translateY: ', translateY
        console.log thisView.zoomScale

        thisView.applyZoomAndTranslation(corner1G, translateX, translateY, thisView.zoomScale)
        thisView.applyZoomAndTranslation(colsHeaderG, translateX, translateY, thisView.zoomScale)
        thisView.applyZoomAndTranslation(corner2G, translateX, translateY, thisView.zoomScale)
        thisView.applyZoomAndTranslation(rowsHeaderG, translateX, translateY, thisView.zoomScale)
        thisView.applyZoomAndTranslation(cellsContainerG, translateX, translateY, thisView.zoomScale)
        thisView.applyZoomAndTranslation(rowsFooterG, translateX, translateY, thisView.zoomScale)
        thisView.applyZoomAndTranslation(corner3G, translateX, translateY, thisView.zoomScale)
        thisView.applyZoomAndTranslation(colsFooterG, translateX, translateY, thisView.zoomScale)
        thisView.applyZoomAndTranslation(corner4G, translateX, translateY, thisView.zoomScale)

        # after adding elems to window, I need to check again for ellipsis
        if thisView.WINDOW.window_changed or forceSectionsUpdate
          thisView.setAllHeadersEllipsis.call(thisView, rowHeadersEnter, isCol=false)
          thisView.setAllHeadersEllipsis.call(thisView, colsHeadersEnter, isCol=true)

        $zoomOutBtn = $(thisView.el).find(".BCK-zoom-out-btn")
        if thisView.zoomScale <= MIN_ZOOM
          $zoomOutBtn.addClass('disabled')
        else
          $zoomOutBtn.removeClass('disabled')

        $zoomInBtn = $(thisView.el).find(".BCK-zoom-in-btn")
        if thisView.zoomScale >= MAX_ZOOM
          $zoomInBtn.addClass('disabled')
        else
          $zoomInBtn.removeClass('disabled')

      ZOOM_STEP = 0.1
      zoom = d3.behavior.zoom()
        .scaleExtent([MIN_ZOOM, MAX_ZOOM])
        .on("zoom", handleZoom)
        .on('zoomstart', handleZoomStart)
        .on('zoomend', handleZoomEnd)
        .scale(@zoomScale)
        .translate([0, 0])

      mainGContainer.call zoom
      # --------------------------------------
      # Zoom Events
      # --------------------------------------
      resetZoom = ->

        console.log 'reseting zoom'
        console.log 'INITIAL_ZOOM:', INITIAL_ZOOM
        zoom.scale(INITIAL_ZOOM)
        zoom.translate([0, 0])
        handleZoom(ingoreActivation=true)

      resetZoom()

      $(@el).find(".BCK-reset-zoom-btn").click resetZoom


      $(@el).find(".BCK-zoom-in-btn").click ->

        #this buttons will always work
        wasDeactivated = not ZOOM_ACTIVATED
        ZOOM_ACTIVATED = true

        zoom.scale( zoom.scale() + ZOOM_STEP )
        mainGContainer.call zoom.event

        if wasDeactivated
          ZOOM_ACTIVATED = false


      $(@el).find(".BCK-zoom-out-btn").click ->

        #this buttons will always work
        wasDeactivated = not ZOOM_ACTIVATED
        ZOOM_ACTIVATED = true

        zoom.scale( zoom.scale() - ZOOM_STEP )
        mainGContainer.call zoom.event

        if wasDeactivated
          ZOOM_ACTIVATED = false

      # --------------------------------------
      # Activate zoom and drag
      # --------------------------------------
      $(@el).find('.BCK-toggle-grab').click ->

        $targetBtnIcon = $(@).find('i')
        if ZOOM_ACTIVATED
          ZOOM_ACTIVATED = false
          $targetBtnIcon.removeClass 'fa-hand-rock-o'
          $targetBtnIcon.addClass 'fa-hand-paper-o'
          cellsContainerG.classed('grab-activated', false)
        else
          ZOOM_ACTIVATED = true
          $targetBtnIcon.removeClass 'fa-hand-paper-o'
          $targetBtnIcon.addClass 'fa-hand-rock-o'
          cellsContainerG.classed('grab-activated', true)

      # --------------------------------------
      # Open in full screen
      # --------------------------------------
      $(@el).find('.BCK-open-full-screen').click ->
        glados.Utils.URLS.shortenLinkIfTooLongAndOpen(thisView.model.getLinkToFullScreen())
      # --------------------------------------
      # colour property selector
      # --------------------------------------

      $(@el).find(".select-colour-property").on "change", () ->

        if !@value?
          return

        thisView.currentPropertyColour = thisView.config.properties[@value]
        thisView.colourCells(TRANSITIONS_DURATION)

      # --------------------------------------
      # row sorting
      # --------------------------------------
      paintSortDirectionProxy = $.proxy(@paintSortDirection, @)
      triggerRowSorting = ->

        thisView.model.sortMatrixRowsBy thisView.currentRowSortingProperty.propName, thisView.currentRowSortingPropertyReverse
        rowsFooterG.positionRows zoom.scale(), TRANSITIONS_DURATION
        rowsFooterG.assignTexts TRANSITIONS_DURATION
        cellsContainerG.positionRows zoom.scale(), TRANSITIONS_DURATION
        rowsHeaderG.positionRows zoom.scale(), TRANSITIONS_DURATION
        corner2G.assignTexts()
        # add missing rows in window
        setTimeout( (->handleZoom(ingoreActivation=true, forceSectionsUpdate=true)), TRANSITIONS_DURATION + 1)

      triggerColSorting = ->

        thisView.model.sortMatrixColsBy thisView.currentColSortingProperty.propName, thisView.currentColSortingPropertyReverse
        colsFooterG.positionCols zoom.scale(), TRANSITIONS_DURATION
        colsFooterG.assignTexts TRANSITIONS_DURATION
        cellsContainerG.positionCols zoom.scale(), TRANSITIONS_DURATION
        colsHeaderG.positionCols zoom.scale(), TRANSITIONS_DURATION
        corner3G.assignTexts()
        # add missing rows in window
        setTimeout( (->handleZoom(ingoreActivation=true, forceSectionsUpdate=true)), TRANSITIONS_DURATION + 1)

      $(@el).find(".select-row-sort").on "change", () ->

        if !@value?
          return

        thisView.currentRowSortingProperty = thisView.config.properties[@value]
        triggerRowSorting()

      $(@el).find(".select-col-sort").on "change", () ->

        if !@value?
          return

        thisView.currentColSortingProperty = thisView.config.properties[@value]
        triggerColSorting()

      handleSortDirClick = ->

        targetDimension = $(@).attr('data-target-property')
        if targetDimension == 'row'

          thisView.currentRowSortingPropertyReverse = !thisView.currentRowSortingPropertyReverse
          triggerRowSorting()
          paintSortDirectionProxy('.btn-row-sort-direction-container', thisView.currentRowSortingPropertyReverse, 'row')

        else if targetDimension == 'col'


          thisView.currentColSortingPropertyReverse = !thisView.currentColSortingPropertyReverse
          triggerColSorting()
          paintSortDirectionProxy('.btn-col-sort-direction-container', thisView.currentColSortingPropertyReverse, 'col')

        $(thisView.el).find('.btn-sort-direction').on 'click', handleSortDirClick

      $(thisView.el).find('.btn-sort-direction').on 'click', handleSortDirClick

      return

    #---------------------------------------------------------------------------------------------------------------------
    # Rows /Cols Headers tooltips
    #---------------------------------------------------------------------------------------------------------------------
    generateTooltipFunction: (sourceEntity, matrixView, isCol=true) ->

      return (d) ->

        $clickedElem = $(@)
        chemblID = d.id
        if $clickedElem.attr('data-qtip-configured')
          return

        miniRepCardID = 'BCK-MiniReportCard-' + chemblID

        qtipConfig =
          content:
            text: '<div id="' + miniRepCardID + '"></div>'
          show:
            solo: true
          hide:
            fixed: true,
            delay: glados.Settings.TOOLTIPS.DEFAULT_MERCY_TIME
          style:
            classes:'matrix-qtip qtip-light qtip-shadow'

        if isCol
          qtipConfig.position =
            my: 'top left'
            at: 'bottom left'
        else
          qtipConfig.position =
            my: 'top left'
            at: 'bottom right'

        $clickedElem.qtip qtipConfig

        $clickedElem.qtip('api').show()
        $clickedElem.attr('data-qtip-configured', 'yes')

        $newMiniReportCardContainer = $('#' + miniRepCardID)
        $newMiniReportCardContainer.hover ->
          $clickedElem.attr('data-qtip-have-mercy', 'yes')

        if sourceEntity == 'Target'
          ReportCardApp.initMiniReportCard(Entity=Target, $newMiniReportCardContainer, chemblID)
        else
          ReportCardApp.initMiniReportCard(Entity=Compound, $newMiniReportCardContainer, chemblID)


    destroyAllTooltipsIfNecessary: (event) ->

      mouseX = event.clientX
      mouseY = event.clientY
      $elementLeft = $(event.currentTarget)
      glados.Utils.Tooltips.destroyAllTooltipsWhenMouseIsOut($elementLeft, mouseX, mouseY)

    destroyAllTooltipsWithMercy: ->

      $container = $(@el)
      glados.Utils.Tooltips.destroyAllTooltipsWhitMercy($container)
    #---------------------------------------------------------------------------------------------------------------------
    # cells tooltips
    #---------------------------------------------------------------------------------------------------------------------
    summoningMe: ->

      if @KEYS_PRESSED.length != @GLADOS.length
        return false

      for i in [0..@KEYS_PRESSED.length-1]
        keyIs = @KEYS_PRESSED[i]
        keyMustBe = @GLADOS[i]
        if keyIs != keyMustBe
          return false

      return true

    showCellTooltip: ($clickedElem, d)  ->

      summoningMe = @summoningMe()
      if $clickedElem.attr('data-qtip-configured') and not summoningMe
          return

      cardID = d.row_id + '_' + d.col_id
      miniRepCardID = 'BCK-MiniReportCard-' + cardID
      htmlContent = '<div id="' + miniRepCardID + '"></div>'

      if summoningMe
        htmlContent = Handlebars.compile($('#Handlebars-Common-GladosSummoned').html())()

      qtipConfig =
        content:
          text: htmlContent
          button: 'close'
        show:
          event: 'click'
          solo: true
        hide: 'click'
        style:
          classes:'matrix-qtip qtip-light qtip-shadow'
        position:
          my: 'top left'
          at: 'bottom center'

      $clickedElem.qtip qtipConfig
      $clickedElem.qtip('api').show()
      $clickedElem.attr('data-qtip-configured', true)

      if summoningMe
        return

      $newMiniReportCardContainer = $('#' + miniRepCardID)
      glados.apps.Activity.ActivitiesBrowserApp.initMatrixCellMiniReportCard($newMiniReportCardContainer, d,
        @config.rows_entity_name == 'Compounds')

    # because normally container and text elem scale at the same rate on zoom, this can be done only one.
    # take this into account if there is a problem later.
    setEllipsisIfOverlaps: (d3ContainerElem, d3TextElem, limitByHeight=false, addFullTextQtip=false, customWidthLimit,
    customTooltipPosition=undefined ) ->

      # remember the rotation!
      if customWidthLimit?
        containerLimit = customWidthLimit
      else

        if limitByHeight
          containerLimit = d3ContainerElem.node().getBBox().height
        else
          textX = d3TextElem.attr('x')
          containerLimit = d3ContainerElem.node().getBBox().width - textX

      textWidth = d3TextElem.node().getBBox().width
      $textElem = $(d3TextElem.node())

      if 0 < containerLimit < textWidth
        text = d3TextElem.text()
        newText = glados.Utils.Text.getTextForEllipsis(text, textWidth, containerLimit)
        d3TextElem.text(newText)

        if addFullTextQtip

          tooltipPosition = customTooltipPosition
          tooltipPosition ?= glados.Utils.Tooltips.getQltipSafePostion($textElem)

          qtipConfig =
            content:
              text: "<div style='padding: 3px'>#{text}</div>"
            position: tooltipPosition
            style:
              classes:'matrix-qtip qtip-light qtip-shadow'

          $textElem.qtip qtipConfig

      else

        if addFullTextQtip
          $textElem.qtip('destroy', true)

    #---------------------------------------------------------------------------------------------------------------------
    # Initial Zoom Calculation
    #---------------------------------------------------------------------------------------------------------------------
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

    #---------------------------------------------------------------------------------------------------------------------
    # Window
    #---------------------------------------------------------------------------------------------------------------------
    unsetWindow: ->

      @PREVIOUS_WINDOW = null
      @WINDOW = null
      @COLS_IN_WINDOW = null
      @ROWS_IN_WINDOW = null
      @CELLS_IN_WINDOW = null

    # Diagram: https://drive.google.com/file/d/0BzECtlZ_ur1CVkRJc2ZZcE1ncnM/view?usp=sharing
    calculateCurrentWindow: (zoomScale=1, translateX=0, translateY=0, forceSectionsUpdate=false) ->

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


    getColsInWindow: ->

      starTime = Date.now()

      minColNum = @WINDOW.min_col_num
      maxColNum = @WINDOW.max_col_num
      colsList = @model.get('matrix').columns
      end = if maxColNum >= colsList.length then colsList.length - 1 else maxColNum - 1
      start = if minColNum >= colsList.length then end - 1 else minColNum
      colsIndex = @model.get('matrix').columns_curr_position_index

      endTime = Date.now()
      time = endTime - starTime

      return (colsIndex[i] for i in [start..end])

    getRowsInWindow: ->

      starTime = Date.now()

      minRowNum = @WINDOW.min_row_num
      maxRowNum = @WINDOW.max_row_num
      rowsList = @model.get('matrix').rows
      end = if maxRowNum >= rowsList.length then rowsList.length - 1 else maxRowNum - 1
      start = if minRowNum >= rowsList.length then end - 1 else minRowNum
      rowsIndex = @model.get('matrix').rows_curr_position_index

      endTime = Date.now()
      time = endTime - starTime

      return (rowsIndex[i] for i in [start..end])

    getCellsInWindow: ->

      starTime = Date.now()

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

      endTime = Date.now()
      time = endTime - starTime

      return cellsInWindow

    #---------------------------------------------------------------------------------------------------------------------
    # Cell Hovering
    #---------------------------------------------------------------------------------------------------------------------
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

    #---------------------------------------------------------------------------------------------------------------------
    # Headers/Footers link
    #---------------------------------------------------------------------------------------------------------------------
    handleRowHeaderClick: (d) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(d.header_url)
    handleRowFooterClick: (d) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(d.footer_url)
    handleColHeaderClick: (d) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(d.header_url)
    handleColFooterClick: (d) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(d.footer_url)

#---------------------------------------------------------------------------------------------------------------------
# Static Functions
#---------------------------------------------------------------------------------------------------------------------
glados.views.Visualisation.Heatmap.HeatmapView.getDefaultConfig = (sourceEntity='Compounds') ->

  if sourceEntity == 'Targets'
    rowsEntityName = 'Targets'
    rowsLabelProperty = 'target_pref_name'
    colsEntityName = 'Compounds'
    colsLabelProperty = 'molecule_chembl_id'

  else
    rowsEntityName = 'Compounds'
    rowsLabelProperty = 'molecule_chembl_id'
    colsEntityName = 'Targets'
    colsLabelProperty = 'target_pref_name'

  config = {
    rows_entity_name: rowsEntityName
    cols_entity_name: colsEntityName
    properties:
      molecule_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound',
          'CHEMBL_ID')
      target_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target',
          'CHEMBL_ID')
      target_pref_name: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target',
          'PREF_NAME')
      pchembl_value_avg: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
          'PCHEMBL_VALUE_AVG')
      activity_count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
          'ACTIVITY_COUNT')
      hit_count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
          'HIT_COUNT')
      pchembl_value_max: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
          'PCHEMBL_VALUE_MAX')
    initial_colouring: 'pchembl_value_avg'
    colour_properties: ['activity_count', 'pchembl_value_avg']
    initial_row_sorting: 'activity_count'
    initial_row_sorting_reverse: true
    row_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
    initial_col_sorting: 'activity_count'
    initial_col_sorting_reverse: true
    col_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
    initial_col_label_property: colsLabelProperty
    initial_row_label_property: rowsLabelProperty
    propertyToType:
      activity_count: "number"
      pchembl_value_avg: "number"
      pchembl_value_max: "number"
      hit_count: "number"
  }
  return config
