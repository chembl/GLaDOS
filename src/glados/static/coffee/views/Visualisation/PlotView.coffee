# this view is in charge of showing a collection of elements as a plot
PlotView = Backbone.View.extend(ResponsiviseViewExt).extend

  events:
    'change .select-xaxis,.select-yaxis,.select-colour': 'changeAxis'

  initialize: ->

    @XAXIS = 'x-axis'
    @YAXIS = 'y-axis'
    @COLOUR = 'colour'
    @ORDINAL = 'ORDINAL'
    @LINEAR = 'LINEAR'

    @collection.on glados.Events.Collections.SELECTION_UPDATED, @selectionChangedHandler, @

    @$vis_elem = $(@el).find('.BCK-CompResultsGraphContainer')
    updateViewProxy = @setUpResponsiveRender()

    @config = arguments[0].config

    @idProperty = @config.properties[@config.id_property]
    @labelerProperty = @config.properties[@config.labeler_property]
    @currentPropertyX = @config.properties[@config.initial_property_x]
    @currentPropertyY = @config.properties[@config.initial_property_y]
    @currentPropertyColour = @config.properties[@config.initial_property_colour]

    @paintSelectors()

  selectionChangedHandler: ->

    # only bother if my element is visible
    if not $(@el).is(":visible")
      return

    newBorderColours = @getBorderColours(@shownElements, @getColourFor)
    newBorderWidths = @getBorderWidths(@shownElements)

    update = {
      'marker.line':
        color: newBorderColours
        width: newBorderWidths
    }

    Plotly.restyle(@$vis_elem.get(0), update, 0)
    @renderRejectedElements()

  selectItems: (idsList) -> @collection.selectItems(idsList)

  renderWhenError: ->

    @clearVisualisation()
    $(@el).find('select').material_select('destroy');

    @$vis_elem.html Handlebars.compile($('#Handlebars-Common-PlotError').html())
      static_images_url: glados.Settings.STATIC_IMAGES_URL

  render: ->

    if @collection.DOWNLOAD_ERROR_STATE
      @renderWhenError()
      return

    # only bother if my element is visible
    if $(@el).is(":visible")

      console.log 'RENDER GRAPH!'
      $messagesElement = $(@el).find('.BCK-VisualisationMessages')
      $messagesElement.html Handlebars.compile($('#' + $messagesElement.attr('data-hb-template')).html())
        message: 'Loading Visualisation...'

      @clearVisualisation()
      @paintGraph()
      $(@el).find('select').material_select()

      $messagesElement.html ''

  paintSelectors: ->

    $xAxisSelector = $(@el).find('.BCK-ESResultsPlot-selectXAxis')

    $xAxisSelector.html Handlebars.compile($('#' + $xAxisSelector.attr('data-hb-template')).html())
      options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_x}) for opt in @config.x_axis_options)

    $yAxisSelector = $(@el).find('.BCK-ESResultsPlot-selectYAxis')
    $yAxisSelector.html Handlebars.compile($('#' + $yAxisSelector.attr('data-hb-template')).html())
      options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_y}) for opt in @config.y_axis_options)

    $colourSelector = $(@el).find('.BCK-ESResultsPlot-selectColour')
    $colourSelector.html Handlebars.compile($('#' + $colourSelector.attr('data-hb-template')).html())
      options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_colour}) for opt in @config.colour_options)


  clearVisualisation: ->

     $legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
     $legendContainer.empty()
     @$vis_elem.empty()
     $(@el).find('.BCK-CompResultsGraphRejectedResults').empty()

  changeAxis: (event) ->

    $selector = $(event.currentTarget)
    newProperty = $selector.val()
    if newProperty == ''
      return

    if $selector.hasClass('select-xaxis')
      console.log 'changing property to: ', newProperty
      @currentPropertyX = @config.properties[newProperty]
    else if $selector.hasClass('select-yaxis')
      @currentPropertyY = @config.properties[newProperty]
    else if $selector.hasClass('select-colour')
      @currentPropertyColour = @config.properties[newProperty]

    @clearVisualisation()
    @paintGraph()

  getBorderColours: (items, colourScale) ->

    thisView = @
    return items.map (item) ->
      if thisView.collection.itemIsSelected(glados.Utils.getNestedValue(item, thisView.idProperty.propName))
        return glados.Settings.VISUALISATION_SELECTED
      else return colourScale.range()[colourScale.range().length - 1]

  getBorderWidths: (items) ->

    thisView = @
    return items.map (item) ->
      if thisView.collection.itemIsSelected(glados.Utils.getNestedValue(item, thisView.idProperty.propName))
        return 2.5
      else return 0.5

  fillRejectedItemsSelection: (items) ->

    thisView = @
    return items.map (item) ->
      item.selected = thisView.collection.itemIsSelected(item.id)

  renderRejectedElements: ->

    @fillRejectedItemsSelection(@rejectedElements)
    $rejectedReslutsInfo = $(@el).find('.BCK-CompResultsGraphRejectedResults')
    $rejectedReslutsInfo.empty()
    if @rejectedElements.length
      glados.Utils.fillContentForElement $rejectedReslutsInfo,
        rejected: @rejectedElements
    else
      $rejectedReslutsInfo.html('')

  paintGraph: ->

    thisView = @
    @shownElements = @collection.allResults
    @rejectedElements = []
    # ignore molecules for which any value on any of the axes is null, they are not shown by plotly and they
    # can mess the axes range
    @shownElements = _.reject(@shownElements, (mol) ->

      for propName in [thisView.currentPropertyX.propName,
        thisView.currentPropertyY.propName,
        thisView.currentPropertyColour.propName]
        value = glados.Utils.getNestedValue(mol, propName)
        if !value? or value == glados.Settings.DEFAULT_NULL_VALUE_LABEL
          thisView.rejectedElements.push
            id: glados.Utils.getNestedValue(mol, thisView.labelerProperty.propName)
          return true

      return false
    )
    @renderRejectedElements()

    if not @currentPropertyColour.colourScale?
      if not @currentPropertyColour.domain?
        values = (glados.Utils.getNestedValue(mol, @currentPropertyColour.propName) for mol in @shownElements)
        glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(@currentPropertyColour, values)
      glados.models.visualisation.PropertiesFactory.generateColourScale(@currentPropertyColour)

    @getColourFor = @currentPropertyColour.colourScale

    xValues = (glados.Utils.getNestedValue(mol, @currentPropertyX.propName) for mol in @shownElements)
    yValues = (glados.Utils.getNestedValue(mol, @currentPropertyY.propName) for mol in @shownElements)
    labels = (glados.Utils.getNestedValue(mol, @labelerProperty.propName) for mol in @shownElements)
    ids = (glados.Utils.getNestedValue(mol, @idProperty.propName) for mol in @shownElements)
    colours = (@getColourFor(glados.Utils.getNestedValue(mol, @currentPropertyColour.propName)) for mol in @shownElements)
    borderColours = @getBorderColours(@shownElements, @getColourFor)
    borderWidths = @getBorderWidths(@shownElements)

    trace1 = {
      x: xValues,
      y: yValues,
      # custom property to identify the dots
      ids: ids
      mode: 'markers',
      type: 'scatter',
      text: labels,
      textposition: 'top center',
      marker: {
        opacity: 0.8
        size: 12
        color: colours
        line:
          width: borderWidths
          color: borderColours
      }
    }

    legendData = [trace1]
    layout = {
      xaxis: {title: @currentPropertyX.label}
      yaxis: {title: @currentPropertyY.label}
      hovermode: 'closest'
    }

    graphDiv = @$vis_elem.get(0)

    Plotly.newPlot(graphDiv, legendData, layout)

    graphDiv.on('plotly_click', (eventInfo) ->
      pointNumber = eventInfo.points[0].pointNumber
      clickedChemblID = eventInfo.points[0].data.ids[pointNumber]
      window.open(Compound.get_report_card_url(clickedChemblID))
    )

    graphDiv.on('plotly_selected', (eventData) ->
      if not eventData?
        return
      thisView.selectItems(_.pluck(eventData.points, 'id'))
    )

    # --------------------------------------
    # Legend initialisation
    # --------------------------------------
    elemWidth = $(@el).width()
    horizontalPadding = 10
    legendWidth = 0.4 * elemWidth
    legendHeight = glados.Settings.VISUALISATION_LEGEND_HEIGHT
    $legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
    $legendContainer.empty()
    legendContainer = d3.select($legendContainer.get(0))

    legendSVG = legendContainer.append('svg')
      .attr('width', legendWidth + 2 * horizontalPadding )
      .attr('height', legendHeight )

    # --------------------------------------
    # Fill legend details
    # --------------------------------------

    fillLegendDetails = ->

      legendSVG.selectAll('g').remove()
      legendSVG.selectAll('text').remove()

      legendG = legendSVG.append('g')
              .attr("transform", "translate(" + horizontalPadding + "," + (legendHeight - 30) + ")")

      legendSVG.append('text')
        .text(thisView.currentPropertyColour.label)
        .attr("class", 'plot-colour-legend-title')

      # center legend title
      textWidth = d3.select('.plot-colour-legend-title').node().getBBox().width
      xTrans = (legendWidth - textWidth) / 2

      legendSVG.select('.plot-colour-legend-title')
        .attr("transform", "translate(" + xTrans + ", 35)")

      rectangleHeight = glados.Settings.VISUALISATION_LEGEND_RECT_HEIGHT
      colourDataType = thisView.currentPropertyColour.type

      if colourDataType == 'string'

        domain = @getColourFor.domain()
        getXInLegendFor = d3.scale.ordinal()
          .domain( domain )
          .rangeBands([0, legendWidth])

        legendAxis = d3.svg.axis()
          .scale(getXInLegendFor)
          .orient("bottom")

        legendG.selectAll('rect')
          .data(getXInLegendFor.domain())
          .enter().append('rect')
          .attr('height',rectangleHeight)
          .attr('width', getXInLegendFor.rangeBand())
          .attr('x', (d) -> getXInLegendFor d)
          .attr('y', -rectangleHeight)
          .attr('fill', (d) -> thisView.getColourFor d)

        legendG.call(legendAxis)

      else if colourDataType == 'number'

        domain = thisView.getColourFor.domain()
        linearScalePadding = 10
        getXInLegendFor = d3.scale.linear()
          .domain(domain)
          .range([linearScalePadding, (legendWidth - linearScalePadding)])

        getXInLegendFor.ticks(3)

        legendAxis = d3.svg.axis()
          .scale(getXInLegendFor)
          .orient("bottom")

        start = domain[0]
        stop = domain[1]
        numValues = 50
        step = Math.abs(stop - start) / numValues
        stepWidthInScale = Math.abs(getXInLegendFor.range()[0] - getXInLegendFor.range()[1]) / numValues

        legendData = d3.range(start, stop, step)

        legendAxis.tickValues([
          legendData[0]
          legendData[parseInt(legendData.length * 0.25)],
          legendData[parseInt(legendData.length * 0.5)],
          legendData[parseInt(legendData.length * 0.75)],
          legendData[legendData.length - 1],
        ])

        legendG.selectAll('rect')
          .data(legendData)
          .enter().append('rect')
          .attr('height',rectangleHeight)
          .attr('width', stepWidthInScale + 1)
          .attr('x', (d) -> getXInLegendFor d)
          .attr('y', -rectangleHeight)
          .attr('fill', (d) -> thisView.getColourFor d)

        legendG.call(legendAxis)

    $legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
    glados.Utils.renderLegendForProperty(@currentPropertyColour, @collection, $legendContainer)