glados.useNameSpace 'glados.views.MainPage',
  BrowseEntitiesAsCirclesView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      @$vis_elem = $(@el).find('.BCK-circles-Container')
      @setUpResponsiveRender()
      @render()

    render: () ->
      thisView = @
      infoURL = "#{glados.Settings.GLADOS_BASE_PATH_REL}entities_records"

      fetchDatabasePromise = $.getJSON(infoURL)

      fetchDatabasePromise.fail ->
        console.log 'Fetching entities info from web services failed :('

      fetchDatabasePromise.done (response) ->
        thisView.renderCircles(response)

    renderCircles: (data) ->
      thisView = @
      thisView.$vis_elem.empty()

      VIS_WIDTH = $(@el).width()
      VIS_HEIGHT = $(@el).height()
      PADDING = VIS_WIDTH * 0.05

      mainContainer = d3.select(@$vis_elem.get(0))
        .append('svg')
        .attr('class', 'mainSVGCirclesContainer')
        .attr('width', VIS_WIDTH)
        .attr('height', VIS_HEIGHT)

      sizes = []
      names = []
      bubbleData =
        'name': 'entities'
        'children': []

#     Get an array with the sizes
      for key, value of data
        sizes.push value
        names.push key

      min = d3.min(sizes)
      max = d3.max(sizes)

#     Scale the sizes
      sizeScale = d3.scale.sqrt()
        .range([4, 200])
        .domain([min, max])

      for key, value of data
        dataItem = {}
        dataItem.name = key
        dataItem.value = sizeScale(value)
        dataItem.count = value

        bubbleData.children.push(dataItem)

      colour = d3.scale.ordinal()
        .domain(sizes)
        .range([
          '#FE7F9D',
          '#084044',
          '#8E122F',
          '#75D8D5',
          '#0d595f',
          '#09979B',
          '#D33C60',
        ])

#     pack layout
      diameter = Math.min(VIS_HEIGHT, VIS_WIDTH)
      pack = d3.layout.pack()
        .size([VIS_WIDTH, VIS_HEIGHT])
        .padding(PADDING)
        .sort((a, b) -> (a.value - b.value * 0.4))

      nodes = pack.nodes(bubbleData)

      console.log 'nodes', nodes

#     draw circles
      circles = mainContainer.selectAll('circle')
        .data(nodes)
        .enter()
        .append('circle')
        .attr('class', 'node')
        .attr('cx', (d) -> d.x + PADDING / 2)
        .attr('cy', (d) -> d.y + PADDING / 2)
        .attr('r', (d) -> d.r)
        .attr('fill', (d) -> colour(d.value))

      counts = mainContainer.selectAll('.count')
        .data(nodes)
        .enter()
        .append('text')
        .text((d) -> thisView.formatNumber(d.count))
        .attr('font-size', (d) -> d.r / 2)
        .attr('class', 'count')
        .attr('x', (d) -> d.x + PADDING / 2)
        .attr('y', (d) -> d.y + PADDING / 2)
        .attr('fill', 'white')

      labels = mainContainer.selectAll('.label')
        .data(nodes)
        .enter()
        .append('text')
        .attr('font-size', (d) -> d.r / 3)
        .text((d) -> d.name)
        .attr('class', 'label')
        .attr('x', (d) -> d.x + PADDING / 2)
        .attr('y', (d) -> d.y + PADDING / 2 + d.r / 3)
        .attr('fill', 'white')


#     make first node transparent
      firstNode = d3.select('.node')
        .style('fill', 'none')
        .style('stroke', 'none')

      firstcount = d3.select('.count')
        .style('fill', 'none')
        .style('stroke', 'none')

      firstlabel = d3.select('.label')
        .style('fill', 'none')
        .style('stroke', 'none')

    formatNumber: (number) ->
      formatted = number

      if number >= 1.0e+9
        formatted = number.toPrecision(2) / 1.0e+9 + "B"

      else if number >= 1.0e+6
        formatted = number.toPrecision(2) / 1.0e+6 + "M"

      else if number >= 1.0e+3
        formatted = number.toPrecision(2) / 1.0e+3 + "K"

      return formatted