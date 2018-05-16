# this view is in charge of showing a collection of elements as a pie chart
PieView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @config = arguments[0].config
    @xAxisAggName = @config.x_axis_prop_name
    @xAxisPropName = @config.properties[@xAxisAggName]
    @model.on 'change', @render, @
    @$vis_elem = $(@el).find('.BCK-pie-container')
    updateViewProxy = @setUpResponsiveRender()

    if @config.stacked_donut
      @splitSeriesAggName = @config.split_series_prop_name
      @splitSeriesPropName = @config.properties[@config.initial_property_z]
      @xAxisPropName = @config.properties[@config.initial_property_x]

  showNoDataFoundMessage: ->

    $visualisationMessages = $(@el).find('.BCK-VisualisationMessages')

    if @config.custom_empty_message?
      emptyMessage = @config.custom_empty_message
    else
      emptyMessage = "No data available. #{@config.title}"

    glados.Utils.fillContentForElement $visualisationMessages,
      msg: emptyMessage

    $mainPieContainer = $(@el)
    $mainPieContainer.addClass('pie-with-error')

  emptyPie: ->

    $titleContainer = $(@el).find('.BCK-pie-title')
    $titleContainer.empty()
    @$vis_elem.empty()

    $legendElem = $(@el).find('.BCK-CompResultsGraphLegendContainer')
    $legendElem.empty()

    $visualisationMessages = $(@el).find('.BCK-VisualisationMessages')
    $visualisationMessages.empty()

    $mainPieContainer = $(@el)
    $mainPieContainer.removeClass('pie-with-error')

  render: ->

    @emptyPie()
    if @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
      @showNoDataFoundMessage()
      return

    if @model.get('state') == glados.models.Aggregations.Aggregation.States.LOADING_BUCKETS
      return

    if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE
      return

    buckets =  @model.get('bucket_data')[@xAxisAggName].buckets
    if buckets.length == 0
      @showNoDataFoundMessage()
      return

    maxCategories = @config.max_categories
    if buckets.length > maxCategories
      buckets = glados.Utils.Buckets.mergeBuckets(buckets, maxCategories, @model, @config.x_axis_prop_name)

    if not @config.hide_title
      $titleContainer = $(@el).find('.BCK-pie-title')
      glados.Utils.fillContentForElement $titleContainer,
        title: @config.title
        title_url: @config.title_link_url

    if @config.stacked_donut
      @renderStackedDonut(buckets, maxCategories)
    else
      @renderSimplePie(buckets)

# ----------------------------------------------------------------------------------------------------------------------
# RENDER STACKED DONUT
# ----------------------------------------------------------------------------------------------------------------------
  renderStackedDonut: (buckets) ->
    thisView = @
    thisView.$vis_elem.empty()

    if @config.side_legend
      VISUALISATION_WIDTH = $(@el).width() - $(@el).width() * 0.30
    else
      VISUALISATION_WIDTH = $(@el).width()
    VISUALISATION_HEIGHT = VISUALISATION_WIDTH
    if $(@el).parents('.visualisation-card')
      VISUALISATION_HEIGHT = @$vis_elem.height()
    TITLE_Y = 40
    PADDING = 40
    MAX_VIS_WIDTH = Math.min(VISUALISATION_WIDTH, VISUALISATION_HEIGHT) - PADDING
    RADIUS = MAX_VIS_WIDTH / (4 * (@config.stacked_levels + 1))
    X_CENTER = VISUALISATION_WIDTH/2
    Y_CENTER = VISUALISATION_HEIGHT/2 + TITLE_Y/2

    mainContainer = d3.select(@$vis_elem.get(0))
    mainSVGContainer = mainContainer
      .append('svg')
        .attr('class', 'mainSVGContainer')
        .attr('width', VISUALISATION_WIDTH)
        .attr('height', VISUALISATION_HEIGHT)

    arcsContainer = mainSVGContainer.append('g')
    subArcsContainer = mainSVGContainer.append('g')

    arcsContainer.append('rect')
        .attr('height', VISUALISATION_HEIGHT)
        .attr('width', VISUALISATION_WIDTH)
        .attr('fill', 'white')
        .classed('arcs-background', true)

    buckets = _.sortBy buckets, (item) -> item.key
    bucketSizes = (b.doc_count for b in buckets)

    #buckets colour scale
    glados.models.visualisation.PropertiesFactory.generateColourScale(@xAxisPropName)
    color = @xAxisPropName.colourScale

    subBucketsOrder = glados.Utils.Buckets.getSubBucketsOrder(buckets, @splitSeriesAggName)

    #sub buckets colour scale
    zScaleDomains = []
    for key, value of subBucketsOrder
      zScaleDomains.push(key)

    @splitSeriesPropName.domain = zScaleDomains


#   paint inner slices
    pie = d3.layout.pie()
      .sort(null)

    innerArc = d3.svg.arc()
      .innerRadius(RADIUS*2)
      .outerRadius(RADIUS*4)

    outerArc = d3.svg.arc()
        .innerRadius(RADIUS*4)
        .outerRadius(RADIUS*5.5)

#   add bucket data to pie data
    bucketsData = pie(bucketSizes)
    for i in [0..buckets.length-1]
      currentDatum = bucketsData[i]
      currentBucket = buckets[i]
      _.extend(currentDatum, currentBucket)

    arcs = arcsContainer.selectAll('g.arc')
      .data(bucketsData)
      .enter()
      .append('g')
        .attr('class', 'arc')
        .attr('transform', 'translate(' + X_CENTER + ', ' + Y_CENTER + ')')
        .on('click', (d) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen d.link)

    arcs.append('path')
      .attr('fill', (d) -> color(d.key))
      .attr('stroke-width', 1)
      .attr('stroke', 'white')
      .attr('d', innerArc)

    arcs.append('text')
      .attr('class', 'arc-text')
      .attr('text-anchor', 'middle')
      .attr('alignment-baseline', 'middle')
      .text((d, i) -> i)
      .attr('fill', 'white')
      .attr('transform', (d) ->
        angle = Math.PI/2 + (d.endAngle + d.startAngle)/2
        x = -Math.cos(angle) * RADIUS*3
        y = -Math.sin(angle) * RADIUS*3
        'translate(' + x + ', ' + y + ')')

    noOthersBucket = {}
    wholePieCount = 0
    for bucket in buckets
      wholePieCount += bucket.doc_count

    for bucket, i in buckets
      subBuckets = bucket[thisView.splitSeriesAggName].buckets

      totalBucketCount = 0
      for subBucket in subBuckets
        totalBucketCount += subBucket.doc_count

      maxCategories = 0
      for subBucket in subBuckets

        if 100/wholePieCount * buckets[i].doc_count > 20
          if subBucket.doc_count > totalBucketCount * 0.04
            maxCategories += 1
        else
          if subBucket.doc_count > totalBucketCount * 0.06
            maxCategories += 1

      if maxCategories <= 1
        maxCategories++

#     get 'Other' sub Buckets
      subBucketsCompleteAggName = "#{thisView.xAxisAggName}.aggs.#{thisView.splitSeriesAggName}"
      subBuckets = glados.Utils.Buckets.mergeBuckets(subBuckets,  maxCategories, thisView.model, subBucketsCompleteAggName, subBuckets=true)

#     fills object with buckets that are not in the 'other' section (for legend domain)
      for bucket in subBuckets
        if not noOthersBucket[bucket.key]? and bucket.key != 'Other'
          noOthersBucket[bucket.key] = bucket

#     only sends the buckets that are not in the 'others' section for rendering in the legend
      noOtherScaleDomains = []
      for key, value of noOthersBucket
          noOtherScaleDomains.push(key)
      noOtherScaleDomains.push('Other')
      @splitSeriesPropName.domain = noOtherScaleDomains

      glados.models.visualisation.PropertiesFactory.generateColourScale(@splitSeriesPropName)
      color2 = @splitSeriesPropName.colourScale

#     paint outter slices
      subBucketSizes = (b.doc_count for b in subBuckets)

      bigSlice =  pie(bucketSizes)[i]

      aggregationPie = d3.layout.pie()
        .startAngle(bigSlice.startAngle)
        .endAngle(bigSlice.endAngle)
        .sort(null)

      # add subucket data to aggregation pie data
      subBucketsData = aggregationPie(subBucketSizes)
      for i in [0..subBuckets.length-1]
        currentDatum = subBucketsData[i]
        currentBucket = subBuckets[i]
        _.extend(currentDatum, currentBucket)

      subArcs = subArcsContainer.selectAll('g.arc')
        .data(subBucketsData)
        .enter()
        .append('g')
          .attr('class', 'sub-arc')
          .attr('transform', 'translate(' + X_CENTER + ', ' + Y_CENTER + ')')
          .on('click', (d) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen d.link )
          .attr('fill', (d) ->
            if d.key == 'Other'
              glados.Settings.VIS_COLORS.GREY2
            else
              color2(d.key)
          )

      subArcs.append('path')
        .attr('stroke-width', 0.5)
        .attr('stroke', 'white')
        .attr('d', outerArc)

#     qtips outter slices
      for subArc, i in subArcs[0]
        parentPropName = thisView.xAxisPropName.label
        propName = thisView.splitSeriesPropName.label

        subBucketName = subBuckets[i].key
        parentBucketName = subBuckets[i].parent_key
        count = subBuckets[i].doc_count

        text = '<b>' + propName + '</b>' + ":  " + subBucketName + '<br>'  \
              + '<b>' + parentPropName + '</b>' + ":  " + parentBucketName + '<br>' \
              + '<b>' + "Count:  " + '</b>' + count + '<br>'
        $(subArc).qtip
          content:
            text: text
          style:
            classes:'qtip-light'
          position:
            my: 'bottom left'
            at: 'top right'
            target: 'mouse'
            adjust:
              y: -5
              x: 5

#   legend
    legendConfig =
              columns_layout: true
              hide_title: true
              side_legend: @config.side_legend

    legendElem = $(thisView.el).find('.BCK-CompResultsGraphLegendContainer')
    glados.Utils.renderLegendForProperty(@splitSeriesPropName, undefined, legendElem, enableSelection=false, legendConfig)
    $(thisView.el).find('.BCK-CompResultsGraphLegendContainer').css('max-height', VISUALISATION_HEIGHT);


#   title
    mainSVGContainer.append('text')
      .text(@config.title)
      .attr('x', VISUALISATION_WIDTH/2)
      .attr('y', TITLE_Y)
      .attr('text-anchor', 'middle')
      .classed('title', 'true')
      .on('click', -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen thisView.config.title_link_url)

# -----------------------------------------------------------------------------------------------------------------
# RENDER SIMPLE PIE
# -----------------------------------------------------------------------------------------------------------------
  renderSimplePie: (buckets) ->
    thisView = @
    thisView.$vis_elem.empty()


    VISUALISATION_WIDTH = $(@el).width()
    VISUALISATION_HEIGHT = VISUALISATION_WIDTH * 0.65
    MAX_VIS_WIDTH = Math.min(VISUALISATION_WIDTH, VISUALISATION_HEIGHT)
    X_CENTER = VISUALISATION_WIDTH / 2
    Y_CENTER = (VISUALISATION_HEIGHT / 2)
    PADDING = MAX_VIS_WIDTH * 0.1
    RADIUS = (MAX_VIS_WIDTH / 2) - PADDING


    bucketSizes = (b.doc_count for b in buckets)
    bucketKeys = (b.key for b in buckets)

    thisView.xAxisPropName.domain = bucketKeys
    glados.models.visualisation.PropertiesFactory.generateColourScale(thisView.xAxisPropName)
    color = @xAxisPropName.colourScale

    mainContainer = d3.select(@$vis_elem.get(0))
    mainSVGContainer = mainContainer
      .append('svg')
        .attr('class', 'mainSVGContainer')
        .attr('width', VISUALISATION_WIDTH)
        .attr('height', VISUALISATION_HEIGHT)

    arcsContainer = mainSVGContainer.append('g')

    pie = d3.layout.pie()
      .sort(null)

    arc = d3.svg.arc()
    .innerRadius(0)
    .outerRadius(RADIUS)

    bucketsData = pie(bucketSizes)
    for i in [0..buckets.length-1]
      currentDatum = bucketsData[i]
      currentBucket = buckets[i]
      _.extend(currentDatum, currentBucket)

    arcs = arcsContainer.selectAll('g.arc')
      .data(bucketsData)
      .enter()
      .append('g')
      .attr('class', 'arc')
        .attr('transform', 'translate(' + X_CENTER + ', ' + Y_CENTER + ')')
        .on('click', (d) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen d.link)

    arcs.append('path')
    .attr('fill', (d) -> color(d.key))
    .attr('d', arc)


#   labels on slices
    texts = arcs.append('text')
      .attr('class', 'arc-text')
      .attr('text-anchor', 'middle')
      .attr('alignment-baseline', 'middle')
      .text((d) -> d.doc_count )
      .attr('transform', (d) ->
        angle = Math.PI/2 + (d.endAngle + d.startAngle)/2
        x = -Math.cos(angle) * 2.2 * RADIUS / 3
        y = -Math.sin(angle) * 2.2 * RADIUS / 3
        'translate(' + x + ', ' + y + ')')

    thisView.checkIfNeedsToHideText(arcs, texts)

#   legend
    legendConfig =
      columns_layout: true
      hide_title: true

    $legendElem = $(thisView.el).find('.BCK-CompResultsGraphLegendContainer')
    glados.Utils.renderLegendForProperty(@xAxisPropName, undefined, $legendElem, enableSelection=false, legendConfig,
      reset=true)

#   qtips
    arcs.each (d) ->
      key = d.key
      count = d.doc_count
      percentage = ((d.endAngle - d.startAngle) * 15.91549430919).toFixed(2);

      text = '<b>' + key + '</b>' +
        '<br>' + '<b>' + "Count:  " + '</b>' + count +
        '<br>' + '<b>' + "Percentage:  " + '</b>' + percentage + '%'
      $(@).qtip
        content:
          text: text
        style:
          classes:'qtip-light'
        position:
          my: 'bottom left'
          at: 'top right'
          target: 'mouse'
          adjust:
            y: -5
            x: 5

  checkIfNeedsToHideText: (arcs, texts) ->
    arcs = arcs[0]
    texts = texts[0]

    for i in [0..arcs.length - 1]
      if texts[i].getBBox().width >= arcs[i].getBBox().width * 0.5
        $(arcs[i]).find('text').hide()



