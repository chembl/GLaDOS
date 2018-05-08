glados.useNameSpace 'glados.views.MainPage',
  ZoomableSunburstView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      @$vis_elem = $(@el).find('.BCK-sunburst-container')
      @setUpResponsiveRender()
      @model.on 'change', @render, @

    render: ->
      thisView = @

      if @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
        return

      if @model.get('state') == glados.models.Aggregations.Aggregation.States.LOADING_BUCKETS
        return

      if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE
        return

      @showCardContent()
      @$vis_elem.empty()

      @ROOT = @getBucketData()
      @VIS_WIDTH = $(@el).width() - 10
      @VIS_HEIGHT = $(@el).height() - 15
      @RADIUS = (Math.min(@VIS_WIDTH, @VIS_HEIGHT) / 2)

      formatNumber = d3.format(",d")

      x = d3.scale.linear()
        .range([0, 2 * Math.PI])

      y = d3.scale.sqrt()
        .range([0, @RADIUS])

      color = d3.scale.category10()

      partition = d3.layout.partition()
        .value (d) -> d.size

      arc = d3.svg.arc()
        .startAngle (d) ->  return Math.max(0, Math.min(2 * Math.PI, x(d.x)))
        .endAngle (d) -> return Math.max(0, Math.min(2 * Math.PI, x(d.x + d.dx)))
        .innerRadius (d) -> return Math.max(0, y(d.y))
        .outerRadius (d) -> return Math.max(0, y(d.y + d.dy))

      nodes = partition.nodes(@ROOT)

      mainSunburstContainer = d3.select @$vis_elem[0]
        .append('svg')
          .attr('class', 'mainEntitiesContainer')
          .attr('width', @VIS_WIDTH)
          .attr('height', @VIS_HEIGHT)

      sunburstGroup = mainSunburstContainer.append("g")
        .attr("transform", "translate(" + @VIS_WIDTH / 2 + "," + (@VIS_HEIGHT / 2) + ")")

      click = (d) ->

        sunburstGroup.transition()
          .duration(700)
          .tween('scale', ->
            xd = d3.interpolate(x.domain(), [
              d.x
              d.x + d.dx
            ])

            yd = d3.interpolate(y.domain(), [
              d.y
              1
            ])

            yr = d3.interpolate(y.range(), [
              if d.y then 20 else 0
              thisView.RADIUS
            ])

            return (t) ->
              x.domain xd(t)
              y.domain(yd(t)).range yr(t)
          ).selectAll('path')
            .attrTween 'd', (d) ->
              ->
                arc d

      sunburstGroup.selectAll("path")
        .data(nodes)
        .enter().append("path")
        .attr("d", arc)
        .style("fill", (d) -> color(d.name) )
        .style("stroke", 'white')
        .on('click',  click)

      d3.select('.BCK-sunburst-container').style("height", @VIS_HEIGHT + "px")

    getBucketData: ->
      receivedBuckets = @model.get 'bucket_data'
      id = 0

      fillNode = (parent_node, input_node) ->

        node = {}
        node.name = input_node.key
        node.size = input_node.doc_count
        node.parent_id = parent_node.id
        node.id = id
        node.link = input_node.link
        node.depth = parent_node.depth + 1
        node.parent = parent_node

        parent_node.children.push(node)

        if input_node.children?
          node.children = []
          for child in input_node.children['buckets']
            id++
            fillNode(node, child)

      if receivedBuckets?
        root = {}
        root.depth = 0
        root.name = 'root'
        root.id = id

        if receivedBuckets.children?
          root.children = []
          for node in receivedBuckets.children['buckets']
            id++
            fillNode(root, node)

      return root

    showCardContent: ->
      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.card-content').show()