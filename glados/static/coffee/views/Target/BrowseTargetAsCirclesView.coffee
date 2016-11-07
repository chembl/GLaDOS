BrowseTargetAsCirclesView = Backbone.View.extend(ResponsiviseViewExt).extend

  # this may have to be improved depending If there are browser issues.
  CTRL_KEY_NUMBER: 17

  events:
    'click .reset-zoom': 'resetZoom'

  initialize: ->

    $(document).on("keydown", $.proxy(@handleKeyDown, @))
    $(document).on("keyup", $.proxy(@handleKeyUp, @))

    @initialiseInstructions()
    $(@el).on 'keydown', @handleKeyDown

    @$vis_elem = $(@el).find('.vis-container')
    @showResponsiveViewPreloader()

    # the render function is debounced so it waits for the size of the
    # element to be ready
    updateViewProxy = @setUpResponsiveRender()

    @model.on 'change', updateViewProxy, @

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
    .range(["#eceff1", "#607d8b"])
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
    focus = @root
    nodes = pack.nodes(@root)
    @currentViewFrame = undefined
    console.log('nodes after')
    console.log(nodes)

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
        thisView.focusTo(d)

    # -----------------------------------------
    # Node hover handler function
    # -----------------------------------------
    handleNodeMouseOver = (d) ->

      thisView.currentHover = d.name
      isPressingCtrl = d3.event.ctrlKey
      thisView.fillInstructionsTemplate d.name, isPressingCtrl

    handleNodeMouseOut = (d) ->

      thisView.currentHover = undefined
      thisView.fillInstructionsTemplate undefined


    circles = svg.selectAll('circle')
      .data(nodes).enter().append('circle')
      .attr("class", (d) ->
        if d.parent then (if d.children then 'node' else 'node node--leaf') else 'node node--root')
      .attr("id", (d) ->
        if d.parent then 'circleFor-' + d.id else 'circleFor-Root')
      .style("fill", (d) ->
        if d.children then color(d.depth) else null)
      .on("click", handleClickOnNode)
      .on('mouseover', handleNodeMouseOver)
      .on('mouseout', handleNodeMouseOut)

    text = svg.selectAll('text')
    .data(nodes)
    .enter().append('text')
    .attr("class", "label")
    .style("fill-opacity", (d) ->
      if d.parent == thisView.root then 1 else 0)
    .style("display", (d) ->
      if d.parent == thisView.root then 'inline' else 'none')
    .text((d) -> return d.name + " (" + d.size + ")" )

    #Select circles to create the views
    @createCircleViews()

    d3.select(container)
    .on("click", () -> thisView.focusTo(thisView.root) )


    @zoomTo([@root.x, @root.y, @root.r * 2 + @margin])

    $('.tooltipped').tooltip()

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
  # Reset zoom btn
  #----------------------------------------------------------

  toggleResetZoomBtn: (focus) ->

    if focus.name == 'root'
      @hideResetZoomBtn()
    else
      @showResetZoomBtn()

  showResetZoomBtn: ->

    $(@el).find('.reset-zoom').show()

  hideResetZoomBtn: ->

    $(@el).find('.reset-zoom').hide()

  resetZoom: ->

    @focusTo @root

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
    console.log 'focus node: ', node
    thisView = @
    focus = node
    @toggleResetZoomBtn(focus)
    transition = d3.transition()
    .duration(1000)
    .tween("zoom", (d) ->
        i = d3.interpolateZoom(thisView.currentViewFrame, [focus.x, focus.y, focus.r * 2 + thisView.margin])
        return (t) -> thisView.zoomTo(i(t))
    )

    transition.selectAll("text")
      .filter( (d) ->
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

      @fillInstructionsTemplate @currentHover, true

  handleKeyUp: (event) ->

    if event.which == @CTRL_KEY_NUMBER

      @fillInstructionsTemplate @currentHover, false









