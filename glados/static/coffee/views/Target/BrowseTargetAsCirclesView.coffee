BrowseTargetAsCirclesView = Backbone.View.extend

  initialize: ->

    @showPreloader()

    # the render function is debounced so it waits for the size of the
    # element to be ready
    debounced_render = _.debounce($.proxy(@render, @), 300)
    updateViewProxy = $.proxy(@updateView, @, debounced_render)

    $(window).resize ->
      updateViewProxy()

    @model.on 'change', updateViewProxy, @

  showPreloader: ->

    if $(@el).attr('data-loading') == 'false' or !$(@el).attr('data-loading')?
      $(@el).html Handlebars.compile($('#Handlebars-Common-Preloader').html())
      $(@el).attr('data-loading', 'true')

  hidePreloader: ->

    $(@el).find('.card-preolader-to-hide').hide()
    $(@el).attr('data-loading', 'false')

  updateView: (debounced_render) ->
    $(@el).empty()
    @showPreloader()
    debounced_render()

  render: ->

    console.log('nodes before')
    console.log(@model.get('plain'))

    @hidePreloader()
    margin = 20
    diameter = $(@el).width();

    diameter = 300 unless diameter != 0;

    color = d3.scale.linear()
    .domain([-1, 5])
    .range(["white", "rgb(0, 110, 156)"])
    .interpolate(d3.interpolateRgb);

    pack = d3.layout.pack()
    .padding(2)
    .size([diameter - margin, diameter - margin])
    .value((d) -> return d.size)

    elem_selector = '#' + $(@el).attr('id')

    svg = d3.select(elem_selector).append("svg")
    .attr("width", diameter)
    .attr("height", diameter)
    .append("g")
    .attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");



    # use plain version
    root = @model.get('plain')

    focus = root
    nodes = pack.nodes(root)
    view = undefined
    console.log('nodes after')
    console.log(nodes)

    circle = svg.selectAll('circle')
    .data(nodes).enter().append('circle')
    .attr("class", (d) ->
      if d.parent then (if d.children then 'node' else 'node node--leaf') else 'node node--root')
    .attr("id", (d) ->
      if d.parent then 'circleFor-' + d.id else 'circleFor-Root')
    .style("fill", (d) ->
      if d.children then color(d.depth) else null)
    .on("click", (d) ->
      if focus != d
        zoom(d)
        d3.event.stopPropagation()
      return)

    text = svg.selectAll('text')
    .data(nodes)
    .enter().append('text')
    .attr("class", "label")
    .style("fill-opacity", (d) ->
      if d.parent == root then 1 else 0)
    .style("display", (d) ->
      if d.parent == root then 'inline' else 'none')
    .text((d) -> return d.name + " (" + d.size + ")" )

    #Select circles to create the views
    @createCircleViews()

    node = svg.selectAll("circle,text")

    d3.select(elem_selector)
    .style("background", color(-1))
    .on("click", () -> zoom(root) )

    zoomTo = (v) ->
      k = diameter / v[2]; view = v;
      node.attr("transform", (d) -> return "translate(" + (d.x - v[0]) * k + "," + (d.y - v[1]) * k + ")" )
      circle.attr("r", (d) -> return d.r * k )

    zoom = (d) ->
      focus0 = focus; focus = d;
      transition = d3.transition()
      .duration(if d3.event.altKey then 7500 else 750)
      .tween("zoom", (d) ->
          i = d3.interpolateZoom(view, [focus.x, focus.y, focus.r * 2 + margin])
          return (t) -> zoomTo(i(t))
      )

      transition.selectAll("text")
      .filter( (d) ->
        d.parent == focus or @style.display == 'inline')
      .style('fill-opacity', (d) ->
        if d.parent == focus then 1 else 0)
      .each('start', (d) ->
        if d.parent == focus
          @style.display = 'inline'
        return )
      .each('end', (d) ->
        if d.parent != focus
          @style.display = 'none'
        return)


    zoomTo([root.x, root.y, root.r * 2 + margin])

  createCircleViews: ->

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










