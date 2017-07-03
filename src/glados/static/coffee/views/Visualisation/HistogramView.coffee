glados.useNameSpace 'glados.views.Visualisation',
  HistogramView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      @config = arguments[0].config

      @model.on 'change', @render, @
      @$vis_elem = $(@el).find('.BCK-HistogramContainer')
      updateViewProxy = @setUpResponsiveRender()
      if @config.paint_axes_selectors
        @currentXAxisProperty = @config.properties[@config.initial_property_x]
        @paintAxesSelectors()
        @paintNumBarsRange()
      @showPreloader()

    events:
      'change .BCK-ESResultsPlot-selectXAxis': 'handleXAxisPropertyChange'
      'change .BCK-ESResultsPlot-selectXAxis-numBars input': 'handleNumColumnsChange'
      'change .BCK-ESResultsPlot-selectXAxis-binSize input': 'handleBinSizeChange'

    showPreloader: ->
      if @config.big_size
        glados.Utils.fillContentForElement(@$vis_elem, {}, 'Handlebars-Common-Preloader')
      else
        glados.Utils.fillContentForElement(@$vis_elem, {}, 'Handlebars-Common-MiniRepCardPreloader')

    # ------------------------------------------------------------------------------------------------------------------
    # axes selectors
    # ------------------------------------------------------------------------------------------------------------------
    paintAxesSelectors: ->
      $xAxisSelector = $(@el).find('.BCK-ESResultsPlot-selectXAxis')
      glados.Utils.fillContentForElement $xAxisSelector,
        options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_x}) for opt in @config.x_axis_options)

      $(@el).find('select').material_select()

    paintNumBarsRange: (currentValue=@config.x_axis_initial_num_columns) ->

      $xAxisNumBarsRange = $(@el).find('.BCK-ESResultsPlot-selectXAxis-numBars')
      glados.Utils.fillContentForElement $xAxisNumBarsRange,
        current_value: currentValue
        min_value: @config.x_axis_min_columns
        max_value: @config.x_axis_max_columns

    paintBinSizeRange: (currentBinSize=@model.get('bin_size')) ->

      console.log 'painting range with: ', currentBinSize
      $xAxisBinSizeRange = $(@el).find('.BCK-ESResultsPlot-selectXAxis-binSize')
      glados.Utils.fillContentForElement $xAxisBinSizeRange,
        current_value: currentBinSize
        min_value: @model.get('min_bin_size')
        max_value: @model.get('max_bin_size')

    handleXAxisPropertyChange: (event) ->

      newProperty = $(event.currentTarget).val()
      if newProperty == ''
        return

      @currentXAxisProperty = @config.properties[newProperty]
      newPropertyComparator = @currentXAxisProperty.propName
      @model.set('current_xaxis_property', newPropertyComparator)
      @model.fetch()

    handleNumColumnsChange: (event) ->

      newColsNum = $(event.currentTarget).val()
      @model.set('num_columns', newColsNum)
      @paintNumBarsRange(newColsNum)
      @model.fetch()

    handleBinSizeChange: (event) ->

      newBinSize = $(event.currentTarget).val()
      @paintBinSizeRange(newBinSize)
      console.log 'new bin size: ', newBinSize
      @model.set('custom_interval_size', newBinSize)
      @model.fetch()

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------

    # returns the buckets that are going to be used for the visualisation
    # actual buckets may be merged into "other" depending on @maxCategories
    getBucketsForView: ->
      buckets =  @model.get('buckets')
      maxCategories = @config.max_categories

      if buckets.length > maxCategories
        buckets = glados.Utils.Buckets.mergeBuckets(buckets, maxCategories, @model)

      return buckets

    render: ->

      console.log 'RENDER HISTOGRAM!'
      @$vis_elem.empty()

      if @config.range_categories
        buckets = @model.get('buckets')
      else
        buckets = @getBucketsForView()

      if buckets.length == 0
        $visualisationMessages = $(@el).find('.BCK-VisualisationMessages')
        noDataMsg = if @config.big_size then 'No data available. ' + @config.title else 'No data.'
        $visualisationMessages.html(noDataMsg)
        return

      if @config.big_size
        @paintBinSizeRange()
        @paintNumBarsRange(@model.get('num_columns'))

      VISUALISATION_WIDTH = $(@el).width()
      VISUALISATION_HEIGHT = if @config.big_size then $(window).height() * 0.6 else 60

      mainContainer = d3.select(@$vis_elem.get(0))
      mainSVGContainer = mainContainer
        .append('svg')
        .attr('class', 'mainSVGContainer')
        .attr('width', VISUALISATION_WIDTH)
        .attr('height', VISUALISATION_HEIGHT)

      thisView = @
      TITLE_Y = if @config.big_size then 30 else 10
      TITLE_Y_PADDING = if @config.big_size then 15 else 5
      BARS_MIN_HEIGHT = 2
      RIGHT_PADDING = if @config.big_size then 20 else 0

      X_AXIS_HEIGHT = if @config.big_size then 100 else 0
      Y_AXIS_WIDTH = if @config.big_size then 60 else 0

      BARS_CONTAINER_HEIGHT = VISUALISATION_HEIGHT - TITLE_Y - TITLE_Y_PADDING - X_AXIS_HEIGHT
      BARS_CONTAINER_WIDTH = VISUALISATION_WIDTH - Y_AXIS_WIDTH - RIGHT_PADDING
      X_AXIS_TRANS_Y =  BARS_CONTAINER_HEIGHT + TITLE_Y + TITLE_Y_PADDING

      #-------------------------------------------------------------------------------------------------------------------
      # add histogram bars container
      #-------------------------------------------------------------------------------------------------------------------
      barsContainerG = mainSVGContainer.append('g')
        .attr('transform', 'translate('+ Y_AXIS_WIDTH + ',' + (TITLE_Y + TITLE_Y_PADDING) + ')')
      barsContainerG.append('rect')
        .attr('height', BARS_CONTAINER_HEIGHT)
        .attr('width', BARS_CONTAINER_WIDTH)
        .classed('bars-background', true)

      #-------------------------------------------------------------------------------------------------------------------
      # add histogram bars groups
      #-------------------------------------------------------------------------------------------------------------------
      bucketNames = (b.key for b in buckets)
      bucketSizes = (b.doc_count for b in buckets)

      if @config.fixed_bar_width
        barWidth = BARS_CONTAINER_WIDTH / @config.max_categories
        xRangeEnd = barWidth * buckets.length
      else
        xRangeEnd = BARS_CONTAINER_WIDTH

      getXForBucket = d3.scale.ordinal()
        .domain(bucketNames)
        .rangeBands([0,xRangeEnd], 0.1)
      getHeightForBucket = d3.scale.linear()
        .domain([0, _.max(bucketSizes)])
        .range([BARS_MIN_HEIGHT, BARS_CONTAINER_HEIGHT])

      barGroups = barsContainerG.selectAll('.bar-group')
        .data(buckets)
        .enter()
        .append('g')
        .classed('bar-group', true)
        .attr('transform', (b) -> 'translate(' + getXForBucket(b.key) + ')')

      barGroups.append('rect')
        .attr('height', BARS_CONTAINER_HEIGHT)
        .attr('width', getXForBucket.rangeBand())
        .classed('background-bar', true)

      valueBars = barGroups.append('rect')
        .attr('height', (b) -> getHeightForBucket(b.doc_count))
        .attr('width', getXForBucket.rangeBand())
        .attr('y', (b) -> BARS_CONTAINER_HEIGHT - getHeightForBucket(b.doc_count) )
        .classed('value-bar', true)

      barsColourScale = @config.bars_colour_scale
      if barsColourScale?
        valueBars.attr('fill', (b) -> barsColourScale(b.key))
      else
        valueBars.attr('fill', glados.Settings.VISUALISATION_TEAL_BASE)

      barGroups.append('rect')
        .attr('height', BARS_CONTAINER_HEIGHT)
        .attr('width', getXForBucket.rangeBand())
        .classed('front-bar', true)
        .on('click', (b) -> window.open(b.link) )

      #-----------------------------------------------------------------------------------------------------------------
      # add qtips
      #-----------------------------------------------------------------------------------------------------------------
      barGroups.each (d) ->

        if thisView.config.range_categories
          rangeText = '[' + d.key.replace('-', ',') + ')'
        else
          rangeText = d.key

        text = '<b>' + rangeText + '</b>' + ":" + d.doc_count

        $(@).qtip
          content:
            text: text
          style:
            classes:'qtip-light'
          position:
            my: if thisView.config.big_size then 'bottom center' else 'top center'
            at: 'bottom center'

      #-----------------------------------------------------------------------------------------------------------------
      # add title
      #-----------------------------------------------------------------------------------------------------------------
      totalItems = _.reduce(bucketSizes, ((a, b) -> a + b))
      totalItemsTxt = '(' + totalItems + ')'
      titleBase = if @config.title? then @config.title else 'Browse All'
      mainSVGContainer.append('text')
        .text(titleBase + ' ' + totalItemsTxt)
        .attr('x', VISUALISATION_WIDTH/2)
        .attr('y', TITLE_Y)
        .attr('text-anchor', 'middle')
        .classed('title', true)
        .on('click', ->
          window.open(thisView.model.get('link_to_all'))
      )

      if not @config.big_size
        return
      #-----------------------------------------------------------------------------------------------------------------
      # add Axes when is big size
      #-----------------------------------------------------------------------------------------------------------------
      xAxisContainerG = mainSVGContainer.append('g')
        .attr('transform', 'translate(' + Y_AXIS_WIDTH + ',' + X_AXIS_TRANS_Y + ')')
        .classed('x-axis', true)

      xAxisContainerG.append('line')
        .attr('x2', BARS_CONTAINER_WIDTH)
        .classed('axis-line', true)

      xAxisContainerG.append('text')
        .text(@currentXAxisProperty.label)
        .attr('text-anchor', 'middle')
        .attr('x', BARS_CONTAINER_WIDTH/2)
        .attr('y', X_AXIS_HEIGHT*(3/4))
        .classed('property-label', true)

      xAxis = d3.svg.axis()
        .scale(getXForBucket)

      xAxisContainerG.call(xAxis)
      @rotateXAxisTicksIfNeeded(xAxisContainerG, getXForBucket)

      yAxisContainerG = mainSVGContainer.append('g')
        .attr('transform', 'translate(' + Y_AXIS_WIDTH + ',' + (TITLE_Y + TITLE_Y_PADDING) + ')')
        .classed('y-axis', true)

      yAxisContainerG.append('line')
        .attr('y2', BARS_CONTAINER_HEIGHT)
        .classed('axis-line', true)

      # reverse the original scale range to get correct number order
      scaleForYAxis = d3.scale.linear()
        .domain(getHeightForBucket.domain())
        .range([getHeightForBucket.range()[1], getHeightForBucket.range()[0]])

      yAxis = d3.svg.axis()
        .scale(scaleForYAxis)
        .tickSize(-BARS_CONTAINER_WIDTH, 0)
        .orient('left')

      yAxisContainerG.call(yAxis)
      yAxisContainerG.selectAll('.tick line')
        .attr("stroke-dasharray", "4,10")
      # remove first tick line, was not able to do it with css
      yAxisContainerG.select('.tick line').style('display', 'none')

    rotateXAxisTicksIfNeeded: (xAxisContainerG, getXForBucket) ->
      # check if ticks are too big
      xAxisTexts = xAxisContainerG.selectAll('.tick text')
      xAxisRangeBand = getXForBucket.rangeBand()

      maxWidth = 0
      xAxisTexts.each (d) ->
        currentWidth = @getBBox().width
        if currentWidth > maxWidth
          maxWidth = currentWidth

      if maxWidth > xAxisRangeBand
        # make texts smaller
        xAxisTexts.classed('rotated', true)
        # and calculate again the max width
        maxWidth = 0
        xAxisTexts.each (d) ->
          currentWidth = @getBBox().width
          if currentWidth > maxWidth
            maxWidth = currentWidth

        if maxWidth > xAxisRangeBand
          #https://drive.google.com/file/d/0BzECtlZ_ur1Ca0Q0TnJKOFNEMnM/view?usp=sharing
          # remember that text anchor is in the middle
          alpha = Math.acos(xAxisRangeBand/maxWidth)
          h = (xAxisRangeBand/2) * Math.tan(alpha)
          alphaDeg = glados.Utils.getDegreesFromRadians(alpha)
          xAxisTexts.attr('transform', 'translate(0,'+ h + ')rotate(' + alphaDeg + ')')

          ticksContainerGs = xAxisContainerG.selectAll('.tick')
          ticksContainerGs.append('line')
            .classed('axis-helper-line', true)
            .attr('y2', h)





