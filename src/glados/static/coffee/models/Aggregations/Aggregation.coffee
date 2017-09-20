glados.useNameSpace 'glados.models.Aggregations',
  Aggregation: Backbone.Model.extend

    initialize: ->
      console.log 'init aggregation!'
      @set('state', glados.models.Aggregations.Aggregation.States.INITIAL_STATE)

      queryConfig = @get('query_config')
      if queryConfig.type == glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
        query =
          multi_match:
            query: @get(queryConfig.queryValueField)
            fields: queryConfig.fields
        @set('query', query)


glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL = glados.models.paginatedCollections.Settings.ES_BASE_URL\
+ '/chembl_molecule/_search'

glados.models.Aggregations.Aggregation.States =
  INITIAL_STATE: 'INITIAL_STATE'
  LOADING_MIN_MAX: 'LOADING_MIN_MAX'
  LOADING_BUCKETS: 'LOADING_BUCKETS'
  NO_DATA_FOUND_STATE: 'NO_DATA_FOUND_STATE'

glados.models.Aggregations.Aggregation.QueryTypes =
   MULTIMATCH: 'MULTIMATCH'