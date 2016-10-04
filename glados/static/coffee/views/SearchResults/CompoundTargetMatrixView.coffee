# this view is in charge of showing the compound vs target matrix
CompoundTargetMatrixView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @$vis_elem = $('#BCK-CompTargMatrixContainer')
    updateViewProxy = @setUpResponsiveRender()


  render: ->

    console.log 'render!'

    @paintMatrix()
    @hidePreloader()

  paintMatrix: ->

    console.log 'painting matrix'

    # --------------------------------------
    # Data
    # --------------------------------------

    compsTargets = {
      "columns": [
        {
          "name": "C1",
        },
        {
          "name": "C2",
        },
        {
          "name": "C3",
        }
      ],
      "rows": [
        {
          "name": "T1",
        },
        {
          "name": "T2",
        },
        {
          "name": "T3",
        },
        {
          "name": "T4",
        },
      ],
      "links": {

        #source Target
        0: {
          # destination Compound
          0: 1 # this means target 0 is connected to compound 0 through
          1: 0 # target 0 is NOT connected to compound 1
          2: 1
        }
        1: {
          0: 0
          1: 1
          2: 0
        }
        2: {
          0: 1
          1: 0
          2: 0
        }
        3: {
          0: 0
          1: 0
          2: 0
        }


      }

    }

    # --------------------------------------
    # pre-configuration
    # --------------------------------------

    margin =
      top: 70
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

    getYCoord = d3.scale.ordinal()
      .domain([0..numRows])
      .rangeBands([0, height])

    getXCoord = d3.scale.ordinal()
      .domain([0..numColumns])
      .rangeBands([0, width])

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
          if d ==1
            return '#009688'
          else return 'white')

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
