glados.useNameSpace 'glados.views.MainPage',
  CentralCardView: Backbone.View.extend

    initialize: ->

      console.log 'INITIALIZE CENTRAL CARD VIEW'
      @marvinSketcherView = new MarvinSketcherView()
      @showHideDivs()

    showHideDivs: ->
      $tabsLinks = $(@el).find('.summary-tabs .results-section-item')
      console.log 'tabsLinks ', $tabsLinks
      for tab in $tabsLinks
        console.log 'working with ', tab
        $tab = $(tab)
        $pointedDiv = $($tab.attr('href'))
        console.log '$pointedDiv: ',$pointedDiv
        if $tab.hasClass('selected')
          $pointedDiv.show()
        else
          $pointedDiv.hide()
