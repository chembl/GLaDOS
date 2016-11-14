# this view is in charge of showing the compound vs target matrix
CompoundTargetMatrixView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @model.on 'change', @render, @

    @$vis_elem = $('#BCK-CompTargMatrixContainer')
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()


  render: ->

    console.log 'render!'

    @paintControls()
    @paintMatrix()

    $(@el).find('select').material_select()
    $(@el).find('.tooltipped').tooltip()

  paintControls: ->

    config = @model.get('config')

    @paintSelect('.select-colouring-container', config.colour_properties, config.initial_colouring, 'select-colour-property', 'Colour by:' )
    @paintSelect('.select-row-sort-container', config.row_sorting_properties, config.initial_row_sorting, 'select-row-sort', 'Sort rows by:' )
    @paintSelect('.select-col-sort-container', config.col_sorting_properties, config.initial_col_sorting, 'select-col-sort', 'Sort columns by:' )

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

    console.log 'painting matrix'

    # --------------------------------------
    # Data
    # --------------------------------------

# this can be used for testing, do not delete
    matrix = {
      "columns": [
        {
          "name": "C1",
          "originalIndex": 0
          "currentPosition": 0
          pchembl_value_sum: 30
          published_value_sum: 330
        },
        {
          "name": "C2",
          "originalIndex": 1
          "currentPosition": 1
          pchembl_value_sum: 26
          published_value_sum: 260
        },
        {
          "name": "C3",
          "originalIndex": 2
          "currentPosition": 2
          pchembl_value_sum: 22
          published_value_sum: 190
        }
      ],
      "rows": [
        {
          "name": "T1",
          "originalIndex": 0
          "currentPosition": 0
          pchembl_value_sum: 33
          published_value_sum: 240
        },
        {
          "name": "T2",
          "originalIndex": 1
          "currentPosition": 1
          pchembl_value_sum: 24
          published_value_sum: 210
        },
        {
          "name": "T3",
          "originalIndex": 2
          "currentPosition": 2
          pchembl_value_sum: 15
          published_value_sum: 90
        },
        {
          "name": "T4",
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

    #compsTargets = @model.get('matrix')

    config = @model.get('config')
    # --------------------------------------
    # pre-configuration
    # --------------------------------------

    currentColourProperty = config.initial_colouring

    margin =
      top: 150
      right: 0
      bottom: 10
      left: 90

    elemWidth = $(@el).width()
    width = 0.8 * elemWidth
    height = width

    mainContainer = d3.select('#' + @$vis_elem.attr('id'))

    # --------------------------------------
    # Leyend initialisation
    # --------------------------------------
    leyendWidth = (width / 2)
    leyendHeight = 100
    leyendSVG = mainContainer.append('svg')
      .attr('width', leyendWidth )
      .attr('height', leyendHeight )

    svg = mainContainer
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    # --------------------------------------
    # Work with data
    # --------------------------------------
    links = matrix.links
    numColumns = matrix.columns.length
    numRows = matrix.rows.length

    console.log 'num rows:', numRows
    console.log 'num columns:', numColumns

    console.log 'links:'
    console.log links

    # --------------------------------------
    # Precompute indexes TODO: put it in model
    # --------------------------------------
    rowsIndex = _.indexBy(matrix.rows, 'name')
    columnsIndex = _.indexBy(matrix.columns, 'name')

    # --------------------------------------
    # Sort by default value
    # --------------------------------------
    sortMatrixRowsBy = (prop) ->

      newOrders = _.sortBy(matrix.rows, prop)
      for row, index in newOrders
        rowsIndex[row.name].currentPosition = index

    sortMatrixRowsBy config.initial_row_sorting + '_sum'

    sortMatrixColsBy = (prop) ->

      newOrders = _.sortBy(matrix.columns, prop)
      for row, index in newOrders
        columnsIndex[row.name].currentPosition = index

    sortMatrixColsBy config.initial_col_sorting + '_sum'

    # --------------------------------------
    # Add background rectangle
    # --------------------------------------

    svg.append("rect")
      .attr("class", "background")
      .style("fill", "white")
      .attr("width", width)
      .attr("height", height)

    # --------------------------------------
    # Sort properties
    # --------------------------------------
    currentRowSortingProperty = config.initial_row_sorting + '_sum'
    currentColSortingProperty = config.initial_col_sorting + '_sum'

    # --------------------------------------
    # scales
    # --------------------------------------

    #given a property, returns a list with all the values found in the links
    getDomainForOrdinalProperty = (prop) ->

      domain = []

      for rowNum, row of matrix.links
        for colNum, cell of row
          domain.push cell[prop]

      return domain

    # given a property, it gives a domain of the property, taking only the smallest and the biggest values.
    getDomainForContinuousProperty = (prop) ->

      minVal = Number.MAX_VALUE
      maxVal = Number.MIN_VALUE
      for rowNum, row of matrix.links
        for colNum, cell of row
          value = cell[prop]
          if value > maxVal
            maxVal = value
          if value < minVal
            minVal = value


      return [minVal, maxVal]

    getYCoord = d3.scale.ordinal()
      .domain([0..numRows])
      .rangeBands([0, height])

    getXCoord = d3.scale.ordinal()
      .domain([0..numColumns])
      .rangeBands([0, width])

    # generates a scale for when the data is numeric
    buildNumericColourScale = (currentProperty) ->

      colourDomain = getDomainForContinuousProperty(currentProperty)

      scale = d3.scale.linear()
        .domain(colourDomain)
        .range(["#FFFFFF", Settings.EMBL_GREEN])

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

      console.log 'type is: ', type
      scale = switch
        when type == 'number' then buildNumericColourScale(currentProperty)
        when type == 'string' then buildTextColourScale(currentProperty)

      console.log 'Scale:'
      console.log 'domain: ', scale.domain()
      console.log 'range: ', scale.range()
      return scale


    getCellColour = defineColourScale(links, currentColourProperty)

    fillColour = (d) ->

      if not d[currentColourProperty]?
          return '#9e9e9e'
      getCellColour(d[currentColourProperty])


    # --------------------------------------
    # Fill leyend details
    # --------------------------------------

    fillLeyendDetails = ->

      leyendSVG.selectAll('g').remove()
      leyendSVG.selectAll('text').remove()

      leyendG = leyendSVG.append('g')
              .attr("transform", "translate(0," + (leyendHeight - 30) + ")");
      leyendSVG.append('text').text('Leyend for: ' + currentColourProperty)
        .attr("transform", "translate(10, 15)");

      rectangleHeight = 50
      colourDataType = config.propertyToType[currentColourProperty]

      if colourDataType == 'string'

        getXInLeyendFor = d3.scale.ordinal()
          .domain( getDomainForOrdinalProperty currentColourProperty  )
          .rangeBands([0, leyendWidth])

        leyendAxis = d3.svg.axis()
          .scale(getXInLeyendFor)
          .orient("bottom")

        leyendG.selectAll('rect')
          .data(getXInLeyendFor.domain())
          .enter().append('rect')
          .attr('height',rectangleHeight)
          .attr('width', getXInLeyendFor.rangeBand())
          .attr('x', (d) -> getXInLeyendFor d)
          .attr('y', -rectangleHeight)
          .attr('fill', (d) -> getCellColour d)

        leyendG.call(leyendAxis)

      else if colourDataType == 'number'

        domain = getDomainForContinuousProperty currentColourProperty
        linearScalePadding = 10
        getXInLeyendFor = d3.scale.linear()
          .domain(domain)
          .range([linearScalePadding, (leyendWidth - linearScalePadding)])

        leyendAxis = d3.svg.axis()
          .scale(getXInLeyendFor)
          .orient("bottom")

        start = domain[0]
        stop = domain[1]
        numValues = 20
        step = Math.abs(stop - start) / numValues
        stepWidthInScale = Math.abs(getXInLeyendFor.range()[0] - getXInLeyendFor.range()[1]) / numValues
        data = d3.range(domain[0], domain[1], step)

        leyendG.selectAll('rect')
          .data(data)
          .enter().append('rect')
          .attr('height',rectangleHeight)
          .attr('width', stepWidthInScale + 5)
          .attr('x', (d) -> getXInLeyendFor d)
          .attr('y', -rectangleHeight)
          .attr('fill', (d) -> getCellColour d)





        leyendG.call(leyendAxis)

    fillLeyendDetails()

    # --------------------------------------
    # Add rows
    # --------------------------------------
    getCellTooltip = (d) ->

      txt = "molecule: " + d.molecule_chembl_id + "\n" + "target: " + d.target_chembl_id + "\n" + currentColourProperty + ":" + d[currentColourProperty]

      return txt

    getRowTooltip = (d) ->

      txt = "target: " + d.name + "\n" +  currentRowSortingProperty + ":" + d[currentRowSortingProperty]
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

      console.log "dataList:", dataList
      console.log 'g elem: ', @
      # @ is the current g element
      cells = d3.select(@).selectAll(".vis-cell")
        .data(dataList)
        .enter().append("rect")
        .attr("class", "vis-cell")
        .attr("x", (d, colNum) -> getXCoord(columnsList[colNum].currentPosition) )
        .attr("width", getXCoord.rangeBand())
        .attr("height", getYCoord.rangeBand())
        .style("fill", fillColour )

      cells.classed('tooltipped', true)
        .attr('data-position', 'bottom')
        .attr('data-delay', '50')
        .attr('data-tooltip', getCellTooltip )


    rows = svg.selectAll('.vis-row')
      .data(matrix.rows)
      .enter()
      .append('g').attr('class', 'vis-row')
      .attr('transform', (d) -> "translate(0, " + getYCoord(d.currentPosition) + ")")
      .each(fillRow)

    rows.append("line")
      .attr("x2", width)

    rows.append("text")
      .attr("x", -6)
      .attr("y", getYCoord.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "end")
      .attr('style', 'font-size:12px;')
      .attr('text-decoration', 'underline')
      .attr('cursor', 'pointer')
      .attr('fill', '#1b5e20')
      .text( (d, i) -> d.name )
      .classed('tooltipped', true)
      .attr('data-position', 'bottom')
      .attr('data-delay', '50')
      .attr('data-tooltip', getRowTooltip)

    # --------------------------------------
    # Add columns
    # --------------------------------------
    getColumnTooltip = (d) ->

      txt = "molecule: " + d.name + "\n" +  currentColSortingProperty + ":" + d[currentColSortingProperty]

    columns = svg.selectAll(".vis-column")
      .data(matrix.columns)
      .enter().append("g")
      .attr("class", "vis-column")
      .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )

    columns.append("line")
      .attr("x1", -width)

    columns.append("text")
      .attr("x", 0)
      .attr("y", getXCoord.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "start")
      .attr('style', 'font-size:12px;')
      .attr('text-decoration', 'underline')
      .attr('cursor', 'pointer')
      .attr('fill', '#1b5e20')
      .text((d, i) -> d.name )
      .classed('tooltipped', true)
      .attr('data-position', 'bottom')
      .attr('data-delay', '50')
      .attr('data-tooltip', getColumnTooltip)

    # --------------------------------------
    # Zoom
    # --------------------------------------
    handleZoom = ->
      console.log 'scale: ' + zoom.scale()
      console.log 'translation: ' + zoom.translate()

      getYCoord.rangeBands([0, (height * zoom.scale())])
      getXCoord.rangeBands([0, (width * zoom.scale())])

      svg.selectAll('.vis-row')
        .attr('transform', (d) ->
          "translate(" + zoom.translate()[0] + ", " + (getYCoord(d.currentPosition) + zoom.translate()[1]) + ")")
        .selectAll("text")
        .attr("y", getYCoord.rangeBand() / (2) )

      svg.selectAll(".vis-column")
        .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )
        .selectAll("text")
        .attr("y", getXCoord.rangeBand() / (2) )
        # remember that the columns texts are rotated -90 degrees,that is why the translation does Y,X instead of X,Y
        .attr('transform', (d) -> "translate( " + (-zoom.translate()[1]) + ", " + zoom.translate()[0] + ")")

      svg.selectAll(".vis-cell")
        .attr("width", getXCoord.rangeBand())
        .attr("height", getYCoord.rangeBand())
        .attr("x", (d, index) -> getXCoord(matrix.columns[(index % matrix.columns.length)].currentPosition) )


    zoom = d3.behavior.zoom()
      .on("zoom", handleZoom)

    svg.call zoom

    # --------------------------------------
    # colour property selector
    # --------------------------------------

    $(@el).find(".select-colour-property").on "change", () ->

      if !@value?
        return

      currentColourProperty = @value
      getCellColour = defineColourScale(links, currentColourProperty)

      fillLeyendDetails()

      t = svg.transition().duration(1000)
      t.selectAll(".vis-cell")
        .style("fill", fillColour)
        .attr('data-tooltip', getCellTooltip )


    # --------------------------------------
    # sort property selector
    # --------------------------------------
    $(@el).find(".select-row-sort").on "change", () ->

      if !@value?
        return

      currentRowSortingProperty = @value + '_sum'
      sortMatrixRowsBy currentRowSortingProperty

      t = svg.transition().duration(2500)
      t.selectAll('.vis-row')
      .attr('transform', (d) ->
          "translate(" + zoom.translate()[0] + ", " + (getYCoord(d.currentPosition) + zoom.translate()[1]) + ")")

      rowTexts = svg.selectAll('.vis-row').selectAll('text')
      .attr('data-tooltip', getRowTooltip)

      $(rowTexts).tooltip()


    $(@el).find(".select-col-sort").on "change", () ->

      if !@value?
        return

      currentColSortingProperty = @value + '_sum'
      sortMatrixColsBy currentColSortingProperty

      t = svg.transition().duration(2500)
      t.selectAll(".vis-column")
      .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )


      # here I have to use the modulo to get the correct column index
      # note that when the cells were being added it was not necessary because it was using the enter()
      t.selectAll(".vis-cell")
      .attr("x", (d, index) -> getXCoord(matrix.columns[(index % matrix.columns.length)].currentPosition) )

      columnTexts = svg.selectAll(".vis-column").selectAll('text')
      .attr('data-tooltip', getColumnTooltip)

      $(columnTexts).tooltip()


    # --------------------------------------
    # Reset zoom
    # --------------------------------------
    resetZoom = ->
      zoom.scale(1)
      zoom.translate([0,0])
      handleZoom()

    $(@el).find(".reset-zoom-btn").click ->

      resetZoom()



