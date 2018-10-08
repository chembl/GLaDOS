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
  .extend(glados.views.Visualisation.Heatmap.Parts.Square1)\
  .extend(glados.views.Visualisation.Heatmap.Parts.Square3)\
  .extend(glados.views.Visualisation.Heatmap.Parts.Square4)\
  .extend(glados.views.Visualisation.Heatmap.Parts.Window)\
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
      @ZOOM_ACTIVATED = false

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
      @TRANSITIONS_DURATION = 1000

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
      @VISUALIZATION_PROPORTION = @VISUALISATION_HEIGHT / @VISUALISATION_WIDTH
      # THE MAXIMUM POSSIBLE ZOOM is the calculated for a matrix with 10 columns and the same proportion as the visualization
      @MIN_COLS_SEEN = 5
      @MIN_ROWS_SEEN = Math.floor(@MIN_COLS_SEEN * @VISUALIZATION_PROPORTION)
      @MAX_ZOOM = @calculateInitialZoom(@MIN_COLS_SEEN, @MIN_ROWS_SEEN)

      # for the minimum possible zoom I calculate the biggest rectangle that should be seen completely according
      # to the screen. Is calculated without taking into account the scaling of other parts for simplicity.
      @MIN_PIXELS_PER_SIDE = 5
      @MAX_COLS_SEEN = Math.ceil(@VISUALISATION_WIDTH / @MIN_PIXELS_PER_SIDE)
      @MAX_COLS_SEEN = if @MAX_COLS_SEEN < 30 then 30 else @MAX_COLS_SEEN
      @MAX_ROWS_SEEN = Math.ceil(@VISUALISATION_HEIGHT / @MIN_PIXELS_PER_SIDE)
      @MAX_ROWS_SEEN = if @MAX_ROWS_SEEN < 30 then Math.floor(30 * @VISUALIZATION_PROPORTION) else @MAX_ROWS_SEEN
      @MIN_ZOOM = @calculateInitialZoom(@MAX_COLS_SEEN, @MAX_ROWS_SEEN)

      # calculate the initial zoom with the matrix I got
      @INITIAL_ZOOM = @calculateInitialZoom(@NUM_COLUMNS, @NUM_ROWS)

      # never start with zoom less than 1
      @INITIAL_ZOOM = if @INITIAL_ZOOM < 1 then 1 else @INITIAL_ZOOM
      @zoomScale = @INITIAL_ZOOM

      console.log 'MIN_ZOOM: ', @MIN_ZOOM
      console.log 'INITIAL_ZOOM: ', @INITIAL_ZOOM
      console.log 'MAX_ZOOM: ', @MAX_ZOOM
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
      @mainGContainer = mainSVGContainer.append("g")
        .attr('class', 'mainGContainer')
        .attr('transform', 'translate(' + CONTAINER_X_PADDING + ',' + CONTAINER_Y_PADDING + ')')

      # Now starts the addition of each section. Remember that for svg elements the order in which elements are added
      # determines their position in the z axis.
      @cellsContainerG = @initCellsContainer(@mainGContainer, matrix)
      @applyZoomAndTranslation(@cellsContainerG)
      @colourCells()
      @rowsHeaderG = @initRowsHeaderContainer(@mainGContainer)
      @colsHeaderG = @initColsHeaderContainer(@mainGContainer)
      @rowsFooterG = @initRowsFooterContainer(@mainGContainer)
      @corner2G = @initSquare2(@mainGContainer)
      @colsFooterG = @initColsFooter(@mainGContainer)
      @corner1G = @initSquare1(@mainGContainer)
      @corner3G = @initSquare3(@mainGContainer)
      @corner4G = @initSquare4(@mainGContainer)

      @initZoom(@mainGContainer)
      @resetZoom()
      @initResetZoomBtn()
      @initZoomInBtn()
      @initZoomOutBtn()
      @initToggleGrabBtn()
      @initFullScreenBtn()
      @initColourPropertySelector()
      @initSortRowsBtn()
      @initSortColBtn()
      @initSortDirectionBtn()

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
