# this view is in charge of showing a collection of elements as a pie chart
PieView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @config = arguments[0].config
    @xAxisAggName = @config.x_axis_prop_name
    @xAxisPropName = @config.properties[@config.initial_property_x]
    @model.on 'change', @render, @
    @$vis_elem = $(@el).find('.BCK-pie-container')
    updateViewProxy = @setUpResponsiveRender()

    if @config.stacked_donut
      @splitSeriesAggName = @config.split_series_prop_name
      @splitSeriesPropName = @config.properties[@config.initial_property_z]


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

  render: ->

    if @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
      @showNoDataFoundMessage()
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

    if @config.stacked_donut
      @renderStackedDonut(buckets, maxCategories)
    else
      @renderSimplePie(buckets)

  renderStackedDonut: (buckets) ->
    thisView = @
    thisView.$vis_elem.empty()

    VISUALISATION_WIDTH = $(@el).width()
    VISUALISATION_HEIGHT = VISUALISATION_WIDTH
    RADIUS = VISUALISATION_WIDTH / 15

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

    #subbuckets colour scale
    subBucketsOrder = glados.Utils.Buckets.getSubBucketsOrder(buckets, @splitSeriesAggName)

    zScaleDomains = []
    for key, value of subBucketsOrder
      zScaleDomains.push(key)

    @splitSeriesPropName.domain = zScaleDomains
    glados.models.visualisation.PropertiesFactory.generateColourScale(@splitSeriesPropName)
    color2 = @splitSeriesPropName.colourScale

    pie = d3.layout.pie()
      .sort(null)

    innerArc = d3.svg.arc()
      .innerRadius(RADIUS*2)
      .outerRadius(RADIUS*4)

    arcs = arcsContainer.selectAll('g.arc')
      .data(pie(bucketSizes))
      .enter()
      .append('g')
      .attr('class', 'arc')
      .attr('transform', 'translate(' + VISUALISATION_WIDTH/2 + ', ' + VISUALISATION_HEIGHT/2 + ')')

    arcs.append('path')
      .attr('fill', (d, i) -> color(i))
#      .attr('stroke-width', 1)
#      .attr('stroke', 'white')
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

    for bucket, i in buckets
      subBuckets = bucket[thisView.splitSeriesAggName].buckets
      #get other buckets
#      subBucketsCompleteAggName = "#{thisView.xAxisAggName}.aggs.#{thisView.splitSeriesAggName}"
#      subBuckets = glados.Utils.Buckets.mergeBuckets(subBuckets,  5, thisView.model, subBucketsCompleteAggName)
      subBucketSizes = (b.doc_count for b in subBuckets)

      bigSlice =  pie(bucketSizes)[i]
      AggregationPie = d3.layout.pie()
        .startAngle(bigSlice.startAngle)
        .endAngle(bigSlice.endAngle)

      outerArc = d3.svg.arc()
        .innerRadius(RADIUS*4)
        .outerRadius(RADIUS*5.5)

      subArcs = subArcsContainer.selectAll('g.arc')
        .data(AggregationPie(subBucketSizes))
        .enter()
        .append('g')
        .attr('class', 'sub-arc')
        .attr('transform', 'translate(' + VISUALISATION_WIDTH/2 + ', ' + VISUALISATION_HEIGHT/2 + ')')

      subArcs.append('path')
        .attr('fill', (d, i) -> color2(i))
#        .attr('stroke-width', 0.1)
#        .attr('stroke', 'white')
        .attr('d', outerArc)

      # ----------------------------------------------------------------------------------------------------------------------
      #  qtips outter slices
      # ----------------------------------------------------------------------------------------------------------------------

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

# ----------------------------------------------------------------------------------------------------------------------
#  qtips inner slices
# ----------------------------------------------------------------------------------------------------------------------
    arcs.each (d) ->
      propName = thisView.xAxisPropName.label
      for bucket in buckets
        if bucket.doc_count == d.value
           bucketCount = bucket.doc_count
           bucketName = bucket.key

      text = '<b>' + propName + '</b>' + ":  " + bucketName + \
        '<br>' + '<b>' + "Count:  " + '</b>' + bucketCount
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

  renderSimplePie: (buckets) ->
    values = []
    labels = []

    bucketsIndex = _.indexBy(buckets, 'key')
    for bucket in buckets
      values.push bucket.doc_count
      labels.push bucket.key

      col = [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.BLUE4,
      ]

    data1 =
      values: values
      labels: labels
      type: 'pie'
      textinfo:'value'
      marker:
        colors: col

    data = [data1]
    width = @$vis_elem.width()
    minWidth = 400
    if width < minWidth
      width = minWidth

    layout =
      height: width * (3/5)
      width: width
      margin:
        l: 5
        r: 5
        b: 5
        t: 40
        pad: 4
      legend:
        orientation: 'h'
      font:
        family: "ChEMBL_HelveticaNeueLTPRo"

    pieDiv = @$vis_elem.get(0)
    Plotly.newPlot pieDiv, data, layout

    thisView = @
    pieDiv.on('plotly_click', (eventInfo) ->
      clickedKey = eventInfo.points[0].label
      link = bucketsIndex[clickedKey].link
      window.open(link)
    )