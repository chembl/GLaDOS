glados.useNameSpace 'glados.views.Visualisation',
  HistogramView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      @config = arguments[0].config
      @model.on 'change:state', @render, @
      @$vis_elem = $(@el).find('.BCK-HistogramContainer')
      @setUpResponsiveRender()
      @xAxisAggName = @config.x_axis_prop_name

      if @config.initial_property_z?
        @subBucketsAggName = @config.properties[@config.initial_property_z].propName
        @currentZAxisProperty = @config.properties[@config.initial_property_z]
        @maxZCategories = @config.max_z_categories

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

    hideHistogramContent: -> $(@el).find('.BCK-HistogramContainer').hide()
    hideAxesSelectors: -> $(@el).find('.BCK-AxesSelectorContainer').hide()

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

    paintBinSizeRange: (currentBinSize=@model.get('bucket_data')[@xAxisAggName].bin_size) ->

      buckets = @model.get('bucket_data')[@xAxisAggName]
      $xAxisBinSizeRange = $(@el).find('.BCK-ESResultsPlot-selectXAxis-binSize')
      glados.Utils.fillContentForElement $xAxisBinSizeRange,
        current_value: currentBinSize
        min_value: buckets.min_bin_size
        max_value: buckets.max_bin_size

    handleXAxisPropertyChange: (event) ->

      newProperty = $(event.currentTarget).val()
      if newProperty == ''
        return

      @currentXAxisProperty = @config.properties[newProperty]
      newPropertyComparator = @currentXAxisProperty.propName

      @model.set('current_xaxis_property', newPropertyComparator)
      @model.changeFieldForAggregation(@xAxisAggName, newPropertyComparator)

    handleNumColumnsChange: (event) ->

      newColsNum = $(event.currentTarget).val()
      @paintNumBarsRange(newColsNum)
      @model.changeNumColumnsForAggregation(@xAxisAggName, newColsNum)

    handleBinSizeChange: (event) ->

      newBinSize = $(event.currentTarget).val()
      @paintBinSizeRange(newBinSize)
      @model.changeBinSizeForAggregation(@xAxisAggName, newBinSize)

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------

    render: ->

      # only bother if my element is visible
      if not $(@el).is(":visible")
        return
      if @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
        $visualisationMessages = $(@el).find('.BCK-VisualisationMessages')
        noDataMsg = if @config.big_size then 'No data available. ' + @config.title else 'No data.'
        $visualisationMessages.html(noDataMsg)
        @hideHistogramContent()
        @hideAxesSelectors()
        return

      if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE
        return

      @$vis_elem.empty()

      buckets = @model.get('bucket_data')[@xAxisAggName].buckets

      maxCategories = @config.max_categories

      if buckets.length > maxCategories
        buckets = glados.Utils.Buckets.mergeBuckets(buckets, maxCategories, @model, @xAxisAggName)

      if @config.big_size
        @paintBinSizeRange()
        @paintNumBarsRange(buckets.length)

      VISUALISATION_WIDTH = $(@el).width()
      VISUALISATION_HEIGHT = if @config.big_size then $(window).height() * 0.6 else 60

      if $(@el).parents('.visualisation-card').length > 0
        VISUALISATION_HEIGHT = @$vis_elem.height()

      if @config.max_height?
        VISUALISATION_HEIGHT = @config.max_height

      mainContainer = d3.select(@$vis_elem.get(0))
      mainSVGContainer = mainContainer
        .append('svg')
        .attr('class', 'mainSVGContainer')
        .attr('width', VISUALISATION_WIDTH)
        .attr('height', VISUALISATION_HEIGHT)

      thisView = @

      if @config.big_size
        TITLE_Y = 40
        TITLE_Y_PADDING = 40
        RIGHT_PADDING = 20
        X_AXIS_HEIGHT = 100
        Y_AXIS_WIDTH = 60

      else
        TITLE_Y = 10
        TITLE_Y_PADDING = 5
        RIGHT_PADDING = 0
        X_AXIS_HEIGHT = 0
        Y_AXIS_WIDTH = 0

      if @config.hide_title
        TITLE_Y = 0
        TITLE_Y_PADDING = 0

      if @config.hide_x_axis_title
        X_AXIS_HEIGHT = 30

      BARS_MIN_HEIGHT = 2

      @BARS_CONTAINER_HEIGHT = VISUALISATION_HEIGHT - TITLE_Y - TITLE_Y_PADDING - X_AXIS_HEIGHT
      @BARS_CONTAINER_WIDTH = (VISUALISATION_WIDTH - Y_AXIS_WIDTH - RIGHT_PADDING)
      X_AXIS_TRANS_Y =  @BARS_CONTAINER_HEIGHT + TITLE_Y + TITLE_Y_PADDING


      #-------------------------------------------------------------------------------------------------------------------
      # add histogram bars container
      #-------------------------------------------------------------------------------------------------------------------
      barsContainerG = mainSVGContainer.append('g')
        .attr('transform', 'translate('+ Y_AXIS_WIDTH + ',' + (TITLE_Y + TITLE_Y_PADDING) + ')')
      barsContainerG.append('rect')
        .attr('height', @BARS_CONTAINER_HEIGHT)
        .attr('width', @BARS_CONTAINER_WIDTH)
        .classed('bars-background', true)

      #-------------------------------------------------------------------------------------------------------------------
      # add histogram bars groups
      #-------------------------------------------------------------------------------------------------------------------
      bucketNames = (b.key for b in buckets)
      bucketSizes = (b.doc_count for b in buckets)

      if @config.fixed_bar_width
        barWidth = @BARS_CONTAINER_WIDTH / @config.max_categories
        xRangeEnd = barWidth * buckets.length
      else
        xRangeEnd = @BARS_CONTAINER_WIDTH

      thisView.getXForBucket = d3.scale.ordinal()
        .domain(bucketNames)
        .rangeRoundBands([0,xRangeEnd], 0.2)

      thisView.getHeightForBucket = d3.scale.linear()
        .domain([0, _.max(bucketSizes)])
        .range([BARS_MIN_HEIGHT, @BARS_CONTAINER_HEIGHT])

      if @config.stacked_histogram
        @renderStackedHistogramBars(barsContainerG, buckets)
      else
        @renderSimpleHistogramBars(barsContainerG, buckets)


      #-------------------------------------------------------------------------------------------------------------------
      # add legend
      #-------------------------------------------------------------------------------------------------------------------
      if @config.legend_vertical

        legendConfig =
          columns_layout: true
          hide_title: true
#
        if @config.max_height
          legendConfig =
          columns_layout: true
          hide_title: true
          max_height: $(@el).height() - @config.max_height

        legendElem = $(thisView.el).find('.BCK-CompResultsGraphLegendContainer')
        glados.Utils.renderLegendForProperty(@currentZAxisProperty, undefined, legendElem,
          enableSelection=false, legendConfig)

      #-----------------------------------------------------------------------------------------------------------------
      # add title
      #-----------------------------------------------------------------------------------------------------------------
      unless @config.hide_title
        totalItems = _.reduce(bucketSizes, ((a, b) -> a + b))
        totalItemsTxt = '(' + totalItems + ')'

        titleBase = if @config.title? then @config.title \
        else 'By ' + @config.properties[@config.initial_property_x].label_mini + ': '

        titleText = titleBase
        if @config.big_size
           titleText += ' ' + totalItemsTxt

        mainSVGContainer.append('text')
          .text(titleText)
          .attr('x', VISUALISATION_WIDTH/2)
          .attr('y', TITLE_Y)
          .attr('text-anchor', 'middle')
          .classed('title', @config.big_size)
          .on('click',
            if @config.title_link_url
              -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(thisView.config.title_link_url)
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
        .attr('x2', @BARS_CONTAINER_WIDTH)
        .classed('axis-line', true)

      xAxisContainerG.append('text')
        .text(() ->
        if @config.hide_x_axis_title
          @currentXAxisProperty.label
        )
        .attr('text-anchor', 'middle')
        .attr('x', @BARS_CONTAINER_WIDTH/2)
        .attr('y', X_AXIS_HEIGHT*(3/4))
        .classed('property-label', true)


      xAxis = d3.svg.axis()
        .scale(thisView.getXForBucket)

      elemWidth = $(@el).width()
      xAxisTickInterval = 3

      if elemWidth < 500
        xAxisTickInterval = 4
      if elemWidth < 400
        xAxisTickInterval = 5
      if elemWidth < 300
        xAxisTickInterval = 6

      if @config.stacked_histogram
        formatAsYear = d3.format("1999")
        xAxis.tickFormat(formatAsYear)
            .tickValues thisView.getXForBucket.domain().filter((d, i) -> !(i % xAxisTickInterval))


      xAxisContainerG.call(xAxis)

      if @config.rotate_x_axis_if_needed
        @rotateXAxisTicksIfNeeded(xAxisContainerG, thisView.getXForBucket)

      yAxisContainerG = mainSVGContainer.append('g')
        .attr('transform', 'translate(' + Y_AXIS_WIDTH + ',' + (TITLE_Y + TITLE_Y_PADDING) + ')')
        .classed('y-axis', true)

      yAxisContainerG.append('line')
        .attr('y2', @BARS_CONTAINER_HEIGHT)
        .classed('axis-line', true)

      # reverse the original scale range to get correct number order
      scaleForYAxis = d3.scale.linear()
        .domain(thisView.getHeightForBucket.domain())
        .range([thisView.getHeightForBucket.range()[1], thisView.getHeightForBucket.range()[0]])

      yAxis = d3.svg.axis()
        .scale(scaleForYAxis)
        .tickSize(-@BARS_CONTAINER_WIDTH, 0)
        .orient('left')

      yAxisContainerG.call(yAxis)
      if @config.stacked_histogram
        yAxisContainerG.selectAll('.tick line').style('display', 'none')
      else
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

    #-------------------------------------------------------------------------------------------------------------------
    # Simple Histogram
    #-------------------------------------------------------------------------------------------------------------------

    renderSimpleHistogramBars: (barsContainerG, buckets) ->
      thisView = @
      barGroups = barsContainerG.selectAll('.bar-group')
        .data(buckets)
        .enter()
        .append('g')
        .classed('bar-group', true)
        .attr('transform', (b) -> 'translate(' + thisView.getXForBucket(b.key) + ')')

      barGroups.append('rect')
        .attr('height', @BARS_CONTAINER_HEIGHT)
        .attr('width', thisView.getXForBucket.rangeBand())
        .classed('background-bar', true)

      h = @BARS_CONTAINER_HEIGHT
      valueBars = barGroups.append('rect')
        .attr('height', (b) -> thisView.getHeightForBucket(b.doc_count))
        .attr('width', thisView.getXForBucket.rangeBand())
        .attr('y', (b) -> h - thisView.getHeightForBucket(b.doc_count))
        .classed('value-bar', true)

      frontBar = barGroups.append('rect')
        .attr('height', @BARS_CONTAINER_HEIGHT)
        .attr('width', thisView.getXForBucket.rangeBand())
        .classed('front-bar', true)
        .on('click', (b) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(b.link) )

      barsColourScale = @config.bars_colour_scale
      if barsColourScale?
        valueBars.attr('fill', (b) -> barsColourScale(b.key))
      else
        valueBars.attr('fill', glados.Settings.VIS_COLORS.TEAL3)

        frontBar.on('mouseover', (d, i)->
          esto = d3.select(valueBars[0][i])
          esto.attr('fill', glados.Settings.VIS_COLORS.RED2))
        .on('mouseout', (d, i)->
          esto = d3.select(valueBars[0][i])
          esto.attr('fill', glados.Settings.VIS_COLORS.TEAL3))

      #-----------------------------------------------------------------------------------------------------------------
      # qtips
      #-----------------------------------------------------------------------------------------------------------------
      barGroups.each (d) ->

        if thisView.config.range_categories
          rangeText = '[' + d.key.replace('-', ',') + ']'
        else
          rangeText = d.key

        if thisView.config.stacked_histogram
          rangeText = d.key.split '.'
          rangeText = rangeText[0]


        text = '<b>' + rangeText + '</b>' + ": " + d.doc_count

        $(@).qtip
          content:
            text: text
          style:
            classes:'qtip-light'
          position:
            my: if thisView.config.big_size then 'bottom right' else 'top center'
            at: 'bottom center'
            target: 'mouse'
            adjust:
              y: -50


    #-------------------------------------------------------------------------------------------------------------------
    #  Stacked Histogram
    #-------------------------------------------------------------------------------------------------------------------

    renderStackedHistogramBars: (barsContainerG, buckets) ->

      subBucketsOrder = glados.Utils.Buckets.getSubBucketsOrder(buckets, @subBucketsAggName)
      thisView = @

      zScaleDomains = []
      for key, value of subBucketsOrder
          zScaleDomains.push(key)

      @currentZAxisProperty.domain = zScaleDomains
      glados.models.visualisation.PropertiesFactory.generateColourScale(@currentZAxisProperty)

      zScale = @currentZAxisProperty.colourScale

#     each bar container
      barGroups = barsContainerG.selectAll('.bar-group')
        .data(buckets)
        .enter()
        .append('g')
        .classed('bar-group', true)
        .attr('transform', (b) -> 'translate(' + thisView.getXForBucket(b.key) + ')')

      noOthersBucket = {}
      barGroups.each (d) ->
        subBuckets = d[thisView.subBucketsAggName].buckets

#       get total doc count for each bar group
        totalCount = 0
        for bucket in subBuckets
          totalCount += bucket.doc_count

#       get number of max categories for each bar group
        if thisView.config.max_categories?
          maxCategories = 0
          for bucket in subBuckets
            if bucket.doc_count > (totalCount * 0.02)
              maxCategories += 1

#        there should be at least 2 categories for the merge to work
        if maxCategories <= 1
          maxCategories++

        subBucketsCompleteAggName = "#{thisView.xAxisAggName}.aggs.#{thisView.subBucketsAggName}"
        subBuckets = glados.Utils.Buckets.mergeBuckets(subBuckets,  maxCategories, thisView.model, subBucketsCompleteAggName, subBuckets = true)

#       fills object with buckets that are not in the 'other' section (for legend domain)
        for bucket in subBuckets
          if not noOthersBucket[bucket.key]? and bucket.key != 'Other'
            noOthersBucket[bucket.key] = bucket

#       get xAxis interval name and pos for each stacked bar
        for bucket in subBuckets
          if bucket.key != glados.Visualisation.Activity.OTHERS_LABEL
            bucket.pos = subBucketsOrder[bucket.key].pos
            bucket.parent_key = d.key.split(".")[0]
        subBuckets = _.sortBy(subBuckets, (item) -> item.pos)

        previousHeight = thisView.BARS_CONTAINER_HEIGHT
        for bucket in subBuckets
          bucket.posY =  previousHeight - thisView.getHeightForBucket(bucket.doc_count)
          previousHeight = bucket.posY

#       stacked bars
        thisBarGroup = d3.select(@)
        stackedBarsGroups = thisBarGroup.selectAll('.bar-sub-group')
          .data(subBuckets)
          .enter()
          .append('g')
          .attr('transform', (b) -> "translate(0, #{b.posY})" )
          .classed('bar-group', true)

        stackedBarsGroups.append('rect')
          .attr('height', (b) -> thisView.getHeightForBucket(b.doc_count))
          .attr('width', thisView.getXForBucket.rangeBand())
          .attr('fill', (b) ->
            if b.key == 'Other'
              return glados.Settings.VIS_COLORS.GREY2
            else
              return zScale(b.key)
          )
          .on('click', (b) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen(b.link))

#       qtips
        stackedBarsGroups.each (d) ->

          key =  d.key
          docCount = d.doc_count
          barText = d.parent_key
          barName = thisView.currentXAxisProperty.label
          keyName = thisView.currentZAxisProperty.label

          text = '<b>' + keyName + '</b>' + ":  " + key + \
            '<br>' + '<b>' + "Count:  " + '</b>' + docCount + \
            '<br>' + '<b>' + barName + ":  "  + '</b>' +  barText
          $(@).qtip
            content:
              text: text
            style:
              classes:'qtip-light'
            position:
              my: if thisView.config.big_size then 'bottom right' else 'top center'
              at: 'bottom center'
              target: 'mouse'
              adjust:
                y: -10

#     only sends the buckets that are not in the 'others' section for rendering in the legend
      noOtherScaleDomains = []
      for key, value of noOthersBucket
          noOtherScaleDomains.push(key)
          
#     add 'other' to legend domain if there is a max number of categories
      if thisView.config.max_categories?
        noOtherScaleDomains.push('Other')
      @currentZAxisProperty.domain = noOtherScaleDomains