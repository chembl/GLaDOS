glados.useNameSpace 'glados.views.MainPage',
  CentralCardView: Backbone.View.extend

    events:
      'click .results-section-item': 'switchTab'

    initialize: ->

      @marvinSketcherView = new MarvinSketcherView()

      LazyIFramesHelper.initLazyIFrames()

      @targetHierarchy = TargetBrowserApp.initTargetHierarchyTree()
      @drugList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugList()

      @targetBrowserView = TargetBrowserApp.initBrowserMain(@targetHierarchy, $('#BCK-TargetBrowserMain'))
      @drugBrowserTableView = DrugBrowserApp.initBrowserAsTable(@drugList, $('#BCK-DrugBrowserMain'))

      @drugList.fetch({reset: true})

      LazyIFramesHelper.loadObjectOnceOnClick($('a[href="#browse_targets"]'), @targetHierarchy)

      @showHideDivs()

    showHideDivs: ->
      $tabsLinks = $(@el).find('.summary-tabs .results-section-item')
      for tab in $tabsLinks
        $tab = $(tab)
        $pointedDiv = $($tab.attr('data-target'))
        if $tab.hasClass('selected')
          $pointedDiv.show()
        else
          $pointedDiv.hide()

    switchTab: (event) ->
      $clickedElem = $(event.currentTarget)
      $tabsLinks = $(@el).find('.summary-tabs .results-section-item')
      $tabsLinks.removeClass('selected')
      $clickedElem.addClass('selected')

      @showHideDivs()
