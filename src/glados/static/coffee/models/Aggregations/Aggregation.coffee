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

      console.log 'fetching!'
      $progressElem = @get('progress_elem')
      state = @get('state')

      if state == glados.models.Aggregations.Aggregation.States.INITIAL_STATE\
      or state == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
        if $progressElem?
          $progressElem.html 'Loading minimun and maximum values...'
        console.log 'loading min and max'
        @set('state', glados.models.Aggregations.Aggregation.States.LOADING_MIN_MAX)
        @fetchMinMax()
        return

      console.log 'I already have min and max'
      if $progressElem?
        $progressElem.html 'Fetching Compound Data...'

      esJSONRequest = JSON.stringify(@getRequestData())

      fetchESOptions =
        url: @url
        data: esJSONRequest
        type: 'POST'
        reset: true

      thisModel = @
      $.ajax(fetchESOptions).done((data) ->
        if $progressElem?
          $progressElem.html ''

        console.log 'data received!! ', data

        thisModel.set('bucket_data', thisModel.parse(data))
        thisModel.set('state', glados.models.Aggregations.Aggregation.States.INITIAL_STATE)
        console.log 'thisModel: ', thisModel
#        thisModel.set('custom_interval_size', undefined , {silent:true})

      ).fail( -> console.log 'error'
#        glados.Utils.ErrorMessages.showLoadingErrorMessageGen($progressElem)
      )

    fetchMinMax: ->

      console.log 'fetching min and max data'
      $progressElem = @get('progress_elem')
      esJSONRequest = JSON.stringify(@getRequestMinMaxData())

      fetchESOptions =
        url: @url
        data: esJSONRequest
        type: 'POST'
        reset: true

      thisModel = @
      $.ajax(fetchESOptions).done((data) ->

        thisModel.set('aggs_config', thisModel.parseMinMax(data))

        console.log 'min and max data received!'
        if thisModel.get('state') == thisModel.NO_DATA_FOUND_STATE
          $progressElem.html '' unless not $progressElem?
          console.log 'no data found! ', thisModel.get('state')
          return

        thisModel.set('state', glados.models.Aggregations.Aggregation.States.LOADING_BUCKETS)
        thisModel.fetch()

      ).fail( -> console.log 'ERROR!'
#        glados.Utils.ErrorMessages.showLoadingErrorMessageGen($progressElem)
      )


    #-------------------------------------------------------------------------------------------------------------------
    # Parsing
    #-------------------------------------------------------------------------------------------------------------------
    parseMinMax: (data) ->

      if data.hits.total == 0
        @set('state', glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE)
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


    parse: (data) ->

      bucketsData = {}

      aggsConfig = @get('aggs_config')
      receivedAggsInfo = data.aggregations

      aggs = aggsConfig.aggs
      for aggKey, aggDescription of aggs

        if aggDescription.type == glados.models.Aggregations.Aggregation.AggTypes.RANGE

          currentBuckets = receivedAggsInfo[aggKey].buckets
          bucketsList = glados.Utils.Buckets.getBucketsList(currentBuckets)

          bucketsData[aggKey] =
            buckets: bucketsList
            num_columns: bucketsList.length

      return bucketsData


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

    getRequestData: ->

      aggsData = {}
      aggsConfig = @get('aggs_config')

      aggs = aggsConfig.aggs
      for aggKey, aggDescription of aggs
        if aggDescription.type == glados.models.Aggregations.Aggregation.AggTypes.RANGE

          minValue = aggDescription.min_value
          maxValue = aggDescription.max_value
          numCols = aggDescription.num_columns

          ranges = glados.Utils.Buckets.getElasticRanges(minValue, maxValue, numCols)

          aggsData[aggKey] =
            range:
              field: aggDescription.field
              ranges: ranges
              keyed: true

      queryData = @get('query')

      return {
        size: 0
        query: queryData
        aggs: aggsData
      }


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