glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserFacetView: Backbone.View.extend(ResponsiviseViewExt).extend

    TRANSITION_DURATION: 1500
    initialize: ->

      @browserView = arguments[0].menu_view
      @FACET_GROUP_IS_CLOSED = {}
      @$vis_elem = $(@el)
      @setUpResponsiveRender(emptyBeforeRender=false)
      @collection.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_CONFIG_FETCHING_STATE_CHANGED, @checkIfFacetsConfigLoadedAndInitStructure, @
      @collection.on 'facets-changed', @render, @
      @collection.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_CONFIG_FETCHING_STATE_CHANGED, @render, @
      @collection.on 'reset', @checkIfNoItems, @

    events:
      'click .BCK-clear-facets' : 'clearFacetsSelection'

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

      #make sure it is always ordered correctly
      @handleFiltersReordering()
      @initAllHistograms()

      $(@el).find('.collapsible').collapsible
        onOpen: $.proxy(@handleOpenFacet, @)
        onClose: $.proxy(@handleCloseFacet, @)

    # ------------------------------------------------------------------------------------------------------------------
    # React to facets config loaded
    # ------------------------------------------------------------------------------------------------------------------
    checkIfFacetsConfigLoadedAndInitStructure: ->

      console.log('CHECK IF FACETS CONFIG WAS LOADED')

      if @collection.facetsConfigIsReady()

        console.log('CONFIG IS READY')
        @initFacetsVisualStructure()

    initFacetsVisualStructure: ->

      @facetsStreamingCover = $(@el).find('.div-cover')

      facetsGroups = @collection.getFacetsGroups(undefined, onlyVisible=false)
      console.log('INIT FACETS VISUAL STRUCTURE')
      console.log(facetsGroups)

      @facetsVisibilityHandler = new glados.models.paginatedCollections.FacetGroupVisibilityHandler
        all_facets_groups: facetsGroups

      @facetsVisibilityHandler.on glados.models.paginatedCollections.ColumnsHandler.EVENTS.COLUMNS_ORDER_CHANGED,\
        @handleFiltersReordering, @

      @facetsVisibilityHandler.on \
        glados.models.paginatedCollections.FacetGroupVisibilityHandler.EVENTS.COLUMNS_SHOW_STATUS_CHANGED,\
        @handleShowHideFilter, @

      @initialiseTitle()
      @initializeHTMLStructure()
      @showPreloader()

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------
    wakeUp: ->

      if @collection.facetsConfigIsReady() and @collection.facetsReady
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
      $(@el).addClass('facets-container-hidden')


    checkIfNoItems: ->

      totalRecords = @collection.getMeta('total_records')
      thereAreItems = totalRecords != 0
      textFilterIsSet = @collection.getTextFilter()?

      if not thereAreItems and not textFilterIsSet
        @hideAll()
        return true
      else if not thereAreItems and textFilterIsSet
        $(@el).removeClass('facets-container-hidden')
        @collapseAllFilters()
      else
        $(@el).removeClass('facets-container-hidden')
        if @textFilterWasSet
          @expandAllFilters()

      @textFilterWasSet = textFilterIsSet

    # ------------------------------------------------------------------------------------------------------------------
    # Filters reordering
    # ------------------------------------------------------------------------------------------------------------------
    handleFiltersReordering: ->

      allFacets = @facetsVisibilityHandler.getAllFacetsGroups()
      $facetsCollapsible = $(@el).find('.BCK-facets-collapsible')

      compareFunction = (a, b) ->

        comparatorA = $(a).attr('data-facet-group-key')
        comparatorB = $(b).attr('data-facet-group-key')

        positionA = allFacets[comparatorA].position
        positionB = allFacets[comparatorB].position

        return positionA - positionB

      $listItems = $facetsCollapsible.find('li.BCK-facet-li')
      $listItems.sort compareFunction
      $facetsCollapsible.append $listItems

    # ------------------------------------------------------------------------------------------------------------------
    # Show/hide filters
    # ------------------------------------------------------------------------------------------------------------------
    handleShowHideFilter: ->
      @showPreloader()
      @collection.loadFacetGroups()
    # ------------------------------------------------------------------------------------------------------------------
    # Add Remove
    # ------------------------------------------------------------------------------------------------------------------
    initialiseTitle: ->


      $titleContainer = $(@el).find('.BCK-show-hide-filters-modal-container')
      now = Date.now()
      modalID = @collection.getMeta('id_name') + 'edit-filters-modal-' + now

      templateParams =
        modal_id: modalID

      $('#BCK-GeneratedModalsContainer').append($(glados.Utils.getContentFromTemplate(
        'Handlebars-Common-EditFiltersModal', templateParams)))

      filters = []
      for fGroupKey, fGroup of @collection.getFacetsGroups(undefined, onlyVisible=false)
        filters.push
          id: fGroupKey + now
          label: fGroup.label
          key: fGroupKey
          checked: fGroup.show

      glados.Utils.fillContentForElement $titleContainer, templateParams

      $modalContentContainer = $("##{modalID}")
      new glados.views.PaginatedViews.ColumnsHandling.ColumnsHandlerView
        model: @facetsVisibilityHandler
        el: $modalContentContainer
        modal_id: modalID
        facets_mode: true

      $modalContentContainer.modal()


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

      @KEY_TEXT_COUNT_TEXT_PADDING = 1

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

      if not @collection.facetsConfigIsReady()
        @showPreloader()
        return

      if not @collection.facetsAreReady()
        @showPreloader()
        return

      console.log('RENDER FACETS')

      @destroyAllTooltips()

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
      if currentFacetGroup.faceting_handler.faceting_keys_inorder?
        for datumKey in currentFacetGroup.faceting_handler.faceting_keys_inorder
          datumToAdd = currentFacetGroup.faceting_handler.faceting_data[datumKey]
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

      if currentFacetGroup.faceting_handler.hasReportCardModel()
        bucketGroupsEnter.each((d) -> thisView.addMiniReportCardForHover(d3.select(@), d,
          currentFacetGroup.faceting_handler.report_card_entity, thisView))

    addMiniReportCardForHover: (bucketG, d, reportCardEntity, thisView) ->

      chemblID = d.key
      # ignore keys like 'Other categories'
      if not chemblID.startsWith('CHEMBL')
        return

      frontBar = bucketG.select('.front-bar')
      frontBar.attr('data-entity-name', reportCardEntity.prototype.entityName)
      $frontBar = $(frontBar.node())
      $frontBar.mouseenter(thisView.generateMiniRepCardTooltipOnHover)

    generateMiniRepCardTooltipOnHover: (event) ->

      $frontBar = $(event.currentTarget)
      chemblID = $frontBar.attr('data-facet-key')
      entityName = $frontBar.attr('data-entity-name')

      if $frontBar.attr('data-qtip-configured') != 'yes'

        miniRepCardID = "BCK-MiniReportCard-Filter-#{chemblID}"

        qtipConfig =
          content:
            text: "<div id='#{miniRepCardID}'></div>"
          show:
            solo: true
          hide:
            fixed: true,
            delay: glados.Settings.TOOLTIPS.DEFAULT_MERCY_TIME
          style:
            classes:'matrix-qtip qtip-light qtip-shadow'
          position:
            my: 'top left'
            at: 'bottom right'

        $frontBar.qtip qtipConfig
        $frontBar.qtip('api').show()
        $newMiniReportCardContainer = $('#' + miniRepCardID)
        Entity = glados.Utils.getEntityFromName(entityName)
        ReportCardApp.initMiniReportCard(Entity, $newMiniReportCardContainer, chemblID)
        $frontBar.attr('data-qtip-configured', 'yes')

    addEllipsisIfNecessary: (bucketG) ->

      keyText = bucketG.select('.key-text')
      countText = bucketG.select('.count-text')
      frontBar = bucketG.select('.front-bar')

      # an estimation is needed because of troubles with .getBBox
      countTextX = parseFloat(countText.attr('x'))
      keyTextX = parseFloat(keyText.attr('x'))
      keyTextWidth = keyText[0][0].getComputedTextLength()
      countTextWidth = countText[0][0].getComputedTextLength()

      # remember that text anchor is end
      spaceForText = countTextX - @KEY_TEXT_COUNT_TEXT_PADDING - countTextWidth
      spaceOccupiedByKeyText = keyTextX + keyTextWidth

      if spaceOccupiedByKeyText > spaceForText

        originalText = keyText.text()
        textWidthLimit = countTextX - @KEY_TEXT_COUNT_TEXT_PADDING - countTextWidth
        newText = glados.Utils.Text.getTextForEllipsis(originalText, keyTextWidth, textWidthLimit)
        keyText.text(newText)

        $frontBar = $(frontBar.node())

        qtipConfig =
          content:
            text: "<div style='padding: 3px'>#{originalText}</div>"
          position:
            my: 'left center'
            at: 'right center'
          style:
            classes:'matrix-qtip qtip-light qtip-shadow'

        $frontBar.qtip qtipConfig
        $frontBar.attr('data-qtip-configured', 'yes')

    # ------------------------------------------------------------------------------------------------------------------
    # FacetSelection
    # ------------------------------------------------------------------------------------------------------------------
    toggleSelectFacet: (fGroupKey, fKey) ->
      @showPreloader()
      facetsGroups = @facetsVisibilityHandler.getAllFacetsGroups()
      facetingHandler = facetsGroups[fGroupKey].faceting_handler
      if facetingHandler.faceting_data[fKey].count == 0
        return

      isSelected = @collection.toggleFacetAndFetch(fGroupKey, fKey)
      $selectedSVGGroup = $(@el).find("[data-facet-group-key='" + fGroupKey + "']")\
        .find("[data-bucket-key='" + fKey + "']")
      $selectedSVGGroup.toggleClass('selected', isSelected)

      @WAITING_FOR_FACETS = true

    clearFacetsSelection: ->
      @showPreloader()
      @collection.clearAllFacetsSelections()
      $(@el).find('g.bucket').removeClass('selected')
