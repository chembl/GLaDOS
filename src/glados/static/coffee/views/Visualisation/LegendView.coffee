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
    @$vis_elem = $(@el)
    updateViewProxy = @setUpResponsiveRender()
    @render()
    @model.on(glados.Events.Legend.VALUE_SELECTED, @valueSelectedHandler, @)
    @model.on(glados.Events.Legend.VALUE_UNSELECTED, @valueUnselectedHandler, @)

  clearLegend: -> $(@el).empty()
  addExtraCss: ->
    $(@el).find('line, path').css('fill', 'none')

  valueSelectedHandler: (value) ->
    console.log 'handling selection for: ', @model.get('property').propName
    rectClassSelector = '.legend-rect-' + value
    d3.select($(@el).find(rectClassSelector)[0])
      .style('stroke', glados.Settings.VISUALISATION_SELECTED)
      .attr('data-is-selected', true)

  valueUnselectedHandler: (value) ->
    console.log 'handling un selection for: ', @model.get('property').propName
    rectClassSelector = '.legend-rect-' + value
    d3.select($(@el).find(rectClassSelector)[0])
      .style('stroke', 'none')
      .attr('data-is-selected', false)

  render: ->

    @clearLegend()
    elemWidth = $(@el).width()
    horizontalPadding = 10
    @legendWidth = 0.4 * elemWidth
    legendHeight = @LEGEND_HEIGHT

    legendContainer = d3.select($(@el).get(0))
    legendSVG = legendContainer.append('svg')
      .attr('width', @legendWidth + 2 * horizontalPadding )
      .attr('height', legendHeight )
    legendG = legendSVG.append('g')
      .attr("transform", "translate(" + horizontalPadding + "," + (legendHeight - 30) + ")")

    legendSVG.append('text')
      .text(@model.get('property').label)
      .attr("class", 'plot-colour-legend-title')
      .attr('text-anchor', 'middle')
      .attr("transform", "translate(" + (@legendWidth / 2) + ", 35)")

    if @model.isDiscrete()
      @paintDiscreteLegend(legendG)
    else
      @paintContinuousLegend(legendG)

    @addExtraCss()

  # ------------------------------------------------------------------------------------------------------------------
  # Continuous
  # ------------------------------------------------------------------------------------------------------------------
  paintContinuousLegend: (legendG) ->

    domain = @model.get('domain')
    ticks = @model.get('ticks')

    linearScalePadding = 10
    #this gives space for the null rectangle
    leftMargin = 35
    getXInLegendFor = d3.scale.linear()
      .domain(domain)
      .range([leftMargin + linearScalePadding, (@legendWidth - linearScalePadding)])

    legendAxis = d3.svg.axis()
      .scale(getXInLegendFor)
      .orient("bottom")
      .tickValues(ticks)

    start = domain[0]
    stop = domain[1]
    numValues = 50
    step = Math.abs(stop - start) / numValues
    stepWidthInScale = Math.abs(getXInLegendFor.range()[0] - getXInLegendFor.range()[1]) / numValues
    legendData = d3.range(start, stop, step)

    getColourFor = @model.get('property').colourScale

    legendG.selectAll('rect')
      .data(legendData)
      .enter().append('rect')
      .attr('height',@LEGEND_RECT_HEIGHT)
      .attr('width', stepWidthInScale + 1)
      .attr('x', (d) -> getXInLegendFor d)
      .attr('y', -@LEGEND_RECT_HEIGHT)
      .attr('fill', (d) -> getColourFor d)

    rangeSelector1G = legendG.append('g')
      .attr("transform", "translate(" + (getXInLegendFor start) + ',' + -@LEGEND_RECT_HEIGHT + ")")
      .classed('legend-range-selector', true)
      .attr('data-range-value', start)

    rangeSelector2G = legendG.append('g')
      .attr("transform", "translate(" + (getXInLegendFor stop) + ',' + -@LEGEND_RECT_HEIGHT + ")")
      .classed('legend-range-selector', true)
      .attr('data-range-value', stop)

    nullSelectorG = legendG.append('g')
      .attr("transform", 'translate(0,' + -@LEGEND_RECT_HEIGHT + ")")

    nullSelectorG.append('rect')
      .attr('height',@LEGEND_RECT_HEIGHT)
      .attr('width', @LEGEND_RECT_HEIGHT)
      .attr('fill', glados.Settings.VISUALISATION_GRID_UNDEFINED)
      .classed('legend-rect', true)
      .classed('legend-rect-' + glados.Settings.DEFAULT_NULL_VALUE_LABEL, true)
      .on('click', $.proxy( (->
        console.log 'click', @
        @model.toggleValueSelection(glados.Settings.DEFAULT_NULL_VALUE_LABEL))
      , @))

    nullSelectorG.append('text')
      .attr('y', 2 * @LEGEND_RECT_HEIGHT)
      .attr('x', @LEGEND_RECT_HEIGHT / 2)
      .text(glados.Settings.DEFAULT_NULL_VALUE_LABEL)
      .attr('text-anchor', 'middle')

    thisView = @
    dragBehaviour = d3.behavior.drag()
      .on('drag', ->
        x = d3.event.x
        if x < leftMargin + linearScalePadding then return
        if x > thisView.legendWidth - linearScalePadding then return
        value = getXInLegendFor.invert(x).toFixed(2)
        draggedG = d3.select(@)
        draggedG.attr("transform", 'translate(' + x + ',' + -thisView.LEGEND_RECT_HEIGHT + ')')
          .attr('data-range-value', value)
        draggedG.select('text')
          .text(value)
      ).on('dragend', $.proxy(@selectRange, @))

    rangeSelector1G.call(dragBehaviour)
    rangeSelector2G.call(dragBehaviour)
    @paintRangeSelector(rangeSelector1G, start)
    @paintRangeSelector(rangeSelector2G, stop)
    legendG.call(legendAxis)

  paintRangeSelector: (selectorG, initialText) ->

    selectorG.append('rect')
      .attr('stroke', @RANGE_SELECTOR_STROKE)
      .attr('stroke-width', @RANGE_SELECTOR_STROKE_WIDTH)
      .attr('fill', @RANGE_SELECTOR_FILL)
      .attr('height', @LEGEND_RECT_HEIGHT)
      .attr('width', @RANGE_SELECTOR_WIDTH)

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



