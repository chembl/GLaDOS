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
    margin =
      top: 20
      right: 20
      bottom: 30
      left: 40

    labelerProperty = 'molecule_chembl_id'
    currentPropertyX = 'mol_wt'

    elemWidth = $(@el).width()
    height = width = 0.8 * elemWidth

    svg = d3.select('#' + @$vis_elem.attr('id'))
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    # --------------------------------------
    # Add background rectangle
    # --------------------------------------
    svg.append("rect")
      .attr("class", "background")
      .style("fill", "white")
      .attr("width", width)
      .attr("height", width)

    # --------------------------------------
    # scales
    # --------------------------------------
    buildLinearNumericScale = (objectList, currentProperty) ->

      minVal = Number.MAX_VALUE
      maxVal = Number.MIN_VALUE

      for obj in objectList
        value = obj[currentProperty]
        if value > maxVal
          maxVal = value
        if value < minVal
          minVal = value

      scaleDomain = [minVal, maxVal]

      return d3.scale.linear()
        .domain(scaleDomain)
        .range([0, width])

    getXCoordFor = buildLinearNumericScale( molecules, currentPropertyX)

    # --------------------------------------
    # Add axes
    # --------------------------------------
    xAxis = d3.svg.axis().scale(getXCoordFor).orient("bottom");

    svg.append("g")
      .attr("class", "x-axis")
      .attr("transform", "translate(0," + (height - 20) + ")")
      .call(xAxis)
      .append("text")
      .attr("class", "axis-label")
      .attr("x", width)
      .attr("y", -6)
      .style("text-anchor", "end")
      .text(currentPropertyX)

    # --------------------------------------
    # Draw dots
    # --------------------------------------
    svg.selectAll("dot")
      .data(molecules)
      .enter().append("circle")
      .attr("class", "dot")
      .attr("r", 3.5)
      .attr("cx", (d) -> getXCoordFor(d[currentPropertyX]))

    # --------------------------------------
    # Draw texts
    # --------------------------------------
    svg.selectAll("dot-label")
      .data(molecules)
      .enter().append("text")
      .attr("class", "dot-label")
      .attr("transform", (d) -> "translate(" + getXCoordFor(d[currentPropertyX]) + ")rotate(45)" )
      .attr("font-size", "10px")
      .text((d) -> d[labelerProperty] + ',' + d[currentPropertyX])

    # --------------------------------------
    # Axis selectors
    # --------------------------------------

    $(@el).find(".select-xaxis").on "change", () ->

      if !@value?
        return

      currentPropertyX = @value
      console.log 'x axis: ', currentPropertyX

      getXCoordFor = buildLinearNumericScale( molecules, currentPropertyX)
      xAxis = d3.svg.axis().scale(getXCoordFor).orient("bottom")

      t = svg.transition().duration(1000)

      t.selectAll("g.x-axis")
        .call(xAxis)
      t.selectAll('text.axis-label')
        .text(currentPropertyX)
      t.selectAll("circle.dot")
        .attr("cx", (d) -> getXCoordFor(d[currentPropertyX]))
      t.selectAll("text.dot-label")
        .attr("transform", (d) -> "translate(" + getXCoordFor(d[currentPropertyX]) + ")rotate(45)" )




