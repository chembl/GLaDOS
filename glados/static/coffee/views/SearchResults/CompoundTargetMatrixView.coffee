# this view is in charge of showing the compound vs target matrix
CompoundTargetMatrixView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @model.on 'change', @render, @

    @$vis_elem = $('#BCK-CompTargMatrixContainer')
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()


  render: ->

    console.log 'render!'

    @paintMatrix()

    $(@el).find('select').material_select()
    $('.tooltipped').tooltip()

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
        },
        {
          "name": "C2",
          "originalIndex": 1
          "currentPosition": 1
        },
        {
          "name": "C3",
          "originalIndex": 2
          "currentPosition": 2
        }
      ],
      "rows": [
        {
          "name": "T1",
          "originalIndex": 0
          "currentPosition": 0
        },
        {
          "name": "T2",
          "originalIndex": 1
          "currentPosition": 1
        },
        {
          "name": "T3",
          "originalIndex": 2
          "currentPosition": 2
        },
        {
          "name": "T4",
          "originalIndex": 3
          "currentPosition": 3
        },
      ],
      "links": {

        #source Target
        0: {
          # destination Compound
          0: {'pchembl': 1, 'num_bioactivities': 0, 'assay_type': 'U', 'pchembl_value': 12, molecule_chembl_id: 'C1', target_chembl_id: 'T1', 'published_value': 120} # this means target 0 is connected to compound 0 through an assay with a value of 1
          1: {pchembl: 0, 'num_bioactivities': 10, 'assay_type': 'P', 'pchembl_value': 11, molecule_chembl_id: 'C2', target_chembl_id: 'T1', 'published_value': 80}
          2: {pchembl: 2, 'num_bioactivities': 0, 'assay_type': 'B', 'pchembl_value': 10, molecule_chembl_id: 'C3', target_chembl_id: 'T1', 'published_value': 40}
        }
        1: {
          0: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'A', 'pchembl_value': 9, molecule_chembl_id: 'C1', target_chembl_id: 'T2', 'published_value': 110}
          1: {pchembl: 3, 'num_bioactivities': 20, 'assay_type': 'T', 'pchembl_value': 8, molecule_chembl_id: 'C2', target_chembl_id: 'T2', 'published_value': 70}
          2: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'F', 'pchembl_value': 7, molecule_chembl_id: 'C3', target_chembl_id: 'T2', 'published_value': 30}
        }
        2: {
          0: {pchembl: 4, 'num_bioactivities': 0, 'assay_type': 'U', 'pchembl_value': 6, molecule_chembl_id: 'C1', target_chembl_id: 'T3', 'published_value': 10}
          1: {pchembl: 0, 'num_bioactivities': 30, 'assay_type': 'P', 'pchembl_value': 5, molecule_chembl_id: 'C2', target_chembl_id: 'T3', 'published_value': 60}
          2: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'B', 'pchembl_value': 4, molecule_chembl_id: 'C3', target_chembl_id: 'T3', 'published_value': 20}
        }
        3: {
          0: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'A', 'pchembl_value': 3, molecule_chembl_id: 'C1', target_chembl_id: 'T4', 'published_value': 90}
          1: {pchembl: 0, 'num_bioactivities': 40, 'assay_type': 'T', 'pchembl_value': 2, molecule_chembl_id: 'C2', target_chembl_id: 'T4', 'published_value': 50}
          2: {pchembl: 5, 'num_bioactivities': 0, 'assay_type': 'F', 'pchembl_value': 1, molecule_chembl_id: 'C3', target_chembl_id: 'T4', 'published_value': 100}
        }


      }

    }

    #compsTargets = @model.get('matrix')

    # --------------------------------------
    # pre-configuration
    # --------------------------------------

    currentProperty = 'pchembl_value'

    margin =
      top: 150
      right: 0
      bottom: 10
      left: 90

    elemWidth = $(@el).width()
    width = 0.8 * elemWidth
    height = width

    mainContainer = d3.select('#' + @$vis_elem.attr('id'))
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
    # Precompute sums and indexes
    # --------------------------------------
    for col in matrix.columns

      j = col.originalIndex
      sum = 0
      sum = _.reduce (row[j]['pchembl_value'] for i, row of links), (initial, succesive) -> initial + succesive
      col['pchembl_value_sum'] = sum

    for row in matrix.rows

      i = row.originalIndex
      sum = 0
      sum = _.reduce (col['pchembl_value'] for j, col of links[i]), (initial, succesive) -> initial + succesive
      row['pchembl_value_sum'] = sum

    rowsIndex = _.indexBy(matrix.rows, 'name')
    columnsIndex = _.indexBy(matrix.columns, 'name')
    # --------------------------------------
    # Add background rectangle
    # --------------------------------------

    svg.append("rect")
      .attr("class", "background")
      .style("fill", "white")
      .attr("width", width)
      .attr("height", height)

    # --------------------------------------
    # scales
    # --------------------------------------

    getYCoord = d3.scale.ordinal()
      .domain([0..numRows])
      .rangeBands([0, height])

    getXCoord = d3.scale.ordinal()
      .domain([0..numColumns])
      .rangeBands([0, width])


    #this would become the standard way of infering types if the other method doesn't work
    inferPropsType2 = (currentProperty) ->

      propToType =
        "assay_type": "string"
        "pchembl_value": "number"
        "published_value": "number"

      return propToType[currentProperty]

    # infers type from the first non null/undefined value,
    # this will be used to generate the correct scale.
    inferPropsType = (links, currentProperty) ->

      for rowNum, row of links
        for colNum, cell of row
          datum = cell[currentProperty]
          if datum?
            if parseInt(datum) != NaN
              return "number"
            type =  typeof datum
            return type

    # generates a scale for when the data is numeric
    buildNumericColourScale = (links, currentProperty) ->

      minVal = Number.MAX_VALUE
      maxVal = Number.MIN_VALUE
      for rowNum, row of links
        for colNum, cell of row
          value = cell[currentProperty]
          if value > maxVal
            maxVal = value
          if value < minVal
            minVal = value

      colourDomain = [minVal, maxVal]

      console.log 'max value: ', maxVal
      console.log 'min value: ', minVal

      scale = d3.scale.linear()
        .domain(colourDomain)
        .range(["#FFFFFF", Settings.EMBL_GREEN])

      return scale

    # generates a scale for when the data is numeric
    buildTextColourScale = (links, currentProperty) ->

      domain = []

      for rowNum, row of links
        for colNum, cell of row
          domain.push cell[currentProperty]

      scale = d3.scale.ordinal()
        .domain(domain)
        .range(d3.scale.category20().range())

      return scale


    defineColourScale = (links, currentProperty)->

      type = inferPropsType2 currentProperty
      console.log 'type is: ', type
      scale = switch
        when type == 'number' then buildNumericColourScale(links, currentProperty)
        when type == 'string' then buildTextColourScale(links, currentProperty)

      console.log 'Scale:'
      console.log 'domain: ', scale.domain()
      console.log 'range: ', scale.range()
      return scale


    getCellColour = defineColourScale(links, currentProperty)

    fillColour = (d) ->

      if not d[currentProperty]?
          return '#9e9e9e'
      getCellColour(d[currentProperty])

    # --------------------------------------
    # Add rows
    # --------------------------------------
    getCellTooltip = (d) ->

      txt = "molecule: " + d.molecule_chembl_id + "\n" + "target: " + d.target_chembl_id + "\n" + currentProperty + ":" + d[currentProperty]

      return txt

    getRowTooltip = (d) ->

      txt = "target: " + d.name + "\n" +  "pchembl_value_sum:" + d['pchembl_value_sum']
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

      txt = "molecule: " + d.name + "\n" +  "pchembl_value_sum:" + d['pchembl_value_sum']

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
      console.log 'translation: ' + d3.event.translate

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

    mainContainer.call zoom

    # --------------------------------------
    # colour property selector
    # --------------------------------------

    $(@el).find(".select-property").on "change", () ->

      if !@value?
        return

      currentProperty = @value
      console.log 'current colour property: ', currentProperty

      getCellColour = defineColourScale(links, currentProperty)

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

      currentProperty = @value
      newOrders = _.sortBy(matrix.rows, 'pchembl_value_sum')

      for row, index in newOrders
        #rowsIndex[row.name], ' has to be in position: ', index
        rowsIndex[row.name].currentPosition = index

      t = svg.transition().duration(2500)
      t.selectAll('.vis-row')
      .attr('transform', (d) ->
          "translate(" + zoom.translate()[0] + ", " + (getYCoord(d.currentPosition) + zoom.translate()[1]) + ")")

    $(@el).find(".select-column-sort").on "change", () ->

      if !@value?
        return

      currentProperty = @value
      newOrders = _.sortBy(matrix.columns, 'pchembl_value_sum')

      for row, index in newOrders
        columnsIndex[row.name].currentPosition = index

      t = svg.transition().duration(2500)
      t.selectAll(".vis-column")
      .attr("transform", (d) -> "translate(" + getXCoord(d.currentPosition) + ")rotate(-90)" )

      # here I have to use the modulo to get the correct column index
      # note that when the cells were being added it was not necessary because it was using the enter()
      t.selectAll(".vis-cell")
      .attr("x", (d, index) -> getXCoord(matrix.columns[(index % matrix.columns.length)].currentPosition) )



