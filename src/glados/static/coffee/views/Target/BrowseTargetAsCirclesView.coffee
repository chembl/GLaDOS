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

  render: ->

    if @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
      return

    if @model.get('state') == glados.models.Aggregations.Aggregation.States.LOADING_BUCKETS
      return

    if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE
      return

    @root = @getBucketData()

    @$vis_elem.empty()
    thisView = @
    @fillInstructionsTemplate undefined

    @hideResponsiveViewPreloader()
    @margin = 20

    @VISUALISATION_WIDTH = $(@el).width() - 10
    @VISUALISATION_HEIGHT = @VISUALISATION_WIDTH
    @diameter = @VISUALISATION_WIDTH

    if $(@el).parents('.visualisation-card')
      @VISUALISATION_HEIGHT = @$vis_elem.height()
      if @VISUALISATION_HEIGHT < @VISUALISATION_WIDTH
        @diameter = @VISUALISATION_HEIGHT

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
    .attr("width", @VISUALISATION_WIDTH)
    .attr("height", @VISUALISATION_HEIGHT)
    .append("g")
    .attr("transform", "translate(" + @VISUALISATION_WIDTH / 2 + "," + @VISUALISATION_HEIGHT / 2 + ")")

    @focusNode = @root
    @originalNodes = pack.nodes(@root)
    @currentViewFrame = undefined

    #get depth domain in tree
    getNodeNumChildren = (node) -> if not node.children? then 0 else node.children.length
    nodeWithMinNumChildren = _.min(nodes, getNodeNumChildren)
    minNumChildren = if not nodeWithMinNumChildren.children? then 0 else nodeWithMinNumChildren.children.length
    nodeWithMaxNumChildren = _.max(nodes, getNodeNumChildren)
    maxNumChildren = if not nodeWithMaxNumChildren.children? then 0 else nodeWithMaxNumChildren.children.length

    textSize = d3.scale.linear()
      .domain([minNumChildren, maxNumChildren])
      .range([60, 160])

    # -----------------------------------------
    # Node click handler function
    # -----------------------------------------
    handleClickOnNode = (d) ->

      d3.event.stopPropagation()
      # If the user is pressing the ctrl Key, the node is selected,
      # I don't zoom, so it's not my responsibility
      if d3.event.ctrlKey
        return

      if thisView.focusNode != d

        thisView.focusTo(thisView.currentHover)
        thisView.drawMissingCircles(thisView.currentHover)
        thisView.fillBrowseButtonTemplate thisView.currentHover.name, thisView.currentHover.link


    # -----------------------------------------
    # Node hover handler function
    # -----------------------------------------
    handleNodeMouseOver = (d) ->

      currentHoverableIDs = (n.id for n in thisView.currentHoverableElems)

      if d.id in currentHoverableIDs

        thisView.currentHover = d
        isPressingCtrl = d3.event.ctrlKey
        thisView.fillInstructionsTemplate d.name, isPressingCtrl
#        thisView.fillBrowseButtonTemplate d.name, d.link

        allNodes = d3.select($(thisView.el)[0]).selectAll('.node')
        allNodes.classed('force-hover', false)
        nodeElem = d3.select($(thisView.el)[0]).select("#circleFor-#{d.id}" for n in nodes)
        nodeElem.classed('force-hover', true)

    @appendCirclesAndTexts = (nodesToRender) ->

      circles = svg.selectAll('circle')
        .data(nodesToRender)
      circles.exit().remove()

      circles.enter()
        .append('circle')
        .classed('circle', true)
        .attr("class", (d) ->
          if d.parent then (if d.children then 'node' else 'node node--leaf') else 'node node--root')
        .attr("id", (d) ->
          if d.parent then 'circleFor-' + d.id else 'circleFor-Root')
        .style("fill", (d) ->
          if d.children then color(d.depth) else glados.Settings.VIS_COLORS.WHITE)
        .on('click', handleClickOnNode)
        .on('mouseover', handleNodeMouseOver)

      texts = svg.selectAll('text').remove()
      texts = svg.selectAll('text')
        .data(nodesToRender)

      texts.enter()
        .append('text')
        .classed('label', true)
        .attr('text-anchor', 'middle')
        .style("fill-opacity", (d) ->
          focusIsleaf = d == thisView.focusNode and not d.children?
          if d.parent == thisView.focusNode or focusIsleaf then 1 else 0
        ).style("display", (d) ->
          if d.parent == thisView.focusNode or not d.children? then 'inline' else 'none'
        ).text((d) -> return d.name + " (" + d.size + ")" )
        .attr('font-size', (d) ->
          if d.children?
            return "#{textSize(d.children.length)}%"
          else return "#{textSize(0)}%"
        )

    nodes = @originalNodes.filter((d) -> d.depth < 5 )
    @renderedNodes = nodes
    @appendCirclesAndTexts(@renderedNodes)

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

    $(@el).find('.circle').each ->

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

  drawMissingCircles: (node) ->

    newNodesToRender = @originalNodes.filter((d) -> d.parent_id == node.id )
    @renderedNodes = _.uniq( @renderedNodes.concat newNodesToRender)

    @appendCirclesAndTexts(@renderedNodes)

  zoomTo: (newViewFrame) ->

    @currentViewFrame = newViewFrame

    $svg = $(@el).find('svg')
    svg = d3.select($svg[0])

    circles = svg.selectAll("circle,text")

    k = @diameter / newViewFrame[2];
    circles.attr("transform", (d) -> return "translate(" + (d.x - newViewFrame[0]) * k + "," + (d.y - newViewFrame[1]) * k + ")" )
    circles.attr("r", (d) -> return d.r * k )

  focusTo: (node) ->

    thisView = @
    thisView.focusNode = node
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
          i = d3.interpolateZoom(thisView.currentViewFrame, [thisView.focusNode.x, thisView.focusNode.y, thisView.focusNode.r * 2 + thisView.margin])
          return (t) -> thisView.zoomTo(i(t))
      )

    transition.selectAll("text")
      .filter( (d) ->
        if d?
          d == thisView.focusNode or d.parent == thisView.focusNode or @style.display == 'inline')
      .style('fill-opacity', (d) ->
        if d.parent == thisView.focusNode then 1 else 0)
      .each('start', (d) ->
        if d.parent == thisView.focusNode
          @style.display = 'inline'
        return )
      .each('end', (d) ->

        # if you focus a leaf I  won't hide the label
        if d == thisView.focusNode and !d.children?
          @style.display = 'inline'
          @style['fill-opacity'] = 1
          return

        if d.parent != thisView.focusNode
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

  fillBrowseButtonTemplate: (nodeName, nodeLink) ->
    $button = $('.BCK-browse-button-circles')
    $button_medium = $('.BCK-browse-button-medium-circles')

    button_medium_template = $('#' + $button_medium.attr('data-hb-template'))
    button_template = $('#' + $button.attr('data-hb-template'))

    $button.html Handlebars.compile(button_template.html())
      node_name: nodeName
      node_link: nodeLink

    $button_medium.html Handlebars.compile(button_medium_template.html())
      node_name: nodeName
      node_link: nodeLink

  handleKeyDown: (event) ->

    if event.which == @CTRL_KEY_NUMBER

      @fillInstructionsTemplate(@currentHover.name, true) unless not @currentHover?

  handleKeyUp: (event) ->

    if event.which == @CTRL_KEY_NUMBER

      @fillInstructionsTemplate(@currentHover.name, false) unless not @currentHover?
