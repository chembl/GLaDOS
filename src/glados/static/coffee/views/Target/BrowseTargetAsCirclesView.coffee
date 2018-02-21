BrowseTargetAsCirclesView = Backbone.View.extend(ResponsiviseViewExt).extend

  # this may have to be improved depending If there are browser issues.
  CTRL_KEY_NUMBER: 17

  initialize: ->

    $(document).on("keydown", $.proxy(@handleKeyDown, @))
    $(document).on("keyup", $.proxy(@handleKeyUp, @))

    @initialiseInstructions()
    $(@el).on 'keydown', @handleKeyDown

    @$vis_elem = $(@el).find('.vis-container')
    @showResponsiveViewPreloader()
    @setUpResponsiveRender()
    @model.on 'change', @render, @

  render: ->

    thisView = @
    @fillInstructionsTemplate undefined

    console.log('nodes before')
    console.log(@model.get('plain'))

    @hideResponsiveViewPreloader()
    @margin = 20
    @diameter = $(@el).width()

    @diameter = 300 unless @diameter != 0

    color = d3.scale.linear()
    .domain([-1, 5])
    .range([glados.Settings.VIS_COLORS.WHITE, glados.Settings.VIS_COLORS.TEAL3])
    .interpolate(d3.interpolateRgb);

    pack = d3.layout.pack()
    .padding(2)
    .size([thisView.diameter - @margin, thisView.diameter - @margin])
    .value((d) -> return d.size)

    container = @$vis_elem[0]
    svg = d3.select(container).append("svg")
    .attr("width", thisView.diameter)
    .attr("height", thisView.diameter)
    .append("g")
    .attr("transform", "translate(" + thisView.diameter / 2 + "," + thisView.diameter / 2 + ")")

    # use plain version
    @root = @model.get('plain')
    console.log '@root: ', @root
    focus = @root
    nodes = pack.nodes(@root)
    @currentViewFrame = undefined
    console.log('nodes after')
    console.log(nodes)

    #get depth domain in tree
    getNodeNumChildren = (node) -> if not node.children? then 0 else node.children.length
    nodeWithMinNumChildren = _.min(nodes, getNodeNumChildren)
    minNumChildren = if not nodeWithMinNumChildren.children? then 0 else nodeWithMinNumChildren.children.length
    nodeWithMaxNumChildren = _.max(nodes, getNodeNumChildren)
    maxNumChildren = if not nodeWithMaxNumChildren.children? then 0 else nodeWithMaxNumChildren.children.length

    textSize = d3.scale.linear()
      .domain([minNumChildren, maxNumChildren])
      .range([60, 150])

    # -----------------------------------------
    # Node click handler function
    # -----------------------------------------
    handleClickOnNode = (d) ->

      d3.event.stopPropagation()
      # If the user is pressing the ctrl Key, the node is selected,
      # I don't zoom, so it's not my responsibility
      if d3.event.ctrlKey
        return

      if focus != d
        thisView.focusTo(thisView.currentHover)

    # -----------------------------------------
    # Node hover handler function
    # -----------------------------------------
    handleNodeMouseOver = (d) ->

      console.log 'real hover is over: ', d.name

      console.log 'thisView', thisView
      console.log '@currentHoverableElems: ', thisView.currentHoverableElems
      currentHoverableIDs = (n.id for n in thisView.currentHoverableElems)
      console.log 'currentHoverableNodes: ', currentHoverableIDs

      currentHoverableNames = (n.name for n in thisView.currentHoverableElems)
      console.log 'currentHoverableNames: ', currentHoverableNames

      if d.id in currentHoverableIDs

        thisView.currentHover = d
        isPressingCtrl = d3.event.ctrlKey
        thisView.fillInstructionsTemplate d.name, isPressingCtrl

        allNodes = d3.select($(thisView.el)[0]).selectAll('.node')
        allNodes.classed('force-hover', false)
        nodeElem = d3.select($(thisView.el)[0]).select("#circleFor-#{d.id}" for n in nodes)
        nodeElem.classed('force-hover', true)

    circles = svg.selectAll('circle')
      .data(nodes).enter().append('circle')
      .attr("class", (d) ->
        if d.parent then (if d.children then 'node' else 'node node--leaf') else 'node node--root')
      .attr("id", (d) ->
        if d.parent then 'circleFor-' + d.id else 'circleFor-Root')
      .style("fill", (d) ->
        if d.children then color(d.depth) else glados.Settings.VIS_COLORS.WHITE)
      .on("click", handleClickOnNode)
      .on('mouseover', handleNodeMouseOver)

    text = svg.selectAll('text')
      .data(nodes)
      .enter().append('text')
      .attr("class", "label")
      .attr('text-anchor', 'middle')
      .style("fill-opacity", (d) ->
        if d.parent == thisView.root then 1 else 0)
      .style("display", (d) ->
        if d.parent == thisView.root then 'inline' else 'none')
      .text((d) -> return d.name + " (" + d.size + ")" )
      .attr('font-size', (d) -> if d.children? then "#{textSize(d.children.length)}%" else "#{textSize(0)}%")

    #Select circles to create the views
#    @createCircleViews()

    d3.select(container)
      .on("click", () -> thisView.focusTo(thisView.root) )

    @currentLevel = 0
    @currentHoverableElems = []
    @zoomTo([@root.x, @root.y, @root.r * 2 + @margin])
    @addHoverabilityTo(@root.children)

  addHoverabilityTo: (nodes=[]) ->

    if nodes.length > 0
      d3Nodes = d3.select($(@el)[0]).selectAll(("#circleFor-#{n.id}" for n in nodes).join(','))
      d3Nodes.classed('hoverable', true)
    @currentHoverableElems = nodes

  removeHoverabilityToAll: ->

    d3.select($(@el)[0]).selectAll('.node')
      .classed('hoverable', false)
      .classed('force-hover', false)
    @currentHoverableElems = []

  createCircleViews: ->

    thisView = @
    nodes_dict = @model.get('all_nodes_dict')

    $(@el).find('circle').each ->

      circle = $(@)
      nodeModelID = circle.attr('id').replace('circleFor-', '')

      #root node only exists in d3 contexts.
      if nodeModelID == 'Root'
        return

      nodeModel = nodes_dict[nodeModelID]

      nodeView = new BrowseTargetAsCirclesNodeView
        model: nodeModel
        el: circle

      nodeView.parentView = thisView

  #----------------------------------------------------------
  # Zoom and focus
  #----------------------------------------------------------
  zoomTo: (newViewFrame) ->

    @currentViewFrame = newViewFrame

    svg = d3.select("svg")
    circles = svg.selectAll("circle,text")

    k = @diameter / newViewFrame[2];
    circles.attr("transform", (d) -> return "translate(" + (d.x - newViewFrame[0]) * k + "," + (d.y - newViewFrame[1]) * k + ")" )
    circles.attr("r", (d) -> return d.r * k )

  focusTo: (node) ->

    thisView = @
    focus = node
    @removeHoverabilityToAll()
    ancestry = []
    currentParent = node.parent
    while currentParent?
      ancestry.push currentParent
      currentParent = currentParent.parent

    newHoverableNodes = _.union(ancestry, node.children)

    d3.select($(@el)[0]).selectAll(".node")
      .classed('selected', false)

    selectedNode = d3.select($(@el)[0]).select("#circleFor-#{node.id}")
    selectedNode.classed('selected', true)
    @addHoverabilityTo(newHoverableNodes)
    transition = d3.transition()
      .duration(1000)
      .tween("zoom", (d) ->
          i = d3.interpolateZoom(thisView.currentViewFrame, [focus.x, focus.y, focus.r * 2 + thisView.margin])
          return (t) -> thisView.zoomTo(i(t))
      )

    transition.selectAll("text")
      .filter( (d) ->
        if d?
          d == focus or d.parent == focus or @style.display == 'inline')
      .style('fill-opacity', (d) ->
        if d.parent == focus then 1 else 0)
      .each('start', (d) ->
        if d.parent == focus
          @style.display = 'inline'
        return )
      .each('end', (d) ->

        # if you focus a leaf I  won't hide the label
        if d == focus and !d.children?
          @style.display = 'inline'
          @style['fill-opacity'] = 1
          return

        if d.parent != focus
          @style.display = 'none'
        return)


  #----------------------------------------------------------
  # Instructions
  #----------------------------------------------------------
  initialiseInstructions: ->

    @$instructionsDiv = $(@el).find('.instructions')
    @$instructionsDivTmpl = $('#' + @$instructionsDiv.attr('data-hb-template'))

  fillInstructionsTemplate: (nodeName, isPressingCtrl) ->

    $div = $(@el).find('.instructions')
    template = $('#' + $div.attr('data-hb-template'))

    $div.html Handlebars.compile(template.html())
      node_name: nodeName
      is_pressing_ctrl: isPressingCtrl


  handleKeyDown: (event) ->

    if event.which == @CTRL_KEY_NUMBER

      @fillInstructionsTemplate @currentHover.name, true

  handleKeyUp: (event) ->

    if event.which == @CTRL_KEY_NUMBER

      @fillInstructionsTemplate @currentHover.name, false









