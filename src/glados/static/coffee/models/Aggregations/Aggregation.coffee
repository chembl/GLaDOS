glados.useNameSpace 'glados.models.Aggregations',
  Aggregation: Backbone.Model.extend

    #-------------------------------------------------------------------------------------------------------------------
    # Initialisation
    #-------------------------------------------------------------------------------------------------------------------
    initialize: ->
      console.log 'init aggregation!'
      @set('state', glados.models.Aggregations.Aggregation.States.INITIAL_STATE)
      @loadQuery()

    loadQuery: ->
      queryConfig = @get('query_config')
      if queryConfig.type == glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
        query =
          multi_match:
            query: @get(queryConfig.queryValueField)
            fields: queryConfig.fields
        @set('query', query)

    #-------------------------------------------------------------------------------------------------------------------
    # Fetching
    #-------------------------------------------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------------------------------------------
    # Request Data
    #-------------------------------------------------------------------------------------------------------------------
    # Checks only first level for now
    # if there is no need to get min and max data, it returns undefined
    getRequestMinMaxData: ->

      aggsData = {}
      aggsConfig = @get('aggs_config')

      aggs = aggsConfig.aggs
      for aggKey, aggDescription of aggs
        if aggDescription.type == glados.models.Aggregations.Aggregation.AggTypes.RANGE
          minAggName = @getMinAggName(aggKey)
          aggsData[minAggName] =
            min:
              field: aggDescription.field

          maxAggName = @getMaxAggName(aggKey)
          aggsData[maxAggName] =
            max:
              field: aggDescription.field

      queryData = @get('query')

      return {
        size: 0
        query: queryData
        aggs: aggsData

      }


    getMinAggName: (aggKey) -> aggKey + '_min'
    getMaxAggName: (aggKey) -> aggKey + '_max'


glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL = glados.models.paginatedCollections.Settings.ES_BASE_URL\
+ '/chembl_molecule/_search'

glados.models.Aggregations.Aggregation.States =
  INITIAL_STATE: 'INITIAL_STATE'
  LOADING_MIN_MAX: 'LOADING_MIN_MAX'
  LOADING_BUCKETS: 'LOADING_BUCKETS'
  NO_DATA_FOUND_STATE: 'NO_DATA_FOUND_STATE'

glados.models.Aggregations.Aggregation.QueryTypes =
   MULTIMATCH: 'MULTIMATCH'

glados.models.Aggregations.Aggregation.AggTypes =
   RANGE: 'RANGE'