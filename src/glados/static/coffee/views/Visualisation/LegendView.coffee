# this view is in charge of painting legends
LegendView = Backbone.View.extend(ResponsiviseViewExt).extend

  LEGEND_HEIGHT: 110
  LEGEND_RECT_HEIGHT: 20
  LEGEND_TEXT_Y: -25
  RANGE_SELECTOR_WIDTH: 2
  RANGE_SELECTOR_FILL: 'white'
  RANGE_SELECTOR_STROKE_WIDTH: 1
  RANGE_SELECTOR_STROKE: 'black'

  initialize: ->

    @config = arguments[0].config
    @config ?= {}
    @model.on 'change', @render, @
    @$vis_elem = $(@el)
    @setUpResponsiveRender()
    @render()

    if @model.get('selection-enabled')
      @model.on(glados.Events.Legend.VALUE_SELECTED, @valueSelectedHandler, @)
      @model.on(glados.Events.Legend.VALUE_UNSELECTED, @valueUnselectedHandler, @)
      @model.on(glados.Events.Legend.RANGE_SELECTED, @rangeSelectedHandler, @)
      @model.on(glados.Events.RANGE_SELECTION_INVALID, @rangeInvalidHandler, @)

  clearLegend: -> $(@el).empty()
  addExtraCss: ->
    $(@el).find('line, path').css('fill', 'none')

  valueSelectedHandler: (value) ->
    rectClassSelector = '.legend-rect-' + value
    $(@el).find(rectClassSelector).addClass('selected')

  valueUnselectedHandler: (value) ->
    rectClassSelector = '.legend-rect-' + value
    $(@el).find(rectClassSelector).removeClass('selected')

  rangeSelectedHandler: ->
    rectClassSelector = '.legend-range-selector .legend-rect'
    $(@el).find(rectClassSelector).addClass('selected')
    $rangeSelectors = $(@el).find('.legend-range-selector')
    [selector1G, selector2G] = [d3.select($rangeSelectors[0]), d3.select($rangeSelectors[1])]
    [minValue, maxValue] = [@model.get('values-selection-min'), @model.get('values-selection-max')]
    [xmin, xmax] = [@getXInLegendFor(minValue), @getXInLegendFor(maxValue)]

    @moveRangeSelectorToValue(selector1G, xmin, minValue)
    @moveRangeSelectorToValue(selector2G, xmax, maxValue)

  rangeInvalidHandler: ->

    rectClassSelector = '.legend-range-selector .legend-rect'
    $(@el).find(rectClassSelector).removeClass('selected')
    $rangeSelectors = $(@el).find('.legend-range-selector')
    [selector1G, selector2G] = [d3.select($rangeSelectors[0]), d3.select($rangeSelectors[1])]
    [minValue, maxValue] = [@model.get('domain')[0], @model.get('domain')[1]]
    [xmin, xmax] = [@getXInLegendFor(minValue), @getXInLegendFor(maxValue)]

    @moveRangeSelectorToValue(selector1G, xmin, minValue)
    @moveRangeSelectorToValue(selector2G, xmax, maxValue)


  render: ->

    @clearLegend()
    elemWidth = $(@el).width()
    Padding = 10
    @legendWidth = 0.95 * elemWidth
    legendHeight = @LEGEND_HEIGHT

    if !@config.hide_title
      legendContainer = d3.select($(@el).get(0))
      legendSVG = legendContainer.append('svg')
        .classed('main-legendSVG', true)
        .attr('width', @legendWidth + 2 * Padding )
        .attr('height', legendHeight )
      legendG = legendSVG.append('g')
        .classed('main-legendG', true)
        .attr("transform", "translate(" + Padding + "," + (legendHeight - 30) + ")")

      legendSVG.append('text')
        .text(@model.get('property').label)
        .attr("class", 'plot-colour-legend-title')
        .attr('text-anchor', 'middle')
        .attr("transform", "translate(" + (@legendWidth / 2) + ", 35)")

    else
      legendContainer = d3.select($(@el).get(0))
      legendSVG = legendContainer.append('svg')
        .classed('main-legendSVG', true)
        .attr('width', @legendWidth + 2 * Padding )
        .attr('height', legendHeight )
      legendG = legendSVG.append('g')
        .classed('main-legendG', true)
        .attr("transform", "translate(" + Padding*2 + "," + (Padding) + ")")



    if @model.isDiscrete()
      @paintDiscreteLegend(legendG)
    else if @model.isThreshold()
      @paintThresholdLegend(legendG)
    else
      @paintContinuousLegend(legendG)

    @addExtraCss()

    if @config.columns_layout
      legendSVG = $(@el).find('.main-legendSVG')
      legendGHeight = $(@el).find('.main-legendG')[0].getBBox().height
      legendSVG.height(legendGHeight + 5)

      if @config.max_height?
        legendSVG.height(@config.max_height)


  # ------------------------------------------------------------------------------------------------------------------
  # Continuous
  # ------------------------------------------------------------------------------------------------------------------
  paintContinuousLegend: (legendG) ->

    domain = @model.get('domain')
    ticks = @model.get('ticks')

    linearScalePadding = 10
    #this gives space for the null rectangle
    leftMargin = 35
    @getXInLegendFor = d3.scale.linear()
      .domain(domain)
      .range([leftMargin + linearScalePadding, (@legendWidth - linearScalePadding)])

    legendAxis = d3.svg.axis()
      .scale(@getXInLegendFor)
      .orient("bottom")
      .tickValues(ticks)

    start = domain[0]
    stop = domain[1]
    numValues = 50
    step = Math.abs(stop - start) / numValues
    stepWidthInScale = Math.abs(@getXInLegendFor.range()[0] - @getXInLegendFor.range()[1]) / numValues
    legendData = d3.range(start, stop, step)

    getColourFor = @model.get('property').colourScale

    thisView = @
    legendG.selectAll('rect')
      .data(legendData)
      .enter().append('rect')
      .attr('height',@LEGEND_RECT_HEIGHT)
      .attr('width', stepWidthInScale + 1)
      .attr('x', (d) -> thisView.getXInLegendFor d)
      .attr('y', -@LEGEND_RECT_HEIGHT)
      .attr('fill', (d) -> getColourFor d)

    thisView = @
    dragBehaviour = d3.behavior.drag()
      .on('drag', ->
        x = d3.event.x
        if x < leftMargin + linearScalePadding then return
        if x > thisView.legendWidth - linearScalePadding then return
        value = thisView.getXInLegendFor.invert(x).toFixed(2)
        draggedG = d3.select(@)
        thisView.moveRangeSelectorToValue(draggedG, x, value, thisView)
      ).on('dragend', $.proxy(@selectRange, @))

    if @model.get('selection-enabled')
      rangeSelector1G = legendG.append('g')
        .attr("transform", "translate(" + (thisView.getXInLegendFor start) + ',' + -@LEGEND_RECT_HEIGHT + ")")
        .classed('legend-range-selector', true)
        .attr('data-range-value', start)

      rangeSelector2G = legendG.append('g')
        .attr("transform", "translate(" + (thisView.getXInLegendFor stop) + ',' + -@LEGEND_RECT_HEIGHT + ")")
        .classed('legend-range-selector', true)
        .attr('data-range-value', stop)

      rangeSelector1G.call(dragBehaviour)
      rangeSelector2G.call(dragBehaviour)
      @paintRangeSelector(rangeSelector1G, start)
      @paintRangeSelector(rangeSelector2G, stop)

    nullSelectorG = legendG.append('g')
      .attr("transform", 'translate(0,' + -@LEGEND_RECT_HEIGHT + ")")

    nullSelectorG.append('rect')
      .attr('height',@LEGEND_RECT_HEIGHT)
      .attr('width', @LEGEND_RECT_HEIGHT)
      .attr('fill', glados.Settings.VISUALISATION_GRID_UNDEFINED)
      .classed('legend-rect', @model.get('selection-enabled'))
      .classed('legend-rect-' + glados.Settings.DEFAULT_NULL_VALUE_LABEL_LEGEND, true)
      .style('stroke-width', 2)
      .on('click', $.proxy( (-> @model.toggleValueSelection(glados.Settings.DEFAULT_NULL_VALUE_LABEL_LEGEND)), @))

    nullSelectorG.append('text')
      .attr('y', 2 * @LEGEND_RECT_HEIGHT)
      .attr('x', @LEGEND_RECT_HEIGHT / 2)
      .text(glados.Settings.DEFAULT_NULL_VALUE_LABEL_LEGEND)
      .attr('text-anchor', 'middle')

    legendG.call(legendAxis)

  moveRangeSelectorToValue: (draggedG, x, value, ctx=@) ->

    draggedG.attr("transform", 'translate(' + x + ',' + -ctx.LEGEND_RECT_HEIGHT + ')')
      .attr('data-range-value', value)
    draggedG.select('text')
      .text(value)

  paintRangeSelector: (selectorG, initialText) ->

    selectorG.append('rect')
      .attr('stroke', @RANGE_SELECTOR_STROKE)
      .attr('stroke-width', @RANGE_SELECTOR_STROKE_WIDTH)
      .attr('fill', @RANGE_SELECTOR_FILL)
      .attr('height', @LEGEND_RECT_HEIGHT)
      .attr('width', @RANGE_SELECTOR_WIDTH)
      .classed('legend-rect', true)

    selectorG.append('text')
      .text(initialText)
      .attr('text-anchor', 'middle')
      .style('font-size', '65%')
      .style('fill', glados.Settings.VISUALISATION_DARKEN_2 )
      .attr("transform", 'translate(0,-10)')

  selectRange: ->
    values = (parseFloat($(elem).attr('data-range-value')) for elem in $(@el).find('.legend-range-selector')).sort()
    @model.selectRange(values[0], values[1])

  # ------------------------------------------------------------------------------------------------------------------
  # Categorical
  # ------------------------------------------------------------------------------------------------------------------
  paintDiscreteLegend: (legendG) ->

    if @config.columns_layout
      @paintColumnsLayout(legendG)
    else
      @paintBarLayout(legendG)

  # ------------------------------------------------------------------------------------------------------------------
  # Columns layout
  # ------------------------------------------------------------------------------------------------------------------
  paintColumnsLayout: (legendG) ->

    domain = @model.get('domain')
    getColourFor = @model.get('property').colourScale
    radius = 5
    containerLimit = 0
    elemWidth = $(@el).width()

    if elemWidth >= 700
      domainGroupsSize = 4
    else if elemWidth <= 450
      domainGroupsSize = 2
    else
      domainGroupsSize = 3

    if @config.side_legend
      domainGroupsSize = 1

    columnSize = Math.ceil domain.length/domainGroupsSize
    columnWidth = @legendWidth / domainGroupsSize
    domainGroups = []

    i = 0
    while i < domain.length
      column = domain.slice i, i+columnSize
      domainGroups.push column
      i+=columnSize

    console.log  'domainGroups: ', domainGroups
    for column, a in domainGroups
      legendG.selectAll('.circle-' + a )
        .data(column)
        .enter()
        .append('circle')
        .attr('cx', 0)
        .attr('cy', (d, i) -> i * ( radius * 3 ))
        .attr('r', radius)
        .attr('fill', (d) ->
              if d == 'Other'
                return glados.Settings.VIS_COLORS.GREY2
              else
                return getColourFor(d)
            )
        .attr('transform', 'translate(' + columnWidth * a + ', 0)')

      legendG.selectAll('.text-' + a)
        .data(column)
        .enter()
        .append('text')
        .classed('legend-text', true)
        .text((d) -> d)
        .attr('x', 15)
        .attr('y', (d, i) -> (i * ( radius * 3 )) + 4)
        .attr('transform', 'translate(' + columnWidth * a + ', 0)')


#   if the text is too long add ellipsis
    texts = legendG.selectAll('text')
    for text, d in texts[0]
      containerLimit = columnWidth - 40
      originalWidth = $(texts[0][d])[0].getBBox().width
      originalText = $(texts[0][d])[0].textContent

      newText =  glados.Utils.Text.getTextForEllipsis(originalText, originalWidth, containerLimit )

      d3.select($(texts[0][d])[0]).text(newText)

  # ------------------------------------------------------------------------------------------------------------------
  # Bar layout
  # ------------------------------------------------------------------------------------------------------------------
  paintBarLayout: (legendG) ->
    rectanglePadding = 1

    getXInLegendFor = d3.scale.ordinal()
      .domain( @model.get('domain') )
      .rangeBands([0, @legendWidth])

    legendAxis = d3.svg.axis()
      .scale(getXInLegendFor)
      .orient("bottom")

    getColourFor = @model.get('property').colourScale

    legendG.selectAll('rect')
      .data(getXInLegendFor.domain())
      .enter().append('rect')
      .attr('class', (d) -> 'legend-rect-' + d)
      .attr('height', @LEGEND_RECT_HEIGHT)
      .attr('width', getXInLegendFor.rangeBand() - rectanglePadding)
      .attr('x', (d) -> getXInLegendFor d)
      .attr('y', -@LEGEND_RECT_HEIGHT)
      .attr('fill', (d) -> getColourFor d)
      .style('stroke-width', 2)
      .classed('legend-rect', true)
      .on('click', $.proxy(@clickRectangle, @))

    legendG.selectAll('text')
      .data(getXInLegendFor.domain())
      .enter().append('text')
      .text($.proxy(@getTextAmountPerValue, @))
      .attr('x', (d) -> getXInLegendFor d)
      .attr('y', @LEGEND_TEXT_Y)
      .style('font-size', '65%')
      .style('fill', glados.Settings.VISUALISATION_DARKEN_2 )
      .attr('text-anchor', 'middle')
      .attr("transform", "translate(" + getXInLegendFor.rangeBand()/2 + ")")

    legendG.call(legendAxis)

  getTextAmountPerValue: (value) -> '(' + @model.getTextAmountPerValue(value) + ')'

  clickRectangle: (d) -> @model.toggleValueSelection(d)

  # ------------------------------------------------------------------------------------------------------------------
  # Threshold
  # ------------------------------------------------------------------------------------------------------------------
  paintThresholdLegend: (legendG) ->

    rectanglePadding = 1
    getXInLegendFor = d3.scale.ordinal()
      .domain( @model.get('ticks') )
      .rangeBands([0, @legendWidth])

    legendAxis = d3.svg.axis()
      .scale(getXInLegendFor)
      .orient("bottom")

    getColourFor = d3.scale.ordinal()
      .domain( @model.get('ticks'))
      .range(@model.get('property').coloursRange)

    legendG.selectAll('rect')
      .data(getXInLegendFor.domain())
      .enter().append('rect')
      .attr('class', (d) -> 'legend-rect-' + d)
      .attr('height', @LEGEND_RECT_HEIGHT)
      .attr('width', getXInLegendFor.rangeBand() - rectanglePadding)
      .attr('x', (d) -> getXInLegendFor d)
      .attr('y', -@LEGEND_RECT_HEIGHT)
      .attr('fill', (d) -> getColourFor d)
      .style('stroke-width', 2)
      .classed('legend-rect', true)
      .on('click', $.proxy(@clickRectangle, @))

    legendG.selectAll('text')
      .data(getXInLegendFor.domain())
      .enter().append('text')
      .text($.proxy(@getTextAmountPerRange, @))
      .attr('x', (d) -> getXInLegendFor d)
      .attr('y', @LEGEND_TEXT_Y)
      .style('font-size', '65%')
      .style('fill', glados.Settings.VISUALISATION_DARKEN_2 )
      .attr('text-anchor', 'middle')
      .attr("transform", "translate(" + getXInLegendFor.rangeBand()/2 + ")")

    legendG.call(legendAxis)

    console.log 'paint threshold legend!'

  getTextAmountPerRange: (value) -> '(' + @model.getTextAmountPerRange(value) + ')'