glados.useNameSpace 'glados.models.Aggregations',
  Aggregation: Backbone.Model.extend

    #-------------------------------------------------------------------------------------------------------------------
    # Initialisation
    #-------------------------------------------------------------------------------------------------------------------
    initialize: ->
      @url = @get('index_url')
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
    fetch: ->

      $progressElem = @get('progress_elem')
      state = @get('state')

      if state == glados.models.Aggregations.Aggregation.States.INITIAL_STATE\
      or state == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
        if $progressElem? or true
#          $progressElem.html 'Loading minimun and maximum values...'
          console.log 'loading min and max'
        @set('state', @LOADING_MIN_MAX)
        @fetchMinMax()
        return


    fetchMinMax: ->

      $progressElem = @get('progress_elem')
      esJSONRequest = JSON.stringify(@getRequestMinMaxData())

      fetchESOptions =
        url: @url
        data: esJSONRequest
        type: 'POST'
        reset: true

      thisModel = @
      $.ajax(fetchESOptions).done((data) ->

        thisModel.set(thisModel.parseMinMax(data))
#        if thisModel.get('state') == thisModel.NO_DATA_FOUND_STATE
#          $progressElem.html ''
#          return
#        thisModel.set('state', thisModel.LOADING_BUCKETS, {silent:true})
#        thisModel.fetch()

      ).fail( -> console.log 'ERROR!'
#        glados.Utils.ErrorMessages.showLoadingErrorMessageGen($progressElem)
      )


    #-------------------------------------------------------------------------------------------------------------------
    # Parsing
    #-------------------------------------------------------------------------------------------------------------------
    parseMinMax: (data) ->

      if data.hits.total == 0
        @set('state', @NO_DATA_FOUND_STATE)
        return

      aggsConfig = @get('aggs_config')
      receivedAggsInfo = data.aggregations

      aggs = aggsConfig.aggs
      for aggKey, aggDescription of aggs

        if aggDescription.type == glados.models.Aggregations.Aggregation.AggTypes.RANGE
          minAggName = @getMinAggName(aggKey)
          currentAggReceivedMin = receivedAggsInfo[minAggName].value
          aggDescription.min_value = currentAggReceivedMin

          maxAggName = @getMaxAggName(aggKey)
          currentAggReceivedMax = receivedAggsInfo[maxAggName].value
          aggDescription.max_value = currentAggReceivedMax

          range = currentAggReceivedMax - currentAggReceivedMin
          minColumns = aggDescription.min_columns
          maxColumns = aggDescription.max_columns

          maxBinSize = parseFloat((Math.ceil(Math.abs(range)) / minColumns).toFixed(2))
          minBinSize = parseFloat((Math.ceil(Math.abs(range)) / maxColumns).toFixed(2))

          aggDescription.min_bin_size = minBinSize
          aggDescription.max_bin_size = maxBinSize

      return aggsConfig




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