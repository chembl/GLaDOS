glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserFacetView: Backbone.View.extend(ResponsiviseViewExt).extend

    TRANSITION_DURATION: 1500
    initialize: ->

      @browserView = arguments[0].menu_view
      @FACET_GROUP_IS_CLOSED = {}
      @$vis_elem = $(@el)
      @setUpResponsiveRender(emptyBeforeRender=false)
      @collection.on 'facets-changed', @render, @
      @collection.on 'reset', @checkIfNoItems, @

      facetsGroups = @collection.getFacetsGroups(undefined, onlyVisible=false)

      @facetsVisibilityHandler = new glados.models.paginatedCollections.FacetGroupVisibilityHandler
        all_facets_groups: facetsGroups

      @initialiseTitle()
      @initializeHTMLStructure()
      @showPreloader()

    events:
      'click .BCK-clear-facets' : 'clearFacetsSelection'
      'click .BCK-show-hide-filter': 'showHideFilter'

    initializeHTMLStructure: ->

      facetsGroups = @facetsVisibilityHandler.getVisibleFacetsGroups()

      facetListForRender = []
      for key, fGroup of facetsGroups

        facetListForRender.push
          label: fGroup.label
          key: key
          closed: @FACET_GROUP_IS_CLOSED[key]

      facetListForRender.sort (a, b) -> a.position - b.position

      $facetsContainer = $(@el).find('.BCK-Facets-content')
      glados.Utils.fillContentForElement $facetsContainer,
        facets: facetListForRender

      $preloaderContainer = $(@el).find('.BCK-Preloader-Container')
      glados.Utils.fillContentForElement $preloaderContainer,
        msg: 'Loading Filters...'

      @initAllHistograms()

      $(@el).find('.collapsible').collapsible
        onOpen: $.proxy(@handleOpenFacet, @)
        onClose: $.proxy(@handleCloseFacet, @)

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------
    wakeUp: ->
      if @collection.facetsReady
        @render()

    collapseAllFilters: ->

      $collapsibleHeaders = $(@el).find('.BCK-collapsible-header')

      $collapsibleHeaders.each( ->
        $currentElem = $(@)
        $currentElem.click() unless not $currentElem.hasClass('active')

      )

    expandAllFilters: ->

      $collapsibleHeaders = $(@el).find('.BCK-collapsible-header')

      $collapsibleHeaders.each( ->
        $currentElem = $(@)
        $currentElem.click() unless $currentElem.hasClass('active')
      )


    handleOpenFacet: ($li) ->

      $icon = $li.find('.BCK-open-close-icon')
      $icon.html('arrow_drop_up')
      $li.attr('data-is-open', 'yes')
      facetGroupKey = $li.attr('data-facet-group-key')
      @FACET_GROUP_IS_CLOSED[facetGroupKey] = false
      $histogramContainer = $(@el).find(".BCK-facet-group-histogram[data-facet-group-key='" + facetGroupKey + "']")
      $histogramContainer.attr('data-is-open', 'yes')
      @updateHistogram($histogramContainer)

    handleCloseFacet: ($li) ->

      $icon = $li.find('.BCK-open-close-icon')
      $icon.html('arrow_drop_down')
      $li.attr('data-is-open', 'no')
      facetGroupKey = $li.attr('data-facet-group-key')
      @FACET_GROUP_IS_CLOSED[facetGroupKey] = true
      $histogramContainer = $(@el).find(".BCK-facet-group-histogram[data-facet-group-key='" + facetGroupKey + "']")
      $histogramContainer.attr('data-is-open', 'no')

    showPreloader: ->

      $(@el).show()
      $(@el).find('.BCK-Preloader-Container').show()
      $(@el).find('.BCK-FacetsContent').hide()

    hidePreloader: ->

      $(@el).show()
      $(@el).find('.BCK-Preloader-Container').hide()
      $(@el).find('.BCK-FacetsContent').show()

    hideAll: ->

      $(@el).find('.BCK-Preloader-Container').hide()
      $(@el).find('.BCK-FacetsContent').hide()
      $(@el).hide()


    checkIfNoItems: ->

      totalRecords = @collection.getMeta('total_records')
      if totalRecords == 0
        @hideAll()
        return true

    # ------------------------------------------------------------------------------------------------------------------
    # Add Remove
    # ------------------------------------------------------------------------------------------------------------------
    initialiseTitle: ->

      $titleAndModalContainer = $(@el).find('.BCK-show-hide-filters-modal-container')
      now = Date.now()
      modalID = @collection.getMeta('id_name') + 'edit-filters-modal-' + now

      filters = []
      for fGroupKey, fGroup of @collection.getFacetsGroups(undefined, onlyVisible=false)
        filters.push
          id: fGroupKey + now
          label: fGroup.label
          key: fGroupKey
          checked: fGroup.show

      glados.Utils.fillContentForElement $titleAndModalContainer,
        modal_id: modalID

      $modalContentContainer = $titleAndModalContainer.find('.BCK-ModalContent-container')
      new glados.views.PaginatedViews.ColumnsHandling.ColumnsHandlerView
        model: @facetsVisibilityHandler
        el: $modalContentContainer
        modal_id: modalID
        facets_mode: true

      $(@el).find('#' + modalID).modal()

    showHideFilter: (event) ->

      $checkbox = $(event.currentTarget)
      facetGroupKey = $checkbox.attr('data-facet-group-key')
      isChecked = $checkbox.is(':checked')
      allFacets = @collection.getFacetsGroups(undefined, onlyVisible=false)
      allFacets[facetGroupKey].show = isChecked

      @collection.loadFacetGroups()

    # ------------------------------------------------------------------------------------------------------------------
    # Histogram Rendering
    # ------------------------------------------------------------------------------------------------------------------
    initAllHistograms: ->

      @HISTOGRAM_PADDING =
        top: 10
        bottom: 10
        left: 8
        right: 8

      @HISTOGRAM_WIDTH = $(@el).width() - @HISTOGRAM_PADDING.left - @HISTOGRAM_PADDING.right
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

    destroyAllTooltips: -> glados.Utils.Tooltips.destroyAllTooltips($(@el))

    render: ->

      if not $(@el).is(":visible") or $(@el).width() == 0
        return

      if @checkIfNoItems()
        return

      @destroyAllTooltips()

      if @IS_RESPONSIVE_RENDER and not @WAITING_FOR_FACETS
        @initializeHTMLStructure()

      @HISTOGRAM_WIDTH = $(@el).width() - @HISTOGRAM_PADDING.left - @HISTOGRAM_PADDING.right
      @BARS_MAX_WIDTH = @HISTOGRAM_WIDTH
      @hidePreloader()

      facetsGroups = @facetsVisibilityHandler.getAllFacetsGroups()

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
      @WAITING_FOR_FACETS = false

    initHistogram: ($containerElem) ->

      mainContainer = d3.select($containerElem.get(0))
      mainSVGContainer = mainContainer
        .append('svg')
        .attr('class', 'mainSVGContainer')
        .attr('width', @HISTOGRAM_WIDTH )
        .attr('transform', 'translate(' + @HISTOGRAM_PADDING.left + ',' + @HISTOGRAM_PADDING.top + ')')

    updateHistogram: ($containerElem) ->

      if $containerElem.attr('data-is-open') != 'yes'
        return

      thisView = @

      facetGroupKey =  $containerElem.attr('data-facet-group-key')
      currentFacetGroup = @facetsVisibilityHandler.getAllFacetsGroups()[facetGroupKey]
      buckets = []
      for datumKey, datum of currentFacetGroup.faceting_handler.faceting_data
        datumToAdd = datum
        datumToAdd.key = datumKey
        datumToAdd.id = datumKey + ':' + datumToAdd.count
        datumToAdd.key
        buckets.push datumToAdd

      HISTOGRAM_HEIGHT = (buckets.length * @BIN_HEIGHT)
      $containerElem.height(HISTOGRAM_HEIGHT + @HISTOGRAM_PADDING.top + @HISTOGRAM_PADDING.bottom)

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

      duration = if (@IS_RESPONSIVE_RENDER and not @WAITING_FOR_FACETS) then 0 else @TRANSITION_DURATION
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

      # an estimation is needed because of troubles with .getBBox
      charWidth = 6
      countTextX = parseFloat(countText.attr('x'))
      keyTextX = parseFloat(keyText.attr('x'))
      keyTextWidth = keyText.text().length * charWidth
      countTextWidth = countText.text().length * charWidth

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
        $frontBar.attr('data-qtip-configured', 'yes' )

    # ------------------------------------------------------------------------------------------------------------------
    # FacetSelection
    # ------------------------------------------------------------------------------------------------------------------
    toggleSelectFacet: (facet_group_key, facet_key) ->
      @showPreloader()
      facetsGroups = @facetsVisibilityHandler.getAllFacetsGroups()
      facetingHandler = facetsGroups[facet_group_key].faceting_handler
      if facetingHandler.faceting_data[facet_key].count == 0
        return

      isSelected = facetingHandler.toggleKeySelection(facet_key)
      $selectedSVGGroup = $(@el).find("[data-facet-group-key='" + facet_group_key + "']")\
        .find("[data-bucket-key='" + facet_key + "']")
      $selectedSVGGroup.toggleClass('selected', isSelected)

      @collection.setMeta('facets_changed', true)
      @collection.fetch()
      @WAITING_FOR_FACETS = true

    clearFacetsSelection: ->
      @showPreloader()
      @collection.clearAllFacetsSelections()
      $(@el).find('g.bucket').removeClass('selected')
