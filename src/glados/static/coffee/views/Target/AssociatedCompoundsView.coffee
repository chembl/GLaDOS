glados.useNameSpace 'glados.views.Target',
  AssociatedCompoundsView: CardView.extend

    initialize: ->
      @model.on 'change', @render, @

      @resource_type = 'Target'
      @initEmbedModal('associated_compounds')
      @activateModals()

      config =
        big_size: true
        paint_axes_selectors: true
        properties:
          mwt: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
          alogp: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')
          psa: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'PSA')
        initial_property_x: 'mwt'
        x_axis_options: ['mwt', 'alogp', 'psa']
        x_axis_min_columns: 1
        x_axis_max_columns: 20
        x_axis_initial_num_columns: 10
        title: 'Associated Compounds for Target ' + @model.get('target_chembl_id')
        numerical_mode: true
        max_categories: 8
        fixed_bar_width: true

      @histogramView = new glados.views.Visualisation.HistogramView
        el: $(@el).find('.BCK-MainHistogramContainer')
        config: config
        model: @model

    render: ->
      @showCardContent()
