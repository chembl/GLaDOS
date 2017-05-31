glados.useNameSpace 'glados.views.Target',
  LigandEfficienciesView: CardView.extend

    initialize: ->
      @showCardContent()
      @fetchInfoForGraph()

      @resource_type = 'Target'
      @initEmbedModal('ligand_efficiencies')
      @activateModals()

    fetchInfoForGraph: ->

      $progressElement = $(@el).find('.load-messages-container')
      deferreds = @collection.getAllResults($progressElement)

      thisView = @
      $.when.apply($, deferreds).done( ->
        console.log 'got all data!'
        console.log thisView.collection.allResults
      )

      console.log 'FETCHING INFO FOR PLOT!'
