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
      @$vis_elem.empty()

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
        .range([2, 200])
        .domain([min, max])

      for key, value of data
        dataItem = {}
        dataItem.key = key
        dataItem.value = sizeScale(value)

        bubbleData.children.push(dataItem)

      colour = d3.scale.ordinal()
       .domain(sizes)
       .range([
          '#D33C60',
          '#084044',
          '#0d595f',
          '#75D8D5',
          '#8E122F',
          '#09979B',
          '#FE7F9D',
      ])

#     pack layout
      diameter = Math.min(VIS_HEIGHT, VIS_WIDTH)
      pack = d3.layout.pack()
       .size([VIS_WIDTH  , VIS_HEIGHT ])
       .padding(PADDING)
       .sort((a, b) -> (a.value - b.value*0.4))

      nodes = pack.nodes(bubbleData)

      console.log 'nodes'

#     draw circles
      circles = mainContainer.selectAll('circle')
        .data(nodes)
        .enter()
        .append('circle')
          .attr('class', 'node')
          .attr('cx', (d) -> d.x + PADDING/2)
          .attr('cy', (d) -> d.y + PADDING/2)
          .attr('r', (d) -> d.r )
          .attr('fill', (d) -> colour(d.value))


#     make first node transparent
      firstNode = d3.select('.node')
      .style('fill', 'none')
      .style('stroke', 'none')















