# this view is in charge of showing the results of a compound search as a graph
CompoundResultsGraphView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @$vis_elem = $('#BCK-CompResultsGraphContainer')
    updateViewProxy = @setUpResponsiveRender()

  render: ->

    @paintGraph()
    $(@el).find('select').material_select()

  paintGraph: ->

    console.log 'painting graph'

    # --------------------------------------
    # Data
    # --------------------------------------
    molecules = [
      {
        molecule_chembl_id: "CHEMBL8659",
        molecule_type: "Small molecule",
        therapeutic_flag: false,
        molecule_properties: {acd_logd: "4.83", acd_logp: "7.42", acd_most_apka: "4.78", acd_most_bpka: null,}
        max_phase: 2,
        mol_wt: 16.5,
      },
      {
        molecule_chembl_id: "CHEMBL9960",
        molecule_type: "Small molecule",
        therapeutic_flag: true,
        molecule_properties: {acd_logd: "5.33", acd_logp: "5.33", acd_most_apka: "12.82", acd_most_bpka: "3.63"}
        max_phase: 3,
        mol_wt: 40.5,
      },
      {
        molecule_chembl_id: "CHEMBL3545375",
        molecule_type: "Antibody",
        therapeutic_flag: false,
        molecule_properties: null
        max_phase: 4,
        mol_wt: 140.5,
      },
      {
        molecule_chembl_id: "CHEMBL6962",
        molecule_type: "Small molecule",
        therapeutic_flag: false,
        molecule_properties: {acd_logd: "0.73", acd_logp: "2.64", acd_most_apka: null, acd_most_bpka: "10.01"},
        max_phase: 1
        mol_wt: 32.0,
      }
      {
        molecule_chembl_id: "CHEMBL1863514"
        molecule_type: "Enzyme",
        therapeutic_flag: true,
        molecule_properties: null,
        max_phase: 2,
        mol_wt: 20.0,
      }
      {
        molecule_chembl_id: "CHEMBL6995",
        molecule_type: "Small molecule",
        therapeutic_flag: false,
        molecule_properties: {acd_logd: "-1.51", acd_logp: "0.59", acd_most_apka: "13.88", acd_most_bpka: "9.43"}
        max_phase: 3,
        mol_wt: 25.0,

      }

    ]

    # --------------------------------------
    # pre-configuration
    # --------------------------------------
    padding =
      right:60
      left: 60
      text_left: 60
      bottom: 40
      top: 40

    XAXIS = 'x-axis'
    YAXIS = 'y-axis'
    COLOUR = 'colour'
    ORDINAL = 'ORDINAL'
    LINEAR = 'LINEAR'

    labelerProperty = 'molecule_chembl_id'
    currentPropertyX = 'mol_wt'
    currentPropertyY = 'mol_wt'
    currentPropertyColour = 'mol_wt'

    elemWidth = $(@el).width()
    height = width = 0.8 * elemWidth

    gridHeight = (height - padding.bottom - padding.top)
    gridWidth = (width - padding.left - padding.right)

    mainContainer = d3.select('#' + @$vis_elem.attr('id'))
      .append('svg')
      .attr('width', width)
      .attr('height', height)

    # --------------------------------------
    # Add background rectangle
    # --------------------------------------
    mainContainer.append("rect")
      .attr("class", "background")
      .attr('fill': 'white')
      .attr("width", width)
      .attr("height", height)
      .attr('stroke', 'black')

    # --------------------------------------
    # Add main canvas
    # --------------------------------------
    svg = mainContainer.append('svg')
            .attr('width', width)
            .attr('height', height)
            .append("g")

    # --------------------------------------
    # scales
    # --------------------------------------
    # infers type from the first non null/undefined value,
    # this will be used to generate the correct scale.
    inferPropsType = (dataList) ->

      for datum in dataList
        if datum?
          type =  typeof datum
          return type

    # builds a linear scale to position the circles
    # when the data is numeric, range is 0 to canvas width,
    # taking into account the padding
    buildLinearNumericScale = (dataList, axis) ->

      minVal = Number.MAX_VALUE
      maxVal = Number.MIN_VALUE

      for datum in dataList
        if datum > maxVal
          maxVal = datum
        if datum < minVal
          minVal = datum

      scaleDomain = [minVal, maxVal]

      console.log 'axis: ', axis

      range = switch
        when axis == XAXIS then [padding.left, width - padding.right]
        when axis == YAXIS then [height - padding.bottom, padding.top]
        when axis == COLOUR then ['#ede7f6', '#311b92']

      console.log 'range: ', range

      scale = d3.scale.linear()
        .domain(scaleDomain)
        .range(range)
      scale.type = LINEAR

      return scale

    # builds an ordinal scale to position the circles
    # when the data is string, range is 0 to canvas width,
    # taking into account the padding
    buildOrdinalStringScale = (dataList, axis) ->

      if axis == COLOUR
        return d3.scale.category20()
          .domain(dataList)

      range = switch
        when axis == XAXIS then [padding.text_left, width - padding.right]
        when axis == YAXIS then [height - padding.bottom, padding.top]

      scale = d3.scale.ordinal()
        .domain(dataList)
        .rangePoints(range)
      scale.type = ORDINAL

      return scale


    getScaleForProperty = (molecules, property, axis) ->

      dataList = _.pluck(molecules, property)

      type = inferPropsType(dataList)
      console.log 'type is: ', type
      scale = switch
        when type == 'number' then buildLinearNumericScale(dataList, axis)
        when type == 'string' then buildOrdinalStringScale(dataList, axis)

      return scale

    getXCoordFor = getScaleForProperty(molecules, currentPropertyX, XAXIS)
    getYCoordFor = getScaleForProperty(molecules, currentPropertyY, YAXIS)
    getColourFor = getScaleForProperty(molecules, currentPropertyColour, COLOUR)

    console.log 'color scale range: ', getColourFor.range()
    console.log 'color scale domain: ', getColourFor.domain()

    # --------------------------------------
    # Add axes
    # --------------------------------------
    xAxis = d3.svg.axis()
      .scale(getXCoordFor)
      .orient("bottom")
      .innerTickSize(-gridHeight)
      .tickPadding(padding.bottom / 3)

    svg.append("g")
      .attr("class", "x-axis")
      .attr("transform", "translate(0," + (height - padding.bottom) + ")")
      .call(xAxis)
      .append("text")
      .attr("class", "x-axis-label")
      .attr("x", width)
      .attr("y", -6)
      .style("text-anchor", "end")
      .text(currentPropertyX)

    yAxis = d3.svg.axis()
      .scale(getYCoordFor)
      .orient("left")
      .innerTickSize(-gridWidth)
      .tickPadding(padding.left / 3)

    svg.append("g")
      .attr("class", "y-axis")
      .attr("transform", "translate(" + (padding.left) + ", 0)")
      .call(yAxis)
      .append("text")
      .attr("class", "y-axis-label")
      .attr("x", 0)
      .attr("y", padding.top - 6 )
      .text(currentPropertyY)

    # --------------------------------------
    # Draw dots
    # --------------------------------------
    calculateDotsCoordinates = ->
      svg.selectAll("circle.dot")
        .attr("cx", (d) -> getXCoordFor(d[currentPropertyX]))
        .attr("cy", (d) -> getYCoordFor(d[currentPropertyY]))
        .attr("fill", (d) -> getColourFor(d[currentPropertyColour]))

    svg.selectAll("dot")
      .data(molecules)
      .enter().append("circle")
      .attr("class", "dot")
      .attr("r", 10)

    calculateDotsCoordinates()
    # --------------------------------------
    # Draw texts
    # --------------------------------------
    calculateTextsCoordinates = ->
      svg.selectAll("text.dot-label")
        .attr("transform", (d) ->
          return "translate(" + getXCoordFor(d[currentPropertyX]) + ',' + getYCoordFor(d[currentPropertyY]) + ")" )

    svg.selectAll("dot-label")
      .data(molecules)
      .enter().append("text")
      .attr("class", "dot-label")
      .attr("font-size", "10px")
      .text((d) -> d[labelerProperty])

    calculateTextsCoordinates()
    # --------------------------------------
    # Zoom
    # --------------------------------------
    handleZoom = ->
      console.log 'scale: ' + zoom.scale()
      console.log 'translation: ' + zoom.translate()
      svg.select(".x-axis").call(xAxis)
      svg.select(".y-axis").call(yAxis)
      calculateDotsCoordinates()
      calculateTextsCoordinates()

    zoom = d3.behavior.zoom()
      .x(getXCoordFor)
      .y(getYCoordFor)
      .on("zoom", handleZoom)

    mainContainer.call(zoom)

    # --------------------------------------
    # Axes selectors
    # --------------------------------------
    $(@el).find(".select-xaxis").on "change", () ->

      if !@value?
        return

      currentPropertyX = @value
      console.log 'x axis: ', currentPropertyX
      resetZoom()

      getXCoordFor = getScaleForProperty(molecules, currentPropertyX, XAXIS)
      console.log 'scale type: ', getXCoordFor.type
      xAxis.scale(getXCoordFor)
      zoom.x(getXCoordFor)

      t = svg.transition().duration(1000)

      t.selectAll("g.x-axis")
        .call(xAxis)
      t.selectAll('text.x-axis-label')
        .text(currentPropertyX)
      t.selectAll("circle.dot")
        .attr("cx", (d) -> getXCoordFor(d[currentPropertyX]))
      t.selectAll("text.dot-label")
        .attr("transform", (d) ->
          return "translate(" + getXCoordFor(d[currentPropertyX]) + ',' +
          getYCoordFor(d[currentPropertyY]) + ")" )

    $(@el).find(".select-yaxis").on "change", () ->

      if !@value?
        return

      currentPropertyY = @value
      console.log 'y axis: ', currentPropertyY
      resetZoom()

      getYCoordFor = getScaleForProperty(molecules, currentPropertyY, YAXIS)
      console.log 'scale type: ', getYCoordFor.type
      yAxis.scale(getYCoordFor)
      zoom.y(getYCoordFor)

      t = svg.transition().duration(1000)

      t.selectAll("g.y-axis")
        .call(yAxis)
      t.selectAll('text.y-axis-label')
        .text(currentPropertyY)
      t.selectAll("circle.dot")
        .attr("cy", (d) -> getYCoordFor(d[currentPropertyY]))
      t.selectAll("text.dot-label")
        .attr("transform", (d) ->
          return "translate(" + getXCoordFor(d[currentPropertyX]) + ',' +
          getYCoordFor(d[currentPropertyY]) + ")" )

    $(@el).find(".select-colour").on "change", () ->

      if !@value?
        return

      currentPropertyColour = @value
      console.log 'colour axis: ', currentPropertyColour

      getColourFor = getScaleForProperty(molecules, currentPropertyColour, COLOUR)

      t = svg.transition().duration(1000)

      t.selectAll("circle.dot")
        .attr("fill", (d) -> getColourFor(d[currentPropertyColour]))

    # --------------------------------------
    # Reset zoom
    # --------------------------------------
    resetZoom = ->
      zoom.scale(1)
      zoom.translate([0,0])
      handleZoom()

    $(@el).find(".reset-zoom-btn").click ->

      resetZoom()



