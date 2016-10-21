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
#    compsTargets = {
#      "columns": [
#        {
#          "name": "C1",
#        },
#        {
#          "name": "C2",
#        },
#        {
#          "name": "C3",
#        }
#      ],
#      "rows": [
#        {
#          "name": "T1",
#        },
#        {
#          "name": "T2",
#        },
#        {
#          "name": "T3",
#        },
#        {
#          "name": "T4",
#        },
#      ],
#      "links": {
#
#        #source Target
#        0: {
#          # destination Compound
#          0: {'pchembl': 1, 'num_bioactivities': 0, 'assay_type': 'U'} # this means target 0 is connected to compound 0 through an assay with a value of 1
#          1: {pchembl: 0, 'num_bioactivities': 10, 'assay_type': 'P'}
#          2: {pchembl: 2, 'num_bioactivities': 0, 'assay_type': 'B'}
#        }
#        1: {
#          0: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'A'}
#          1: {pchembl: 3, 'num_bioactivities': 20, 'assay_type': 'T'}
#          2: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'F'}
#        }
#        2: {
#          0: {pchembl: 4, 'num_bioactivities': 0, 'assay_type': 'U'}
#          1: {pchembl: 0, 'num_bioactivities': 30, 'assay_type': 'P'}
#          2: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'B'}
#        }
#        3: {
#          0: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'A'}
#          1: {pchembl: 0, 'num_bioactivities': 40, 'assay_type': 'T'}
#          2: {pchembl: 5, 'num_bioactivities': 0, 'assay_type': 'F'}
#        }
#
#
#      }
#
#    }

    compsTargets = @model.get('matrix')

    # --------------------------------------
    # pre-configuration
    # --------------------------------------

    currentProperty = 'pchembl_value'

    margin =
      top: 140
      right: 0
      bottom: 10
      left: 90

    elemWidth = $(@el).width()
    height = width = 0.8 * elemWidth

    svg = d3.select('#' + @$vis_elem.attr('id'))
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    # --------------------------------------
    # Work with data
    # --------------------------------------
    links = compsTargets.links
    numColumns = compsTargets.columns.length
    numRows = compsTargets.rows.length

    console.log 'num rows:', numRows
    console.log 'num columns:', numColumns

    console.log 'links:'
    console.log links

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

    # --------------------------------------
    # Add rows
    # --------------------------------------
    fillRow = (row, rowNumber) ->

      console.log 'row: ', rowNumber
      console.log 'cells: ', links[rowNumber]
      dataList = []
      for key, value of links[rowNumber]
        dataList.push(value)
      console.log "dataList:", dataList
      console.log 'g elem: ', @
      # @ is the current g element
      cells = d3.select(@).selectAll(".vis-cell")
        .data(dataList)
        .enter().append("rect")
        .attr("class", "vis-cell")
        .attr("x", (d, colNum) ->
          console.log 'here!'
          console.log getXCoord(colNum)
          return getXCoord(colNum) )
        .attr("width", getXCoord.rangeBand())
        .attr("height", getYCoord.rangeBand())
        .style("fill", (d) ->
          console.log 'value!'
          console.log d
          if _.isEmpty(d)
            return '#9e9e9e'
          return getCellColour(d[currentProperty]) )

      cells.classed('tooltipped', true)
        .attr('data-position', 'bottom')
        .attr('data-delay', '50')
        .attr('data-tooltip', (d) -> currentProperty + ":" + d[currentProperty] )


    rows = svg.selectAll('.vis-row')
      .data(compsTargets.rows)
      .enter()
      .append('g').attr('class', 'vis-row')
      .attr('transform', (d, rowNum) -> "translate(0, " + getYCoord(rowNum) + ")")
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

    # --------------------------------------
    # Add columns
    # --------------------------------------

    columns = svg.selectAll(".vis-column")
      .data(compsTargets.columns)
      .enter().append("g")
      .attr("class", "vis-column")
      .attr("transform", (d, colNum) -> "translate(" + getXCoord(colNum) + ")rotate(-90)" )

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

    # --------------------------------------
    # property selector
    # --------------------------------------

    $(@el).find(".select-property").on "change", () ->

      if !@value?
        return

      currentProperty = @value
      console.log 'current property: ', currentProperty

      getCellColour = defineColourScale(links, currentProperty)

      t = svg.transition().duration(1000)
      t.selectAll(".vis-cell")
        .style("fill", (d) ->
          if _.isEmpty(d)
            return '#9e9e9e'
          getCellColour(d[currentProperty]) )
        .attr('data-tooltip', (d) ->
          currentProperty + ":" + d[currentProperty] )

