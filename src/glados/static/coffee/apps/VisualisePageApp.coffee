glados.useNameSpace 'glados.apps',
  VisualisePageApp: class VisualisePageApp

    @init = ->
      glados.apps.Main.MainGladosApp.hideMainSplashScreen()

      VisualisePageApp.initZoomableSunburst()

# ----------------------------------------------------------------------------------------------------------------------
# Init Visualisations
# ----------------------------------------------------------------------------------------------------------------------

    @initZoomableSunburst = ->
      console.log 'init zoomable sunburst'
      aggregation = VisualisePageApp.getTargetsTreeAgg()

      config =
        browse_all_link: "#{glados.Settings.GLADOS_BASE_URL_FULL}/g/#browse/targets"

      new glados.views.MainPage.ZoomableSunburstView
        el: $('#BCK-zoomable-sunburst')
        model: aggregation
        config: config

      aggregation.fetch()

    @getTargetsTreeAgg = ->
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

