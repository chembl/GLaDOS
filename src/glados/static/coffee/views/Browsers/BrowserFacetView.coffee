glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserFacetView: Backbone.View.extend(ResponsiviseViewExt).extend

    TRANSITION_DURATION: 1500
    initialize: ->

      @$vis_elem = $(@el)
      @setUpResponsiveRender()
      @collection.on 'facets-changed', @render, @

      @initializeHTMLStructure()
      @showPreloader()

    events:
      'click .BCK-clear-facets' : 'clearFacetsSelection'

    initializeHTMLStructure: ->

      facetsGroups = @collection.getFacetsGroups()

      facetListForRender = []
      filtersSelected = false
      for key, fGroup of facetsGroups
        for dataKey, data of fGroup.faceting_handler.faceting_data
          filtersSelected ||= data.selected

        facetListForRender.push
          label: fGroup.label
          key: key

      glados.Utils.fillContentForElement $(@el),
        facets: facetListForRender
        filters_selected: filtersSelected

      $preloaderContainer = $(@el).find('.BCK-Preloader-Container')
      glados.Utils.fillContentForElement $preloaderContainer,
        msg: 'Loading Filters...'

      @initAllHistograms()

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------
    showPreloader: ->

      $(@el).find('.BCK-Preloader-Container').show()
      $(@el).find('.BCK-FacetsContent').hide()

    hidePreloader: ->

      $(@el).find('.BCK-Preloader-Container').hide()
      $(@el).find('.BCK-FacetsContent').show()

    initAllHistograms: ->

      @HISTOGRAM_WIDTH = $(@el).width()
      @BIN_HEIGHT = 25

      @BARS_MIN_WIDTH = 1
      @BAR_CONTENT_PADDING =
        left: 2
        right: 1

      @BARS_MAX_WIDTH = @HISTOGRAM_WIDTH
      @RECT_RX = 3
      @RECT_RY = @RECT_RX

      $histogramsContainers = $(@el).find('.BCK-facet-group-histogram')
      thisView = @
      $histogramsContainers.each((i) -> thisView.initHistogram($(@)))

    render: ->
      @hidePreloader()

      $histogramsContainers = $(@el).find('.BCK-facet-group-histogram')
      thisView = @
      $histogramsContainers.each((i) -> thisView.updateHistogram($(@)))

#      @paintAllHistograms()


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
        datum.key = datumKey
        datum.id = datumKey + ':' + datum.count
        datum.key
        buckets.push datum

      HISTOGRAM_HEIGHT = buckets.length * @BIN_HEIGHT

      mainContainer = d3.select($containerElem.get(0))
      mainSVGContainer = mainContainer.select('.mainSVGContainer')
      mainSVGContainer.attr('height', HISTOGRAM_HEIGHT)

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
        .attr('transform', (b) -> 'translate(0,' + getYForBucket(b.key) + ')')

      valueRectangles = bucketGroupsEnter.append('rect')
        .attr('x', @HISTOGRAM_WIDTH)
        .attr('rx', @RECT_RX)
        .attr('ry', @RECT_RY)
        .attr('width', 0)
        .attr('height', getYForBucket.rangeBand())
        .classed('value-bar', true)

      valueRectangles.transition()
        .duration(@TRANSITION_DURATION)
        .attr('width', (d) -> getWidthForBucket(d.count))
        .attr('x', (d) -> thisView.HISTOGRAM_WIDTH - getWidthForBucket(d.count))

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
        .classed('front-bar', true)
        .attr('data-facet-group-key', facetGroupKey)
        .attr('data-facet-key', (d) -> d.key)
        .on('click', ->
          $clickedElem = $(@)
          facetGroupKey = $clickedElem.attr('data-facet-group-key')
          facetKey = $clickedElem.attr('data-facet-key')
          thisView.toggleSelectFacet(facetGroupKey, facetKey)
        )

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
      facets_groups = @collection.getFacetsGroups()
      faceting_handler = facets_groups[facet_group_key].faceting_handler
      isSelected = faceting_handler.toggleKeySelection(facet_key)
      $selectedSVGGroup = $(@el).find("[data-facet-group-key='" + facet_group_key + "']")\
        .find("[data-bucket-key='" + facet_key + "']")
      $selectedSVGGroup.toggleClass('selected', isSelected)

      @collection.setMeta('facets_changed', true)
      @collection.fetch()

    clearFacetsSelection: -> @collection.clearAllFacetsSelections()
