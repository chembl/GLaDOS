# this view is in charge of showing the compound vs target matrix
CompoundTargetMatrixView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @model.on 'change', @render, @

    @$vis_elem = $(@el).find('.BCK-CompTargMatrixContainer')
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()


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

  clearVisualisation: ->

    $messagesElement = $(@el).find('.BCK-VisualisationMessages')
    $messagesElement.html Handlebars.compile($('#' + $messagesElement.attr('data-hb-template')).html())
      message: 'Generating Visualisation...'

    @clearControls()
    @clearMatrix()

  clearControls: ->

    $('.select-colouring-container').empty()
    $('.select-row-sort-container').empty()
    $('.select-col-sort-container').empty()

    $('.btn-row-sort-direction-container').empty()
    $('.btn-col-sort-direction-container').empty()

  clearMatrix: ->

    @$vis_elem.empty()

  paintControls: ->

    config = @model.get('config')

    @paintSelect('.select-colouring-container', config.colour_properties, config.initial_colouring, 'select-colour-property', 'Colour by:' )
    @paintSelect('.select-row-sort-container', config.row_sorting_properties, config.initial_row_sorting, 'select-row-sort', 'Sort rows by:' )
    @paintSelect('.select-col-sort-container', config.col_sorting_properties, config.initial_col_sorting, 'select-col-sort', 'Sort columns by:' )

    @paintSortDirection('.btn-row-sort-direction-container', config.initial_row_sorting_reverse, 'row')
    @paintSortDirection('.btn-col-sort-direction-container', config.initial_col_sorting_reverse, 'col')

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
      comparator: item
      selected: (item == defaultValue)
      })

    $select = $(@el).find(elemSelector)
    $template = $('#' + $select.attr('data-hb-template'))
    $select.html Handlebars.compile( $template.html() )
      custom_class: customClass
      columns: columns
      custom_label: label

  paintMatrix: ->

    console.log 'PAINT MATRIX!'
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
          pchembl_value_sum: 30
          published_value_sum: 330
        },
        {
          "label": "C2",
          "originalIndex": 1
          "currentPosition": 1
          pchembl_value_sum: 26
          published_value_sum: 260
        },
        {
          "label": "C3",
          "originalIndex": 2
          "currentPosition": 2
          pchembl_value_sum: 22
          published_value_sum: 190
        }
      ],
      "rows": [
        {
          "label": "T1",
          "originalIndex": 0
          "currentPosition": 0
          pchembl_value_sum: 33
          published_value_sum: 240
        },
        {
          "label": "T2",
          "originalIndex": 1
          "currentPosition": 1
          pchembl_value_sum: 24
          published_value_sum: 210
        },
        {
          "label": "T3",
          "originalIndex": 2
          "currentPosition": 2
          pchembl_value_sum: 15
          published_value_sum: 90
        },
        {
          "label": "T4",
          "originalIndex": 3
          "currentPosition": 3
          pchembl_value_sum: 6
          published_value_sum: 240
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

    config = @model.get('config')
    # --------------------------------------
    # variable initialisation
    # --------------------------------------

    links = matrix.links
    NUM_COLUMNS = matrix.columns.length
    NUM_ROWS = matrix.rows.length
    TOTAL_NUM_CELLS = NUM_COLUMNS * NUM_ROWS

    # make sure all intersections are squared
    SIDE_SIZE = 20
    RANGE_X_END = SIDE_SIZE * NUM_COLUMNS
    RANGE_Y_END = SIDE_SIZE * NUM_ROWS
    LABELS_PADDING = 12
    LABELS_ROTATION = 45
    BASE_LABELS_SIZE = 10

    currentColourProperty = config.initial_colouring

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
    totalVisualisationHeight = height

    g = mainContainer
            .append('svg')
            .attr('class', 'mainSVGContainer')
            .attr('width', totalVisualisationWidth)
            .attr('height', totalVisualisationHeight)
            .attr('style', 'background-color: white;')
            .append("g")
            .attr('class', 'mainGContainer')

    mainSVGContainer = mainContainer.select('.mainSVGContainer')

    console.log 'Element IS: ', mainContainer
    console.log 'WIDTH IS: ', totalVisualisationWidth
    console.log 'HEIGHT IS: ', totalVisualisationHeight

    # --------------------------------------
    # Legend initialisation
    # --------------------------------------
    legendWidth = 0.4 * width
    legendHeight = glados.Settings.VISUALISATION_LEGEND_HEIGHT

    $legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
    $legendContainer.empty()
    legendContainer = d3.select($legendContainer.get(0))

    legendSVG = legendContainer.append('svg')
      .attr('width', legendWidth )
      .attr('height', legendHeight )

    # --------------------------------------
    # Precompute indexes TODO: put it in model
    # --------------------------------------
    rowsIndex = _.indexBy(matrix.rows, 'label')
    columnsIndex = _.indexBy(matrix.columns, 'label')

    # --------------------------------------
    # Sort by default value
    # --------------------------------------
    sortMatrixRowsBy = (prop, reverse) ->

      newOrders = _.sortBy(matrix.rows, prop)
      newOrders = newOrders.reverse() if reverse
      for row, index in newOrders
        rowsIndex[row.label].currentPosition = index

    sortMatrixRowsBy config.initial_row_sorting + '_sum', config.initial_row_sorting_reverse

    sortMatrixColsBy = (prop, reverse) ->

      newOrders = _.sortBy(matrix.columns, prop)
      newOrders = newOrders.reverse() if reverse
      for row, index in newOrders
        columnsIndex[row.label].currentPosition = index

    sortMatrixColsBy config.initial_col_sorting + '_sum', config.initial_col_sorting_reverse

    getYCoord = d3.scale.ordinal()
      .domain([0..NUM_ROWS])
      .rangeBands([0, RANGE_Y_END])

    getXCoord = d3.scale.ordinal()
      .domain([0..NUM_COLUMNS])
      .rangeBands([0, RANGE_X_END])


    # --------------------------------------
    # Add background MATRIX rectangle
    # --------------------------------------
    backRectWitdh = RANGE_X_END - SIDE_SIZE + 1
    backRectHeight = RANGE_Y_END - SIDE_SIZE + 1
    BACK_RECT_TRANS_X = -1
    BACK_RECT_TRANS_Y = -1

    g.append("rect")
      .attr("class", "background")
      .style("fill", "black")
      .attr("width", backRectWitdh )
      .attr("height", backRectHeight )
      .attr('stroke', glados.Settings.VISUALISATION_GRID_EXTERNAL_BORDER)
      .attr('stroke-width', 1)
      .attr('transform', "translate(" + BACK_RECT_TRANS_X + ", " + BACK_RECT_TRANS_Y + ")")

    # --------------------------------------
    # Sort properties
    # --------------------------------------
    currentRowSortingProperty = config.initial_row_sorting + '_sum'
    currentRowSortingPropertyReverse = config.initial_row_sorting_reverse
    currentColSortingProperty = config.initial_col_sorting + '_sum'
    currentColSortingPropertyReverse = config.initial_row_sorting_reverse

    # --------------------------------------
    # scales
    # --------------------------------------

    #given a property, returns a list with all the values found in the links
    getDomainForOrdinalProperty = (prop) ->

      domain = []

      for rowNum, row of matrix.links
        for colNum, cell of row
          value = cell[prop]
          if value?
            domain.push value

      return domain

    # given a property, it gives a domain of the property, taking only the smallest and the biggest values.
    getDomainForContinuousProperty = (prop) ->

      minVal = Number.MAX_VALUE
      maxVal = Number.MIN_VALUE
      for rowNum, row of matrix.links
        for colNum, cell of row
          value = parseFloat(cell[prop])
          if value > maxVal
            maxVal = value
          if value < minVal
            minVal = value


      return [minVal, maxVal]



    # generates a scale for when the data is numeric
    buildNumericColourScale = (currentProperty) ->

      colourDomain = getDomainForContinuousProperty(currentProperty)

      scale = d3.scale.linear()
        .domain(colourDomain)
        .range(["#FFFFFF", glados.Settings.EMBL_GREEN])

      return scale

    # generates a scale for when the data is numeric
    buildTextColourScale = (currentProperty) ->

      domain = getDomainForOrdinalProperty currentProperty

      scale = d3.scale.ordinal()
        .domain(domain)
        .range(d3.scale.category20().range())

      return scale


    defineColourScale = (links, currentProperty)->

      type = config.propertyToType[currentProperty]

      scale = switch
        when type == 'number' then buildNumericColourScale(currentProperty)
        when type == 'string' then buildTextColourScale(currentProperty)

      return scale


    getCellColour = defineColourScale(links, currentColourProperty)

    fillColour = (d) ->

      if not d[currentColourProperty]?
          return glados.Settings.VISUALISATION_GRID_UNDEFINED
      getCellColour(d[currentColourProperty])


    # --------------------------------------
    # Fill legend details
    # --------------------------------------

    fillLegendDetails = ->

      legendSVG.selectAll('g').remove()
      legendSVG.selectAll('text').remove()

      legendG = legendSVG.append('g')
        .attr("transform", "translate(0," + (legendHeight - 30) + ")");
      legendSVG.append('text').text(currentColourProperty)
        .attr("transform", "translate(10, 35)");

      rectangleHeight = glados.Settings.VISUALISATION_LEGEND_RECT_HEIGHT
      colourDataType = config.propertyToType[currentColourProperty]

      if colourDataType == 'string'

        domain = getDomainForOrdinalProperty currentColourProperty
        getXInLegendFor = d3.scale.ordinal()
          .domain( domain )
          .rangeBands([0, legendWidth])

        legendAxis = d3.svg.axis()
          .scale(getXInLegendFor)
          .orient("bottom")

        legendG.selectAll('rect')
          .data(getXInLegendFor.domain())
          .enter().append('rect')
          .attr('height',rectangleHeight)
          .attr('width', getXInLegendFor.rangeBand())
          .attr('x', (d) -> getXInLegendFor d)
          .attr('y', -rectangleHeight)
          .attr('fill', (d) -> getCellColour d)

        legendG.call(legendAxis)

      else if colourDataType == 'number'

        domain = getDomainForContinuousProperty currentColourProperty
        linearScalePadding = 10
        getXInLegendFor = d3.scale.linear()
          .domain(domain)
          .range([linearScalePadding, (legendWidth - linearScalePadding)])

        legendAxis = d3.svg.axis()
          .scale(getXInLegendFor)
          .orient("bottom")

        start = domain[0]
        stop = domain[1]
        numValues = 20
        step = Math.abs(stop - start) / numValues
        stepWidthInScale = Math.abs(getXInLegendFor.range()[0] - getXInLegendFor.range()[1]) / numValues
        data = d3.range(domain[0], domain[1], step)

        legendG.selectAll('rect')
          .data(data)
          .enter().append('rect')
          .attr('height',rectangleHeight)
          .attr('width', stepWidthInScale + 5)
          .attr('x', (d) -> getXInLegendFor d)
          .attr('y', -rectangleHeight)
          .attr('fill', (d) -> getCellColour d)

        legendG.call(legendAxis)

      #customize legend styles
      $legendContainer.find('line, path').css('fill', 'none')

    fillLegendDetails()

     # --------------------------------------
    # Hover
    # --------------------------------------
    # index to identify the cells and speed up some operations, for a row id, there is a list of cells that belong to
    # that row. the same for columns.
    visCellRowsIndex = {}
    visCellColsIndex = {}
    numCellsProcesed = 0
    addVisCellToIndex = (cell, data) ->

      if !visCellRowsIndex[data.row_id]?
        visCellRowsIndex[data.row_id] = []

      visCellRowsIndex[data.row_id].push(cell)

      if !visCellColsIndex[data.col_id]?
        visCellColsIndex[data.col_id] = []

      visCellColsIndex[data.col_id].push(cell)

    hoverCellsAndColumnsForCell = (cellData) ->

      cellsToHoverRow = visCellRowsIndex[cellData[0].row_id]
      cellsToHoverCol = visCellColsIndex[cellData[0].col_id]
      for cell in cellsToHoverRow
        console.log('cell: ', cell)


    handleCellMouseover = () ->

      selectedElement = d3.select(@)
      x = selectedElement.attr('x')
      y = selectedElement.attr('y')
      height = selectedElement.attr('height')
      width = selectedElement.attr('width')

      selectedElement.attr('opacity', 0.6)

#      hoverCellsAndColumnsForCell selectedElement.data()

    handleCellMouseout = () ->

      selectedElement = d3.select(@)
      selectedElement.attr('opacity', 1)
      console.log 'OUT'


    # --------------------------------------
    # Add rows
    # --------------------------------------
    getCellTooltip = (d) ->

      txt = "molecule: " + d.molecule_chembl_id + "\n" + "target: " + d.target_chembl_id + "\n" + currentColourProperty + ":" + d[currentColourProperty]

      return txt

    getRowTooltip = (d) ->

      txt = "target: " + d.label + "\n" +  currentRowSortingProperty + ":" + d[currentRowSortingProperty]
      return txt

    fillRow = (row, rowNumber) ->

      columnsList = matrix.columns
      rowInMatrix = matrix.rows[rowNumber]
      i = rowInMatrix.originalIndex

      dataList = []
      for col in columnsList
        j = col.originalIndex
        value = links[i][j]
        dataList.push(value)

      # @ is the current g element
      cells = d3.select(@).selectAll(".vis-cell")
        .data(dataList)
        .enter().append("rect")
        .attr("class", "vis-cell")
        .attr("x", (d, colNum) -> getXCoord(columnsList[colNum].currentPosition) )
        .attr("width", getXCoord.rangeBand())
        .attr("height", getYCoord.rangeBand())
        .style("fill", fillColour )
        .on("mouseover", handleCellMouseover)
        .on("mouseout", handleCellMouseout)
        .each((d) -> addVisCellToIndex(@, d))

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
      .attr("x2", backRectWitdh)
      .attr("stroke", glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .attr("stroke-width", (d) -> if d.currentPosition == 0 then 0 else 1 )

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
      .classed('tooltipped', true)
      .attr('data-position', 'bottom')
      .attr('data-delay', '50')
      .attr('data-tooltip', getRowTooltip)

    # --------------------------------------
    # Add columns
    # --------------------------------------
    getColumnTooltip = (d) ->

      txt = "molecule: " + d.label + "\n" +  currentColSortingProperty + ":" + d[currentColSortingProperty]

    columns = g.selectAll(".vis-column")
      .data(matrix.columns)
      .enter().append("g")
      .attr("class", "vis-column")
      .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )

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
      .classed('tooltipped', true)
      .attr('data-position', 'bottom')
      .attr('data-delay', '50')
      .attr('data-tooltip', getColumnTooltip)

    columnsWithDivLines = g.selectAll(".vis-column")

    #divisory lines
    columns.append("line")
      .attr('class', 'dividing-line')
      .attr("x1", -(backRectHeight))
      .attr("stroke", glados.Settings.VISUALISATION_GRID_DIVIDER_LINES)
      .attr("stroke-width", (d) -> if d.currentPosition == 0 then 0 else 1 )



    # --------------------------------------
    # Zoom
    # --------------------------------------
    handleZoom = ->

      if not ZOOM_ACTIVATED
        return

      getYCoord.rangeBands([0, (RANGE_Y_END * zoom.scale())])
      getXCoord.rangeBands([0, (RANGE_X_END * zoom.scale())])

      g.selectAll('.background')
        .attr("width", backRectWitdh * zoom.scale())
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
        .attr("x2", backRectWitdh * zoom.scale())
      
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
        .attr("x1", -(backRectHeight * zoom.scale()))
        .attr("transform", "translate(" + (-zoom.translate()[1]) + ", " + zoom.translate()[0] + ")" )

      g.selectAll(".vis-cell")
        .attr("width", getXCoord.rangeBand())
        .attr("height", getYCoord.rangeBand())
        .attr("x", (d, index) -> getXCoord(matrix.columns[(index % matrix.columns.length)].currentPosition) )


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

      currentColourProperty = @value
      getCellColour = defineColourScale(links, currentColourProperty)

      fillLegendDetails()

      t = g.transition().duration(1000)
      t.selectAll(".vis-cell")
        .style("fill", fillColour)
        .attr('data-tooltip', getCellTooltip )


    # --------------------------------------
    # sort property selector
    # --------------------------------------
    paintSortDirectionProxy = $.proxy(@paintSortDirection, @)
    thisView = @

    triggerRowSortTransition = ->

      t = g.transition().duration(2500)
      t.selectAll('.vis-row')
      .attr('transform', (d) ->
          "translate(" + zoom.translate()[0] + ", " + (getYCoord(d.currentPosition) + zoom.translate()[1]) + ")")

      rowTexts = g.selectAll('.vis-row').selectAll('text')
      .attr('data-tooltip', getRowTooltip)

      g.selectAll(".vis-row")
        .selectAll('.dividing-line')
        .attr("stroke-width", (d) -> if d.currentPosition == 0 then 0 else 1 )

      $(rowTexts).tooltip()

    handleSortDirClick = ->

      targetDimension = $(@).attr('data-target-property')
      if targetDimension == 'row'

        console.log 're-sort rows'
        currentRowSortingPropertyReverse = !currentRowSortingPropertyReverse
        sortMatrixRowsBy currentRowSortingProperty, currentRowSortingPropertyReverse
        paintSortDirectionProxy('.btn-row-sort-direction-container', currentRowSortingPropertyReverse, 'row')
        triggerRowSortTransition()

      else if targetDimension == 'col'

        currentColSortingPropertyReverse = !currentColSortingPropertyReverse
        sortMatrixColsBy currentColSortingProperty, currentColSortingPropertyReverse
        paintSortDirectionProxy('.btn-col-sort-direction-container', currentColSortingPropertyReverse, 'col')
        triggerColSortTransition()

      $(thisView.el).find('.btn-sort-direction').on 'click', handleSortDirClick

    $(@el).find('.btn-sort-direction').on 'click', handleSortDirClick

    $(@el).find(".select-row-sort").on "change", () ->

      if !@value?
        return

      currentRowSortingProperty = @value + '_sum'
      sortMatrixRowsBy currentRowSortingProperty, currentRowSortingPropertyReverse
      paintSortDirectionProxy('.btn-col-sort-direction-container', currentColSortingPropertyReverse, 'col')
      triggerRowSortTransition()



    triggerColSortTransition = ->
      t = g.transition().duration(2500)
      t.selectAll(".vis-column")
      .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )


      # here I have to use the modulo to get the correct column index
      # note that when the cells were being added it was not necessary because it was using the enter()
      t.selectAll(".vis-cell")
      .attr("x", (d, index) -> getXCoord(matrix.columns[(index % matrix.columns.length)].currentPosition) )

      columnTexts = g.selectAll(".vis-column").selectAll('text')
      .attr('data-tooltip', getColumnTooltip)

      g.selectAll(".vis-column")
        .selectAll('.dividing-line')
        .attr("stroke-width", (d) -> if d.currentPosition == 0 then 0 else 1 )

      $(columnTexts).tooltip()


    $(@el).find(".select-col-sort").on "change", () ->

      if !@value?
        return

      currentColSortingProperty = @value + '_sum'
      sortMatrixColsBy currentColSortingProperty, currentColSortingPropertyReverse

      triggerColSortTransition()


    # --------------------------------------
    #  initial zoom
    # --------------------------------------
    adjustVisHeight = ->

      currentBackRectHeight = parseInt(g.select('.background').attr('height'))
      desiredVisHeight = currentBackRectHeight + zoom.scale() * (margin.top + margin.bottom)

      mainSVGContainer
        .attr('height', desiredVisHeight)

    resetZoom = ->

      # get an initial zoom scale so all the matrix is visible.
      matrixWidth = margin.left + backRectWitdh + margin.right
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
      console.log 'target:', $(@)

      if ZOOM_ACTIVATED
        ZOOM_ACTIVATED = false

        $targetBtnIcon.removeClass 'fa-hand-rock-o'
        $targetBtnIcon.addClass 'fa-hand-paper-o'

      else

        ZOOM_ACTIVATED = true

        $targetBtnIcon.removeClass 'fa-hand-paper-o'
        $targetBtnIcon.addClass 'fa-hand-rock-o'

    resetZoom()
    adjustVisHeight()
    ZOOM_ACTIVATED = false


