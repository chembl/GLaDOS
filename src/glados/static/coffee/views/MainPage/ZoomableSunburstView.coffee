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
      @MAX_LINE_HEIGHT = 12
      @LABEL_LEVELS_TO_SHOW = 3

      # ------------ helper functions --------------- #

      wrapText = (d) ->
        self = d3.select(@)
        textLength = self.node().getComputedTextLength()
        text = self.text()
        textLimit = self.attr('data-limit-for-text')

        wrappedText = glados.Utils.Text.getTextForEllipsis(text, textLength, textLimit)
        self.text wrappedText

      appendLabelText = (d, parent) ->
        group = d3.select(parent)
        path = d3.select(parent).select('.text-path')
        pathID = path.attr('id')

        innerRadius = arc.innerRadius() (d)
        outerRadius = arc.outerRadius() (d)
        arcRadius = outerRadius - innerRadius

        startAngle =  textArc.startAngle() (d)
        endAngle = textArc.endAngle() (d)
        textArcAngle = endAngle - startAngle
        textArcRadius = textArc.innerRadius() (d)

        arcLength = textArcAngle * textArcRadius

        paintAlongArc = arcLength > arcRadius
        limitForText =  if paintAlongArc then arcLength else arcRadius

        if limitForText < 10
          return

        if paintAlongArc

          text = group.append('text')
            .classed('sunburst-text', true)
            .append('textPath')
            .attr('startOffset', '25%')
            .style("text-anchor","middle")
            .attr("xlink:href", "##{pathID}")
            .attr("href", "##{pathID}")
            .text((d) -> d.name)
            .attr('data-limit-for-text', limitForText - 4)

        else

          text = group.append('text')
            .classed('sunburst-text', true)
            .attr('dx', '5px')
            .attr('dy', '.4em')
            .attr('x', (d) -> getRadius(d.y))
            .text((d) -> d.name)
            .attr('data-limit-for-text', limitForText)
            .attr('transform', (d) ->
              'rotate(' + thisView.computeTextRotation(d, getAngle) + ')'
            )

          if not textFitsInArc(d)
            text.attr('opacity', 0)

        text.each(wrapText)

      textFitsInArc = (d) ->

        startAngle =  arc.startAngle() (d)
        endAngle = arc.endAngle() (d)
        angle = endAngle - startAngle

        radius = arc.innerRadius() (d)
        arcLength = angle * radius

        return arcLength > thisView.MAX_LINE_HEIGHT

      # ------------ end of helper functions --------------- #

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

      textArc = d3.svg.arc()
        .startAngle (d) ->  return Math.max(0, Math.min(2 * Math.PI, getAngle(d.x)))
        .endAngle (d) -> return Math.max(0, Math.min(2 * Math.PI, getAngle(d.x + d.dx)))
        .innerRadius (d) -> return Math.max(0, getRadius(d.y + d.dy/3))
        .outerRadius (d) -> return Math.max(0, getRadius(d.y + d.dy/3))

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

      textPaths = sunburstGroup.append('path')
        .classed('text-path', true)
        .attr('id', (d, i) -> "text-path-#{i}")
        .classed('text-path', true)
        .attr('d', textArc)
        .style('stroke', 'grey')

#     append labels
      sunburstGroup.each (d) ->
        shouldCreateLabel = d.depth - thisView.FOCUS.depth <= thisView.LABEL_LEVELS_TO_SHOW

        if shouldCreateLabel
          appendLabelText(d, @)


#     --- hover handling --- #
      @numTooltips = 0
      renderQTip = ($elem, d, i) ->
        qtipConfigured = $elem.attr('data-qtip-configured') == 'yes'

        if thisView.numTooltips > 10
          glados.Utils.Tooltips.destroyAllTooltips(thisView.$vis_elem)
          thisView.numTooltips = 0

        if not qtipConfigured

          name = d.name
          count = d.size
          text = '<b>' + name + '</b>' +
            '<br>' + '<b>' + "Count:  " + '</b>' + count

          qtipConfig =
            id: 'tooltip-' + i
            content:
              text: text
            show:
              solo: true
            style:
              classes:'qtip-light'
            position:
              my: 'bottom left'
              at: 'top right'
              target: 'mouse'
              adjust:
                y: -5
                x: 5

          $elem.qtip(qtipConfig)
          $elem.attr('data-qtip-configured', 'yes')
          thisView.numTooltips++
          $elem.trigger('mouseover')

        return

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
            shouldCreateLabels = text.empty() and d.depth - f.depth <= thisView.LABEL_LEVELS_TO_SHOW and d.x >= f.x and d.x < (f.x + f.dx)

            if shouldCreateLabels
              appendLabelText(d, @)

#       function for interpolating scales in arc
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

#       function for interpolating scales in arc
        textArcTween  = (d) ->
          xd = d3.interpolate(getAngle.domain(), [d.x, d.x + d.dx])
          yd = d3.interpolate(getRadius.domain(), [d.y, 1])
          yr = d3.interpolate(getRadius.range(), [ (if d.y then 15 else 0), thisView.RADIUS])

          return (d, i) ->
            if i then ((t) -> textArc d)
            else ((t) ->
              getAngle.domain xd(t)
              getRadius.domain(yd(t)).range yr(t)
              return textArc d
            )

        # arcs and text transition
        textPaths.transition()
          .duration(700)
          .attrTween('d', textArcTween(d))

        paths.transition()
          .duration(700)
          .attrTween('d', arcTween(d))
          .each 'end', (e) ->

            shouldDoTransition = e.depth - d.depth <= thisView.LABEL_LEVELS_TO_SHOW and  e.x >= d.x and e.x < (d.x + d.dx)

            if shouldDoTransition

              arcText = d3.select(@parentNode).select('.sunburst-text')

              arcText.text((d) -> d.name)
                  .each(wrapText)

              arcText.transition()
                .duration(400)
                .attr('opacity', (e) ->
                  if textFitsInArc(e) then 1 else 0
                ).attr('transform', ->
                  'rotate(' + thisView.computeTextRotation(e, getAngle) + ')'
                ).attr 'x', (d) ->
                  getRadius(d.y)

      sunburstGroup.on('click',  click)
      sunburstGroup.on 'mouseover', (d, i) -> renderQTip($(@), d, i)

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