glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserToolBarView: Backbone.View.extend

    events:
      'click .BCK-toggle-hide-filters': 'toggleHideFilters'
      'click .BCK-toggle-collapse-filters': 'toggleCollapseFilters'
      'click .BCK-zoom-in': 'zoomIn'
      'click .BCK-zoom-out': 'zoomOut'
      'click .BCK-reset-zoom': 'resetZoom'
      'click .BCK-toggle-SimMaps': 'toggleSpecialStructure'

    initialize: ->

      @browserView = arguments[0].menu_view
      @collection.on 'reset', @checkIfNoItems, @
      @collection.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_CONFIG_FETCHING_STATE_CHANGED, @checkIfNoItems, @

#      @checkIfNoFilters()
#      @checkIfNoItems()

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------
    hideAll: ->
      $(@el).hide()
      @browserView.hideFilters()

    showAll: ->

      $(@el).show()
      @browserView.showFilters()

    checkIfNoItems: ->

      if not @collection.facetsConfigIsReady()
        return

      console.log('CHECK IF NO ITEMS')
      totalRecords = @collection.getMeta('total_records')

      thereAreItems = totalRecords != 0
      textFilterIsSet = @collection.getTextFilter()?

      if not thereAreItems and not textFilterIsSet
        @hideAll()
        return true
      else
        @showAll() #make sure everything is shown when there are items.
        @checkIfNoFilters()
        return false

    wakeUp: ->

    checkIfNoFilters: ->
      facetsGroups = @collection.getFacetsGroups(undefined, onlyVisible=false)
      if Object.keys(facetsGroups).length == 0
        $filtersCollapser = $(@el).find('.BCK-toggle-collapse-filters')
        $filtersCollapser.addClass('disabled')
        $opener = $(@el).find('.BCK-toggle-hide-filters')
        $opener.addClass('disabled')
        @browserView.hideFilters()

        qtipConfig =
          content:
            text: gettext('glados_filters__no_filters_available')
          style:
            classes: 'qtip-light qtip-shadow'
          position:
            my: 'left center'
            at: 'right center'

        $opener.qtip qtipConfig

    # ------------------------------------------------------------------------------------------------------------------
    # Hide Filters
    # ------------------------------------------------------------------------------------------------------------------
    toggleHideFilters: (event) ->

      $opener = $(event.currentTarget)
      if $opener.hasClass('disabled')
        return

      $icon = $opener.find('i')

      $filtersCollapser = $(@el).find('.BCK-toggle-collapse-filters')

      if $opener.attr('data-filters-open') == 'yes'
        $icon.addClass('fa-rotate-90')
        $opener.attr('data-filters-open', 'no')
        $filtersCollapser.addClass('disabled')
        @browserView.hideFilters()
      else
        $icon.removeClass('fa-rotate-90')
        $opener.attr('data-filters-open', 'yes')
        $filtersCollapser.removeClass('disabled')
        @browserView.showFilters()

    # ------------------------------------------------------------------------------------------------------------------
    # Collapse Filters
    # ------------------------------------------------------------------------------------------------------------------
    toggleCollapseFilters: (event) ->

      $opener = $(event.currentTarget)
      if $opener.hasClass('disabled')
        return

      $icon = $opener.find('i')

      if $opener.attr('data-filters-expanded') == 'yes'
        $icon.removeClass('fa-angle-double-up')
        $icon.addClass('fa-angle-double-down')
        $opener.attr('data-filters-expanded', 'no')
        @browserView.collapseAllFilters()
      else
        $icon.addClass('fa-angle-double-up')
        $icon.removeClass('fa-angle-double-down')
        $opener.attr('data-filters-expanded', 'yes')
        @browserView.expandAllFilters()

    # ------------------------------------------------------------------------------------------------------------------
    # Zoom Controls
    # ------------------------------------------------------------------------------------------------------------------
    showZoomControls: -> $(@el).find('.BCK-zoom-buttons-container').show()
    hideZoomControls: -> $(@el).find('.BCK-zoom-buttons-container').hide()
    getZoomControlsContainer: -> $(@el).find('.BCK-zoom-buttons-container')

    zoomIn: -> @browserView.zoomIn()
    zoomOut: -> @browserView.zoomOut()
    resetZoom: -> @browserView.resetZoom()

    # ------------------------------------------------------------------------------------------------------------------
    # Similariy maps controls
    # ------------------------------------------------------------------------------------------------------------------
    showSpecialStructureControls: -> $(@el).find('.BCK-special-structures-toggler-container').show()
    hideSpecialStructureControls: -> $(@el).find('.BCK-special-structures-toggler-container').hide()
    getSpecialStructureControlsContainer: -> $(@el).find('.BCK-special-structures-toggler-container')

    toggleSpecialStructure: (event) ->

      $toggler = $(event.currentTarget)
      checked = $toggler.prop('checked')
      @browserView.toggleShowSpecialStructure(checked)


