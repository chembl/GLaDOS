glados.useNameSpace 'glados.views.Target',
  LigandEfficienciesView: CardView.extend

    initialize: ->
      @showCardContent()
      @fetchInfoForGraph()

      @resource_type = 'Target'
      @initEmbedModal('ligand_efficiencies')
      @activateModals()

    fetchInfoForGraph: ->

      console.log 'FETCHING INFO FOR PLOT!'
