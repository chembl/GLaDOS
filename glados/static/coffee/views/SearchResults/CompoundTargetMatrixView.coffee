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
    compsTargets = {
      "columns": [
        {
          "name": "C1",
          "originalIndex": 0
        },
        {
          "name": "C2",
          "originalIndex": 1
        },
        {
          "name": "C3",
          "originalIndex": 2
        }
      ],
      "rows": [
        {
          "name": "T1",
          "originalIndex": 0
        },
        {
          "name": "T2",
          "originalIndex": 1
        },
        {
          "name": "T3",
          "originalIndex": 2
        },
        {
          "name": "T4",
          "originalIndex": 3
        },
      ],
      "links": {

        #source Target
        0: {
          # destination Compound
          0: {'pchembl': 1, 'num_bioactivities': 0, 'assay_type': 'U', 'pchembl_value': 1, molecule_chembl_id: 'C1', target_chembl_id: 'T1', 'published_value': 120} # this means target 0 is connected to compound 0 through an assay with a value of 1
          1: {pchembl: 0, 'num_bioactivities': 10, 'assay_type': 'P', 'pchembl_value': 2, molecule_chembl_id: 'C2', target_chembl_id: 'T1', 'published_value': 80}
          2: {pchembl: 2, 'num_bioactivities': 0, 'assay_type': 'B', 'pchembl_value': 3, molecule_chembl_id: 'C3', target_chembl_id: 'T1', 'published_value': 40}
        }
        1: {
          0: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'A', 'pchembl_value': 4, molecule_chembl_id: 'C1', target_chembl_id: 'T2', 'published_value': 110}
          1: {pchembl: 3, 'num_bioactivities': 20, 'assay_type': 'T', 'pchembl_value': 5, molecule_chembl_id: 'C2', target_chembl_id: 'T2', 'published_value': 70}
          2: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'F', 'pchembl_value': 6, molecule_chembl_id: 'C3', target_chembl_id: 'T2', 'published_value': 30}
        }
        2: {
          0: {pchembl: 4, 'num_bioactivities': 0, 'assay_type': 'U', 'pchembl_value': 7, molecule_chembl_id: 'C1', target_chembl_id: 'T3', 'published_value': 10}
          1: {pchembl: 0, 'num_bioactivities': 30, 'assay_type': 'P', 'pchembl_value': 8, molecule_chembl_id: 'C2', target_chembl_id: 'T3', 'published_value': 60}
          2: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'B', 'pchembl_value': 9, molecule_chembl_id: 'C3', target_chembl_id: 'T3', 'published_value': 20}
        }
        3: {
          0: {pchembl: 0, 'num_bioactivities': 0, 'assay_type': 'A', 'pchembl_value': 10, molecule_chembl_id: 'C1', target_chembl_id: 'T4', 'published_value': 90}
          1: {pchembl: 0, 'num_bioactivities': 40, 'assay_type': 'T', 'pchembl_value': 11, molecule_chembl_id: 'C2', target_chembl_id: 'T4', 'published_value': 50}
          2: {pchembl: 5, 'num_bioactivities': 0, 'assay_type': 'F', 'pchembl_value': 12, molecule_chembl_id: 'C3', target_chembl_id: 'T4', 'published_value': 100}
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
    # Precompute sums
    # --------------------------------------
    for col in compsTargets.columns

      j = col.originalIndex
      sum = 0
      sum = _.reduce (row[j]['pchembl_value'] for i, row of links), (initial, succesive) -> initial + succesive
      col['pchembl_value_sum'] = sum

    console.log 'AFTER COMPUTING SUMS:'
    console.log compsTargets
    console.log '^^^'



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
    getCellText = (d) ->

      txt = "molecule: " + d.molecule_chembl_id + "\n" + "target: " + d.target_chembl_id + "\n" + currentProperty + ":" + d[currentProperty]

      return txt

    fillRow = (row, rowNumber) ->

      columnsList = compsTargets.columns
      rowInMatrix = compsTargets.rows[rowNumber]
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
        .attr("x", (d, colNum) ->
          console.log 'here!'
          console.log getXCoord(colNum)
          return getXCoord(colNum) )
        .attr("width", getXCoord.rangeBand())
        .attr("height", getYCoord.rangeBand())
        .style("fill", fillColour )

      cells.classed('tooltipped', true)
        .attr('data-position', 'bottom')
        .attr('data-delay', '50')
        .attr('data-tooltip', getCellText )


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
    getColumnText = (d) ->

      txt = "molecule: " + d.name + "\n" +  "pchembl_value_sum:" + d['pchembl_value_sum']

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

    columns.classed('tooltipped', true)
        .attr('data-position', 'bottom')
        .attr('data-delay', '50')
        .attr('data-tooltip', getColumnText)

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
        .attr('data-tooltip', getCellText )


    # --------------------------------------
    # sort property selector
    # --------------------------------------
    $(@el).find(".select-sort").on "change", () ->

        if !@value?
          return

        currentProperty = @value
        console.log 'current sort property: ', currentProperty

