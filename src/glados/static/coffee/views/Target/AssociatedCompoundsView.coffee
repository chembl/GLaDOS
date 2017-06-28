glados.useNameSpace 'glados.views.Target',
  AssociatedCompoundsView: CardView.extend

    initialize: ->
      @showCardContent()

      @resource_type = 'Target'
      @initEmbedModal('associated_compounds')
      @activateModals()

      config =
        properties:
          mwt: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
          alogp: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')
          psa: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'PSA')
        initial_property_x: 'mwt'
        x_axis_options: ['mwt', 'alogp', 'psa']
        x_axis_min_columns: 1
        x_axis_max_columns: 20
        x_axis_initial_columns: 10

      @histogramView = new glados.views.Visualisation.HistogramView
        el: $(@el).find('.BCK-MainHistogramContainer')
        config: config