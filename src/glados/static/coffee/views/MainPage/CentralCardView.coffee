glados.useNameSpace 'glados.views.MainPage',
  CentralCardView: Backbone.View.extend

    events:
      'click .results-section-item': 'switchTab'

    initialize: ->

      @marvinSketcherView = new MarvinSketcherView
        el: $('#BCK-MarvinContainer')

      LazyIFramesHelper.initLazyIFrames()

      @targetHierarchy = TargetBrowserApp.initTargetHierarchyTree()
      @drugList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugList()

      @targetBrowserView = TargetBrowserApp.initBrowserMain(@targetHierarchy, $('#BCK-TargetBrowserMain'))
      @drugBrowserTableView = DrugBrowserApp.initBrowserAsTable(@drugList, $('#BCK-DrugBrowserMain'))

      @drugList.fetch({reset: true})

      LazyIFramesHelper.loadObjectOnceOnClick($('a[data-target="#browse_targets"]'), @targetHierarchy)

      @showHideDivs()

    hideIFrameCover: ->
      $(@el).find('.iframe-cover.scroll-cover').hide()
      iframe = $(@el).find('#sketch')[0]
      iframe.contentWindow.focus()
      @marvinSketcherView.loadStructure('c1ccccc1', MarvinSketcherView.SMILES_FORMAT, true)

    showIFrameCover: ->
      $(@el).find('.iframe-cover.scroll-cover').show()

    events:
      'click .iframe-cover.scroll-cover .iframe-centered a': 'hideIFrameCover'
      'mouseleave': 'showIFrameCover'

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
