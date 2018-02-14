glados.useNameSpace 'glados.views.MainPage',
  CentralCardView: Backbone.View.extend

    events:
      'click .results-section-item': 'switchTab'

    initialize: ->

      LazyIFramesHelper.initLazyIFrames()

      @targetHierarchy = TargetBrowserApp.initTargetHierarchyTree()
      @targetBrowserView = TargetBrowserApp.initBrowserMain(@targetHierarchy, $('#BCK-TargetBrowserMain'))

      LazyIFramesHelper.loadObjectOnceOnClick($('a[data-target="#browse_targets"]'), @targetHierarchy)

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
