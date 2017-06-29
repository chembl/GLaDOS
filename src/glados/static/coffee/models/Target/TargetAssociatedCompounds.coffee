glados.useNameSpace 'glados.models.Target',
  TargetAssociatedCompounds: Backbone.Model.extend

    initialize: ->

      console.log 'INITIALISING TARGET ASSOCIATED COMPOUNDS!'

    fetch: ->
      console.log 'FETCHING ASSOC COMPS!'
      @set(@parse())

    parse: (data) ->

      buckets = [
        {"key":"0","doc_count":94,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Ratio\""},
        {"key":"50","doc_count":32,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Ki\""},
        {"key":"100","doc_count":18,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"IC50\""},
        {"key":"150","doc_count":5,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"EC50\""},
        {"key":"200","doc_count":5,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Emax\""},
        {"key":"250","doc_count":4,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Change\""},
        {"key":"300","doc_count":2,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Bmax\""},
        {"key":"350","doc_count":2,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Kd\""}
      ]

      return {
        'buckets': buckets
      }

    getRequestData: ->

      return {

      }

    getRequestMinMaxData: ->

      return {
        size: 0,
        query: {
          query_string: {
            analyze_wildcard: true,
            query: "*"
          }
        },
        aggs: {
          min_agg: {
            min: {
              field: @get('current_xaxis_property')
            }
          },
          max_agg: {
            max: {
              field: @get('current_xaxis_property')
            }
          }
        }
      }

    parseMinMax: (data) ->

      return {
        max_value: data.aggregations.max_agg.value
        min_value: data.aggregations.min_agg.value
      }
