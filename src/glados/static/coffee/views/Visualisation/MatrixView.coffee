# this view is in charge of rendering a matrix
MatrixView = Backbone.View.extend(ResponsiviseViewExt).extend

  REVERSE_POSITION_TOOLTIP_TH: 0.8

  initialize: ->

    @config = {
      properties:
        pchembl_value_avg: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
            'PCHEMBL_VALUE_AVG')
        activity_count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
            'ACTIVITY_COUNT')
        hit_count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
            'HIT_COUNT')
        pchembl_value_max: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
            'PCHEMBL_VALUE_MAX')
      initial_colouring: 'pchembl_value_avg'
      colour_properties: ['activity_count', 'pchembl_value_avg']
      initial_row_sorting: 'activity_count'
      initial_row_sorting_reverse: true
      row_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
      initial_col_sorting: 'activity_count'
      initial_col_sorting_reverse: true
      col_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
      propertyToType:
        activity_count: "number"
        pchembl_value_avg: "number"
        pchembl_value_max: "number"
        hit_count: "number"
    }

    @model.on 'change', @render, @

    @$vis_elem = $(@el).find('.BCK-CompTargMatrixContainer')
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()

  renderWhenError: ->

    @clearVisualisation()

    $messagesElement = $(@el).find('.BCK-VisualisationMessages')
    $messagesElement.html ''

    @$vis_elem.html Handlebars.compile($('#Handlebars-Common-MatrixError').html())
      static_images_url: glados.Settings.STATIC_IMAGES_URL

  render: ->

    # only bother if my element is visible
    if $(@el).is(":visible")

      $messagesElement = $(@el).find('.BCK-VisualisationMessages')
      $messagesElement.html Handlebars.compile($('#' + $messagesElement.attr('data-hb-template')).html())
        message: 'Loading Visualisation...'

      @clearVisualisation()
      @paintControls()
      @paintMatrix()

      $(@el).find('select').material_select()

      $messagesElement.html ''

  destroyAllTooltips: ->

    $elemsWithToolTip = $(@el).find('[data-qtip-configured=true]')
    $elemsWithToolTip.each (index, elem) ->
      $(elem).qtip('destroy', true)
      $(elem).attr('data-qtip-configured', null )

  clearVisualisation: ->

    $messagesElement = $(@el).find('.BCK-VisualisationMessages')
    $messagesElement.html Handlebars.compile($('#' + $messagesElement.attr('data-hb-template')).html())
      message: 'Generating Visualisation...'

    @destroyAllTooltips()
    @clearControls()
    @clearMatrix()

    $legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
    $legendContainer.empty()

  clearControls: ->

    $('.select-colouring-container').empty()
    $('.select-row-sort-container').empty()
    $('.select-col-sort-container').empty()

    $('.btn-row-sort-direction-container').empty()
    $('.btn-col-sort-direction-container').empty()

  clearMatrix: ->

    @$vis_elem.empty()

  paintControls: ->

    @paintSelect('.select-colouring-container',
      (@config.properties[propID] for propID in @config.colour_properties),
      @config.initial_colouring,
      'select-colour-property',
      'Colour by:' )

    @paintSelect('.select-row-sort-container',
      (@config.properties[propID] for propID in @config.row_sorting_properties),
      @config.initial_row_sorting,
      'select-row-sort',
      'Sort rows by:' )

    @paintSelect('.select-col-sort-container',
      (@config.properties[propID] for propID in @config.col_sorting_properties)
      @config.initial_col_sorting,
      'select-col-sort',
      'Sort columns by:' )

    @paintSortDirection('.btn-row-sort-direction-container',
      @config.initial_row_sorting_reverse,
      'row')
    @paintSortDirection('.btn-col-sort-direction-container',
      @config.initial_col_sorting_reverse,
      'col')

    @paintZoomButtons()

  paintZoomButtons: ->

    zoomOptsContent = Handlebars.compile( $('#Handlebars-Common-ESResultsMatrix-ZoomOptions').html() )()

    @$vis_elem.append(zoomOptsContent)

  paintSortDirection: (elemSelector, reverse, target_property) ->

    $sortDirectionBtn = $(@el).find(elemSelector)
    $template = $('#' + $sortDirectionBtn.attr('data-hb-template'))

    if reverse
      $sortDirectionBtn.html Handlebars.compile( $template.html() )
        sort_class: 'fa fa-sort-desc'
        text: 'Desc'
        target_property: target_property
    else
      $sortDirectionBtn.html Handlebars.compile( $template.html() )
        sort_class: 'fa fa-sort-asc'
        text: 'Asc'
        target_property: target_property

  paintSelect: (elemSelector, propsList, defaultValue, customClass, label) ->


    columns = _.map(propsList, (item) ->
      {
        comparator: item.propName
        selected: (item.propName == defaultValue)
        label: item.label
      })

    $select = $(@el).find(elemSelector)
    glados.Utils.fillContentForElement $select,
      custom_class: customClass
      columns: columns
      custom_label: label

  paintMatrix: ->

    # --------------------------------------
    # Data
    # --------------------------------------

# this can be used for testing, do not delete
    matrix = {
      "columns": [
        {
          "label": "C1",
          "originalIndex": 0
          "currentPosition": 0
          pchembl_value: 30
          published_value: 330
        },
        {
          "label": "C2",
          "originalIndex": 1
          "currentPosition": 1
          pchembl_value: 26
          published_value: 260
        },
        {
          "label": "C3",
          "originalIndex": 2
          "currentPosition": 2
          pchembl_value: 22
          published_value: 190
        }
      ],
      "rows": [
        {
          "label": "T1",
          "originalIndex": 0
          "currentPosition": 0
          pchembl_value: 33
          published_value: 240
        },
        {
          "label": "T2",
          "originalIndex": 1
          "currentPosition": 1
          pchembl_value: 24
          published_value: 210
        },
        {
          "label": "T3",
          "originalIndex": 2
          "currentPosition": 2
          pchembl_value: 15
          published_value: 90
        },
        {
          "label": "T4",
          "originalIndex": 3
          "currentPosition": 3
          pchembl_value: 6
          published_value: 240
        },
      ],
      "links": {

        #source Target
        0: {
          # destination Compound
          0: {'num_bioactivities': 0, 'assay_type': 'U', 'pchembl_value': 12, molecule_chembl_id: 'C1', target_chembl_id: 'T1', 'published_value': 120} # this means target 0 is connected to compound 0 through an assay with a value of 1
          1: {'num_bioactivities': 10, 'assay_type': 'P', 'pchembl_value': 11, molecule_chembl_id: 'C2', target_chembl_id: 'T1', 'published_value': 80}
          2: {'num_bioactivities': 0, 'assay_type': 'B', 'pchembl_value': 10, molecule_chembl_id: 'C3', target_chembl_id: 'T1', 'published_value': 40}
        }
        1: {
          0: {'num_bioactivities': 0, 'assay_type': 'A', 'pchembl_value': 9, molecule_chembl_id: 'C1', target_chembl_id: 'T2', 'published_value': 110}
          1: {'num_bioactivities': 20, 'assay_type': 'T', 'pchembl_value': 8, molecule_chembl_id: 'C2', target_chembl_id: 'T2', 'published_value': 70}
          2: {'num_bioactivities': 0, 'assay_type': 'F', 'pchembl_value': 7, molecule_chembl_id: 'C3', target_chembl_id: 'T2', 'published_value': 30}
        }
        2: {
          0: {'num_bioactivities': 0, 'assay_type': 'U', 'pchembl_value': 6, molecule_chembl_id: 'C1', target_chembl_id: 'T3', 'published_value': 10}
          1: {'num_bioactivities': 30, 'assay_type': 'P', 'pchembl_value': 5, molecule_chembl_id: 'C2', target_chembl_id: 'T3', 'published_value': 60}
          2: {'num_bioactivities': 0, 'assay_type': 'B', 'pchembl_value': 4, molecule_chembl_id: 'C3', target_chembl_id: 'T3', 'published_value': 20}
        }
        3: {
          0: {'num_bioactivities': 0, 'assay_type': 'A', 'pchembl_value': 3, molecule_chembl_id: 'C1', target_chembl_id: 'T4', 'published_value': 90}
          1: {'num_bioactivities': 40, 'assay_type': 'T', 'pchembl_value': 2, molecule_chembl_id: 'C2', target_chembl_id: 'T4', 'published_value': 50}
          2: {'num_bioactivities': 0, 'assay_type': 'F', 'pchembl_value': 1, molecule_chembl_id: 'C3', target_chembl_id: 'T4', 'published_value': 100}
        }


      }

    }

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

    # --------------------------------------
    # Sort by default value
    # --------------------------------------
    @model.sortMatrixRowsBy @currentRowSortingProperty.propName, @currentRowSortingPropertyReverse
    @model.sortMatrixColsBy  @currentRowSortingProperty.propName, @currentRowSortingPropertyReverse

    # --------------------------------------
    # variable initialisation
    # --------------------------------------

    links = matrix.links
    NUM_COLUMNS = matrix.columns.length
    NUM_ROWS = matrix.rows.length
    TOTAL_NUM_CELLS = NUM_COLUMNS * NUM_ROWS

    # make sure all intersections are squared
    SIDE_SIZE = 20
    ROWS_HEADER_WIDTH = 100
    ROWS_FOOTER_WIDTH = 50
    COLS_HEADER_HEIGHT = 120
    COLS_FOOTER_HEIGHT = 50
    RANGE_X_END = SIDE_SIZE * NUM_COLUMNS
    RANGE_Y_END = SIDE_SIZE * NUM_ROWS
    ROWS_HEADER_HEIGHT = RANGE_Y_END
    COLS_HEADER_WIDTH = RANGE_X_END
    BASE_X_TRANS_ATT = 'glados-baseXTrans'
    BASE_Y_TRANS_ATT = 'glados-baseYTrans'
    MOVE_X_ATT = 'glados-moveX'
    MOVE_Y_ATT = 'glados-moveY'
    FIXED_TO_LEFT_ATT = 'glados-fixedToLeft'
    FIXED_TO_BOTTOM_ATT = 'glados-fixedToBottom'
    BASE_WIDTH_ATT = 'glados-baseWidth'
    BASE_HEIGHT_ATT = 'glados-baseHeight'
    YES = 'yes'
    NO = 'no'
    CONTAINER_Y_PADDING = 0
    CONTAINER_X_PADDING = 0
    ZOOM_ACTIVATED = false

    getYCoord = d3.scale.ordinal()
      .domain([0..(NUM_ROWS-1)])
      .rangeBands([0, RANGE_Y_END])

    getXCoord = d3.scale.ordinal()
      .domain([0..(NUM_COLUMNS-1)])
      .rangeBands([0, RANGE_X_END])

    LABELS_PADDING = 8
    COLS_LABELS_ROTATION = 30
    BASE_LABELS_SIZE = 10
    GRID_STROKE_WIDTH = 1
    CELLS_PADDING = GRID_STROKE_WIDTH
    TRANSITIONS_DURATION = 1000

    elemWidth = $(@el).width()
    width = elemWidth
    #since I know the side size and how many rows I have, I can calculate which should be the height of the container
    height = SIDE_SIZE * NUM_ROWS
    # Anyway, I have to limit it so it is not too long.
    if height > width
      height = width

    mainContainer = d3.select(@$vis_elem.get(0))

    VISUALISATION_WIDTH = width
    #this is a initial valur, it will be changed after organising everything
    VISUALISATION_HEIGHT = 500

    MIN_COLUMNS_SEEN = 20
    # THE MAXIMUM POSSIBLE ZOOM is the one that allows to see 5 columns, notice that the structure is very similar to
    # initial zoom
    MAX_DESIRED_WIDTH = (SIDE_SIZE - 1) * MIN_COLUMNS_SEEN
    MAX_ZOOM =  VISUALISATION_WIDTH / (ROWS_HEADER_WIDTH + MAX_DESIRED_WIDTH + ROWS_FOOTER_WIDTH)
    #the initial zoom scale is a scale that makes all the matrix to be seen at once
    #ROWS_HEADER_WIDTH * zoomScale + COLS_HEADER_WIDTH * zoomScale + ROWS_FOOTER_WIDTH * zoomScale = VISUALISATION_WIDTH
    INITIAL_ZOOM = VISUALISATION_WIDTH / (ROWS_HEADER_WIDTH + COLS_HEADER_WIDTH + ROWS_FOOTER_WIDTH)
    INITIAL_ZOOM = MAX_ZOOM if INITIAL_ZOOM > MAX_ZOOM
    # the minimum zoom possible is also the one that makes all the matrix to be seen at once
    MIN_ZOOM = INITIAL_ZOOM

    mainSVGContainer = mainContainer
      .append('svg')
      .attr('class', 'mainSVGContainer')
      .attr('width', VISUALISATION_WIDTH)
      .attr('height', VISUALISATION_HEIGHT)
      .attr('style', 'background-color: white;')

    mainSVGContainer = mainContainer.select('.mainSVGContainer')
    # --------------------------------------
    # Base translations
    # --------------------------------------
    applyZoomAndTranslation = (elem, translateX=0, translateY=0, zoomScale=1) ->

      elem.scaleSizes(zoomScale) unless not elem.scaleSizes?

      moveX = elem.attr(MOVE_X_ATT)
      moveY = elem.attr(MOVE_Y_ATT)
      translateX = 0 if moveX == NO
      translateY = 0 if moveY == NO
      fixedToLeft = elem.attr(FIXED_TO_LEFT_ATT) == YES
      fixedToBottom = elem.attr(FIXED_TO_BOTTOM_ATT) == YES

      if fixedToLeft
        baseWidth = elem.attr(BASE_WIDTH_ATT)
        newTransX = VISUALISATION_WIDTH - (baseWidth * zoomScale)
      else
        newTransX = (parseFloat(elem.attr(BASE_X_TRANS_ATT)) + translateX) * zoomScale

      if fixedToBottom
        baseHeight = elem.attr(BASE_HEIGHT_ATT)
        newTransY = VISUALISATION_HEIGHT - (baseHeight * zoomScale)
      else
        newTransY = (parseFloat(elem.attr(BASE_Y_TRANS_ATT)) + translateY) * zoomScale


      elem.attr('transform', 'translate(' + newTransX + ',' + newTransY + ')')
    # --------------------------------------
    # Add background MATRIX g
    # --------------------------------------
    mainGContainer = mainSVGContainer.append("g")
      .attr('class', 'mainGContainer')
      .attr('transform', 'translate(' + CONTAINER_X_PADDING + ',' + CONTAINER_Y_PADDING + ')')

    # --------------------------------------
    # Cells container
    # --------------------------------------
    cellsContainerG = mainGContainer.append('g')
      .attr('data-section-name', 'cellsContainerG')
      .attr(BASE_X_TRANS_ATT, ROWS_HEADER_WIDTH)
      .attr(BASE_Y_TRANS_ATT, COLS_HEADER_HEIGHT)
      .attr(MOVE_X_ATT, YES)
      .attr(MOVE_Y_ATT, YES)

    cellsContainerG.append('rect')
      .style("fill", glados.Settings.VISUALISATION_GRID_NO_DATA)
      .classed('background-rect', true)

    cellsContainerG.selectAll('grid-horizontal-rect')
      .data(matrix.rows)
      .enter()
      .append("rect")
        .classed('grid-horizontal-rect', true)
        .style("stroke", glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .style("fill", glados.Settings.VISUALISATION_GRID_NO_DATA)

    cellsContainerG.selectAll('grid-vertical-line')
      .data(matrix.columns)
      .enter()
      .append("line")
        .classed('grid-vertical-line', true)
        .attr("stroke", glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
        .attr('stroke-width', GRID_STROKE_WIDTH)

    dataList = @model.getDataList()

    cells = cellsContainerG.selectAll(".vis-cell")
      .data(dataList)
      .enter().append("rect")
      .classed('vis-cell', true)
      .attr('stroke-width', GRID_STROKE_WIDTH)

    cellsContainerG.positionRows = (zoomScale, transitionDuration=0 ) ->

      if transitionDuration == 0
        cellsContainerG.selectAll(".vis-cell")
          .attr("y", (d) -> (getYCoord(matrix.rows_index[d.row_id].currentPosition) + CELLS_PADDING) * zoomScale)
      else
        t = cellsContainerG.transition().duration(transitionDuration)
        t.selectAll(".vis-cell")
          .attr("y", (d) -> (getYCoord(matrix.rows_index[d.row_id].currentPosition) + CELLS_PADDING) * zoomScale)

    cellsContainerG.positionCols = (zoomScale, transitionDuration=0 ) ->

      if transitionDuration == 0
        cellsContainerG.selectAll(".vis-cell")
        .attr("x", (d) -> (getXCoord(matrix.columns_index[d.col_id].currentPosition) + CELLS_PADDING) * zoomScale)
      else
        t = cellsContainerG.transition().duration(transitionDuration)
        t.selectAll(".vis-cell")
          .attr("x", (d) -> (getXCoord(matrix.columns_index[d.col_id].currentPosition) + CELLS_PADDING) * zoomScale)

    cellsContainerG.scaleSizes = (zoomScale) ->

      cellsContainerG.select('.background-rect')
        .attr('height', (ROWS_HEADER_HEIGHT * zoomScale))
        .attr('width', (COLS_HEADER_WIDTH * zoomScale))

      cellsContainerG.selectAll('.grid-horizontal-rect')
        .attr("x", 0)
        .attr("y", (d) -> (getYCoord(d.currentPosition) * zoomScale) )
        .attr("width", COLS_HEADER_WIDTH * zoomScale)
        .attr("height", (d) -> (getYCoord.rangeBand() * zoomScale) )

      cellsContainerG.selectAll('.grid-vertical-line')
        .attr("x1", (d) -> (getXCoord(d.currentPosition) * zoomScale))
        .attr("y1", 0)
        .attr("x2", (d) -> (getXCoord(d.currentPosition) * zoomScale))
        .attr("y2", (ROWS_HEADER_HEIGHT * zoomScale))

      cellsContainerG.positionRows(zoomScale)
      cellsContainerG.positionCols(zoomScale)

      cellsContainerG.selectAll(".vis-cell")
        .attr("width", (getXCoord.rangeBand() - 2 * CELLS_PADDING) * zoomScale)
        .attr("height", (getYCoord.rangeBand() - 2 * CELLS_PADDING) * zoomScale)
        .classed('tooltipped', true)
        .attr('data-position', 'bottom')
        .attr('data-delay', '50')

    applyZoomAndTranslation(cellsContainerG)

    fillColour = (d) ->

      if not d[thisView.currentPropertyColour.propName]?
          return glados.Settings.VISUALISATION_GRID_UNDEFINED
      thisView.getCellColour(d[thisView.currentPropertyColour.propName])

    getCellTooltip = (d) ->

      txt = d.row_id + "\n" + d.col_id + "\n" + thisView.currentPropertyColour.label +
        ":" + d[thisView.currentPropertyColour.propName]

      return txt

    colourCells = (transitionDuration=0)->

      if not thisView.currentPropertyColour.colourScale?
        if not thisView.currentPropertyColour.domain?
          colourValues = thisView.model.getValuesListForProperty(thisView.currentPropertyColour.propName)
          glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(thisView.currentPropertyColour,
            colourValues)
        glados.models.visualisation.PropertiesFactory.generateColourScale(thisView.currentPropertyColour)

      thisView.getCellColour = thisView.currentPropertyColour.colourScale

      cellsContainerG.selectAll(".vis-cell")
        .attr('data-tooltip', getCellTooltip)

      t = cellsContainerG.transition().duration(transitionDuration)
      t.selectAll(".vis-cell")
        .style("fill", fillColour)

      $(thisView.el).find('.tooltipped').tooltip('remove')
      $(thisView.el).find('.tooltipped').tooltip()

      thisView.$legendContainer = $(thisView.el).find('.BCK-CompResultsGraphLegendContainer')
      glados.Utils.renderLegendForProperty(thisView.currentPropertyColour, undefined, thisView.$legendContainer)

    colourCells()

    # --------------------------------------
    # Rows Header Container
    # --------------------------------------
    rowsHeaderG = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, 0)
      .attr(BASE_Y_TRANS_ATT, COLS_HEADER_HEIGHT)
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, YES)

    rowsHeaderG.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .classed('background-rect', true)

    rowHeaders = rowsHeaderG.selectAll('.vis-row')
      .data(matrix.rows)
      .enter()
      .append('g').attr('class', 'vis-row')

    rowHeaders.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .style('stroke-width', GRID_STROKE_WIDTH)
      .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .classed('headers-background-rect', true)

    setUpRowTooltip = @generateTooltipFunction('Compound', @)
    rowHeaders.append('text')
      .classed('headers-text', true)
      .text((d) -> d.label)
      .attr('text-decoration', 'underline')
      .attr('cursor', 'pointer')
      .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
      .on('mouseover', -> d3.select(@).style('fill', glados.Settings.VISUALISATION_TEAL_ACCENT_4))
      .on('mouseout', -> d3.select(@).style('fill', glados.Settings.VISUALISATION_TEAL_MAX))
      .on('click', setUpRowTooltip)

    rowsHeaderG.positionRows = (zoomScale, transitionDuration=0 ) ->

      t = rowsHeaderG.transition().duration(transitionDuration)
      t.selectAll('.vis-row')
        .attr('transform', (d) -> "translate(0, " + (getYCoord(d.currentPosition) * zoomScale) + ")")

    rowsHeaderG.scaleSizes = (zoomScale) ->

      rowsHeaderG.select('.background-rect')
        .attr('height', (ROWS_HEADER_HEIGHT * zoomScale))
        .attr('width', (ROWS_HEADER_WIDTH * zoomScale))

      rowsHeaderG.positionRows(zoomScale)

      rowsHeaderG.selectAll('.headers-background-rect')
        .attr('height', (getYCoord.rangeBand() * zoomScale))
        .attr('width', (ROWS_HEADER_WIDTH * zoomScale))

      rowsHeaderG.selectAll('.headers-text')
        .attr('x', (LABELS_PADDING * zoomScale))
        .attr("y", (getYCoord.rangeBand() * (2/3) * zoomScale) )
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoomScale ) + 'px;')


    applyZoomAndTranslation(rowsHeaderG)

    # --------------------------------------
    # Square 2
    # --------------------------------------
    corner2G = mainGContainer.append('g')
      .attr(BASE_Y_TRANS_ATT, 0)
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, NO)
      .attr(FIXED_TO_LEFT_ATT, YES)
      .attr(BASE_WIDTH_ATT, ROWS_FOOTER_WIDTH)

    corner2G.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)

    corner2G.scaleSizes = (zoomScale) ->
      corner2G.select('rect')
        .attr('height', (COLS_HEADER_HEIGHT * zoomScale))
        .attr('width', (ROWS_FOOTER_WIDTH *zoomScale))

    applyZoomAndTranslation(corner2G)

    # --------------------------------------
    # Cols Header Container
    # --------------------------------------
    colsHeaderG = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, ROWS_HEADER_WIDTH)
      .attr(BASE_Y_TRANS_ATT, 0)
      .attr(MOVE_X_ATT, YES)
      .attr(MOVE_Y_ATT, NO)

    colsHeaderG.append('rect')
      .attr('height', COLS_HEADER_HEIGHT)
      .attr('width', RANGE_X_END)
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .classed('background-rect', true)

    colsHeaders = colsHeaderG.selectAll(".vis-column")
      .data(matrix.columns)
      .enter().append("g")
      .classed('vis-column', true)

    colsHeaders.append('rect')
      .style('fill', 'none')
      .style('fill-opacity', 0.5)
      .classed('headers-background-rect', true)

    colsHeaders.append('line')
      .style('stroke-width', GRID_STROKE_WIDTH)
      .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .classed('headers-divisory-line', true)

    setUpColTooltip = @generateTooltipFunction('Target', @)

    colsHeaders.append('text')
      .classed('headers-text', true)
      .attr('transform', 'rotate(-90)')
      .text((d) -> d.label)
      .attr('text-decoration', 'underline')
      .attr('cursor', 'pointer')
      .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
      .on('click', setUpColTooltip)
      .on('mouseover', -> d3.select(@).style('fill', glados.Settings.VISUALISATION_TEAL_ACCENT_4))
      .on('mouseout', -> d3.select(@).style('fill', glados.Settings.VISUALISATION_TEAL_MAX))

    colsHeaderG.positionCols = (zoomScale, transitionDuration=0) ->

      t = colsHeaderG.transition().duration(transitionDuration)
      t.selectAll('.vis-column')
        .attr("transform", ((d) -> "translate(" + (getXCoord(d.currentPosition) * zoomScale) +
        ")rotate(" + COLS_LABELS_ROTATION + " " + (getXCoord.rangeBand() * zoomScale) +
        " " + (COLS_HEADER_HEIGHT * zoomScale) + ")" ))

    colsHeaderG.scaleSizes = (zoomScale) ->

      colsHeaderG.select('.background-rect')
        .attr('height', COLS_HEADER_HEIGHT * zoomScale)
        .attr('width', COLS_HEADER_WIDTH * zoomScale)

      colsHeaderG.positionCols(zoomScale)

      colsHeaderG.selectAll('.headers-background-rect')
        .attr('height', (COLS_HEADER_HEIGHT * zoomScale) )
        .attr('width', (getXCoord.rangeBand() * zoomScale))

      colsHeaderG.selectAll('.headers-divisory-line')
        .attr('x1', (getXCoord.rangeBand() * zoomScale))
        .attr('y1', (COLS_HEADER_HEIGHT * zoomScale))
        .attr('x2', (getXCoord.rangeBand() * zoomScale))
        .attr('y2', 0)

      colsHeaderG.selectAll('.headers-text')
        .attr("y", (getXCoord.rangeBand() * (2/3) * zoomScale ) )
        .attr('x', (-COLS_HEADER_HEIGHT * zoomScale))
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoomScale) + 'px;')


    applyZoomAndTranslation(colsHeaderG)

    # --------------------------------------
    # Rows Footer Container
    # --------------------------------------
    rowsFooterG = mainGContainer.append('g')
      .attr(BASE_Y_TRANS_ATT, COLS_HEADER_HEIGHT)
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, YES)
      .attr(FIXED_TO_LEFT_ATT, YES)
      .attr(BASE_WIDTH_ATT, ROWS_FOOTER_WIDTH)

    rowsFooterG.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .classed('background-rect', true)

    rowFooters = rowsFooterG.selectAll('.vis-row-footer')
      .data(matrix.rows)
      .enter()
      .append('g').attr('class', 'vis-row-footer')

    rowFooters.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .style('stroke-width', GRID_STROKE_WIDTH)
      .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .classed('footers-background-rect', true)

    rowFooters.append('text')
      .classed('footers-text', true)
      .attr('text-anchor', 'end')
      .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)

    rowsFooterG.assignTexts = (transitionDuration=0) ->

      t = rowsFooterG.transition().duration(transitionDuration)
      t.selectAll('.footers-text')
        .text((d) -> glados.Utils.getNestedValue(d, thisView.currentRowSortingProperty.propName))

    rowsFooterG.positionRows = (zoomScale, transitionDuration=0 ) ->

      t = rowsFooterG.transition().duration(transitionDuration)
      t.selectAll('.vis-row-footer')
        .attr('transform', (d) -> "translate(0, " + (getYCoord(d.currentPosition) * zoomScale) + ")" )

    rowsFooterG.scaleSizes = (zoomScale) ->

      rowsFooterG.select('.background-rect')
        .attr('height', (ROWS_HEADER_HEIGHT * zoomScale))
        .attr('width', (ROWS_FOOTER_WIDTH * zoomScale))

      rowsFooterG.positionRows(zoomScale)
      rowsFooterG.assignTexts()

      rowsFooterG.selectAll('.footers-background-rect')
        .attr('height', (getYCoord.rangeBand() * zoomScale))
        .attr('width', (ROWS_FOOTER_WIDTH * zoomScale))

      rowsFooterG.selectAll('.footers-text')
        .attr('x', ((ROWS_FOOTER_WIDTH - LABELS_PADDING) * zoomScale))
        .attr("y", (getYCoord.rangeBand() * (2/3) * zoomScale) )
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoomScale ) + 'px;')

    applyZoomAndTranslation(rowsFooterG)

    # --------------------------------------
    # Cols Footer Container
    # --------------------------------------
    colsFooterG = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, ROWS_HEADER_WIDTH)
      .attr(MOVE_X_ATT, YES)
      .attr(MOVE_Y_ATT, NO)
      .attr(FIXED_TO_BOTTOM_ATT, YES)
      .attr(BASE_HEIGHT_ATT, COLS_FOOTER_HEIGHT)

    colsFooterG.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .classed('background-rect', true)

    colsFooters = colsFooterG.selectAll(".vis-column-footer")
      .data(matrix.columns)
      .enter().append("g")
      .classed('vis-column-footer', true)

    colsFooters.append('rect')
      .style('fill', 'none')
      .classed('footers-background-rect', true)

    colsFooters.append('line')
      .style('stroke-width', GRID_STROKE_WIDTH)
      .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .classed('footers-divisory-line', true)

    colsFooters.append('text')
      .classed('footers-text', true)
      .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
      .attr('transform', 'rotate(90)')


    colsFooterG.positionCols = (zoomScale, transitionDuration=0) ->

      t = colsFooterG.transition().duration(transitionDuration)
      t.selectAll('.vis-column-footer')
        .attr("transform", ((d) -> "translate(" + (getXCoord(d.currentPosition) * zoomScale) +
        ")rotate(" + (-COLS_LABELS_ROTATION) + " " + (getXCoord.rangeBand() * zoomScale) + " 0)" ))

    colsFooterG.assignTexts = (transitionDuration=0) ->

      t = colsFooterG.transition().duration(transitionDuration)
      t.selectAll('.footers-text')
        .text((d) -> glados.Utils.getNestedValue(d, thisView.currentColSortingProperty.propName))

    colsFooterG.scaleSizes = (zoomScale) ->

      colsFooterG.select('.background-rect')
        .attr('height', (COLS_FOOTER_HEIGHT * zoomScale))
        .attr('width', (COLS_HEADER_WIDTH * zoomScale))

      colsFooterG.positionCols(zoomScale)

      colsFooterG.selectAll('.footers-background-rect')
        .attr('height', (COLS_FOOTER_HEIGHT * zoomScale))
        .attr('width', (getXCoord.rangeBand() * zoomScale))

      colsFooterG.selectAll('.footers-divisory-line')
        .attr('x1', (getXCoord.rangeBand() * zoomScale))
        .attr('y1',0)
        .attr('x2', (getXCoord.rangeBand() * zoomScale))
        .attr('y2', (COLS_FOOTER_HEIGHT * zoomScale) )

      colsFooterG.selectAll('.footers-text')
        .attr("y", (-getXCoord.rangeBand() * (1/3) * zoomScale) )
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoomScale) + 'px;')


    applyZoomAndTranslation(colsFooterG)
    colsFooterG.assignTexts()

    # --------------------------------------
    # Square 1
    # --------------------------------------
    corner1G = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, 0)
      .attr(BASE_Y_TRANS_ATT, 0)
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, NO)

    corner1G.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .classed('background-rect', true)

    corner1G.append('line')
      .style('stroke-width', GRID_STROKE_WIDTH)
      .style('stroke', glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .classed('diagonal-line', true)

    corner1G.append('text')
      .text('Targets')
      .classed('columns-text', true)
      .attr('text-anchor', 'middle')

    corner1G.append('text')
      .text('Compounds')
      .classed('rows-text', true)
      .attr('text-anchor', 'middle')

    corner1G.textRotationAngle = glados.Utils.getDegreesFromRadians(Math.atan(COLS_HEADER_HEIGHT / ROWS_HEADER_WIDTH))

    corner1G.scaleSizes = (zoomScale) ->

      corner1G.select('.background-rect')
        .attr('height', COLS_HEADER_HEIGHT * zoomScale)
        .attr('width', ROWS_HEADER_WIDTH * zoomScale)

      corner1G.select('.diagonal-line')
        .attr('x2', ROWS_HEADER_WIDTH * zoomScale)
        .attr('y2', COLS_HEADER_HEIGHT * zoomScale)

      corner1G.select('.columns-text')
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoomScale) + 'px;')
        .attr('transform', 'translate(' + (ROWS_HEADER_WIDTH * 2/3) * zoomScale + ',' +
          (COLS_HEADER_HEIGHT / 2) * zoomScale + ')' + 'rotate(' + corner1G.textRotationAngle + ' 0 0)')

      corner1G.select('.rows-text')
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoomScale) + 'px;')
        .attr('transform', 'translate(' + (ROWS_HEADER_WIDTH / 2) * zoomScale + ',' +
          (COLS_HEADER_HEIGHT * 2/3) * zoomScale + ')' + 'rotate(' + corner1G.textRotationAngle + ' 0 0)')

    applyZoomAndTranslation(corner1G)

    # --------------------------------------
    # Square 3
    # --------------------------------------
    corner3G = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, 0)
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, NO)
      .attr(FIXED_TO_BOTTOM_ATT, YES)
      .attr(BASE_HEIGHT_ATT, COLS_FOOTER_HEIGHT)

    corner3G.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .classed('background-rect', true)

    corner3G.append('text')
      .attr('x', LABELS_PADDING)
      .attr('y', getYCoord.rangeBand())
      .classed('cols-sort-text', true)

    corner3G.assignTexts = ->

      corner3G.select('.cols-sort-text')
        .text(thisView.currentColSortingProperty.label + ':')

    corner3G.scaleSizes = (zoomScale) ->

      corner3G.select('.background-rect')
        .attr('height', (COLS_FOOTER_HEIGHT * zoomScale))
        .attr('width', (ROWS_HEADER_WIDTH * zoomScale))

      corner3G.select('.cols-sort-text')
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * (3/4) * zoomScale) + 'px;')

    applyZoomAndTranslation(corner3G)
    corner3G.assignTexts()
    # --------------------------------------
    # Square 4
    # --------------------------------------
    corner4G = mainGContainer.append('g')
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, NO)
      .attr(FIXED_TO_LEFT_ATT, YES)
      .attr(BASE_WIDTH_ATT, ROWS_FOOTER_WIDTH)
      .attr(FIXED_TO_BOTTOM_ATT, YES)
      .attr(BASE_HEIGHT_ATT, (COLS_FOOTER_HEIGHT))

    corner4G.append('rect')
      .style('fill', glados.Settings.VISUALISATION_GRID_PANELS)
      .classed('background-rect', true)

    corner4G.scaleSizes = (zoomScale) ->

      corner4G.select('.background-rect')
        .attr('height', (COLS_FOOTER_HEIGHT * zoomScale))
        .attr('width', (ROWS_FOOTER_WIDTH * zoomScale))

    applyZoomAndTranslation(corner4G)

    # --------------------------------------
    # Zoom
    # --------------------------------------
    handleZoom = (ingoreActivation=false) ->

      if not ZOOM_ACTIVATED and not ingoreActivation
        return

      translateX = zoom.translate()[0]
      translateY = zoom.translate()[1]
      zoomScale = zoom.scale()

      console.log 'handle zoom'
      console.log 'translateX: ', translateX
      console.log 'translateY: ', translateY
      console.log zoomScale

      applyZoomAndTranslation(corner1G, translateX, translateY, zoomScale)
      applyZoomAndTranslation(colsHeaderG, translateX, translateY, zoomScale)
      applyZoomAndTranslation(corner2G, translateX, translateY, zoomScale)
      applyZoomAndTranslation(rowsHeaderG, translateX, translateY, zoomScale)
      applyZoomAndTranslation(cellsContainerG, translateX, translateY, zoomScale)
      applyZoomAndTranslation(rowsFooterG, translateX, translateY, zoomScale)
      applyZoomAndTranslation(corner3G, translateX, translateY, zoomScale)
      applyZoomAndTranslation(colsFooterG, translateX, translateY, zoomScale)
      applyZoomAndTranslation(corner4G, translateX, translateY, zoomScale)

    ZOOM_STEP = 0.1
    zoom = d3.behavior.zoom()
      .scaleExtent([MIN_ZOOM, MAX_ZOOM])
      .on("zoom", handleZoom)

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

    adjustVisHeight = ->

      translateX = zoom.translate()[0]
      translateY = zoom.translate()[1]
      zoomScale = zoom.scale()

      VISUALISATION_HEIGHT = $(window).height() * 0.6
      mainSVGContainer
        .attr('height', VISUALISATION_HEIGHT)

      applyZoomAndTranslation(corner3G, translateX, translateY, zoomScale)
      applyZoomAndTranslation(colsFooterG, translateX, translateY, zoomScale)
      applyZoomAndTranslation(corner4G, translateX, translateY, zoomScale)

    adjustVisHeight()

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

      $targetBtnIcon = $(@)
      if ZOOM_ACTIVATED
        ZOOM_ACTIVATED = false
        $targetBtnIcon.removeClass 'fa-hand-rock-o'
        $targetBtnIcon.addClass 'fa-hand-paper-o'
      else
        ZOOM_ACTIVATED = true
        $targetBtnIcon.removeClass 'fa-hand-paper-o'
        $targetBtnIcon.addClass 'fa-hand-rock-o'
    # --------------------------------------
    # colour property selector
    # --------------------------------------

    $(@el).find(".select-colour-property").on "change", () ->

      if !@value?
        return

      thisView.currentPropertyColour = thisView.config.properties[@value]
      colourCells(TRANSITIONS_DURATION)

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

    triggerColSorting = ->

      thisView.model.sortMatrixColsBy thisView.currentColSortingProperty.propName, thisView.currentColSortingPropertyReverse
      colsFooterG.positionCols zoom.scale(), TRANSITIONS_DURATION
      colsFooterG.assignTexts TRANSITIONS_DURATION
      cellsContainerG.positionCols zoom.scale(), TRANSITIONS_DURATION
      colsHeaderG.positionCols zoom.scale(), TRANSITIONS_DURATION
      corner3G.assignTexts()

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
    
  generateTooltipFunction: (entityName, matrixView) ->

    return (d) ->

      $clickedElem = $(@)
      if entityName == 'Target'
        chemblID = d.label.replace('Targ: ', '')
      else
        chemblID = d.label
      if $clickedElem.attr('data-qtip-configured')
        return

      miniRepCardID = 'BCK-MiniReportCard-' + chemblID

      qtipConfig =
        content:
          text: '<div id="' + miniRepCardID + '"></div>'
          button: 'close'
        show:
          event: 'click'
          solo: true
        hide: 'click'
        style:
          classes:'matrix-qtip qtip-light qtip-shadow'

      if entityName == 'Target'

        numCols = matrixView.model.get('matrix').columns.length

        if d.currentPosition > numCols * matrixView.REVERSE_POSITION_TOOLTIP_TH
          qtipConfig.position =
            my: 'top right'
            at: 'bottom left'
        else
          qtipConfig.position =
            my: 'top left'
            at: 'bottom left'

      $clickedElem.qtip qtipConfig

      $clickedElem.qtip('api').show()
      $clickedElem.attr('data-qtip-configured', true)

      $newMiniReportCardContainer = $('#' + miniRepCardID)

      if entityName == 'Target'
        TargetReportCardApp.initMiniTargetReportCard($newMiniReportCardContainer, chemblID)
      else
        CompoundReportCardApp.initMiniCompoundReportCard($newMiniReportCardContainer, chemblID)




