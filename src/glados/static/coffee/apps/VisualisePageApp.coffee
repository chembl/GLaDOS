glados.useNameSpace 'glados.apps',
  VisualisePageApp: class VisualisePageApp

    @init = ->
      glados.apps.Main.MainGladosApp.hideMainSplashScreen()

      new glados.views.Visualisation.VisualisationsPageHandlerView
        el: $('.BCK-visualisations-with-captions')

# ----------------------------------------------------------------------------------------------------------------------
# Aggregations
# ----------------------------------------------------------------------------------------------------------------------

    #TODO: move all the aggregations generators for the visualisations here.
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
