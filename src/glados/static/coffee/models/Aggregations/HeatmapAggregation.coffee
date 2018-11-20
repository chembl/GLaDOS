glados.useNameSpace 'glados.models.Aggregations',
  HeatmapAggregation: glados.models.Aggregations.Aggregation.extend

    initialize: ->
      @set('state', glados.models.Aggregations.HeatmapAggregation.States.INITIAL_STATE)
      @loadQuery()

    #-------------------------------------------------------------------------------------------------------------------
    # Requesting initialisation in server
    #-------------------------------------------------------------------------------------------------------------------
    getIndexName: -> @get('index_name')
    getFullRequestData: ->

      fullRequestData =
        index_name: @getIndexName()
        search_data: JSON.stringify(@getRequestData())
        action: 'GET_INITIAL_DATA'

      return fullRequestData

    requestInitInServer: ->

      console.log 'requestInitInServer: '
      fullRequestData = @getFullRequestData()
      console.log 'fullRequestData: ', fullRequestData
      requestInitPromise = glados.doCSRFPost(glados.models.Aggregations.HeatmapAggregation.HEATMAP_HELPER_ENDPOINT,
        fullRequestData)

      requestInitPromise.done (data) ->
        console.log 'Request done: ', data

glados.models.Aggregations.HeatmapAggregation.States =
  INITIAL_STATE: 'INITIAL_STATE'

glados.models.Aggregations.HeatmapAggregation.HEATMAP_HELPER_ENDPOINT = 'heatmap_helper'
