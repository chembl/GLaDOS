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
          molecule_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'CHEMBL_ID')
          ALogP: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')
          FULL_MWT: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
          RO5: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5',
            withColourScale = true)
          PSA: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'PSA')
          HBA: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'HBA')
          HBD: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'HBD')
        id_property: 'molecule_chembl_id'
        labeler_property: 'molecule_chembl_id'
        initial_property_x: 'ALogP'
        initial_property_y: 'FULL_MWT'
        initial_property_colour: 'RO5'
        disable_axes_selectors: true
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
      )

      console.log 'FETCHING INFO FOR PLOT!'
