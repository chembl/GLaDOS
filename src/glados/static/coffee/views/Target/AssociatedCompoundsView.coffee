glados.useNameSpace 'glados.views.Target',
  AssociatedCompoundsView: CardView.extend

    initialize: ->
      @model.on 'change', @render, @
      $progressElem = $(@el).find('.load-messages-container')
      @model.set('progress_elem', $progressElem)

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
        range_categories: true
        max_categories: 8

      @model.set('current_xaxis_property', config.properties[config.initial_property_x].propName)
      @model.set('num_columns', config.x_axis_initial_num_columns)
      @model.set('x_axis_min_columns', config.x_axis_min_columns)
      @model.set('x_axis_max_columns', config.x_axis_max_columns)

      @histogramView = new glados.views.Visualisation.HistogramView
        el: $(@el).find('.BCK-MainHistogramContainer')
        config: config
        model: @model

    render: ->
      @showCardContent()
