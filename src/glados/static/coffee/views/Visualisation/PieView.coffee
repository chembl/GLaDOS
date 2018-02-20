# this view is in charge of showing a collection of elements as a pie chart
PieView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @config = arguments[0].config
    @xAxisAggName = @config.x_axis_prop_name
    @model.on 'change', @render, @
    @$vis_elem = $(@el).find('.BCK-pie-container')
    updateViewProxy = @setUpResponsiveRender()

    if @config.stacked_donut
      @splitSeriesAggName = @config.split_series_prop_name



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
    VISUALISATION_HEIGHT = VISUALISATION_WIDTH * 0.6
    RADIUS = VISUALISATION_WIDTH / 30


    mainContainer = d3.select(@$vis_elem.get(0))
    mainSVGContainer = mainContainer
      .append('svg')
      .attr('class', 'mainSVGContainer')
      .attr('width', VISUALISATION_WIDTH)
      .attr('height', VISUALISATION_HEIGHT)

    arcsContainer = mainSVGContainer.append('g')
    subArcsContainer = mainSVGContainer.append('g')

    arcsBackground = arcsContainer.append('rect')
        .attr('height', VISUALISATION_HEIGHT)
        .attr('width', VISUALISATION_WIDTH)
        .attr('fill', 'white')
        .classed('arcs-background', true)

    bucketSizes = (b.doc_count for b in buckets)
    color = d3.scale.category10()
    pie = d3.layout.pie()

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
      .attr('d', innerArc)

    for bucket in buckets
      subBuckets = bucket[thisView.splitSeriesAggName].buckets
      subBucketSizes = (b.doc_count for b in subBuckets)

      outerArc = d3.svg.arc()
        .innerRadius(RADIUS*4)
        .outerRadius(RADIUS*6)

      subArcs = subArcsContainer.selectAll('g.arc')
        .data(pie(subBucketSizes))
        .enter()
        .append('g')
        .attr('class', 'arc')
        .attr('transform', 'translate(' + VISUALISATION_WIDTH/2 + ', ' + VISUALISATION_HEIGHT/2 + ')')

      subArcs.append('path')
        .attr('fill', (d, i) -> color(i))
        .attr('d', outerArc)

# ----------------------------------------------------------------------------------------------------------------------
#  qtips
# ----------------------------------------------------------------------------------------------------------------------
    arcs.each (d) ->
      text = d.data
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
            y: -10
            x: 40

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