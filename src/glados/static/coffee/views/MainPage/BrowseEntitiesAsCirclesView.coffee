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

      VIS_WIDTH = $(@el).width()
      VIS_HEIGHT = VIS_WIDTH


      mainContainer = d3.select(@$vis_elem.get(0))
        .append('svg')
          .attr('class', 'mainSVGCirclesContainer')
          .attr('width', VIS_WIDTH)
          .attr('height', VIS_HEIGHT)

      sizes = []
      names = []
      bubbleData =
        'children': []

      for key, value of data

        dataItem = {}
        dataItem.entity = key
        dataItem.count = value

        names.push key
        sizes.push value
        bubbleData.children.push(dataItem)

      console.log 'bubbleData: ', bubbleData

      bubble = d3.layout.pack()
       .size([VIS_WIDTH, VIS_HEIGHT])
       .padding(1.5)

      nodes = bubble.nodes(bubbleData)

      console.log 'nodes:', nodes
















      

#      dataMin= d3.min sizes
#      dataMax = d3.max sizes
#
#      tam =  d3.scale.ordinal()
#        .domain([dataList])
#        .range([10, 20, 30, 40, 50, 60, 70])
#
#      pack = d3.layout.pack()
#        .size([VIS_WIDTH, VIS_HEIGHT])
#        .padding(1.5)
#
#
#
#      mainContainer.selectAll('circle')
#        .data(dataList)
#        .enter()
#        .append('circle')
#          .attr('transform', 'translate(0, 0)')
#          .attr('cx', (d, i) -> 50 + i * 80)
#          .attr('cy', 400)
#          .attr('r', 30)
#          .attr('fill', 'orange')


















