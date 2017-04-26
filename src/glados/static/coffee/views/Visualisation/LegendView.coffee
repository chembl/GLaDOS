# this view is in charge of painting legends
LegendView = Backbone.View.extend(ResponsiviseViewExt).extend

  LEGEND_HEIGHT: 110
  LEGEND_RECT_HEIGHT: 20
  LEGEND_TEXT_Y: -25

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
    rectClassSelector = '.legend-rect-' + value
    d3.select($(@el).find(rectClassSelector)[0])
      .style('stroke', glados.Settings.VISUALISATION_SELECTED)
      .attr('data-is-selected', true)

  valueUnselectedHandler: (value) ->
    rectClassSelector = '.legend-rect-' + value
    d3.select($(@el).find(rectClassSelector)[0])
      .style('stroke', 'none')
      .attr('data-is-selected', false)

  render: ->

    @clearLegend()
    console.log 'RENDER LEGEND!'
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

    @addExtraCss()

  paintDiscreteLegend: (legendG) ->

    rectanglePadding = 1
    getXInLegendFor = d3.scale.ordinal()
      .domain( @model.get('domain') )
      .rangeBands([0, @legendWidth])

    legendAxis = d3.svg.axis()
      .scale(getXInLegendFor)
      .orient("bottom")

    getColourFor = d3.scale.ordinal()
        .domain( @model.get('domain') )
        .range( @model.get('colour-range') )

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



