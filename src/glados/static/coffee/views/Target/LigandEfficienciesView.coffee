glados.useNameSpace 'glados.views.Target',
  LigandEfficienciesView: CardView.extend

    initialize: ->
      @showCardContent()
      @fetchInfoForGraph()

    fetchInfoForGraph: ->
      console.log 'FETCHING INFO FOR PLOT!'
