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
      iframeDoc = iframe.contentDocument || iframe.contentWindow.document
      innerCanvas = $(iframeDoc).find('#canvas')
      innerCanvas.focus()
#      innerCanvas.bind 'wheel', (mouseEvent)->
#        if mouseEvent.ctrlKey
#          console.log innerCanvas[0].__listener
#          console.log innerCanvas[0].__eventBits
##          innerCanvas[0].onwheel(mouseEvent.originalEvent)
#        else
#          mouseEvent.stopImmediatePropagation()


      @marvinSketcherView.loadStructure('c1ccccc1', MarvinSketcherView.SMILES_FORMAT, true)

    events:
      'click .iframe-cover.scroll-cover': 'hideIFrameCover'

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
