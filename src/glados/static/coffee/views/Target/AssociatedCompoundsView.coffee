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

      buckets = [
        {"key":"Ratio","doc_count":94,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Ratio\""},
        {"key":"Ki","doc_count":32,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Ki\""},
        {"key":"IC50","doc_count":18,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"IC50\""},
        {"key":"EC50","doc_count":5,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"EC50\""},
        {"key":"Emax","doc_count":5,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Emax\""},
        {"key":"Change","doc_count":4,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Change\""},
        {"key":"Bmax","doc_count":2,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Bmax\""},
        {"key":"Kd","doc_count":2,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Kd\""}
      ]

      bioactivities = new TargetAssociatedBioactivities
        target_chembl_id: 'CHEMBL2111342'

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
        title: 'Associated Compounds for Target CHEMBL2111342'
        numerical_mode: true
        max_categories: 8
        fixed_bar_width: true

      @histogramView = new glados.views.Visualisation.HistogramView
        el: $(@el).find('.BCK-MainHistogramContainer')
        config: config
        model: bioactivities

      bioactivities.fetch()
      console.log 'bioactivities: ', bioactivities