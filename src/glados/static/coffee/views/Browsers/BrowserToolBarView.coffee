glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserToolBarView: Backbone.View.extend

    events:
      'click .BCK-toggle-hide-filters': 'toggleHideFilters'

    initialize: ->

      @$facetsElem = $(@el).find('.BCK-Facets-Container')
      @facetsView = new glados.views.Browsers.BrowserFacetView
        collection: @collection
        el: $(@el).find('.BCK-Facets-Container')

    wakeUp: ->

      @facetsView.wakeUp()

    toggleHideFilters: ->

      $opener = $(@el).find('.BCK-toggle-hide-filters')
      $icon = $opener.find('i')

      if $opener.attr('data-filters-open') == 'yes'
        @$facetsElem.slideUp()
        $icon.removeClass('fa-chevron-left')
        $icon.addClass('fa-chevron-right')
        $opener.attr('data-filters-open', 'no')
      else
        @$facetsElem.slideDown()
        $icon.addClass('fa-chevron-left')
        $icon.removeClass('fa-chevron-right')
        $opener.attr('data-filters-open', 'yes')
