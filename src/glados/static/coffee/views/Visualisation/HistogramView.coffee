glados.useNameSpace 'glados.views.Visualisation',
  HistogramView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      @config = arguments[0].config

      @model.on 'change', @render, @
      @$vis_elem = $(@el).find('.BCK-HistogramContainer')
      updateViewProxy = @setUpResponsiveRender()
      if @config.paint_axes_selectors
        @paintAxesSelectors()
      @showPreloader()

    showPreloader: ->
      if @config.big_size
        glados.Utils.fillContentForElement(@$vis_elem, {}, 'Handlebars-Common-Preloader')
      else
        glados.Utils.fillContentForElement(@$vis_elem, {}, 'Handlebars-Common-MiniRepCardPreloader')

    paintAxesSelectors: ->
      $xAxisSelector = $(@el).find('.BCK-ESResultsPlot-selectXAxis')
      glados.Utils.fillContentForElement $xAxisSelector,
        options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_x}) for opt in @config.x_axis_options)

      $xAxisNumBarsRange = $(@el).find('.BCK-ESResultsPlot-selectXAxis-numBars')
      glados.Utils.fillContentForElement $xAxisNumBarsRange,
        current_value: @config.x_axis_initial_columns
        min_value: @config.x_axis_min_columns
        max_value: @config.x_axis_max_columns

      $(@el).find('select').material_select()

    # returns the buckets that are going to be used for the visualisation
    # actual buckets may be merged into "other" depending on @maxCategories
    getBucketsForView: ->
      buckets =  @model.get('pie-data')
      maxCategories = @config.max_categories

      if buckets.length > maxCategories
        buckets = glados.Utils.Buckets.mergeBuckets(buckets, maxCategories, @model)

      return buckets

    render: ->
      @$vis_elem.empty()
      buckets = @getBucketsForView()

      if buckets.length == 0
        $visualisationMessages = $(@el).find('.BCK-VisualisationMessages')
        $visualisationMessages.html('No data.')
        return

      console.log 'RENDER VIEW!', buckets
      VISUALISATION_WIDTH = $(@el).width()
      VISUALISATION_HEIGHT = 60

      mainContainer = d3.select(@$vis_elem.get(0))
      mainSVGContainer = mainContainer
        .append('svg')
        .attr('class', 'mainSVGContainer')
        .attr('width', VISUALISATION_WIDTH)
        .attr('height', VISUALISATION_HEIGHT)

      thisView = @
      TITLE_Y = 10
      TITLE_Y_PADDING = 5
      BARS_MIN_HEIGHT = 2
      BARS_CONTAINER_HEIGHT = VISUALISATION_HEIGHT - TITLE_Y - TITLE_Y_PADDING

      #-------------------------------------------------------------------------------------------------------------------
      # add histogram bars container
      #-------------------------------------------------------------------------------------------------------------------
      barsContainerG = mainSVGContainer.append('g')
        .attr('transform', 'translate(0,' + (TITLE_Y + TITLE_Y_PADDING) + ')')
      barsContainerG.append('rect')
        .attr('height', BARS_CONTAINER_HEIGHT)
        .attr('width', VISUALISATION_WIDTH)
        .classed('bars-background', true)

      #-------------------------------------------------------------------------------------------------------------------
      # add histogram bars groups
      #-------------------------------------------------------------------------------------------------------------------
      bucketNames = (b.key for b in buckets)
      bucketSizes = (b.doc_count for b in buckets)
      console.log 'bucketSizes: ', bucketSizes
      console.log 'max:', _.max(bucketSizes)

      if @config.fixed_bar_width
        barWidth = VISUALISATION_WIDTH / @config.max_categories
        xRangeEnd = barWidth * buckets.length
      else
        fixed_bar_width = VISUALISATION_WIDTH

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
        #2196f3 blue
        valueBars.attr('fill', glados.Settings.VISUALISATION_BLUE_BASE)

      barGroups.append('rect')
        .attr('height', BARS_CONTAINER_HEIGHT)
        .attr('width', getXForBucket.rangeBand())
        .classed('front-bar', true)
        .on('click', (b) -> window.open(b.link) )

      #-------------------------------------------------------------------------------------------------------------------
      # add qtips
      #-------------------------------------------------------------------------------------------------------------------
      barGroups.each (d) ->
        text = '<b>' + d.key + '</b>' + ":" + d.doc_count
        $(@).qtip
          content:
            text: text
          style:
            classes:'qtip-light'
          position:
            my: 'top center'
            at: 'bottom center'

      #-------------------------------------------------------------------------------------------------------------------
      # add title
      #-------------------------------------------------------------------------------------------------------------------
      totalBioactivities = _.reduce(bucketSizes, ((a, b) -> a + b))
      console.log 'totalBioactivities: ', totalBioactivities
      mainSVGContainer.append('text')
        .text('Browse All (' + totalBioactivities + ')')
        .attr('x', VISUALISATION_WIDTH/2)
        .attr('y', TITLE_Y)
        .attr('text-anchor', 'middle')
        .classed('title', true)
        .on('click', ->
          window.open(thisView.model.get('link_to_all'))
      )