glados.useNameSpace 'glados.views.Target',
  LigandEfficienciesView: CardView.extend

    initialize: ->
      @showCardContent()
      @fetchInfoForGraph()

      @resource_type = 'Target'
      @initEmbedModal('ligand_efficiencies')
      @activateModals()

      config = {
        properties:
          ligand_efficienfy_sei: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'LIGAND_EFFICIENCY_SEI')
          ligand_efficienfy_bei: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'LIGAND_EFFICIENCY_BEI')
          standard_value: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'STANDARD_VALUE')
          molecule_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'MOLECULE_CHEMBL_ID')
          activity_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'ACTIVITY_ID')
        id_property: 'activity_id'
        labeler_property: 'molecule_chembl_id'
        initial_property_x: 'ligand_efficienfy_sei'
        initial_property_y: 'ligand_efficienfy_bei'
        initial_property_colour: 'standard_value'
        disable_axes_selectors: true
        plot_title: 'ChEMBL Ligand Efficiency Plot for Target ' + arguments[0].target_chembl_id
      }

      @scatterPlotView = new PlotView
        el: $(@el).find('.BCK-MainPlotContainer')
        collection: @collection
        config: config


    fetchInfoForGraph: ->

      $progressElement = $(@el).find('.load-messages-container')
      deferreds = @collection.getAllResults($progressElement)

      thisView = @
      $.when.apply($, deferreds).done( ->
        console.log 'got all data!'
        console.log thisView.collection.allResults
        $progressElement.html ''
        thisView.scatterPlotView.render()
      )

      console.log 'FETCHING INFO FOR PLOT!'
