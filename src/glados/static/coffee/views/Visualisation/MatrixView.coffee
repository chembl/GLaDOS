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
#    $(@el).find('select').material_select('destroy');

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
      $(@el).find('.tooltipped').tooltip()

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
    @currentRowSortingPropertyReverse = @config.properties[@config.initial_row_sorting_reverse]
    @currentColSortingProperty = @config.properties[@config.initial_col_sorting]
    @currentColSortingPropertyReverse = @config.properties[@config.initial_row_sorting_reverse]
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

    BASE_X_TRANS_ATT = 'baseXTrans'
    BASE_Y_TRANS_ATT = 'baseYTrans'
    MOVE_X_ATT = 'moveX'
    MOVE_Y_ATT = 'moveY'
    YES = 'yes'
    NO = 'no'

    CONTAINER_Y_PADDING = 40
    CONTAINER_X_PADDING = 0

    getYCoord = d3.scale.ordinal()
      .domain([0..NUM_ROWS])
      .rangeBands([0, RANGE_Y_END])

    getXCoord = d3.scale.ordinal()
      .domain([0..NUM_COLUMNS])
      .rangeBands([0, RANGE_X_END])

    LABELS_PADDING = 8
    LABELS_ROTATION = 45
    BASE_LABELS_SIZE = 10

    if GlobalVariables['IS_EMBEDED']

      margin =
        top: 120
        right: 0
        bottom: 10
        left: 0
    else

      margin =
        top: 190
        right: 160
        bottom: 10
        left: 130

    elemWidth = $(@el).width()
    width = elemWidth
    #since I know the side size and how many rows I have, I can calculate which should be the height of the container
    height = SIDE_SIZE * NUM_ROWS
    # Anyway, I have to limit it so it is not too long.
    if height > width
      height = width

    mainContainer = d3.select(@$vis_elem.get(0))

    totalVisualisationWidth = width
    totalVisualisationHeight = 500

    mainSVGContainer = mainContainer
      .append('svg')
      .attr('class', 'mainSVGContainer')
      .attr('width', totalVisualisationWidth)
      .attr('height', totalVisualisationHeight)
      .attr('style', 'background-color: white;')

    mainSVGContainer = mainContainer.select('.mainSVGContainer')
    # --------------------------------------
    # Base translations
    # --------------------------------------
    applyZoomAndTranslation = (elem, translateX=0, translateY=0, zoomScale=1) ->

      moveX = elem.attr(MOVE_X_ATT)
      moveY = elem.attr(MOVE_Y_ATT)
      translateX = 0 if moveX == NO
      translateY = 0 if moveY == NO

      newTransX = (parseFloat(elem.attr(BASE_X_TRANS_ATT)) + translateX) * zoomScale
      newTransY = (parseFloat(elem.attr(BASE_Y_TRANS_ATT)) + translateY) * zoomScale
      elem.attr('transform', 'translate(' + newTransX + ',' + newTransY + ')')

      elem.scaleSizes(zoomScale) unless not elem.scaleSizes?
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
      .style('fill', 'red')
      .classed('background-rect', true)

    cellsContainerG.scaleSizes = (zoomScale) ->

      cellsContainerG.select('.background-rect')
        .attr('height', (RANGE_Y_END * zoomScale))
        .attr('width', (RANGE_X_END * zoomScale))

    applyZoomAndTranslation(cellsContainerG)

    # --------------------------------------
    # Rows Header Container
    # --------------------------------------
    rowsHeaderG = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, 0)
      .attr(BASE_Y_TRANS_ATT, COLS_HEADER_HEIGHT)
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, YES)

    rowsHeaderG.append('rect')
      .style('fill', 'yellow')
      .classed('background-rect', true)

    rowHeaders = rowsHeaderG.selectAll('.vis-row')
      .data(matrix.rows)
      .enter()
      .append('g').attr('class', 'vis-row')

    rowHeaders.append('rect')
      .style('fill', 'white')
      .style('stroke-width', 1)
      .style('stroke', 'black')
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

    rowsHeaderG.scaleSizes = (zoomScale) ->

      rowsHeaderG.select('.background-rect')
        .attr('height', (RANGE_Y_END * zoomScale))
        .attr('width', (ROWS_HEADER_WIDTH * zoomScale))

      rowsHeaderG.selectAll('.vis-row')
        .attr('transform', (d) -> "translate(0, " + (getYCoord(d.currentPosition) * zoomScale) + ")")

      rowsHeaderG.selectAll('.headers-background-rect')
        .attr('height', (getYCoord.rangeBand() * zoomScale))
        .attr('width', (ROWS_HEADER_WIDTH * zoomScale))

      rowsHeaderG.selectAll('.headers-text')
        .attr('x', (LABELS_PADDING * zoomScale))
        .attr("y", (getYCoord.rangeBand() * (2/3) * zoomScale) )
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoomScale ) + 'px;')


    applyZoomAndTranslation(rowsHeaderG)
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
      .style('fill', 'orange')
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
      .style('stroke-width', 1)
      .style('stroke', 'black')
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

    colsHeaderG.scaleSizes = (zoomScale) ->

      colsHeaderG.select('.background-rect')
        .attr('height', COLS_HEADER_HEIGHT * zoomScale)
        .attr('width', RANGE_X_END * zoomScale)

      colsHeaderG.selectAll('.vis-column')
        .attr("transform", ((d) -> "translate(" + (getXCoord(d.currentPosition) * zoomScale) +
        ")rotate(30 " + (getXCoord.rangeBand() * zoomScale) + " " + (COLS_HEADER_HEIGHT * zoomScale) + ")" ))

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
      .attr(BASE_X_TRANS_ATT, (ROWS_HEADER_WIDTH + RANGE_X_END))
      .attr(BASE_Y_TRANS_ATT, COLS_HEADER_HEIGHT)
      .attr(MOVE_X_ATT, YES)
      .attr(MOVE_Y_ATT, YES)

    rowsFooterG.append('rect')
      .style('fill', 'yellow')
      .classed('background-rect', true)

    rowFooters = rowsFooterG.selectAll('.vis-row-footer')
      .data(matrix.rows)
      .enter()
      .append('g').attr('class', 'vis-row-footer')

    rowFooters.append('rect')
      .style('fill', 'white')
      .style('stroke-width', 1)
      .style('stroke', 'black')
      .classed('footers-background-rect', true)

    rowFooters.append('text')
      .classed('footers-text', true)
      .attr('text-anchor', 'end')
      .text((d) -> d[thisView.currentRowSortingProperty.propName])
      .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)

    rowsFooterG.scaleSizes = (zoomScale) ->

      rowsFooterG.select('.background-rect')
        .attr('height', (RANGE_Y_END * zoomScale))
        .attr('width', (ROWS_FOOTER_WIDTH * zoomScale))

      rowsFooterG.selectAll('.vis-row-footer')
        .attr('transform', (d) -> "translate(0, " + (getYCoord(d.currentPosition) * zoomScale) + ")" )

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
      .attr(BASE_Y_TRANS_ATT, (COLS_HEADER_HEIGHT + RANGE_Y_END))
      .attr(MOVE_X_ATT, YES)
      .attr(MOVE_Y_ATT, YES)

    colsFooterG.append('rect')
      .style('fill', 'orange')
      .classed('background-rect', true)

    colsFooterG.scaleSizes = (zoomScale) ->

      colsFooterG.select('.background-rect')
        .attr('height', (COLS_FOOTER_HEIGHT * zoomScale))
        .attr('width', (RANGE_X_END * zoomScale))

    applyZoomAndTranslation(colsFooterG)

    # --------------------------------------
    # Square 1
    # --------------------------------------
    corner1G = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, 0)
      .attr(BASE_Y_TRANS_ATT, 0)
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, NO)

    corner1G.append('rect')
      .style('fill', 'blue')

    corner1G.scaleSizes = (zoomScale) ->
      corner1G.select('rect')
        .attr('height', COLS_HEADER_HEIGHT * zoomScale)
        .attr('width', ROWS_HEADER_WIDTH * zoomScale)

    applyZoomAndTranslation(corner1G)

    # --------------------------------------
    # Square 2
    # --------------------------------------
    corner2G = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, (ROWS_HEADER_WIDTH + RANGE_X_END))
      .attr(BASE_Y_TRANS_ATT, 0)
      .attr(MOVE_X_ATT, YES)
      .attr(MOVE_Y_ATT, NO)

    corner2G.append('rect')
      .style('fill', 'blue')

    corner2G.scaleSizes = (zoomScale) ->
      corner2G.select('rect')
        .attr('height', (COLS_HEADER_HEIGHT * zoomScale))
        .attr('width', (ROWS_FOOTER_WIDTH *zoomScale))

    applyZoomAndTranslation(corner2G)

    # --------------------------------------
    # Square 3
    # --------------------------------------
    corner3G = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, 0)
      .attr(BASE_Y_TRANS_ATT, (COLS_HEADER_HEIGHT + RANGE_Y_END))
      .attr(MOVE_X_ATT, NO)
      .attr(MOVE_Y_ATT, YES)

    corner3G.append('rect')
      .style('fill', 'blue')
      .classed('background-rect', true)

    corner3G.scaleSizes = (zoomScale) ->

      corner3G.select('.background-rect')
      .attr('height', (COLS_FOOTER_HEIGHT * zoomScale))
      .attr('width', (ROWS_HEADER_WIDTH * zoomScale))

    applyZoomAndTranslation(corner3G)

    # --------------------------------------
    # Square 4
    # --------------------------------------
    corner4G = mainGContainer.append('g')
      .attr(BASE_X_TRANS_ATT, (ROWS_HEADER_WIDTH + RANGE_X_END))
      .attr(BASE_Y_TRANS_ATT, (COLS_HEADER_HEIGHT + RANGE_Y_END))
      .attr(MOVE_X_ATT, YES)
      .attr(MOVE_Y_ATT, YES)

    corner4G.append('rect')
      .style('fill', 'blue')
      .classed('background-rect', true)

    corner4G.scaleSizes = (zoomScale) ->

      corner4G.select('.background-rect')
      .attr('height', (COLS_FOOTER_HEIGHT * zoomScale))
      .attr('width', (ROWS_FOOTER_WIDTH * zoomScale))

    applyZoomAndTranslation(corner4G)

    # --------------------------------------
    # Zoom
    # --------------------------------------
    handleZoom = ->

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

    MIN_ZOOM_SCALE = 0.2
    MAX_ZOOM_SCALE = 2
    ZOOM_STEP = 0.1
    zoom = d3.behavior.zoom()
      .scaleExtent([MIN_ZOOM_SCALE, MAX_ZOOM_SCALE])
      .on("zoom", handleZoom)

    mainGContainer.call zoom

    # --------------------------------------
    # Zoom Events
    # --------------------------------------
    resetZoom = ->
      zoom.scale(1)
      zoom.translate([0, 0])
      handleZoom()

    $(@el).find(".BCK-reset-zoom-btn").click ->

      #this buttons will always work
      wasDeactivated = not ZOOM_ACTIVATED
      ZOOM_ACTIVATED = true

      resetZoom()

      if wasDeactivated
        ZOOM_ACTIVATED = false

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

    return

    # --------------------------------------
    # Add background MATRIX g
    # --------------------------------------

    backRectWidth = RANGE_X_END - SIDE_SIZE + 1
    backRectHeight = RANGE_Y_END - SIDE_SIZE + 1

    backLineWidth = backRectWidth - 3
    backLineHeight = backRectHeight - 3

    BACK_RECT_TRANS_X = -1
    BACK_RECT_TRANS_Y = -1

    g.append("rect")
      .attr("class", "background")
      .style("fill", glados.Settings.VISUALISATION_GRID_NO_DATA)
      .attr("width", backRectWidth )
      .attr("height", backRectHeight )
      .attr('stroke', glados.Settings.VISUALISATION_GRID_EXTERNAL_BORDER)
      .attr('stroke-width', 1)
      .attr('transform', "translate(" + BACK_RECT_TRANS_X + ", " + BACK_RECT_TRANS_Y + ")")




    if not @currentPropertyColour.colourScale?
      if not @currentPropertyColour.domain?
        colourValues = @model.getValuesListForProperty(@currentPropertyColour.propName)
        glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(@currentPropertyColour,
          colourValues)
      glados.models.visualisation.PropertiesFactory.generateColourScale(@currentPropertyColour)

    @getCellColour = @currentPropertyColour.colourScale

    fillColour = (d) ->

      if not d[thisView.currentPropertyColour.propName]?
          return glados.Settings.VISUALISATION_GRID_UNDEFINED
      thisView.getCellColour(d[thisView.currentPropertyColour.propName])


    # --------------------------------------
    # Hover
    # --------------------------------------
    handleCellMouseover = () ->

      selectedElement = d3.select(@)
      x = selectedElement.attr('x')
      y = selectedElement.attr('y')
      height = selectedElement.attr('height')
      width = selectedElement.attr('width')

      selectedElement.attr('opacity', 0.6)


    handleCellMouseout = () ->

      selectedElement = d3.select(@)
      selectedElement.attr('opacity', 1)


    # --------------------------------------
    # Add rows
    # --------------------------------------
    getCellTooltip = (d) ->

      txt = d.row_id + "\n" + d.col_id + "\n" + thisView.currentPropertyColour.label +
        ":" + d[thisView.currentPropertyColour.propName]

      return txt

    getRowTooltip = (d) ->

      txt = "Compound: " + d.label + "\n" +  thisView.currentRowSortingProperty + ":" +
        d[thisView.currentRowSortingProperty]
      return txt

    fillRow = (row, rowNumber) ->

      columnsList = matrix.columns
      i = row.originalIndex

      dataList = ( value for key, value of links[i])

      # @ is the current g element
      cells = d3.select(@).selectAll(".vis-cell")
        .data(dataList)
        .enter().append("rect")
        .attr("class", "vis-cell")
        .attr("x", (d) -> getXCoord(matrix.columns_index[d.col_id].currentPosition))
        .attr("width", getXCoord.rangeBand())
        .attr("height", getYCoord.rangeBand())
        .style("fill", fillColour )
        .on("mouseover", handleCellMouseover)
        .on("mouseout", handleCellMouseout)

      cells.classed('tooltipped', true)
        .attr('data-position', 'bottom')
        .attr('data-delay', '50')
        .attr('data-tooltip', getCellTooltip )


    rows = g.selectAll('.vis-row')
      .data(matrix.rows)
      .enter()
      .append('g').attr('class', 'vis-row')
      .attr('transform', (d) -> "translate(0, " + getYCoord(d.currentPosition) + ")")
      .each(fillRow)

    rows.append("line")
      .attr('class', 'dividing-line')
      .attr("x2", backLineWidth)
      .attr("stroke", glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .attr("stroke-width", (d) -> if d.currentPosition == 0 then 0 else 1 )

    setUpRowTooltip = @generateTooltipFunction('Compound', @)

    rows.append("text")
      .attr("x", -LABELS_PADDING)
      .attr("y", getYCoord.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "end")
      .attr('style', 'font-size:' + BASE_LABELS_SIZE + 'px;')
      .attr('text-decoration', 'underline')
      .attr('cursor', 'pointer')
      .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
      .text( (d, i) -> d.label )
      .on('click', setUpRowTooltip)
      .on('mouseover', -> d3.select(@).style('fill', glados.Settings.VISUALISATION_TEAL_ACCENT_4))
      .on('mouseout', -> d3.select(@).style('fill', glados.Settings.VISUALISATION_TEAL_MAX))

    # --------------------------------------
    # Add columns
    # --------------------------------------
    getColumnTooltip = (d) ->

      txt = "Target: " + d.label + "\n" +  thisView.currentColSortingProperty + ":"
      + d[thisView.currentColSortingProperty]

    columns = g.selectAll(".vis-column")
      .data(matrix.columns)
      .enter().append("g")
      .attr("class", "vis-column")
      .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )


    setUpColTooltip = @generateTooltipFunction('Target', @)

    columns.append("text")
      .attr("x", LABELS_PADDING)
      .attr("y", getXCoord.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "start")
      .attr('style', 'font-size:' + BASE_LABELS_SIZE + 'px;')
      .attr('text-decoration', 'underline')
      .attr('cursor', 'pointer')
      .attr("transform", "rotate(" + LABELS_ROTATION + " " + LABELS_PADDING + "," + LABELS_PADDING + ")")
      .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)
      .text((d, i) -> d.label )
      .on('click', setUpColTooltip)
      .on('mouseover', -> d3.select(@).style('fill', glados.Settings.VISUALISATION_TEAL_ACCENT_4))
      .on('mouseout', -> d3.select(@).style('fill', glados.Settings.VISUALISATION_TEAL_MAX))

    columnsWithDivLines = g.selectAll(".vis-column")

    #divisory lines
    columns.append("line")
      .attr('class', 'dividing-line')
      .attr("x1", -(backLineHeight))
      .attr("stroke", glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .attr("stroke-width", (d) -> if d.currentPosition == 0 then 0 else 1 )

    # --------------------------------------
    # Legend
    # --------------------------------------
    @$legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
    glados.Utils.renderLegendForProperty(@currentPropertyColour, undefined, @$legendContainer)
    # --------------------------------------
    # Zoom
    # --------------------------------------
    handleZoom = ->

      if not ZOOM_ACTIVATED
        return

      thisView.destroyAllTooltips()

      if thisView.bugWillHappen
        zoom.translate([thisView.initialTransX, thisView.initialTransY])
        zoom.scale(thisView.initialScale)
        thisView.bugWillHappen = false

      getYCoord.rangeBands([0, (RANGE_Y_END * zoom.scale())])
      getXCoord.rangeBands([0, (RANGE_X_END * zoom.scale())])

      g.selectAll('.background')
        .attr("width", backRectWidth * zoom.scale())
        .attr("height", backRectHeight * zoom.scale())
        .attr('transform', "translate(" + (zoom.translate()[0] + BACK_RECT_TRANS_X) +
          ", " + (zoom.translate()[1] + BACK_RECT_TRANS_Y) + ")")

      g.selectAll('.vis-row')
        .attr('transform', (d) ->
          "translate(" + zoom.translate()[0] + ", " + (getYCoord(d.currentPosition) + zoom.translate()[1]) + ")")
        .selectAll("text")
        .attr("y", getYCoord.rangeBand() / (2) )
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoom.scale()) + 'px;')
        .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)

      g.selectAll('.vis-row')
        .selectAll('.dividing-line')
        .attr("x2", backLineWidth * zoom.scale())
      
      g.selectAll(".vis-column")
        .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )
        .selectAll("text")
        .attr("y", getXCoord.rangeBand() / (2) )
        .attr('style', 'font-size:' + (BASE_LABELS_SIZE * zoom.scale()) + 'px;')
        # remember that the columns texts are rotated -90 degrees,that is why the translation does Y,X instead of X,Y
        .attr('transform', (d) ->
          "translate( " + (-zoom.translate()[1]) + ", " + zoom.translate()[0] + ")" +
          "rotate(" + LABELS_ROTATION + " " + (LABELS_PADDING*zoom.scale()) + "," + (LABELS_PADDING*zoom.scale()) + ")")
        .style("fill", glados.Settings.VISUALISATION_TEAL_MAX)

      g.selectAll(".vis-column")
        .selectAll('.dividing-line')
        .attr("x1", -(backLineHeight * zoom.scale()))
        .attr("transform", "translate(" + (-zoom.translate()[1]) + ", " + zoom.translate()[0] + ")" )

      g.selectAll(".vis-cell")
        .attr("width", getXCoord.rangeBand())
        .attr("height", getYCoord.rangeBand())
        .attr("x", (d, index) -> getXCoord(matrix.columns_index[d.col_id].currentPosition) )


    MIN_ZOOM_SCALE = 0.2
    MAX_ZOOM_SCALE = 2
    ZOOM_STEP = 0.2
    ZOOM_ACTIVATED = true
    zoom = d3.behavior.zoom()
      .scaleExtent([MIN_ZOOM_SCALE, MAX_ZOOM_SCALE])
      .on("zoom", handleZoom)

    mainSVGContainer.call zoom

    # --------------------------------------
    # colour property selector
    # --------------------------------------

    $(@el).find(".select-colour-property").on "change", () ->

      if !@value?
        return

      thisView.currentPropertyColour = thisView.config.properties[@value]

      if not thisView.currentPropertyColour.colourScale?
        if not thisView.currentPropertyColour.domain?
          colourValues = thisView.model.getValuesListForProperty(thisView.currentPropertyColour.propName)
          glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(
            thisView.currentPropertyColour,
            colourValues)
        glados.models.visualisation.PropertiesFactory.generateColourScale(thisView.currentPropertyColour)

      thisView.getCellColour = thisView.currentPropertyColour.colourScale

      t = g.transition().duration(1000)
      t.selectAll(".vis-cell")
        .style("fill", fillColour)
        .attr('data-tooltip', getCellTooltip )

      glados.Utils.renderLegendForProperty(thisView.currentPropertyColour, undefined, thisView.$legendContainer)

    # --------------------------------------
    # sort property selector
    # --------------------------------------
    paintSortDirectionProxy = $.proxy(@paintSortDirection, @)

    triggerRowSortTransition = ->

      if thisView.bugWillHappen
        zoom.translate([thisView.initialTransX, thisView.initialTransY])
        zoom.scale(thisView.initialScale)
        thisView.bugWillHappen = false

      thisView.destroyAllTooltips()
      t = g.transition().duration(2500)
      t.selectAll('.vis-row')
      .attr('transform', (d) ->
          "translate(" + zoom.translate()[0] + ", " + (getYCoord(d.currentPosition) + zoom.translate()[1]) + ")")

      g.selectAll(".vis-row")
        .selectAll('.dividing-line')
        .attr("stroke-width", (d) -> if d.currentPosition == 0 then 0 else 1 )

    handleSortDirClick = ->

      targetDimension = $(@).attr('data-target-property')
      if targetDimension == 'row'

        thisView.currentRowSortingPropertyReverse = !thisView.currentRowSortingPropertyReverse
        sortMatrixRowsBy thisView.currentRowSortingProperty, thisView.currentRowSortingPropertyReverse
        paintSortDirectionProxy('.btn-row-sort-direction-container', thisView.currentRowSortingPropertyReverse, 'row')
        triggerRowSortTransition()

      else if targetDimension == 'col'

        thisView.currentColSortingPropertyReverse = !thisView.currentColSortingPropertyReverse
        sortMatrixColsBy thisView.currentColSortingProperty, thisView.currentColSortingPropertyReverse
        paintSortDirectionProxy('.btn-col-sort-direction-container', thisView.currentColSortingPropertyReverse, 'col')
        triggerColSortTransition()

      $(thisView.el).find('.btn-sort-direction').on 'click', handleSortDirClick

    $(@el).find('.btn-sort-direction').on 'click', handleSortDirClick

    $(@el).find(".select-row-sort").on "change", () ->

      if !@value?
        return

      thisView.currentRowSortingProperty = @value
      sortMatrixRowsBy thisView.currentRowSortingProperty, thisView.currentRowSortingPropertyReverse
      paintSortDirectionProxy('.btn-col-sort-direction-container', thisView.currentColSortingPropertyReverse, 'col')
      triggerRowSortTransition()

    triggerColSortTransition = ->

      thisView.destroyAllTooltips()
      t = g.transition().duration(2500)
      t.selectAll(".vis-column")
      .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )


      # here I have to use the modulo to get the correct column index
      # note that when the cells were being added it was not necessary because it was using the enter()
      t.selectAll(".vis-cell")
      .attr("x", (d, index) -> getXCoord(matrix.columns[(index % matrix.columns.length)].currentPosition) )

      g.selectAll(".vis-column")
        .selectAll('.dividing-line')
        .attr("stroke-width", (d) -> if d.currentPosition == 0 then 0 else 1 )


    $(@el).find(".select-col-sort").on "change", () ->

      if !@value?
        return

      thisView.currentColSortingProperty = @value
      sortMatrixColsBy thisView.currentColSortingProperty, thisView.currentColSortingPropertyReverse

      triggerColSortTransition()


    # --------------------------------------
    #  initial zoom
    # --------------------------------------
    adjustVisHeight = ->

      currentBackRectHeight = parseInt(g.select('.background').attr('height'))
      desiredVisHeight = currentBackRectHeight + zoom.scale() * (margin.top + margin.bottom)
      if desiredVisHeight < MIN_VIS_HEIGHT
        desiredVisHeight = MIN_VIS_HEIGHT

      mainSVGContainer
        .attr('height', desiredVisHeight)

    resetZoom = ->

      # get an initial zoom scale so all the matrix is visible.
      matrixWidth = margin.left + backRectWidth + margin.right
      initialZoomScale = totalVisualisationWidth / matrixWidth
      zoom.scale(initialZoomScale)
      zoom.translate([initialZoomScale * margin.left, initialZoomScale * margin.top])
      handleZoom()

    # --------------------------------------
    #  Zoom events
    # --------------------------------------

    $(@el).find(".BCK-reset-zoom-btn").click ->

      #this buttons will always work
      wasDeactivated = not ZOOM_ACTIVATED
      ZOOM_ACTIVATED = true

      resetZoom()

      if wasDeactivated
        ZOOM_ACTIVATED = false

    $(@el).find(".BCK-zoom-in-btn").click ->

      #this buttons will always work
      wasDeactivated = not ZOOM_ACTIVATED
      ZOOM_ACTIVATED = true

      zoom.scale( zoom.scale() + ZOOM_STEP )
      mainSVGContainer.call zoom.event

      if wasDeactivated
        ZOOM_ACTIVATED = false


    $(@el).find(".BCK-zoom-out-btn").click ->

      #this buttons will always work
      wasDeactivated = not ZOOM_ACTIVATED
      ZOOM_ACTIVATED = true

      zoom.scale( zoom.scale() - ZOOM_STEP )
      mainSVGContainer.call zoom.event

      if wasDeactivated
        ZOOM_ACTIVATED = false

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

#    resetZoom()
    MIN_VIS_HEIGHT = 300
#    adjustVisHeight()
    ZOOM_ACTIVATED = false

    @initialTransX = zoom.translate()[0]
    @initialTransY = zoom.translate()[1]
    @initialScale = zoom.scale()
    @bugWillHappen = true


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




