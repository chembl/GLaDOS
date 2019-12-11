glados.useNameSpace 'glados.views.MainPage',
  ZoomableSunburstView: Backbone.View\
  .extend(ResponsiviseViewExt)\
  .extend(glados.views.base.TrackView).extend

    initialize: ->

      @config = arguments[0].config
      console.log('@config: ', @config)
      @initTracking('ZoomableSunburst-ProteinClass', glados.views.base.TrackView.viewTypes.VISUALISATION)
      @$vis_elem = $(@el).find('.BCK-sunburst-container')
      @$vis_elem.attr('id', "sunburst-#{Math.floor((Math.random() * 10000) + 1)}")
      @setUpResponsiveRender()
      @model.on 'change', @render, @

    render: ->

      thisView = @

      @$vis_elem.empty()
      @showCardContent()

      @ROOT = @getTreeData()
      @VIS_WIDTH = $(@el).width() - 10
      @VIS_HEIGHT = $(@el).height() - 15
      @RADIUS = (Math.min(@VIS_WIDTH, @VIS_HEIGHT) / 2)
      @FOCUS = @ROOT
      @MAX_LINE_HEIGHT = 12
      @LABEL_LEVELS_TO_SHOW = 3
      @BASE_ID = "#{Math.floor((Math.random() * 10000) + 1)}"

      # ------------ helper functions --------------- #
      wrapText = (d) ->
        self = d3.select(@)
        textLength = self.node().getComputedTextLength()
        text = self.text()
        textLimit = self.attr('data-limit-for-text')

        wrappedText = glados.Utils.Text.getTextForEllipsis(text, textLength, textLimit)
        self.text wrappedText

      appendLabelText = (d, parentGroup) ->

        if d.name == 'root'
          return

        group = d3.select(parentGroup)
        path = group.select('.text-path')
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

        if limitForText < 12
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
            .style('fill', (d) -> textColor(d.assignedColor))
            .attr('data-limit-for-text', limitForText - 12)

        else

          text = group.append('text')
            .classed('sunburst-text', true)
            .attr('dx', '5px')
            .attr('dy', '.4em')
            .attr('x', (d) -> getRadius(d.y))
            .text((d) -> d.name)
            .style('fill', (d) -> textColor(d.assignedColor))
            .attr('data-limit-for-text', limitForText)
            .attr('transform', (d) ->
              'rotate(' + thisView.computeTextRotation(d, getAngle) + ')'
            )

          if arcLength < thisView.MAX_LINE_HEIGHT
            text.remove()

        text.each(wrapText)

      # ------------ end of helper functions --------------- #

#     scales
      getAngle = d3.scale.linear()
        .range([0, 2 * Math.PI])

      getRadius = d3.scale.pow()
        .exponent(0.5)
        .range([0, @RADIUS])

      color = d3.scale.ordinal()
        .range([
            '#0b4d56',
            '#066c70',
            '#088d91',
            '#41aeaf',
            '#79cccb',
            '#c4e6e5',
            '#fdabbc',
            '#f9849d',
            '#e95f7e',
            '#cc4362',

        ])

      textColor = d3.scale.ordinal()
        .domain([
          '#0b4d56',
          '#066c70',
          '#088d91',
          '#41aeaf',
          '#79cccb',
          '#c4e6e5',
          '#fdabbc',
          '#f9849d',
          '#e95f7e',
          '#cc4362',
        ])
        .range([
            '#ffffff',
            '#ffffff',
            '#ffffff'
            '#000000',
            '#000000',
            '#000000',
            '#000000',
            '#ffffff',
            '#ffffff',
            '#ffffff',
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

#     create main svg
      mainSunburstContainer = d3.select @$vis_elem[0]
        .append('svg')
          .attr('class', 'mainEntitiesContainer')
          .attr('width', @VIS_WIDTH)
          .attr('height', @VIS_HEIGHT)
          .append("g")
            .attr("transform", "translate(" + @VIS_WIDTH / 2 + "," + (@VIS_HEIGHT / 2) + ")")

#     append group for arcs and texts
      sunburstGroup = mainSunburstContainer.selectAll('g')
        .data(nodes)
        .enter().append('g')

#     append arcs
      paths = sunburstGroup.append('path')
        .classed('arc-path', true)
        .attr('d', arc)
        .style 'fill', (d) ->
          assignedColor = color (if d.children then d else d.parent).name
          d.assignedColor = assignedColor
          return assignedColor

#     append paths for text
      textPaths = sunburstGroup.append('path')
        .classed('text-path', true)
        .attr('id', (d, i) -> "#{thisView.BASE_ID}-text-path-#{i}")
        .attr('d', textArc)
        .style('stroke', 'none')

#     append labels
      sunburstGroup.each (d) ->
        shouldCreateLabel = d.depth - thisView.FOCUS.depth <= thisView.LABEL_LEVELS_TO_SHOW

        if shouldCreateLabel
          appendLabelText(d, @)

#     --- hover handling --- #
      @numTooltips = 0
      renderQTip = (d, i) ->

        if d.name == 'root'
          return

        $elem = $(@)
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

      thisView.repaintAllLabels = ->

        d3.selectAll("##{thisView.$vis_elem.attr('id')} .sunburst-text").remove()
        f = thisView.FOCUS
        sunburstGroup.each (d) ->

          shouldCreateLabels = d.depth - f.depth <= thisView.LABEL_LEVELS_TO_SHOW and d.x >= f.x and d.x < (f.x + f.dx)
          if shouldCreateLabels
            appendLabelText(d, @)


      # --- click handling --- #
      click = (d) ->

#       function for interpolating scales in arc
        scaleTween  = (d, scale) ->
          xd = d3.interpolate(getAngle.domain(), [d.x, d.x + d.dx])
          yd = d3.interpolate(getRadius.domain(), [d.y, 1])
          yr = d3.interpolate(getRadius.range(), [ (if d.y then 15 else 0), thisView.RADIUS])

          return (d, i) ->
            if i then ((t) -> scale d)
            else ((t) ->
              getAngle.domain xd(t)
              getRadius.domain(yd(t)).range yr(t)
              return scale d
            )

#       appends labels when transitions are over
        appendLabels = (isDone1, isDone2) ->

          if isDone1 and isDone2
            f = thisView.FOCUS
            sunburstGroup.each (d) ->

              shouldCreateLabels = d.depth - f.depth <= thisView.LABEL_LEVELS_TO_SHOW and d.x >= f.x and d.x < (f.x + f.dx)
              if shouldCreateLabels
                appendLabelText(d, @)

#       if focus changes
        if thisView.FOCUS != d

          d3.selectAll("##{thisView.$vis_elem.attr('id')} .sunburst-text").remove()

          if thisView.config.browse_button
            thisView.fillBrowseButton(d)

          textPathsTransitionisDone = false
          arcPathsTransitionisDone = false
          textPathsSize = textPaths.transition().size()
          arcPathsSize = paths.transition().size()

#         arcs transition
          textPaths.transition()
            .duration(700)
            .attrTween('d', scaleTween(d, textArc))
            .each('end', ->
              textPathsSize--
              if textPathsSize == 0
                textPathsTransitionisDone = true
                appendLabels(textPathsTransitionisDone, arcPathsTransitionisDone)
            )

          paths.transition()
            .duration(700)
            .attrTween('d', scaleTween(d, arc))
            .each('end', ->
              arcPathsSize--
              if arcPathsSize == 0
                arcPathsTransitionisDone = true
                appendLabels(textPathsTransitionisDone, arcPathsTransitionisDone)
            )

#         update focus
          thisView.FOCUS = d

#     trigger events
      sunburstGroup.on 'click',  click
      sunburstGroup.on 'mouseover', renderQTip
      @fillBrowseButton(@FOCUS)

    computeTextRotation: (d, getAngle) ->
      (getAngle(d.x + d.dx / 2) - (Math.PI / 2)) / Math.PI * 180

    fillBrowseButton: (d) ->

      $browseButtonContainer = @config.browse_button_container

      if d.name == 'root'
        glados.Utils.fillContentForElement $browseButtonContainer,
          link_title: "Browse all #{@config.entity_name_plural}"
          link_url: Target.getTargetsListURL()
      else
        glados.Utils.fillContentForElement $browseButtonContainer,
          link_title: "Browse all #{d.name} #{@config.entity_name_plural}"
          link_url: d.link

    getTreeData: ->
      receivedRoot = @model.get 'root'
      id = 0

      fillNode = (parentNode, currentNodeReceived) ->

        node = {}
        if currentNodeReceived.label?
          node.name = currentNodeReceived.label
        else
          node.name = currentNodeReceived.id

        node.size = currentNodeReceived.count
        node.parent_id = parentNode.id
        node.id = id
        node.link = currentNodeReceived.link
        node.depth = parentNode.depth + 1
        node.parent = parentNode

        parentNode.children.push(node)

        if currentNodeReceived.children?
          node.children = []
          for childID, child of currentNodeReceived.children
            id++
            fillNode(node, child)

      parsedRoot = {}
      parsedRoot.depth = 0
      parsedRoot.name = 'root'
      parsedRoot.id = id

      parsedRoot.children = []
      for nodeID, node of receivedRoot.children
        id++
        fillNode(parsedRoot, node)

      return parsedRoot

    wakeUp: ->

      if @$vis_elem.children().length == 0
        @render()
      @repaintAllLabels()
      @fillBrowseButton(@FOCUS)



    showCardContent: ->
      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.card-content').show()
