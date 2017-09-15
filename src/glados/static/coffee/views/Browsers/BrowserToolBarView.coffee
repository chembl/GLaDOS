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
      @checkIfNoItems()

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------
    hideAll: ->
      $(@el).hide()

    checkIfNoItems: ->

      totalRecords = @collection.getMeta('total_records')
      if totalRecords == 0
        @hideAll()
        return true
      return false

    wakeUp: ->

    # ------------------------------------------------------------------------------------------------------------------
    # Hide Filters
    # ------------------------------------------------------------------------------------------------------------------
    toggleHideFilters: (event) ->

      $opener = $(event.currentTarget)
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
      @collection.toggleShowSpecialStructure(checked)


