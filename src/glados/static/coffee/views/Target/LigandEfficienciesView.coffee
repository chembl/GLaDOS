glados.useNameSpace 'glados.views.Target',
  LigandEfficienciesView: CardView.extend

    initialize: ->
      CardView.prototype.initialize.call(@, arguments)
      @showSection()
      @showCardContent()

      @collection.on glados.Events.Collections.ALL_ITEMS_DOWNLOADED, @renderPlot, @

      @$progressElement = $(@el).find('.load-messages-container')
      @collection.getAllResults(@$progressElement)
      @target_chembl_id = arguments[0].target_chembl_id

      @resource_type = 'Target'
      @initEmbedModal('ligand_efficiencies', arguments[0].target_chembl_id)
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
        plot_title: 'ChEMBL Ligand Efficiency Plot for Target ' + @target_chembl_id
        disable_selection: true
      }

      @scatterPlotView = new PlotView
        el: $(@el).find('.BCK-MainPlotContainer')
        collection: @collection
        config: config


    renderPlot: ->
      console.log 'going to render plot!'
      @$progressElement.html ''
      @scatterPlotView.render()

      if @collection.getMeta('total_records') > 0
        $linkToActivities = $(@el).find('.BCK-all-sources-link')
        glados.Utils.fillContentForElement $linkToActivities,
          link_text: 'See all bioactivities for target ' + @target_chembl_id + ' used in this visualisation'
          url: Activity.getActivitiesListURL(@collection.getMeta('custom_query'))

