glados.useNameSpace 'glados.apps',
  VisualisePageApp: class VisualisePageApp

    @init = ->
      glados.apps.Main.MainGladosApp.hideMainSplashScreen()

      VisualisePageApp.initZoomableSunburst()

# ----------------------------------------------------------------------------------------------------------------------
# Init Visualisations
# ----------------------------------------------------------------------------------------------------------------------

    @initZoomableSunburst = ->
      aggregation = VisualisePageApp.getTargetClassificationAgg()

      config =
        browse_all_link: "#{glados.Settings.GLADOS_BASE_URL_FULL}/g/#browse/targets"
        browse_button: false

      console.log 'config: ', config

      new glados.views.MainPage.ZoomableSunburstView
        el: $('#BCK-zoomable-sunburst')
        model: aggregation
        config: config

      aggregation.fetch()


    @initStackedHistogram = ->
      aggregation = VisualisePageApp.getYearByMaxPhaseAgg()
      usanYearProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'USAN_YEAR')
      maxPhaseProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'MAX_PHASE', true)
      barsColourScale = maxPhaseProp.colourScale

      histogramConfig =
        bars_colour_scale: barsColourScale
        stacked_histogram: true
        sort_by_key: true
        rotate_x_axis_if_needed: false
        hide_x_axis_title: true
        y_scale_mode: 'normal'
        legend_vertical: true
        big_size: true
        paint_axes_selectors: true
        properties:
          year: usanYearProp
          max_phase: maxPhaseProp
        initial_property_x: 'year'
        initial_property_z: 'max_phase'
        x_axis_options: ['count']
        x_axis_min_columns: 1
        x_axis_max_columns: 40
        x_axis_initial_num_columns: 40
        x_axis_prop_name: 'yearByMaxPhase'
        title: 'Drugs by Usan Year'
        title_link_url: Drug.getDrugsListURL('_metadata.compound_records.src_id:13 AND _exists_:usan_year')

      config =
        histogram_config: histogramConfig
        is_outside_an_entity_report_card: true
        embed_url: "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#documents_by_year_histogram"

      new glados.views.ReportCards.HistogramInCardView
        el: $('#BCK-stacked-histogram')
        model: aggregation
        config: config
        report_card_app: @

      allDrugsByYear.fetch()

# ----------------------------------------------------------------------------------------------------------------------
# Aggregations
# ----------------------------------------------------------------------------------------------------------------------

    @getTargetClassificationAgg = ->
      queryConfig =
        type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
        query_string_template: '*'
        template_data: {}

      aggsConfig =
        aggs:
          children:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: '_metadata.protein_classification.l1'
            size: 100
            bucket_links:
              bucket_filter_template: '_metadata.protein_classification.l1:("{{bucket_key}}")'
              template_data:
                bucket_key: 'BUCKET.key'
              link_generator: Target.getTargetsListURL
            aggs:
              children:
                type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                field: '_metadata.protein_classification.l2'
                size: 100
                bucket_links:
                  bucket_filter_template: '_metadata.protein_classification.l2:("{{bucket_key}}")'
                  template_data:
                    bucket_key: 'BUCKET.key'
                  link_generator: Target.getTargetsListURL
                aggs:
                  children:
                    type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                    field: '_metadata.protein_classification.l3'
                    size: 100
                    bucket_links:
                      bucket_filter_template: '_metadata.protein_classification.l3:("{{bucket_key}}")'
                      template_data:
                        bucket_key: 'BUCKET.key'
                      link_generator: Target.getTargetsListURL
                    aggs:
                      children:
                        type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                        field: '_metadata.protein_classification.l4'
                        size: 100
                        bucket_links:
                          bucket_filter_template: '_metadata.protein_classification.l4:("{{bucket_key}}")'
                          template_data:
                            bucket_key: 'BUCKET.key'
                          link_generator: Target.getTargetsListURL
                        aggs:
                          children:
                            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                            field: '_metadata.protein_classification.l5'
                            size: 100
                            bucket_links:
                              bucket_filter_template: '_metadata.protein_classification.l5:("{{bucket_key}}")'
                              template_data:
                                bucket_key: 'BUCKET.key'
                              link_generator: Target.getTargetsListURL
                            aggs:
                              children:
                                type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                                field: '_metadata.protein_classification.l6'
                                size: 100
                                bucket_links:
                                  bucket_filter_template: '_metadata.protein_classification.l6:("{{bucket_key}}")'
                                  template_data:
                                    bucket_key: 'BUCKET.key'
                                  link_generator: Target.getTargetsListURL


      targetsTreeAgg = new glados.models.Aggregations.Aggregation
        index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
        query_config: queryConfig
        aggs_config: aggsConfig

      return targetsTreeAgg

    @getYearByMaxPhaseAgg = (defaultInterval = 1) ->
      queryConfig =
        type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
        query_string_template: '_metadata.drug.is_drug:true AND _metadata.compound_records.src_id:13 AND _exists_:usan_year'
        template_data: {}

      aggsConfig =
        aggs:
          yearByMaxPhase:
            type: glados.models.Aggregations.Aggregation.AggTypes.HISTOGRAM
            field: 'usan_year'
            default_interval_size: defaultInterval
            min_interval_size: 1
            max_interval_size: 10
            bucket_key_parse_function: (key) -> key.replace(/\.0/i, '')
            aggs:
              max_phase:
                type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                field: 'max_phase'
                size: 10
                bucket_links:
                  bucket_filter_template: '_metadata.compound_records.src_id:13 AND usan_year:{{year}} AND max_phase:{{bucket_key}}'
                  template_data:
                    year: 'BUCKET.parsed_parent_key'
                    bucket_key: 'BUCKET.key'

                  link_generator: Drug.getDrugsListURL

      yearByMaxPhase = new glados.models.Aggregations.Aggregation
        index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
        query_config: queryConfig
        aggs_config: aggsConfig

      return yearByMaxPhase

