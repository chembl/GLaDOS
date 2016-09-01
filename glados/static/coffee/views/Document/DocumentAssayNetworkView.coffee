# View that renders the Document assay network section
# from the Document report card
# load CardView first!
# also make sure the html can access the handlebars templates!
DocumentAssayNetworkView = CardView.extend

  render: ->
    console.log('render!')

    # --------------------------------------
    # Data
    # --------------------------------------
    assays = {
      "nodes": [
        {
          "name": "A",
          "assay_type": "A",
          "assay_test_type", "In vivo",
          "description": "desc node a"
        },
        {
          "name": "B",
          "assay_type": "F",
          "assay_test_type", "In vitro",
          "description": "desc node b"
        },
        {
          "name": "C",
          "assay_type": "B",
          "assay_test_type", "Ex vivo",
          "description": "desc node c"
        }
      ],
      "links": [
        {
          "source": 0,
          "target": 1,
          "value": 10
        },
        {
          "source": 0,
          "target": 2,
          "value": 20
        },
        {
          "source": 1,
          "target": 2,
          "value": 30
        }
      ]
    }

    # --------------------------------------
    # auxiliary functions
    # --------------------------------------

    color_value = 'solid';

    assayType2Color =
      'A': Color({r: 255, g: 0, b: 0})
      'F': Color({r: 0, g: 255, b: 0})
      'B': Color({r: 0, g: 0, b: 255})
      null: Color({r: 0, g: 0, b: 0})

    assayTestType2Color =
      'In vivo': Color({r: 255, g: 0, b: 0}),
      'In vitro': Color({r: 0, g: 255, b: 0}),
      'Ex vivo': Color({r: 0, g: 0, b: 255}),
      null: Color({r: 0, g: 0, b: 0})


    colorise =  (d) ->
      color1 = null
      color2 = null

      if color_value == 'solid'
          return '#0000FF'

      if color_value=='assay_type'

          as1 = nodes[d.x].assay_type
          as2 = nodes[d.y].assay_type
          color1 = assayType2Color[as1].clone()
          color2 = assayType2Color[as2].clone()

      else

          as1 = nodes[d.x].assay_test_type;
          as2 = nodes[d.y].assay_test_type;
          color1 = assayTestType2Color[as1].clone()
          color2 = assayTestType2Color[as2].clone()

      if color1.hexString() != color2.hexString()
          color1.mix(color2)

      return color1.hexString()

    tip = d3.tip()
          .attr('class', 'd3-tip')
          .html( (d) ->
              if typeof d == 'string' || d instanceof String
                  return d
              return d.z
          )

    mouseover= (p) ->
      tip.show(p)
      d3.selectAll(".dan-row text").classed("active", (d, i) -> i == p.y)
      d3.selectAll(".dan-column text").classed("active", (d, i) ->  i == p.x )

    mouseout = ->
      tip.hide()
      d3.selectAll("text").classed("active", false)
      d3.selectAll("text").classed("linked", false)


    fillRow = (row) ->
      cell = d3.select(this).selectAll(".dan-cell")
              .data(row)
              .enter().append("rect")
              .attr("class", "cell")
              .attr("x", (d) -> x(d.x) )
              .attr("width", x.rangeBand())
              .attr("height", x.rangeBand())
              .style("fill-opacity", (d) -> d.z/max)
              .style("fill", colorise)
              .on("mouseover", mouseover)
              .on("mouseout", mouseout);





    # --------------------------------------
    # pre-configuration
    # --------------------------------------

    margin =
      top: 100
      right: 0
      bottom: 10
      left: 100

    width = 600
    height = 600

    x = d3.scale.ordinal().rangeBands([0, width])
    z = d3.scale.linear().domain([0, 4]).clamp(true)

    svg = d3.select('#AssayNetworkVisualisationContainer')
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append("g")
              .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    svg.call(tip)

    # --------------------------------------
    # Work with data
    # --------------------------------------

    matrix = []
    nodes = assays.nodes
    total = 0
    n = nodes.length

    # Compute index per node.
    nodes.forEach (node, i) ->
      node.index = i
      node.count = 0
      matrix[i] = d3.range(n).map((j) ->
        {
          x: j
          y: i
          z: 0
        }
      )

    # Convert links to matrix; count character occurrences.
    assays.links.forEach (link) ->
      matrix[link.source][link.target].z = link.value
      matrix[link.target][link.source].z = link.value
      nodes[link.source].count += link.value
      nodes[link.target].count += link.value
      total += link.value

    orders =
      group: d3.range(n).sort((a, b) ->
        nodes[b].group - (nodes[a].group)
      )
      name: d3.range(n).sort((a, b) ->
        d3.ascending nodes[a].name, nodes[b].name
      )
      count: d3.range(n).sort((a, b) ->
        nodes[b].count - (nodes[a].count)
      )
      assay_type: d3.range(n).sort((a, b) ->
        d3.ascending nodes[a].assay_type, nodes[b].assay_type
      )
      assay_test_type: d3.range(n).sort((a, b) ->
        d3.ascending nodes[a].assay_test_type, nodes[b].assay_test_type
      )

    console.log 'Matrix:'
    console.log matrix

    console.log 'Nodes:'
    console.log nodes

    console.log 'Orders:'
    console.log orders

    max = d3.max assays.links, (d) -> d.value

    # The default sort order.
    x.domain(orders.count)

    svg.append("rect")
      .attr("class", "background")
      .style("fill", "white")
      .attr("width", width)
      .attr("height", height)

    row = svg.selectAll('.dan-row')
          .data(matrix)
          .enter()
          .append('g').attr('class', 'dan-row')
          .attr('transform', (d, i) ->
            'translate(0,' + x(i) + ')'
    ).each(fillRow)

    row.append("line")
      .attr("x2", width);

    row.append("text")
      .attr("x", -6)
      .attr("y", x.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "end")
      .text( (d, i) ->  nodes[i].name + '.' + nodes[i].assay_type )
      .on("mouseover", (row, j) ->
          tip.show(nodes[j].description)
          d3.selectAll(".row text").classed("linked", (d, i) -> i == j)
      )
      .on("mouseout", mouseout)
      .on("click", (d, i) -> window.location = "https://www.ebi.ac.uk/chembl/assay/inspect/" + nodes[i].name)

    column = svg.selectAll(".dan-column")
      .data(matrix)
      .enter().append("g")
      .attr("class", "dan-column")
      .attr("transform", (d, i) -> "translate(" + x(i) + ")rotate(-90)" )

    column.append("line")
      .attr("x1", -width)

    column.append("text")
      .attr("x", 6)
      .attr("y", x.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "start")
      .text((d, i) -> nodes[i].name + '.' + nodes[i].assay_type )
      .on("mouseover", (col, j) ->
          tip.show(nodes[j].description)
          d3.selectAll(".column text").classed("linked", (d, i) -> i == j)
      )
      .on("mouseout", mouseout)
      .on("click", (d, i) -> window.location = "https://www.ebi.ac.uk/chembl/assay/inspect/" + nodes[i].name)



