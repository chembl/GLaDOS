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
      console.log 'data: ', data

      @$vis_elem.empty()

      PADDING = 20
      VIS_WIDTH = $(@el).width()
      VIS_HEIGHT = $(@el).height()



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

#     Get data in correct format
      for key, value of data

        dataItem = {}
        dataItem.key = key
        dataItem.value = value

        names.push key
        sizes.push value
        bubbleData.children.push(dataItem)


#     pack layout
      diameter = Math.min(VIS_HEIGHT, VIS_WIDTH)
      pack = d3.layout.pack()
       .size([VIS_WIDTH - PADDING , VIS_HEIGHT - PADDING ])
       .padding(PADDING)


      nodes = pack.nodes(bubbleData)

      console.log '--Nodes:', nodes

#     draw circles
      node = mainContainer.selectAll('circle')
        .data(nodes)
        .enter()
        .append('circle')
          .attr('class', 'node')
          .attr('cx', (d) -> d.x + PADDING/2)
          .attr('cy', (d) -> d.y + PADDING/2)
          .attr('r', (d) -> d.r )
          .attr('stroke', 'orange')
          .attr('fill', 'none')

#     make first node transparent
      firstNode = d3.select('.node')
      .style('fill', 'none')
      .style('stroke', 'none')















