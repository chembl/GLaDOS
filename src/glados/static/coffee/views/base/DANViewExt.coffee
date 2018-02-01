# This is a base object for the document asssay network extension, extend a view in backbone with this object
# to get the functionality for handling the assay netweork visualisation
# this way allows to easily handle multiple inheritance in the models.
DANViewExt =

  paintMatrix: ->
    # --------------------------------------
    # Data
    # --------------------------------------

    #    assays = {
    #      "nodes": [
    #        {
    #          "name": "A",
    #          "assay_type": "A",
    #          "assay_test_type", "In vivo",
    #          "description": "desc node a"
    #        },
    #        {
    #          "name": "B",
    #          "assay_type": "F",
    #          "assay_test_type", "In vitro",
    #          "description": "desc node b"
    #        },
    #        {
    #          "name": "C",
    #          "assay_type": "B",
    #          "assay_test_type", "Ex vivo",
    #          "description": "desc node c"
    #        }
    #      ],
    #      "links": [
    #        {
    #          "source": 0,
    #          "target": 1,
    #          "value": 10
    #        },
    #        {
    #          "source": 0,
    #          "target": 2,
    #          "value": 20
    #        },
    #        {
    #          "source": 1,
    #          "target": 2,
    #          "value": 30
    #        }
    #      ]
    #    }

    assays = @model.get('graph')
    console.log 'ASSAYS: ', assays
    numNodes = assays.nodes.length

    if !assays?
      #do something here!
      return
    # --------------------------------------
    # auxiliary functions
    # --------------------------------------

    color_value = 'solid';

    assayType2Color =
      'A': Color(glados.Settings.VIS_COLORS.RED2),
      'F': Color(glados.Settings.VIS_COLORS.RED3),
      'B': Color(glados.Settings.VIS_COLORS.TEAL3),
      'P': Color(glados.Settings.VIS_COLORS.TEAL4),
      'T': Color(glados.Settings.VIS_COLORS.BLUE2),
      'U': Color(glados.Settings.VIS_COLORS.ORANGE2),
      null: Color(glados.Settings.VIS_COLORS.GREY1)

    assayTestType2Color =
      'In vivo': Color(glados.Settings.VIS_COLORS.RED2),
      'In vitro': Color(glados.Settings.VIS_COLORS.TEAL3),
      'Ex vivo': Color(glados.Settings.VIS_COLORS.ORANGE2),
      null: Color(glados.Settings.VIS_COLORS.GREY1)

    mouseover= (p) ->
      d3.selectAll(".dan-row text").classed("active", (d, i) -> i == p.y)
      d3.selectAll(".dan-column text").classed("active", (d, i) ->  i == p.x )

    mouseout = ->
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
              .on("mouseout", mouseout)


    colorise = (d) ->
      color1 = null
      color2 = null

      if color_value == 'solid'
          return glados.Settings.VIS_COLORS.TEAL3

      if color_value=='assay_type'

          as1 = nodes[d.x].assay_type
          as2 = nodes[d.y].assay_type
          color1 = assayType2Color[as1].clone()
          color2 = assayType2Color[as2].clone()

      else

          as1 = nodes[d.x].assay_test_type
          as2 = nodes[d.y].assay_test_type
          color1 = assayTestType2Color[as1].clone()
          color2 = assayTestType2Color[as2].clone()

      if color1.hexString() != color2.hexString()
          color1.mix(color2)

      return color1.hexString()


    # --------------------------------------
    # pre-configuration
    # --------------------------------------

    margin =
      top: 90
      right: 0
      bottom: 10
      left: 90

    elemWidth = $(@el).width()

    # when it is embedded the visualization width must be taken based on the window size!
    if EMBEDED?
      baseWidth = window.innerWidth
    else
      baseWidth = elemWidth

    console.log 'BASE WIDTH: ', baseWidth

    scaleWidthFor = d3.scale.linear()
      .domain([1, 20])
      .range([0.1 * baseWidth, 0.8 * baseWidth])
      .clamp(true)

    width = scaleWidthFor numNodes

    height = width

    x = d3.scale.ordinal().rangeBands([0, width])
    z = d3.scale.linear().domain([0, 4]).clamp(true)

    svg = d3.select('#' + @$vis_elem.attr('id'))
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

#    svg.call(tip)

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
    console.log 'ORDERS: ', orders

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
            'translate(0,' + x(i) + ')')
          .each(fillRow)

    row.append("line")
      .attr("x2", width);

    row.append("text")
      .attr("x", -6)
      .attr("y", x.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "end")
      .attr('style', 'font-size:8px;')
      .attr('text-decoration', 'underline')
      .attr('cursor', 'pointer')
      .attr('fill', '#1b5e20')
      .attr('class', 'tooltipped')
      .attr('data-position', 'bottom')
      .attr('data-delay', '50')
      .attr('data-tooltip', (d, i) -> nodes[i].description )
      .text( (d, i) ->  nodes[i].name + '.' + nodes[i].assay_type )
      .on("mouseover", (row, j) ->
          d3.selectAll(".row text").classed("linked", (d, i) -> i == j)
      )
      .on("mouseout", mouseout)
      .on("click", (d, i) -> window.location = Assay.get_report_card_url(nodes[i].name))

    column = svg.selectAll(".dan-column")
      .data(matrix)
      .enter().append("g")
      .attr("class", "dan-column")
      .attr("transform", (d, i) -> "translate(" + x(i) + ")rotate(-90)" )

    column.append("line")
      .attr("x1", -width)

    column.append("text")
      .attr("x", 0)
      .attr("y", x.rangeBand() / 2)
      .attr("dy", ".32em")
      .attr("text-anchor", "start")
      .attr('style', 'font-size:8px;')
      .attr('text-decoration', 'underline')
      .attr('cursor', 'pointer')
      .attr('fill', '#1b5e20')
      .attr('class', 'tooltipped')
      .attr('data-position', 'bottom')
      .attr('data-delay', '50')
      .attr('data-tooltip', (d, i) -> nodes[i].description )
      .text((d, i) -> nodes[i].name + '.' + nodes[i].assay_type )
      .on("mouseover", (col, j) ->
          d3.selectAll(".column text").classed("linked", (d, i) -> i == j)
      )
      .on("mouseout", mouseout)
      .on("click", (d, i) -> window.location = Assay.get_report_card_url(nodes[i].name))

    $('.tooltipped').tooltip()

    # --------------------------------------
    # Controls
    # --------------------------------------

    # --------------------------------------
    # Colour selector
    # --------------------------------------

    $(@el).find(".select-colours").on "change", () ->

      if !@value?
        return

      color_value = @value
      color()

      $('.legend-container').empty()

      if color_value=='solid'
          return
      if color_value=='assay_type'
          palette = assayType2Color
      else
          palette = assayTestType2Color;
      $('.legend-container').append('<div class="legend">Legend:</div>')
      draw_legend(palette)

    color = () ->

      t = svg.transition().duration(2500)

      t.selectAll(".cell")
      .style("fill", colorise)

    # --------------------------------------
    # Order selector
    # --------------------------------------
    $(@el).find(".select-order").on "change", () ->

      if !@value?
        return

      order(@value)

    order = (value) ->

      console.log 'change order!'
      console.log orders[value]
      x.domain(orders[value])

      t = svg.transition().duration(2500)

      t.selectAll(".dan-row")
          .delay((d, i) -> x(i) * 4 )
          .attr("transform", (d, i) -> "translate(0," + x(i) + ")" )
        .selectAll(".cell")
          .delay((d) -> x(d.x) * 4)
          .attr("x", (d) -> x(d.x))

      t.selectAll(".dan-column")
        .delay((d, i) -> x(i) * 4)
        .attr("transform", (d, i) -> "translate(" + x(i) + ")rotate(-90)")


    draw_legend = (data) ->
      legend = d3.selectAll(".legend-container").append("svg")
        .attr("class", "legend")
        .attr("width", 100)
        .attr("height", 150)
        .selectAll("g")
        .data($.map(data, (val, key) -> { label: key, color: val } ))
        .enter().append("g")
        .attr("transform", (d, i) -> "translate(0," + i * 20 + ")" )

      legend.append("rect")
        .attr("width", 18)
        .attr("height", 18)
        .style("fill", (d) -> d.color.hexString() )

      legend.append("text")
        .attr("x", 24)
        .attr("y", 9)
        .attr("dy", ".35em")
        .text( (d) -> d.label)









