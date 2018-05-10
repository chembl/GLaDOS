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
      @FOCUS = @ROOT
      @MAX_LINE_HEIGHT = 15
      @LABEL_LEVELS_TO_SHOW = 3

      # ------------ helper functions --------------- #

      wrapText = (d) ->
        self = d3.select(@)
        textLength = self.node().getComputedTextLength()
        text = self.text()
        arcWidth = getRadius(d.y + d.dy) - getRadius(d.y) - 5

        wrappedText = glados.Utils.Text.getTextForEllipsis(text, textLength, arcWidth)
        self.text wrappedText

      appendLabelText = (d, parent) ->
        path = d3.select(parent)

        text = path.append('text')
          .classed('sunburst-text', true)
          .attr('dx', '5px')
          .attr('dy', '.4em')
          .attr('x', (d) -> getRadius(d.y))
          .text((d) -> d.name)
          .attr('transform', (d) ->
            'rotate(' + thisView.computeTextRotation(d, getAngle) + ')'
          )

        if not textFitsInArc(d)
          text.attr('opacity', 0)

        text.each(wrapText)

      textFitsInArc = (d) ->
        arcHeight = getRadius(d.y) * getAngle(d.dx)
        return arcHeight > thisView.MAX_LINE_HEIGHT

      # ------------ end of helper functions --------------- #

      # ------------ scales --------------- #

      getAngle = d3.scale.linear()
        .range([0, 2 * Math.PI])

      getRadius = d3.scale.pow()
        .exponent(0.5)
        .range([0, @RADIUS])

      color = d3.scale.ordinal()
        .range([
            '#0a585b',
            '#077c80',
            '#0d343a',
            '#2ba3a5',
            '#6fc7c6',
            '#c4e6e5',
            '#fdabbc',
            '#f9849d',
            '#e95f7e',
            '#cc4362',
            '#a03a50'
        ])

      partition = d3.layout.partition()
        .value (d) -> d.size

      arc = d3.svg.arc()
        .startAngle (d) ->  return Math.max(0, Math.min(2 * Math.PI, getAngle(d.x)))
        .endAngle (d) -> return Math.max(0, Math.min(2 * Math.PI, getAngle(d.x + d.dx)))
        .innerRadius (d) -> return Math.max(0, getRadius(d.y))
        .outerRadius (d) -> return Math.max(0, getRadius(d.y + d.dy))

      nodes = partition.nodes(@ROOT)

      mainSunburstContainer = d3.select @$vis_elem[0]
        .append('svg')
          .attr('class', 'mainEntitiesContainer')
          .attr('width', @VIS_WIDTH)
          .attr('height', @VIS_HEIGHT)
          .append("g")
            .attr("transform", "translate(" + @VIS_WIDTH / 2 + "," + (@VIS_HEIGHT / 2) + ")")

      sunburstGroup = mainSunburstContainer.selectAll('g')
        .data(nodes)
        .enter().append('g')

      paths = sunburstGroup.append('path')
        .classed('arc-path', true)
        .attr('d', arc)
        .style 'fill', (d) ->
          color (if d.children then d else d.parent).name

#     append labels
      sunburstGroup.each (d) ->

        shouldCreateLabel = d.depth - thisView.FOCUS.depth <= thisView.LABEL_LEVELS_TO_SHOW

        if shouldCreateLabel
          appendLabelText(d, @)

      # --- click handling --- #
      click = (d) ->

        # if focus changes
        if thisView.FOCUS != d

          d3.selectAll('.sunburst-text').transition().attr("opacity", 0)
          thisView.FOCUS = d
          thisView.fillBrowseButton(d)

          #create labels if focus changes
          sunburstGroup.each (d) ->

            f = thisView.FOCUS
            text = d3.select(@).select('.sunburst-text')
            shouldCreateLabel = d.depth - f.depth <= thisView.LABEL_LEVELS_TO_SHOW and d.x >= f.x and d.x < (f.x + f.dx) and text.empty()

            if shouldCreateLabel
              appendLabelText(d, @)

#       function for interpolating scales
        arcTween  = (d) ->
          xd = d3.interpolate(getAngle.domain(), [d.x, d.x + d.dx])
          yd = d3.interpolate(getRadius.domain(), [d.y, 1])
          yr = d3.interpolate(getRadius.range(), [ (if d.y then 15 else 0), thisView.RADIUS])

          return (d, i) ->
            if i then ((t) -> arc d)
            else ((t) ->
              getAngle.domain xd(t)
              getRadius.domain(yd(t)).range yr(t)
              return arc d
            )

        # arcs and text transition
        paths.transition()
          .duration(700)
          .attrTween('d', arcTween(d))
          .each 'end', (e, i) ->
            f = thisView.FOCUS
            path = d3.select(@)

            if e.depth >= f.depth and e.depth - f.depth <= 3 and  e.x >= d.x and e.x < (d.x + d.dx)

              arcText = d3.select(@parentNode).select('.sunburst-text')

              if not arcText.empty()
                arcText.text((d) -> d.name)
                  .each(wrapText)

              if textFitsInArc(e)
                arcText.transition()
                  .duration(400)
                  .attr('opacity', 1)
                  .attr('transform', ->
                    'rotate(' + thisView.computeTextRotation(e, getAngle) + ')'
                  ).attr 'x', (d) ->
                    getRadius(d.y)
                return

      # --- end of click handling --- #

      paths.on('click',  click)

    computeTextRotation: (d, getAngle) ->
      (getAngle(d.x + d.dx / 2) - (Math.PI / 2)) / Math.PI * 180

    fillBrowseButton: (d) ->
      $button = $('.BCK-browse-button')

      button_template = $('#' + $button.attr('data-hb-template'))

      if d.name == 'root'
        $button.html Handlebars.compile(button_template.html())
          node_name: ''
          node_link: '/g/#browse/targets'
      else
        $button.html Handlebars.compile(button_template.html())
          node_name: d.name
          node_link: d.link

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