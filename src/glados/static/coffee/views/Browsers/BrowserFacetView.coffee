glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserFacetView: Backbone.View.extend(ResponsiviseViewExt).extend

    TRANSITION_DURATION: 1500
    initialize: ->

      @$vis_elem = $(@el)
      @setUpResponsiveRender()
      @collection.on 'facets-changed', @render, @
      @collection.on 'reset', @checkIfNoItems, @

      @initializeHTMLStructure(emptyBeforeRender=true)
      @showPreloader()

    events:
      'click .BCK-clear-facets' : 'clearFacetsSelection'

    initializeHTMLStructure: ->

      facetsGroups = @collection.getFacetsGroups()

      facetListForRender = []
      for key, fGroup of facetsGroups

        facetListForRender.push
          label: fGroup.label
          key: key

      glados.Utils.fillContentForElement $(@el),
        facets: facetListForRender

      $preloaderContainer = $(@el).find('.BCK-Preloader-Container')
      glados.Utils.fillContentForElement $preloaderContainer,
        msg: 'Loading Filters...'

      @initAllHistograms()

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------
    wakeUp: ->
      if @collection.facetsReady
        @render()

    showPreloader: ->

      $(@el).find('.BCK-Preloader-Container').show()
      $(@el).find('.BCK-FacetsContent').hide()

    hidePreloader: ->

      $(@el).find('.BCK-Preloader-Container').hide()
      $(@el).find('.BCK-FacetsContent').show()

    hideAll: ->

      $(@el).find('.BCK-Preloader-Container').hide()
      $(@el).find('.BCK-FacetsContent').hide()

    checkIfNoItems: ->

      totalRecords = @collection.getMeta('total_records')
      if totalRecords == 0
        @hideAll()
        return true
      return false

    initAllHistograms: ->

      @HISTOGRAM_WIDTH = $(@el).width()
      @BIN_HEIGHT = 25

      @BARS_MIN_WIDTH = 1
      @BAR_CONTENT_PADDING =
        left: 2
        right: 4

      @BARS_MAX_WIDTH = @HISTOGRAM_WIDTH
      @RECT_RX = 3
      @RECT_RY = @RECT_RX

      $histogramsContainers = $(@el).find('.BCK-facet-group-histogram')
      thisView = @
      $histogramsContainers.each((i) ->thisView.initHistogram($(@)))

    render: ->

      if not $(@el).is(":visible")
        return

      if @checkIfNoItems()
        return

      if @IS_RESPONSIVE_RENDER
        @initializeHTMLStructure()

      @HISTOGRAM_WIDTH = $(@el).width()
      @BARS_MAX_WIDTH = @HISTOGRAM_WIDTH
      @hidePreloader()

      facetsGroups = @collection.getFacetsGroups()

      filtersSelected = false
      for key, fGroup of facetsGroups
        for dataKey, data of fGroup.faceting_handler.faceting_data
          filtersSelected ||= data.selected

      $clearFiltersContainer = $(@el).find('.BCK-clearFiltersButtonContainer')
      if filtersSelected
        $clearFiltersContainer.show()
      else
        $clearFiltersContainer.hide()


      $histogramsContainers = $(@el).find('.BCK-facet-group-histogram')
      thisView = @
      $histogramsContainers.each((i) -> thisView.updateHistogram($(@)))

    initHistogram: ($containerElem) ->

      mainContainer = d3.select($containerElem.get(0))
      mainSVGContainer = mainContainer
        .append('svg')
        .attr('class', 'mainSVGContainer')
        .attr('width', @HISTOGRAM_WIDTH)

    updateHistogram: ($containerElem) ->

      thisView = @

      facetGroupKey =  $containerElem.attr('data-facet-group-key')
      currentFacetGroup = @collection.getFacetsGroups()[facetGroupKey]
      buckets = []
      for datumKey, datum of currentFacetGroup.faceting_handler.faceting_data
        datumToAdd = datum
        datumToAdd.key = datumKey
        datumToAdd.id = datumKey + ':' + datumToAdd.count
        datumToAdd.key
        buckets.push datumToAdd

      HISTOGRAM_HEIGHT = buckets.length * @BIN_HEIGHT

      mainContainer = d3.select($containerElem.get(0))
      mainSVGContainer = mainContainer.select('.mainSVGContainer')
      mainSVGContainer
        .attr('height', HISTOGRAM_HEIGHT)
        .attr('width', @HISTOGRAM_WIDTH)

      bucketNames = _.pluck(buckets, 'key')
      bucketSizes = _.pluck(buckets, 'count')
      getYForBucket = d3.scale.ordinal()
        .domain(bucketNames)
        .rangeBands([0,HISTOGRAM_HEIGHT], 0.1)
      getWidthForBucket = d3.scale.linear()
        .domain([0, _.reduce(bucketSizes, (nemo, num) -> nemo + num )])
        .range([@BARS_MIN_WIDTH, @BARS_MAX_WIDTH])

      bucketGroups = mainSVGContainer.selectAll('.bucket')
        .data(buckets, (d) -> d.id)

      bucketGroups.exit().remove()
      bucketGroupsEnter = bucketGroups.enter()
        .append('g')
        .classed('bucket', true)
        .attr('data-bucket-key', (d) -> d.key)
        .classed('selected', (d) -> d.selected)
        .classed('disabled', (d) -> d.count == 0)

      bucketGroups.attr('transform', (b) -> 'translate(0,' + getYForBucket(b.key) + ')')

      bucketGroupsEnter.append('rect')
        .attr('height', getYForBucket.rangeBand())
        .attr('width', @HISTOGRAM_WIDTH)
        .classed('background-bar', true)

      valueRectangles = bucketGroupsEnter.append('rect')
        .classed('value-bar', true)
        .attr('x', @HISTOGRAM_WIDTH)
        .attr('rx', @RECT_RX)
        .attr('ry', @RECT_RY)
        .attr('width', 0)
        .attr('height', getYForBucket.rangeBand())

      bucketGroupsEnter.append('text')
        .text((d) -> d.key_for_humans)
        .attr('y', @BIN_HEIGHT * (2/3))
        .attr('x', @BAR_CONTENT_PADDING.left)
        .classed('key-text', true)

      bucketGroupsEnter.append('text')
        .text((d) -> d.count)
        .attr('x', @HISTOGRAM_WIDTH - @BAR_CONTENT_PADDING.right)
        .attr('y', @BIN_HEIGHT * (2/3))
        .attr('text-anchor', 'end')
        .classed('count-text', true)

      bucketGroupsEnter.append('rect')
        .attr('height', getYForBucket.rangeBand())
        .attr('width', @HISTOGRAM_WIDTH)
        .attr('rx', @RECT_RX)
        .attr('ry', @RECT_RY)
        .classed('make-teal-bar', true)

      duration = if @IS_RESPONSIVE_RENDER then 0 else @TRANSITION_DURATION
      valueRectangles.transition()
        .duration(duration)
        .attr('width', (d) -> getWidthForBucket(d.count))
        .attr('x', (d) -> thisView.HISTOGRAM_WIDTH - getWidthForBucket(d.count))

      handleClickBar = ->
        $clickedElem = $(@)
        facetGroupKey = $clickedElem.attr('data-facet-group-key')
        facetKey = $clickedElem.attr('data-facet-key')
        thisView.toggleSelectFacet(facetGroupKey, facetKey)

      bucketGroupsEnter.append('rect')
        .attr('height', getYForBucket.rangeBand())
        .attr('width', @HISTOGRAM_WIDTH)
        .classed('front-bar', true)
        .attr('data-facet-group-key', facetGroupKey)
        .attr('data-facet-key', (d) -> d.key)
        .on('click', handleClickBar)

      bucketGroupsEnter.append('rect')
        .attr('height', getYForBucket.rangeBand())
        .attr('width', @HISTOGRAM_WIDTH)
        .attr('rx', @RECT_RX)
        .attr('ry', @RECT_RY)
        .classed('hover-bar', true)

      bucketGroupsEnter.each(->thisView.addEllipsisIfNecessary(d3.select(@)))


    addEllipsisIfNecessary: (bucketG) ->

      keyText = bucketG.select('.key-text')
      countText = bucketG.select('.count-text')
      frontBar = bucketG.select('.front-bar')

      countTextX = parseFloat(countText.attr('x'))
      keyTextX = parseFloat(keyText.attr('x'))
      keyTextWidth = keyText.node().getBBox().width
      countTextWidth = countText.node().getBBox().width

      # remember that text anchor is end
      spaceForText = countTextX - countTextWidth
      spaceOccupiedByKeyText = keyTextX + keyTextWidth

      if spaceOccupiedByKeyText > spaceForText

        originalText = keyText.text()
        textWidthLimit = countTextX - countTextWidth
        newText = glados.Utils.Text.getTextForEllipsis(originalText, keyTextWidth, textWidthLimit)
        keyText.text(newText)

        $frontBar = $(frontBar.node())

        qtipConfig =
          content:
            text: originalText
          position:
            my: 'left center'
            at: 'right center'
          style:
            classes:'matrix-qtip qtip-light qtip-shadow'

        $frontBar.qtip qtipConfig

    # ------------------------------------------------------------------------------------------------------------------
    # FacetSelection
    # ------------------------------------------------------------------------------------------------------------------
    toggleSelectFacet: (facet_group_key, facet_key) ->
      facetsGroups = @collection.getFacetsGroups()
      facetingHandler = facetsGroups[facet_group_key].faceting_handler
      if facetingHandler.faceting_data[facet_key].count == 0
        return

      isSelected = facetingHandler.toggleKeySelection(facet_key)
      $selectedSVGGroup = $(@el).find("[data-facet-group-key='" + facet_group_key + "']")\
        .find("[data-bucket-key='" + facet_key + "']")
      $selectedSVGGroup.toggleClass('selected', isSelected)

      @collection.setMeta('facets_changed', true)
      @collection.fetch()

    clearFacetsSelection: ->
      @collection.clearAllFacetsSelections()
      $(@el).find('g.bucket').removeClass('selected')
