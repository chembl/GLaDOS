glados.useNameSpace 'glados.apps',
  VisualisePageApp: class VisualisePageApp

    @init = ->
      glados.apps.Main.MainGladosApp.hideMainSplashScreen()

      VisualisePageApp.initZoomableSunburst()
      VisualisePageApp.initStackedHistogram()
      VisualisePageApp.initBubbleHierarchyChart()
      VisualisePageApp.initDonutChart()

# ----------------------------------------------------------------------------------------------------------------------
# Init Visualisations
# ----------------------------------------------------------------------------------------------------------------------

    @initZoomableSunburst = ->
      aggregation = VisualisePageApp.getTargetClassificationAgg()

      config =
        browse_all_link: "#{glados.Settings.GLADOS_BASE_URL_FULL}/g/#browse/targets"
        browse_button: true

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
        el: $('#PapersPerYearHistogram')
        model: aggregation
        config: config
        report_card_app: @

      aggregation.fetch()

    @initBubbleHierarchyChart = ->
      targetHierarchy = TargetBrowserApp.initTargetHierarchyTree()
      targetHierarchyAgg = MainPageApp.getTargetsOrganismTreeAgg()
      targetHierarchy.fetch()
      targetHierarchyAgg.fetch()

      TargetBrowserApp.initBrowserAsCircles(targetHierarchyAgg, $('#BCK-TargetBrowserAsCircles'))

      config =
        is_outside_an_entity_report_card: true
        embed_url: "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#targets_by_protein_class"
        view_class: BrowseTargetAsCirclesView

      new glados.views.ReportCards.VisualisationInCardView
        el: $('#BCK-TargetBrowserAsCircles')
        model: targetHierarchy
        config: config
        report_card_app: @

      @initDonutChart = ->
        aggregation = MainPageApp.getMaxPhaseForDiseaseAgg()
        maxPhaseProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'MAX_PHASE', true)
        diseaseClassProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'DISEASE')

        pieConfig =
          side_legend: true
          x_axis_prop_name: 'maxPhaseForDisease'
          split_series_prop_name: 'split_series_agg'
          title: 'Max Phase for Disease'
          max_categories: 5
          stacked_donut: true
          stacked_levels: 2
          hide_title: true
          properties:
            max_phase: maxPhaseProp
            disease_class: diseaseClassProp
          initial_property_x: 'max_phase'
          initial_property_z: 'disease_class'
          title_link_url: Drug.getDrugsListURL()

        config =
          pie_config: pieConfig
          is_outside_an_entity_report_card: true
          embed_url: "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#max_phase_for_disease"
          link_to_all:
            link_text: 'See all drug Compounds in ChEMBL'
            url: Drug.getDrugsListURL()

        new glados.views.ReportCards.PieInCardView
          el: $('#MaxPhaseForDisease')
          model: aggregation
          config: config
          report_card_app: @

        aggregation.fetch()


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
            bucket_sort_compare_function: (bucketA, bucketB) ->
              yearA = parseFloat(bucketA.key)
              yearB = parseFloat(bucketB.key)
              if yearA < yearB
                return -1
              else if yearA > yearB
                return 1
              return 0
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

    @getTargetsOrganismTreeAgg = ->

      queryConfig =
        type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
        query_string_template: '*'
        template_data: {}

      aggsConfig =
        aggs:
          children:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: '_metadata.organism_taxonomy.l1'
            size: 50
            bucket_links:
              bucket_filter_template: '_metadata.organism_taxonomy.l1:("{{bucket_key}}")'
              template_data:
                bucket_key: 'BUCKET.key'
              link_generator: Target.getTargetsListURL
            aggs:
              children:
                type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                field: '_metadata.organism_taxonomy.l2'
                size: 50
                bucket_links:
                  bucket_filter_template: '_metadata.organism_taxonomy.l2:("{{bucket_key}}")'
                  template_data:
                    bucket_key: 'BUCKET.key'
                  link_generator: Target.getTargetsListURL
                aggs:
                  children:
                    type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                    field: '_metadata.organism_taxonomy.l3'
                    size: 50
                    bucket_links:
                      bucket_filter_template: '_metadata.organism_taxonomy.l3:("{{bucket_key}}")'
                      template_data:
                        bucket_key: 'BUCKET.key'
                      link_generator: Target.getTargetsListURL

      organismTreeAgg = new glados.models.Aggregations.Aggregation
        index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
        query_config: queryConfig
        aggs_config: aggsConfig

      return organismTreeAgg


    @getMaxPhaseForDiseaseAgg = () ->
      queryConfig =
        type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
        query_string_template: '_metadata.drug.is_drug:true'
        template_data: {}

      aggsConfig =
        aggs:
          maxPhaseForDisease:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: 'max_phase'
            size: 5
            bucket_links:
              bucket_filter_template: '_metadata.drug.is_drug:true AND ' +
                'max_phase:{{bucket_key}}'
              template_data:
                bucket_key: 'BUCKET.key'

              link_generator: Compound.getCompoundsListURL
            aggs:
              split_series_agg:
                type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                field: '_metadata.drug_indications.efo_term'
                size: 12
                bucket_links:
                  bucket_filter_template: '_metadata.drug.is_drug:true AND ' +
                    'max_phase :{{max_phase}} AND _metadata.drug_indications.efo_term:("{{bucket_key}}"' +
                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
                  template_data:
                    max_phase: 'BUCKET.parent_key'
                    bucket_key: 'BUCKET.key'
                    extra_buckets: 'EXTRA_BUCKETS.key'

                  link_generator: Compound.getCompoundsListURL

      MaxPhaseForDisease = new glados.models.Aggregations.Aggregation
        index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
        query_config: queryConfig
        aggs_config: aggsConfig

      return MaxPhaseForDisease
