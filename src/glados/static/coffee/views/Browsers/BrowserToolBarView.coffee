glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserToolBarView: Backbone.View.extend

    events:
      'click .BCK-toggle-hide-filters': 'toggleHideFilters'

    initialize: ->

      @browserView = arguments[0].menu_view

      @$facetsElem = $(@el).find('.BCK-Facets-Container')
      @facetsView = new glados.views.Browsers.BrowserFacetView
        collection: @collection
        el: $(@el).find('.BCK-Facets-Container')

      @makeToolbarThinProxy = $.proxy(@makeToolbarThin, @)

    wakeUp: ->

      @facetsView.wakeUp()

    toggleHideFilters: ->

      $opener = $(@el).find('.BCK-toggle-hide-filters')
      $icon = $opener.find('i')

      if $opener.attr('data-filters-open') == 'yes'
        @$facetsElem.slideUp(@makeToolbarThinProxy)
        $icon.removeClass('fa-chevron-left')
        $icon.addClass('fa-chevron-right')
        $opener.attr('data-filters-open', 'no')
      else
        @makeToolbarThick()
        @$facetsElem.slideDown()
        $icon.addClass('fa-chevron-left')
        $icon.removeClass('fa-chevron-right')
        $opener.attr('data-filters-open', 'yes')

    makeToolbarThin: ->

      $(@el).removeClass('m4 l3')
      $(@el).addClass('m1')

      $toolBar = $(@el).find('.BCK-tool-bar')
      $toolBar.removeClass('s2')
      $toolBar.addClass('s12')

      @browserView.makeItemsContainerWider()

    makeToolbarThick: ->

      $(@el).removeClass('m1')
      $(@el).addClass('m4 l3')

      $toolBar = $(@el).find('.BCK-tool-bar')
      $toolBar.removeClass('s12')
      $toolBar.addClass('s2')

      @browserView.makeItemsContainerThin()